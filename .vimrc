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

" enable clipboard
set clipboard+=unnamed

" 行番号の表示
set number

" GUI font size
set guifont=Source\ Code\ Pro\ for\ Powerline:h10

" Ex wild mode
set wildmode=list:longest,full

" updatetime
set updatetime=200

" highlighting ejs files
au BufNewFile,BufRead *.ejs set filetype=html

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

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

" js indent
let g:js_indent_typescript = 1
" disable folding javascript
function! JavaScriptFold()
endfunction

" Emmet
let g:user_emmet_leader_key='<C-D>'

" Ack
let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <leader>* :Ack! "\b<cword>\b" <CR>

" fzf
set rtp+=/usr/local/opt/fzf
function! RunAg()
  let name = input('Keyword: ')
  execute 'Ag ' . name
endfunction

nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>g :BCommits<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>a :call RunAg()<CR>

" Prettier
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync
