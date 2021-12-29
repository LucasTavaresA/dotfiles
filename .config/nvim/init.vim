" Vim-plug

call plug#begin('~/.config/nvim/plugged')

Plug 'projekt0n/github-nvim-theme'
Plug 'farmergreg/vim-lastplace'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'bilalq/lite-dfm'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

" Indicação de sintaxe
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" C#
" Plug 'OmniSharp/omnisharp-vim'
" Plug 'dense-analysis/ale'
" Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'
" Markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
" sxhkd
Plug 'baskerville/vim-sxhkdrc'

call plug#end()

" Miscelânea
set whichwrap+=<,>,h,l,[,]
set hidden
" Indica linha selecionada no modo normal
set cursorline
" Ativa uso do mouse
set mouse=a
" Ativa numero de linhas
set number
" Define quando a barra superior aparece
set showtabline=0
" Diminui tamanho da barra inferior
set cmdheight=1
" Copiar usando vim
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set clipboard=unnamedplus
" Idioma para correção ortográfica
set spell spelllang=pt
" Junta os números e marcadores em uma única coluna
set signcolumn=number

" Aparência : github_dark_default
colorscheme github_dark_default
set background=dark
" Transparência
hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi Normal guibg=NONE ctermbg=NONE
hi CursorLine guibg=#303030

" AutoCompletação : COC
set shortmess+=c
" Usa tab para compleção
inoremap <silent><expr> <TAB>
     \ pumvisible() ? "\<C-n>" :
     \ <SID>check_back_space() ? "\<TAB>" :
     \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
 let col = col('.') - 1
 return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" AutoCompletação csharp : Omnisharp, Ale
" let g:ale_linters = {
" \ 'cs': ['OmniSharp']
" \}

" Indicador git : GitGutter
hi GitGutterAdd    guifg=#008000 ctermfg=2
hi GitGutterChange guifg=#FFFF00 ctermfg=3
hi GitGutterDelete guifg=#FF0000 ctermfg=1
let g:lf_map_keys = 0
let g:gitgutter_highlight_linenrs = 1

" Indicador indentação : IndentLine
let g:indentLine_enabled = 1
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
let g:indentLine_color_gui = '#777777'
let g:indentLine_char = '│'

" Troca entre partes da mesma linha usando setas
nnoremap <Down> gj
nnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
vnoremap <Down> gj
vnoremap <Up> gk

" Modo foco : LiteDFM
map E :LiteDFMToggle<CR>
autocmd VimEnter * LiteDFMToggle

" Previa de cores : nvim colorizer
autocmd VimEnter * ColorizerToggle

" Comentar linhas
map C :norm gcc<CR>j
