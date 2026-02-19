-- LSP関連プラグインの定義 (Neovim v0.11 + Mason)
return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "lua_ls", "ts_ls", "ruby_lsp" },
    },
  },
}
