-- ~/.config/nvim/lua/core/keymaps.lua

-- リーダーキーをSpaceに設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- ノーマルモード
keymap("n", "<leader>pv", vim.cmd.Ex, { desc = "プロジェクトツリーを開く" })
keymap("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
keymap("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- ビジュアルモード
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "選択範囲を下に移動" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "選択範囲を上に移動" })