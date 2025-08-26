-- ~/.config/nvim/lua/core/keymaps.lua

-- リーダーキーをSpaceに設定
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

-- ノーマルモード
keymap("n", "<leader>e", vim.cmd.Ex, { desc = "プロジェクトツリーを開く" })
keymap("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
keymap("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- ビジュアルモード
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "選択範囲を下に移動" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "選択範囲を上に移動" })

-- Emacsライクキーバインド (旧設定から移行)
-- インサートモード
keymap("i", "<C-f>", "<Right>", { desc = "カーソル右移動" })
keymap("i", "<C-b>", "<Left>", { desc = "カーソル左移動" })
keymap("i", "<C-e>", "<End>", { desc = "行末へ移動" })
keymap("i", "<C-a>", "<Home>", { desc = "行頭へ移動" })

-- コマンドモード
keymap("c", "<C-f>", "<Right>", { desc = "カーソル右移動" })
keymap("c", "<C-b>", "<Left>", { desc = "カーソル左移動" })
keymap("c", "<C-a>", "<Home>", { desc = "行頭へ移動" })
keymap("c", "<C-e>", "<End>", { desc = "行末へ移動" })

-- Shift+Tab逆インデント (旧設定から移行)
keymap("i", "<S-Tab>", "<C-d>", { desc = "逆インデント" })

keymap("n", "<leader><space>", "/", { desc = "検索開始" })
keymap("n", "<leader>x", ":e ~/buffer.md<CR>", { desc = "スクラッチバッファを開く" })
