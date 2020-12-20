if has('nvim')
  set rtp^=/home/satotoru/.vim/
  tnoremap <C-W><C-n> <C-\><C-n>
endif

runtime! userautoload/*.vim

" シェルに出力しない
set shellpipe=>

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

  command! Winpaste r !win_paste

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
colorscheme NeoSolarized

" Ex wild mode
set wildmode=list:longest,full

" updatetime
set updatetime=200

" QuickFixでtabを開かないように設定上書き
set switchbuf=useopen

" vim indent guide on startup
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1

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

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" JSONの""を隠す機能無効化
set conceallevel=0
let g:vim_json_syntax_conceal = 0

" Terminal
function! TermOpen()
  if empty(term_list())
    execute "terminal ++close"
  else
    let bufnr = term_list()[0]
    let winnr = bufwinnr(bufnr)
    echo winnr
    if winnr < 0
      execute "sbuffer " . bufnr
    else
      execute winnr . "hide"
    endif
  endif
endfunction
command! TermOpen call TermOpen()
command! TermNew execute "terminal++close"
nnoremap <leader>t :call TermOpen()<CR>
tnoremap <C-W>t <C-W>:call TermOpen()<CR>

" Emmet
let g:user_emmet_leader_key='<C-D>'

" Ack
let g:ackprg = 'ag --nogroup --nocolor --column'
nnoremap <leader>* :Ack! "\b<cword>\b" <CR>
vnoremap <leader>* :call VisualSelection('gv', '')<CR>

" fzf
set rtp+=~/.fzf
function! RunAg()
  let name = input('Keyword: ')
  if name != ""
    execute 'Ag ' . name
  endif
endfunction

nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>: :Commands<CR>
nnoremap <leader>P :Commands<CR>
nnoremap <leader>g :BCommits<CR>
nnoremap <leader>a :call RunAg()<CR>

" LSP
let g:lsp_text_edit_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> <C-]> <plug>(lsp-definition)
  nmap <buffer> <leader>ld <plug>(lsp-definition)
  nmap <buffer> <leader>lf <plug>(lsp-document-format)
  nmap <buffer> <leader>lr <plug>(lsp-references)
  nmap <buffer> <leader>li <plug>(lsp-implementation)
  nmap <buffer> <leader>lt <plug>(lsp-type-definition)
  nmap <buffer> <leader>la <Plug>(lsp-code-action)
  nmap <buffer> <leader>l[ <Plug>(lsp-previous-diagnostic)
  nmap <buffer> <leader>l] <Plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> K <plug>(lsp-hover)

  " refer to doc to add more commands
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" vim-terraform
let g:terraform_align=1
let g:terraform_fmt_on_save=1
