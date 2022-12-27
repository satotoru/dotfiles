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
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'tpope/vim-rhubarb'
Plug 'prabirshrestha/vim-lsp'
Plug 'preservim/nerdtree'
Plug 'slim-template/vim-slim'
Plug 'overcache/NeoSolarized'
Plug 'mattn/vim-lsp-settings'
Plug 'aklt/plantuml-syntax'
Plug 'hashivim/vim-terraform'
Plug 'jparise/vim-graphql'
Plug 'dag/vim-fish'

call plug#end()
