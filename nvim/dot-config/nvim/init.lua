-- ~/.config/nvim/init.lua

-- コア設定を読み込む
require("core.options")
require("core.keymaps")

-- プラグインマネージャー(lazy.nvim)をセットアップ
require("lazy-setup")

-- ローカル設定の読み込み (端末固有、dotfiles管理外)
local local_config = vim.fn.expand("~/.config/nvim-local.lua")
if vim.fn.filereadable(local_config) == 1 then
  dofile(local_config)
end
