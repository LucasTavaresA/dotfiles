call plug#begin('~/.config/nvim/plugged')

" Tema
Plug '~/.config/nvim/plugged/moonlight.nvim'
" Salva posição do cursor
Plug 'farmergreg/vim-lastplace'
" Indica diffs
Plug 'mhinz/vim-signify'
" Esconde a barra
Plug '~/.config/nvim/plugged/lite-dfm'
" Multiplos cursores
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" Comenta linhas
Plug 'tpope/vim-commentary'
" Troca/coloca aspas/parenteses
Plug 'tpope/vim-surround'
" Expande região selecionada
Plug 'terryma/vim-expand-region'
" Previsão de cores
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

call plug#end()

filetype plugin on
filetype indent on
set hidden
set lazyredraw
" Limita tabs em 4 espaços
set tabstop=4
set shiftwidth=4
" Troca tabs por espaços
set expandtab
" Muda o titulo da janela
set title
set titlestring=nvim
set titleold=st
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
" Linhas não dão a volta na tela
set nowrap
" Estilo de previsão de cores
let g:Hexokinase_highlighters = [ 'backgroundfull' ]

" Automaticamente deleta todos os espaços em branco e novas linhas no salvamento do arquivo e reseta a posição do cursor
autocmd BufWritePre * let currPos = getpos(".")
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e
autocmd BufWritePre *.[ch] %s/\%$/\r/e
autocmd BufWritePre * cal cursor(currPos[1], currPos[2])

syntax on
colorscheme moonlight
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
map <leader>wq :wq!<CR>
" Fecha sem salvar
map <leader>qq :q!<CR>
" Divide a tela do lado
map <C-A-Right> :vs<CR>
" Divide a tela abaixo
map <C-A-down> :sp<CR>
" Ativa previsão de cores
map <leader>r :ColorizerToggle<CR>
" Selecionar multiplas palavras
map <A-s> <C-n>
" criar cursor em uma linha
map <C-s-Up> <C-Up>
map <C-s-Down> <C-Down>
" Copiar buffer
map cb ggVGy
