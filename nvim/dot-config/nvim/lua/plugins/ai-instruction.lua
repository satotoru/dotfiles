return {
  "nvim-lua/plenary.nvim",
  lazy = false,
  config = function()
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
      vim.api.nvim_win_set_option(win, "statusline", "🤖 AI INSTRUCTION PANEL - <leader># to open | <Esc><Esc> to close")

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
