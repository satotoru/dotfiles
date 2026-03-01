return {
  "nvim-lua/plenary.nvim",
  lazy = false,
  config = function()
    -- Claudeペインを自動検出（pane_current_commandが"claude"のものを探す）
    local function find_claude_pane()
      local result = vim.fn.system(
        "tmux list-panes -a -F '#{pane_id} #{pane_current_command}'"
      )
      for line in result:gmatch("[^\n]+") do
        local pane_id, cmd = line:match("(%S+)%s+(%S+)")
        if cmd and cmd:match("claude") then
          return pane_id
        end
      end
      return nil
    end

    -- AI_INSTRUCTION.md の内容を tmux paste-buffer にロードし、Claude Code ペインに貼り付け
    local function send_ai_instruction(buf)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      -- 末尾の空行を削除
      while #lines > 0 and lines[#lines]:match("^%s*$") do
        table.remove(lines)
      end

      if #lines == 0 then
        vim.notify("送信内容が空です", vim.log.levels.WARN)
        return
      end

      local pane_id = find_claude_pane()
      if not pane_id then
        vim.notify("Claude Codeのペインが見つかりません", vim.log.levels.WARN)
        return
      end

      -- tmux paste-buffer にコンテンツをロード
      local tmpfile = vim.fn.tempname()
      vim.fn.writefile(lines, tmpfile)
      vim.fn.system("tmux load-buffer " .. vim.fn.shellescape(tmpfile))
      vim.fn.delete(tmpfile)

      -- バッファとファイルをクリアしてウィンドウを閉じる
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "" })
      vim.cmd("silent! write")
      vim.cmd("close")

      -- Claude Code ペインに貼り付け（ブラケットペーストモード）
      vim.fn.system("tmux paste-buffer -p -t " .. vim.fn.shellescape(pane_id))

      -- Claude Code ペインにフォーカスを移す
      vim.fn.system("tmux select-pane -t " .. vim.fn.shellescape(pane_id))

      vim.notify("貼り付け完了 → " .. pane_id .. "（Enter で送信）", vim.log.levels.INFO)
    end

    local function open_ai_instruction()
      local cwd = vim.fn.getcwd()
      local ai_file = cwd .. "/AI_INSTRUCTION.md"

      -- Check if file exists, create if not
      if vim.fn.filereadable(ai_file) == 0 then
        vim.fn.writefile({ "" }, ai_file)
      end

      -- Create horizontal split at bottom
      local height = 20

      -- Open horizontal split at bottom
      vim.cmd("botright split")
      vim.api.nvim_win_set_height(0, height)

      -- Load file content
      vim.cmd("edit " .. ai_file)

      local buf = vim.api.nvim_get_current_buf()
      local win = vim.api.nvim_get_current_win()

      -- Set special UI elements for AI instruction panel
      vim.api.nvim_win_set_option(win, "statusline", "🤖 AI INSTRUCTION PANEL - <leader># to open | <C-s> to send | <Esc><Esc> to close")

      -- Set distinctive colors for the AI instruction panel
      vim.api.nvim_win_set_option(win, "winhl", "Normal:FloatBorder,NormalFloat:FloatBorder")

      -- Add border-like effect with sign column
      vim.api.nvim_win_set_option(win, "signcolumn", "yes:2")

      -- Set buffer options to make it feel like a terminal-like panel
      vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
      vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      vim.api.nvim_win_set_option(win, "winfixheight", true)
      vim.api.nvim_win_set_option(win, "number", false)
      vim.api.nvim_win_set_option(win, "relativenumber", false)

      -- Close on <Esc><Esc>
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc><Esc>", ":q<CR>", { noremap = true, silent = true })

      -- <C-s> で送信（ノーマルモード・インサートモード）
      vim.keymap.set("n", "<C-s>", function()
        send_ai_instruction(buf)
      end, { buffer = buf, desc = "AI指示をClaudeに送信して内容をクリア" })

      vim.keymap.set("i", "<C-s>", function()
        vim.cmd("stopinsert")
        send_ai_instruction(buf)
      end, { buffer = buf, desc = "AI指示をClaudeに送信して内容をクリア" })

      -- AI指示バッファでのみ自動保存を有効にする
      vim.api.nvim_create_autocmd("InsertLeave", {
        buffer = buf,
        callback = function()
          vim.cmd("silent! write")
        end,
        desc = "AI指示ファイルの自動保存"
      })
    end

    -- Set up keymap
    vim.keymap.set("n", "<leader>#", open_ai_instruction, { desc = "Edit AI_INSTRUCTION.md in horizontal split" })
  end
}
