call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'leafgarland/typescript-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim'
Plug 'junegunn/vim-easy-align'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'szw/vim-tags'
Plug 'tpope/vim-rhubarb'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'slim-template/vim-slim'
Plug 'vicious-widgets/vicious'
Plug 'overcache/NeoSolarized'
Plug 'mattn/vim-lsp-settings'
Plug 'aklt/plantuml-syntax'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'hashivim/vim-terraform'
Plug 'jparise/vim-graphql'

call plug#end()
