-- テキスト整列ツール (vim-easy-align)
return {
  "junegunn/vim-easy-align",
  cmd = { "EasyAlign" },
  keys = {
    { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy align" },
  },
}