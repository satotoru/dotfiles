-- HTML/CSS展開ツール (emmet-vim)
return {
  "mattn/emmet-vim",
  ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  config = function()
    -- 旧設定からのリーダーキー移行
    vim.g.user_emmet_leader_key = '<C-D>'
    
    -- 旧設定からの詳細設定移行
    vim.g.user_emmet_settings = {
      variables = { lang = 'ja' },
      eruby = {
        extends = "html",
        snippets = {
          ["erb:s"] = "<%| %>",
          ["erb:m"] = "<%=| do %>\n${child}\n<% end %>"
        }
      }
    }
  end,
}