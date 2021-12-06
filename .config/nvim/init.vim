
call plug#begin('~/.vim/plugged')

Plug 'itchyny/lightline.vim'
Plug 'fcpg/vim-fahrenheit'
Plug 'ap/vim-css-color'
Plug 'farmergreg/vim-lastplace'
Plug 'jiangmiao/auto-pairs'
Plug 'ptzz/lf.vim'
Plug 'voldikss/vim-floaterm'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'

call plug#end()

set mouse=a
set number

colorscheme fahrenheit

set showtabline=2
set laststatus=2

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

set shortmess+=c
set hidden
set cmdheight=2
set updatetime=300
set statusline^=%{coc#status()}

autocmd InsertEnter * set cul
autocmd InsertLeave * set nocul

set noshowmode

let g:lightline = {
	\ 'colorscheme': 'fahrenheit',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
        \ },
        \ 'component_function': {
        \   'cocstatus': 'coc#status'
        \ },
        \ }
" Use autocmd to force lightline update.
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

set background=dark
set whichwrap+=<,>,h,l,[,]

hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi Normal guibg=NONE ctermbg=NONE
hi GitGutterAdd    guifg=#009900 ctermfg=2
hi GitGutterChange guifg=#FFFF00 ctermfg=3
hi GitGutterDelete guifg=#FF0000 ctermfg=1

let g:lf_map_keys = 0
map f :Lf<CR>

let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

let g:gitgutter_highlight_linenrs = 1
