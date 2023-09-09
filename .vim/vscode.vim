if !exists('g:vscode')
  finish
endif

runtime! userautoload/plug.vim

" Install Plugins for vscode-neovim
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
call plug#end()

" enable clipboard
" set clipboard+=unnamed
set clipboard+=unnamedplus

" map leader key
let mapleader = " "
let g:mapleader = " "

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Map <Space> to / (search)
map <leader><space> /

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" <C-W><C-jkhl>でウィンドウを移動
map <C-W><C-j> <C-W>j
map <C-W><C-k> <C-W>k
map <C-W><C-h> <C-W>h
map <C-W><C-l> <C-W>l

" leader + * で現在選択中の単語を検索
nnoremap <leader>* :call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
" leader + a で検索サイドバーを開く
nnoremap <leader>a :call VSCodeNotify('workbench.action.findInFiles')<CR>

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack! '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

vnoremap <leader>* :call VisualSelection('gv', '')<CR>

" vscodeのサイドバーの表示/非表示を切り替える
nnoremap <leader>b :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>
" ターミナルにフォーカス
nnoremap <leader>j :call VSCodeNotify('workbench.action.terminal.focus')<CR>
