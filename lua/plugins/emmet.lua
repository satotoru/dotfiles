-- HTML/CSS展開ツール (emmet-vim)
return {
  "mattn/emmet-vim",
  ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
  config = function()
    -- デフォルトのリーダーキーは<C-Y>のまま維持
    vim.g.user_emmet_leader_key = '<C-Y>'
  end,
}