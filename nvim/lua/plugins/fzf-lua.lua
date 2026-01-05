-- fzf-lua設定 (telescope.nvimからの移行)
return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "ファイル検索" },
    { "<leader>fa", function() require("fzf-lua").files({ hidden = true }) end, desc = "隠しファイル込み検索" },
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "バッファ一覧" },
    { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Grep検索" },
    { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "quickfix検索" },
    { "<leader>*", "<cmd>FzfLua grep_cword<cr>", mode = "n", desc = "カーソル位置の単語でGrep検索", },
    { "<leader>*", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "選択中の文字列でGrep検索", },
  },
  config = function()
    require("fzf-lua").setup({
      -- デフォルトのプロファイルを使用（telescope風UI）
      "telescope",
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          layout = "flex",
          flip_columns = 120,
        },
      },
    })
  end,
}
