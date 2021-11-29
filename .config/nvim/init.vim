
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'fcpg/vim-fahrenheit'
Plug 'ap/vim-css-color'

call plug#end()

set mouse=a
set number

colorscheme fahrenheit

set showtabline=2
set laststatus=2

autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

set noshowmode
let g:lightline = {
	      \ 'colorscheme': 'fahrenheit',
      \ }
set background=dark

