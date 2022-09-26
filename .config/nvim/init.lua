----- PLUGINS -----
-- clona o paq caso a sua pasta não exista
local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.fn.system {
        'git',
        'clone',
        '--depth=1',
        'https://github.com/savq/paq-nvim.git',
        path
    }
end

-- adiciona o paq aos pacotes do nvim
vim.cmd('packadd paq-nvim')

-- inicia o paq e seus pacotes
local paq = require('paq')
paq({
    --- Iniciar
    -- vim mais rápido
    "lewis6991/impatient.nvim";
    -- gerenciador de pacotes
    "savq/paq-nvim";

    --- Miscelânea
    -- salva posição do cursor
    "farmergreg/vim-lastplace";
    -- múltiplos cursores
    { "mg979/vim-visual-multi", branch = 'master' };
    -- comenta linhas
    "tpope/vim-commentary";
    -- troca/coloca aspas/parenteses
    "tpope/vim-surround";
    -- expande região selecionada
    "terryma/vim-expand-region";
    -- previsão de cores
    { "norcalli/nvim-colorizer.lua", config = function() require('colorizer').setup() end };
    -- procura arquivos usando fzf
    { "junegunn/fzf", run = './install --bin', };
    "junegunn/fzf.vim";
    -- procura arquivos rapidamente
    "ctrlpvim/ctrlp.vim";
    -- procura linhas no buffer
    "pelodelfuego/vim-swoop";
    -- arvore de undos
    "mbbill/undotree";

    --- Code
    -- indentação e indicação de sintaxe
    "sheerun/vim-polyglot";
    "nvim-treesitter/nvim-treesitter";
    -- fecha parenteses apertando enter
    "jiangmiao/auto-pairs";
    -- indica diffs
    "mhinz/vim-signify";
    -- buffer com erros no codigo
    "kyazdani42/nvim-web-devicons";
    { "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
        require("trouble").setup {
            padding = false,
            icons = false,
            fold_open = "v",
            fold_closed = ">",
            indent_lines = false,
            signs = {
                error = "error",
                warning = "warn",
                hint = "hint",
                information = "info"
            },
            use_diagnostic_signs = false
        }
      end
    };
    -- snippets
    "SirVer/ultisnips";
    "honza/vim-snippets";

    --- Aparência
    -- Tema
    "morhetz/gruvbox";
})
require('impatient')

-- carrega plugins locais
vim.opt.runtimepath:append("~/.config/nvim/plugins/lite-dfm")

----- Configuração -----
--- Vim
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
-- mantem configurações de buffers
vim.opt.hidden = true
-- diminui recarregamentos da tela
vim.opt.lazyredraw = true

--- Arquivos
-- desabilita swapfile
vim.opt.swapfile = false

--- Tabs/Espaços
-- limita tabs em 4 espaços
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- troca tabs por espaços
vim.opt.expandtab = true

