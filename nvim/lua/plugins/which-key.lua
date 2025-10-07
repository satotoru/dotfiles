-- キーバインドヘルプ表示 (which-key.nvim)
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>?", "<cmd>WhichKey<cr>", desc = "which-keyヘルプを表示" },
  },
  opts = {
    preset = "modern",
    delay = 500,
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
    },
    win = {
      border = "rounded",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- 既存のleaderキーバインドを登録
    wk.add({
      -- 基本操作
      { "<leader>e", desc = "プロジェクトツリーを開く" },
      { "<leader><space>", desc = "検索開始" },
      { "<leader>x", desc = "スクラッチバッファを開く" },

      -- Telescopeグループ
      { "<leader>f", group = "find" },
      { "<leader>ff", desc = "ファイル検索" },
      { "<leader>fa", desc = "隠しファイル込み検索" },
      { "<leader>fb", desc = "バッファ一覧" },
      { "<leader>fg", desc = "Grep検索" },
      { "<leader>fq", desc = "quickfix検索" },
      { "<leader>*", desc = "カーソル位置/選択範囲でGrep検索" },

      -- ファイルパス操作グループ
      { "<leader>y", group = "yank" },
      { "<leader>yf", desc = "ファイルパスのみをヤンク" },
      { "<leader>yp", desc = "ファイルパス+行番号をヤンク" },

      -- その他
      { "<leader>t", desc = "ターミナルを切り替え" },

      -- Ctrl+Wグループ
      { "<C-W>z", desc = "集中モード切り替え" },
    })
  end,
}
