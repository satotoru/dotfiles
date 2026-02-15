-- 集中モード (goyo.vim)
return {
  "junegunn/goyo.vim",
  cmd = "Goyo",
  keys = {
    { "<C-W>z", "<cmd>Goyo<cr>", desc = "集中モード切り替え" },
  },
  config = function()
    -- Goyo起動時の設定
    vim.g.goyo_width = 120
    vim.g.goyo_height = 90
    vim.g.goyo_linenr = 0
  end,
}