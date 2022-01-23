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
" Inicia no modo foco
autocmd VimEnter * LiteDFMToggle

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
hi CursorLine guibg=#222222
highlight Search guibg=#222222 guifg=#ffff00

let mapleader ="z"
" Troca entre partes da mesma linha usando setas
nnoremap <Down> gj
nnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
vnoremap <Down> gj
vnoremap <Up> gk
" Comentar linhas
map cc :norm gcc<CR>j
" Copiar na linha abaixo
map P :norm o<CR>p
" Ativa/Desativa o corretor ortográfico
map <leader>s :setlocal spell! spelllang=pt<CR>
" Navega entre as divisórias
map <A-Left> <C-w>h
map <A-Down> <C-w>j
map <A-Up> <C-w>k
map <A-Right> <C-w>l
" Esconde a modeline
map <leader>x :LiteDFMToggle<CR>
" Expande região selecionada
map <leader><Up> <Plug>(expand_region_expand)
map <leader><Down> <Plug>(expand_region_shrink)
" Troca para o próximo buffer
map <leader><Tab> :bn<CR>
" Fecha buffer
map <leader>d :bd<CR>
" Divide a tela do lado
map <leader>S :vs<CR>
" Divide a tela abaixo
map <leader>b :sp<CR>
