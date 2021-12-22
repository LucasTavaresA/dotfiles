" Vim-plug

call plug#begin('~/.config/nvim/plugged')

Plug 'projekt0n/github-nvim-theme'
Plug 'farmergreg/vim-lastplace'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'kevinhwang91/rnvimr'
Plug 'Yggdroot/indentLine'
Plug 'bilalq/lite-dfm'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/vim-emoji'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'baskerville/vim-sxhkdrc'

call plug#end()

" Misc
set mouse=a
set number
set showtabline=2
set whichwrap+=<,>,h,l,[,]
set hidden
set cmdheight=1
autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul
set clipboard=unnamedplus
set spell spelllang=pt
set nowrap

" Aparencia : github_dark_default
colorscheme github_dark_default
set background=dark
" Transparencia
hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi Normal guibg=NONE ctermbg=NONE

" AutoCompletação : COC
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
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
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}
" COC
set shortmess+=c

" Indicador git : GitGutter
hi GitGutterAdd    guifg=#008000 ctermfg=2
hi GitGutterChange guifg=#FFFF00 ctermfg=3
hi GitGutterDelete guifg=#FF0000 ctermfg=1
let g:lf_map_keys = 0
let g:gitgutter_highlight_linenrs = 1

" Indiador indentação : IndentLine
let g:indentLine_enabled = 1
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
let g:indentLine_color_gui = '#FFFFFF'
let g:indentLine_char = '│'

" Modo foco : LiteDFM
map E :LiteDFMToggle<CR>
autocmd VimEnter * LiteDFMToggle

" Explorador de arquivos : Ranger
map f :RnvimrToggle<CR>

" Previa de cores : 
autocmd VimEnter * ColorizerToggle
