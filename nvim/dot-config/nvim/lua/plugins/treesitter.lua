-- 高速で正確なシンタックスハイライト (Tree-sitter)
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Vimにslim filetypeが組み込まれていないため追加
    vim.filetype.add({
      extension = {
        slim = "slim",
      },
    })

    require("nvim-treesitter.configs").setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "typescript", "html", "css", "rust", "slim" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}