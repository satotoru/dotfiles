-- Git統合 (vim-fugitive)
return {
  "tpope/vim-fugitive",
  cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  config = function()
    -- 基本的なキーマッピングは後でkeymaps.luaで設定
  end,
}