return {
  "nvim-lua/plenary.nvim",
  config = function()
    local function open_ai_instruction()
      local cwd = vim.fn.getcwd()
      local ai_file = cwd .. "/AI_INSTRUCTION.md"
      
      -- Check if file exists, create if not
      if vim.fn.filereadable(ai_file) == 0 then
        vim.fn.writefile({""}, ai_file)
      end
      
      -- Create floating window
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)
      
      local buf = vim.api.nvim_create_buf(false, false)
      local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = " AI_INSTRUCTION.md ",
        title_pos = "center"
      })
      
      -- Load file content
      vim.cmd("edit " .. ai_file)
      
    end
    
    -- Set up keymap
    vim.keymap.set("n", "<leader>#", open_ai_instruction, { desc = "Edit AI_INSTRUCTION.md in floating window" })
  end
}