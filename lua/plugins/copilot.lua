-- GitHub Copilot (copilot.vim)
return {
  "github/copilot.vim",
  event = "VeryLazy",
  config = function()
    -- Copilotの基本設定
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    
    -- キーマッピング
    vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
      desc = "Copilot accept"
    })
    vim.keymap.set("i", "<C-]>", "<Plug>(copilot-dismiss)", { desc = "Copilot dismiss" })
    vim.keymap.set("i", "<C-\\>", "<Plug>(copilot-next)", { desc = "Copilot next" })
  end,
}