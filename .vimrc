runtime! userautoload/*.vim

" シェルに出力しない
set shellpipe=>

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" macmeta
if has("gui_running")
  set macmeta
endif

" Windows Subsystem for Linux
if system('uname -a | grep microsoft') != ''
  " ヤンクでクリップボードにコピー
  augroup myYank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe', @")
  augroup END

  " カーソル設定
  let &t_SI="\<CSI>5 q"
  let &t_EI="\<CSI>1 q"
endif

" enable clipboard
" set clipboard+=unnamed
set clipboard+=unnamedplus

" 行番号の表示
set number

" GUI font size
set guifont=Source\ Code\ Pro\ for\ Powerline:h10

" colorscheme
colorscheme solarized


" Terminal Color
let g:terminal_ansi_colors = [
\ '#073642',
\ '#dc322f',
\ '#859900',
\ '#b58900',
\ '#268bd2',
\ '#d33682',
\ '#2aa198',
\ '#eee8d5',
\ '#002b36',
\ '#cb4b16',
\ '#586e75',
\ '#657b83',
\ '#839496',
\ '#6c71c4',
\ '#93a1a1',
\ '#fdf6e3'
\ ]

" Ex wild mode
set wildmode=list:longest,full

" updatetime
set updatetime=200

" QuickFixでtabを開かないように設定上書き
set switchbuf=useopen

" highlighting ejs files
au BufNewFile,BufRead *.ejs set filetype=html

" vim indent guide on startup
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

" go indent setting
au BufNewFile,BufRead *.go set noexpandtab tabstop=4 shiftwidth=4

" jsx highlighting
au BufNewFile,BufRead *.js let g:jsx_ext_required = 0

" remove witespaces at end of lines
autocmd BufWritePre * :%s/\s\+$//ge

" Emacs like keybindings
imap <C-f> <Right>
imap <C-b> <Left>
imap <C-e> <End>
imap <C-a> <Home>

cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Shift+tabで逆インデント
inoremap <S-Tab> <C-d>

" js indent
let g:js_indent_typescript = 1
" disable folding javascript
function! JavaScriptFold()
endfunction

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" JSONの""を隠す機能無効化
set conceallevel=0
let g:vim_json_syntax_conceal = 0

" Emmet
let g:user_emmet_leader_key='<C-D>'

" Ack
let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <leader>* :Ack! "\b<cword>\b" <CR>

" fzf
set rtp+=~/.fzf
function! RunAg()
  let name = input('Keyword: ')
  execute 'Ag ' . name
endfunction

nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>P :Commands<CR>
nnoremap <leader>g :BCommits<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>a :call RunAg()<CR>

" ALE
let g:ale_cache_executable_check_failures = 1
let g:ale_fixers = {
      \   'ruby': ['rubocop'],
      \   'typescript': ['tslint'],
      \}

" LSP
autocmd FileType java setlocal omnifunc=lsp#complete
autocmd FileType ruby setlocal omnifunc=lsp#complete

nnoremap <expr> <silent> <C-]> execute(':LspDefinition') =~ "not supported" ? "\<C-]>" : ":echo<cr>"
