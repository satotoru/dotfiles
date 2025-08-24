-- LSP関連プラグインの定義 (サンプル)
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = { "lua_ls" },
    })
    
    -- LSP基本設定のサンプル
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({})
  end,
}