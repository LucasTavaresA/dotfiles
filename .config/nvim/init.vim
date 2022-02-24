call plug#begin('~/.config/nvim/plugged')

Plug 'projekt0n/github-nvim-theme'
Plug 'farmergreg/vim-lastplace'
Plug 'mhinz/vim-signify'
Plug 'bilalq/lite-dfm'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'

call plug#end()

set hidden
set lazyredraw
" Desabilita swapfile
set noswapfile
" Da a volta entre linhas
set whichwrap+=<,>,h,l,[,]
" Indica linha selecionada no modo normal
set cursorline
" Ativa uso do mouse
set mouse=a
" Define quando a barra superior aparece
set showtabline=0
" Diminui tamanho da barra inferior
set cmdheight=1
" Copiar usando vim
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set clipboard+=unnamedplus
" Idioma para correção ortográfica
set spell spelllang=pt
" Junta os números e marcadores em uma única coluna
set signcolumn=number
" Atualiza o neovim mais rápido
set updatetime=100
" Procura ignorando maiúsculas
set ignorecase
set smartcase
" Desativa comentar automaticamente a próxima linha
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Habilita a compleção de comandos
set wildmode=longest,list,full
" Divide a tela do lado e para baixo
set splitbelow splitright
" Não vai automaticamente para os itens pesquisados
set incsearch!
" Inicia sem a barra
autocmd VimEnter * LiteDFMToggle
" Numero de linhas
set number
set signcolumn=number
" Linhas não dão a volta na tela
set nowrap

" Automaticamente deleta todos os espaços em branco e novas linhas no salvamento do arquivo e reseta a posição do cursor
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

colorscheme github_dark_default
set background=dark
" Transparência
hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi Normal guibg=NONE ctermbg=NONE
hi CursorLine guibg=#000000
highlight Search guibg=#000000 guifg=#ffff00
hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=NONE guifg=#ff0000

let mapleader =" "
let maplocalleader = " "
" Para indicação de palavras procuradas
nnoremap <esc><esc> :noh<return>
" Comentar linhas
map cc :norm gcc<CR>j
" Copiar na linha abaixo
map P :norm o<CR>p
" Ativa/Desativa o corretor ortográfico
map <leader>s :setlocal spell! spelllang=pt<CR>
" Navega entre as divisórias
map <leader><Tab> :wincmd w<CR>
" Esconde a modeline
map <leader>x :LiteDFMToggle<CR>
" Expande região selecionada
map <A-Up> <Plug>(expand_region_expand)
map <A-Down> <Plug>(expand_region_shrink)
" Troca para o próximo buffer
map <A-Tab> :bn<CR>
" Salvar buffer
map <leader>ww :w<CR>
" Sair e salvar
map <leader>wq :wq<CR>
" Fecha sem salvar
map <leader>qq :q!<CR>
" Divide a tela do lado
map <C-A-Right> :vs<CR>
" Divide a tela abaixo
map <C-A-down> :sp<CR>
" Selecionar multiplas palavras
map <A-s> <C-n>
" criar cursor em uma linha
map <C-s-Up> <C-Up>
map <C-s-Down> <C-Down>
" Copiar buffer
map cb ggVGy
