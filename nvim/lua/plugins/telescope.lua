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
    { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "quickfix検索" },
    -- カーソル位置の単語でGrep検索
    {
      "<leader>*",
      function()
        require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
      end,
      mode = "n",
      desc = "カーソル位置の単語でGrep検索",
    },
    -- 選択中の文字列でGrep検索
    {
      "<leader>*",
      function()
        -- ビジュアルモードで選択中のテキストを取得
        vim.cmd('noau normal! "vy"')
        local text = vim.fn.getreg("v")
        -- レジスタをクリア
        vim.fn.setreg("v", "")
        -- 改行や余分な空白を処理
        text = text:gsub("\n", " "):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
        require("telescope.builtin").live_grep({ default_text = text })
      end,
      mode = "v",
      desc = "選択中の文字列でGrep検索",
    },
  },
  config = function()
    require("telescope").setup()
  end,
}
