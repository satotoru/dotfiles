-- ~/.config/nvim/lua/lazy-setup.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグインをセットアップ
-- `lua/plugins` ディレクトリ内の .lua ファイルをすべて読み込む
require("lazy").setup("plugins", {
  -- lazy.nvim自体の設定 (オプション)
  ui = {
    border = "rounded", -- UIのボーダーを丸くする
  },
})