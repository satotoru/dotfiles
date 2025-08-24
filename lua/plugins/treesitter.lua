-- 高速で正確なシンタックスハイライト (Tree-sitter)
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "typescript", "html", "css", "rust" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}