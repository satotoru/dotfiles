-- ~/.config/nvim/lua/core/options.lua

local opt = vim.opt

-- 外観
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.scrolloff = 8

-- 編集
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- 検索
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- その他
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.hidden = true

-- 自動保存
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "silent! write"
})

-- 行末空白削除 (旧設定から移行)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//ge"
})

-- conceal設定 (旧設定から移行)
opt.conceallevel = 0
vim.g.vim_json_syntax_conceal = 0