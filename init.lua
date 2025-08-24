-- ~/.config/nvim/init.lua

-- コア設定を読み込む
require("core.options")
require("core.keymaps")

-- プラグインマネージャー(lazy.nvim)をセットアップ
require("lazy-setup")