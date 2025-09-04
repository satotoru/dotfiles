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
opt.smartindent = true
opt.wrap = true

-- 検索
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- その他
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.hidden = true

-- 旧設定から移行
opt.wildmode = { "list:longest", "full" }  -- コマンドライン補完
opt.switchbuf = "useopen"                   -- QuickFix効率化
opt.laststatus = 2                          -- ステータスライン常時表示


-- 行末空白削除 (旧設定から移行)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = ":%s/\\s\\+$//ge"
})

-- conceal設定 (旧設定から移行)
opt.conceallevel = 0
vim.g.vim_json_syntax_conceal = 0

-- 音・ベル無効化
opt.errorbells = false
opt.visualbell = false
