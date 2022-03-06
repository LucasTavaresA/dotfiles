require('packer').startup(function()
    ---- Vim
    -- Vim mais rapido
    use 'lewis6991/impatient.nvim'
    -- Gerenciador de pacotes
    use 'wbthomason/packer.nvim'

    ---- Aparencia
    -- Tema
    use '~/.config/nvim/plugins/moonlight.nvim'
    -- Indentação e indicação de sintaxe
    use 'sheerun/vim-polyglot'
    -- Indica diffs
    use 'mhinz/vim-signify'
    -- Esconde a barra
    use '~/.config/nvim/plugins/lite-dfm'

    ---- Miscellanea
    -- Fecha parenteses apertando enter
    use 'rstacruz/vim-closer'
    -- Salva posição do cursor
    use 'farmergreg/vim-lastplace'
    -- Múltiplos cursores
    use { 'mg979/vim-visual-multi', branch = 'master' }
    -- Comenta linhas
    use 'tpope/vim-commentary'
    -- Troca/coloca aspas/parenteses
    use 'tpope/vim-surround'
    -- Expande região selecionada
    use 'terryma/vim-expand-region'
    -- Previsão de cores
    use { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end }
    -- Procura usando o fzf
    use { 'junegunn/fzf', run = './install --bin', }
    use 'junegunn/fzf.vim'
    -- Procura linhas no buffer
    use 'pelodelfuego/vim-swoop'

    ---- Code
    -- sxhkd
    use 'baskerville/vim-sxhkdrc'
end)

---- vim
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
-- Mantem configurações de buffers
vim.opt.hidden = true
-- Diminui recarregamentos da tela
vim.opt.lazyredraw = true
-- Melhora support ao terminal
vim.opt.termguicolors = true

---- Arquivos
-- Desabilita swapfile
vim.opt.swapfile = false

---- Tabs/Espaços
-- Limita tabs em 4 espaços
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- Troca tabs por espaços
vim.opt.expandtab = true

---- Miscellanea
-- Muda o titulo da janela
vim.opt.title = true
vim.opt.titlestring = "nvim"
vim.opt.titleold = "st"
-- Da a volta entre linhas
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,h,l,[,]"
-- Ativa uso do mouse
vim.opt.mouse = "a"
-- Copiar e colar para o neovim
vim.cmd("autocmd InsertEnter * set cul")
vim.cmd("autocmd InsertLeave * set nocul")
vim.opt.clipboard:append { "unnamedplus" }
-- Atualiza o neovim mais rápido
vim.opt.updatetime = 100
-- Procura ignorando maiúsculas
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Habilita a compleção de comandos
vim.opt.wildmode = { "longest", "list", "full" }
-- Divide a tela do lado e para baixo
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Não vai automaticamente para os itens pesquisados
vim.opt.incsearch = false
-- Linhas não dão a volta na tela
vim.opt.wrap = false
-- Desativa comentar automaticamente a próxima linha
vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
-- Automaticamente deleta todos os espaços em branco e novas linhas no salvamento do arquivo
vim.cmd [[ autocmd BufWritePre * let currPos = getpos('.') ]]
vim.cmd [[ autocmd BufWritePre * %s/\s\+$//e ]]
vim.cmd [[ autocmd BufWritePre * %s/\n\+\%$//e ]]
vim.cmd [[ autocmd BufWritePre *.[ch] %s/\%$/\r/e ]]
vim.cmd [[ autocmd BufWritePre * cal cursor(currPos[1], currPos[2]) ]]

---- Aparência
-- Inicia sem a barra - LiteDFM
vim.cmd("autocmd VimEnter * LiteDFMToggle")
-- Tema - moonlight
vim.cmd("colorscheme moonlight")
-- Tema do visual multi
vim.g.VM_theme = "neon"
-- Indica linha selecionada no modo normal
vim.opt.cursorline = true
-- Define quando a barra superior aparece
vim.opt.showtabline = 0
-- Diminui tamanho da barra inferior
vim.opt.cmdheight = 1
-- Indicação de sintaxe
vim.cmd("syntax on")
-- Fundo escuro
vim.opt.background = "dark"
-- Transparência
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
-- Cor da linha atual
vim.cmd("hi CursorLine guibg=#2f334d")
vim.cmd("autocmd InsertLeave * set cursorline")
-- Cor de palavras pesquisadas
vim.cmd("highlight Search guibg=#000000 guifg=#ffff00")
-- Incida parenteses correspondente
vim.cmd("hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=NONE guifg=#ff0000")

local keymap = vim.api.nvim_set_keymap
local nr = { noremap = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Para indicação de palavras procuradas
keymap("n", "<esc><esc>", ":noh<CR>", {})
-- Comentar linhas
keymap("n", "cc", ":norm gcc<CR>j", {})
-- Copiar na linha abaixo
keymap("n", "P", ":norm o<CR>p", {})
-- Ativa/Desativa o corretor ortográfico
keymap("n", "ts", ":setlocal spell! spelllang=pt", {})
-- Navega entre as divisórias
keymap("n", "<leader><Tab>", ":wincmd w<CR>", nr)
-- Esconde a barra
keymap("n", "tb", ":LiteDFMToggle<CR>", {})
-- Salvar buffer
keymap("n", "<leader>ww", ":w<CR>", {})
-- Sair e salvar
keymap("n", "<leader>wq", ":wq!<CR>", {})
-- Fecha sem salvar
keymap("n", "<leader>qq", ":q!<CR>", {})
-- Divide a tela do lado
keymap("n", "<C-A-Right>", ":vs<CR>", {})
-- Divide a tela abaixo
keymap("n", "<C-A-down>", ":sp<CR>", {})
-- Ativa previsão de cores
keymap("n", "tc", ":ColorizerToggle<CR>", {})
-- Expande região selecionada
keymap("n", "<A-up>", "<Plug>(expand_region_expand)", nr)
keymap("n", "<A-down>", "<Plug>(expand_region_shrink)", nr)
-- Criar cursor na prox palavra
keymap("n", "<A-s-s>", "<C-n>", {})
-- Pular cursor ate a prox palavra
keymap("n", "<A-s>", "q", {})
-- Criar cursor abaixo/acima
keymap("n", "<C-s-Up>", "<C-Up>", {})
keymap("n", "<C-s-Down>", "<C-Down>", {})
-- Copiar buffer
keymap("n", "cb", "ggVGy", nr)
-- Procura linhas no buffer
keymap("n", ";", ":call Swoop()<CR>", {})
keymap("v", ";", ":call SwoopSelection()<CR>", {})
-- Abre arquivos no diretório atual
keymap("n", "ff", ":Files %:p:h<CR>", {})
-- Historico de arquivos
keymap("n", "fh", ":History<CR>", {})
-- Ativa/Desativa numeros de linha
keymap("n", "tn", ":set number!<CR>", {})
-- Trocar de buffer
keymap("n", "<A-Tab>", ":Buffers<CR>", {})
