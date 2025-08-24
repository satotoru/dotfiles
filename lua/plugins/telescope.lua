-- シンプルなTelescope設定 (検証用)
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "ファイル検索" },
    { "<leader>fa", "<cmd>Telescope find_files hidden=true<cr>", desc = "隠しファイル込み検索" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "バッファ一覧" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep検索" },
  },
  config = function()
    require("telescope").setup()
  end,
}