--- Miscelânea
-- muda o titulo da janela
vim.opt.title = true
vim.opt.titlestring = "nvim"
vim.opt.titleold = "foot"
-- da a volta entre linhas
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,h,l,[,]"
-- ativa uso do mouse
vim.opt.mouse = "a"
-- copiar e colar para o neovim
vim.api.nvim_create_autocmd("InsertEnter", { pattern = {"*"}, command = "set cul", })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = {"*"}, command = "set nocul", })
vim.opt.clipboard:append { "unnamedplus" }
-- atualiza o neovim mais rápido
vim.opt.updatetime = 100
-- procura ignorando maiúsculas
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- habilita a compleção de comandos
vim.opt.wildmode = { "longest", "list", "full" }
-- divide a tela do lado e para baixo
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.diffopt:append { "horizontal" }
-- não vai automaticamente para os itens pesquisados
vim.opt.incsearch = false
-- linhas não dão a volta na tela
vim.opt.wrap = false
-- desativa comentar automaticamente a próxima linha
vim.api.nvim_create_autocmd("FileType", 
    { pattern = {"*"}, command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o", })

--- Aparência
-- indicação de sintaxe
vim.cmd("syntax on")
-- inicia sem a barra - LiteDFM
vim.api.nvim_create_autocmd("VimEnter", { pattern = {"*"}, command = "LiteDFMToggle", })
-- tema
-- melhora suporte de cores
vim.opt.termguicolors = true
vim.g.gruvbox_italic = 1
vim.g.gruvbox_transparent_bg = 1
vim.g.gruvbox_contrast_dark = "hard"
vim.cmd [[colorscheme gruvbox]]
-- tema do visual multi
vim.g.VM_theme = "neon"
-- indica linha selecionada no modo normal
vim.opt.cursorline = false
-- define quando a barra superior aparece
vim.opt.showtabline = 0
-- diminui tamanho da barra inferior
vim.opt.cmdheight = 1
-- fundo escuro
vim.opt.background = "dark"
-- transparência
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
-- cor da linha atual
vim.cmd("hi CursorLine guibg=#333333")
vim.api.nvim_create_autocmd("InsertLeave", { pattern = {"*"}, command = "set cursorline", })
-- incida parenteses correspondente
vim.cmd("hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=NONE guifg=#ff0000")
-- não deleta pares automaticamente
vim.g.AutoPairsMapBS = 0

--- Treesitter
-- indentação e indicação de sintaxe
local configs = require'nvim-treesitter.configs'
configs.setup {
    ensure_installed = "all",
    highlight = { -- Indicação de sintaxe
        enable = true,
    },
    indent = {
        enable = true, -- Indentação
    }
}
-- ativa folding do treesitter
--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

--- Ctrlp
-- abre arquivos no repositório atual de acordo com o gitignore
vim.cmd([[
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
]])

----- Teclas -----
local keymap = vim.api.nvim_set_keymap
local nr = { noremap = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- cancela indicação de palavras procuradas
keymap("n", "<esc><esc>", ":noh<CR>", {})
-- colar na linha abaixo
keymap("n", "P", ":norm o<CR>p", {})
-- ativa/desativa o corretor ortográfico
keymap("n", "tt", ":setlocal spell! spelllang=pt<CR>", {})
keymap("n", "te", ":setlocal spell! spelllang=en<CR>", {})
-- mudar o typo de arquivo
keymap("n", "ft", ":set filetype=", {})
-- salvar buffer
keymap("n", "<leader>ww", ":w<CR>", {})
-- sair e salvar
keymap("n", "<leader>wq", ":wq!<CR>", {})
-- fecha sem salvar
keymap("n", "<leader>qq", ":q!<CR>", {})
-- salvar e recarregar arquivo
keymap("n", "<leader>wr", ":w<CR>:e<CR>", {})
-- abre ultima mensagem
keymap("n", "<leader>m", ":message<CR>", {})
-- divide a tela do lado
keymap("n", "<C-A-Right>", ":vs<CR>", {})
-- divide a tela abaixo
keymap("n", "<C-A-Down>", ":sp<CR>", {})
-- copiar buffer
keymap("n", "cb", "ggVGy", nr)
-- ativa/desativa números de linha
keymap("n", "zn", ":set number!<CR>", {})
-- procura palavra no cursor
keymap("n", "?", "*", {})
-- abre terminal no local do arquivo atual
keymap("n", "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>", {})
-- executa um macro
keymap("n", "m", "@", {})
-- abre/fecha fold
keymap("n", "zz", "za", {})
-- marca/desmarca caixas
vim.cmd([[
function Marcar()
    let l:line=getline('.')
    let l:curs=winsaveview()
    if l:line=~?'\s*-\s*\[\s*\].*'
        s/\[.\]/[X]/
    elseif l:line=~?'\s*-\s*\[X\].*'
        s/\[X\]/[ ]/
    endif
    call winrestview(l:curs)
endfunction
autocmd FileType markdown nnoremap <silent> zx :call Marcar()<CR>j
autocmd FileType org nnoremap <silent> zx :call Marcar()<CR>j
]])

--- Plugins
-- atualiza plugins do paq - paq
keymap("n", "<leader>ps", ":PaqSync<CR>", {})
-- remove plugins não utilizados - paq
keymap("n", "<leader>pc", ":PaqClean<CR>", {})
-- ativa/desativa a barra - litedfm
keymap("n", "zb", ":LiteDFMToggle<CR>", {})
-- expande região selecionada - expand region
keymap("n", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("n", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("v", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("v", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("i", "<S-Up>", "<esc><Plug>(expand_region_expand)", {})
keymap("i", "<S-Down>", "<esc><Plug>(expand_region_shrink)", {})
-- Criar cursor na próxima palavra - visual multi
keymap("n", "<C-s>", "<C-n>", {})
keymap("v", "<C-s>", "<C-n>", {})
-- criar cursor abaixo - visual multi
keymap("n", "<A-s>", "<C-Down>", {})
-- procura linhas no buffer - swoop
keymap("n", ";", ":call Swoop()<CR>", {})
keymap("v", ";", ":call SwoopSelection()<CR>", {})
-- abre arquivos no repositório atual - ctrlp
keymap("n", "ff", ":CtrlP<CR>", {})
-- abre arquivos abertos recentemente - ctrlp
keymap("n", "<leader><leader>", ":CtrlPMRUFiles<CR>", {})
-- trocar de buffer
keymap("n", "<C-Tab>", ":bn", {})
-- abre arquivos na home - fzf
keymap("n", "fh", ":Files ~<CR>", {})
-- comentar linhas - vim comentary
keymap("n", "cc", "gccj", {})
keymap("v", "cc", "gc", {})
-- ativa previsão de cores - nvimcolorizer
keymap("n", "zr", ":ColorizerToggle<CR>", {})
-- abrir e fechar o buffer de diagnostico - Trouble
keymap("n", "zt", ":TroubleToggle<CR>", {})
-- abrir e fechar arvore de undos - undotree
keymap("n", "zu", ":UndotreeToggle<CR>:UndotreeFocus<CR>", {})
-- editar snippets para o tipo de arquivo atual - ultisnips
keymap("n", "<leader>es", ":UltiSnipsEdit<CR>", {})
-- troca entre partes do snippet - ultisnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"

