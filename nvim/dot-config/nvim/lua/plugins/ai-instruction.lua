return {
  "nvim-lua/plenary.nvim",
  lazy = false,
  config = function()
    -- 未保存状態用のハイライトグループを定義
    vim.api.nvim_set_hl(0, "AiInstructionModified", { bg = "#3b2020" })
    vim.api.nvim_set_hl(0, "AiInstructionStatusModified", { fg = "#ff6666", bg = "#3b2020", bold = true })
    vim.api.nvim_set_hl(0, "AiInstructionStatusSaved", { fg = "#66cc66", bg = "#1a1b26", bold = true })

    local function update_ai_panel_appearance(win, buf)
      if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then
        return
      end
      local modified = vim.bo[buf].modified
      if modified then
        vim.wo[win].winhl = "Normal:AiInstructionModified,NormalFloat:AiInstructionModified,StatusLine:AiInstructionStatusModified"
        vim.wo[win].statusline = "🤖 AI INSTRUCTION [未保存] - <leader># to open | <Esc><Esc> to close"
      else
        vim.wo[win].winhl = "Normal:FloatBorder,NormalFloat:FloatBorder,StatusLine:AiInstructionStatusSaved"
        vim.wo[win].statusline = "🤖 AI INSTRUCTION [保存済] - <leader># to open | <Esc><Esc> to close"
      end
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

      -- Add border-like effect with sign column
      vim.wo[win].signcolumn = "yes:2"

      -- Set buffer options to make it feel like a terminal-like panel
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].filetype = "markdown"
      vim.wo[win].winfixheight = true
      vim.wo[win].number = false
      vim.wo[win].relativenumber = false

      -- 初期表示の設定
      update_ai_panel_appearance(win, buf)

      -- Close on <Esc><Esc>
      vim.api.nvim_buf_set_keymap(buf, "n", "<Esc><Esc>", ":q<CR>", { noremap = true, silent = true })

      -- バッファ変更時に色を更新
      local augroup = vim.api.nvim_create_augroup("AiInstructionModified_" .. buf, { clear = true })

      vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
        group = augroup,
        buffer = buf,
        callback = function()
          update_ai_panel_appearance(win, buf)
        end,
        desc = "AI指示パネルの未保存状態を色で表示",
      })

      vim.api.nvim_create_autocmd("BufWritePost", {
        group = augroup,
        buffer = buf,
        callback = function()
          update_ai_panel_appearance(win, buf)
        end,
        desc = "AI指示パネルの保存済み状態を色で表示",
      })

      -- AI指示バッファでのみ自動保存を有効にする
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = augroup,
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
