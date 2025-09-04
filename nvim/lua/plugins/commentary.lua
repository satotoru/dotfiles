-- コメントアウト機能 (vim-commentary)
return {
  "numToStr/Comment.nvim",
  lazy = false,
  config = function()
    require("Comment").setup()
  end,
}