-- LSP関連プラグインの定義 (サンプル)
return {
  "neovim/nvim-lspconfig",
  config = function ()
    local lspconfig = require('lspconfig')

    -- lua
    lspconfig.lua_ls.setup({})

    -- ruby-lsp
    lspconfig.ruby_lsp.setup({
      -- 起動コマンドをカスタマイズ
      cmd = { "bundle", "exec", "ruby-lsp" },
    })

    -- ts_ls
    lspconfig.ts_ls.setup({
      cmd = {
        "/Users/toru.sato/.nodenv/versions/22.18.0/bin/typescript-language-server",
        "--stdio"
      }
    })
  end
}
