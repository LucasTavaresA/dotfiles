-- bootstrap paq with:
-- nvim --headless -u NONE -c 'lua require("bootstrap").bootstrap_paq()'
local PKGS = {
    --- Iniciar
    -- vim mais rápido
    "lewis6991/impatient.nvim";
    -- gerenciador de pacotes
    "savq/paq-nvim";

    --- Miscelânea
    -- salva posição do cursor
    "ethanholz/nvim-lastplace";
    -- múltiplos cursores
    { "mg979/vim-visual-multi", branch = 'master' };
    -- comenta linhas
    "numToStr/Comment.nvim";
    -- troca/coloca aspas/parenteses
    "tpope/vim-surround";
    -- expande região selecionada
    "terryma/vim-expand-region";
    -- previsão de cores
    "norcalli/nvim-colorizer.lua";
    -- procura arquivos usando fzf
    { "junegunn/fzf", run = './install --bin', };
    "junegunn/fzf.vim";
    -- procura rapidamente
    "ctrlpvim/ctrlp.vim";
    -- arvore de undos
    "mbbill/undotree";
    -- move linhas
    "matze/vim-move";
    -- remove espaços em linhas editadas
    "lewis6991/spaceless.nvim";
    -- pula para palavras
    { "phaazon/hop.nvim", branch = 'v2' };

    --- Code
    -- procura e edita varias ocorrencias de uma palavra
    "skwp/greplace.vim";
    -- indentação e indicação de sintaxe
    "nvim-treesitter/nvim-treesitter";
    -- LSP
    "neovim/nvim-lspconfig";
    -- fecha parenteses apertando enter
    "jiangmiao/auto-pairs";
    -- indica diffs
    "lewis6991/gitsigns.nvim";
    -- snippets
    "SirVer/ultisnips";
    "honza/vim-snippets";
    -- autocompletion
    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-nvim-lsp";
    "hrsh7th/cmp-buffer";
    "hrsh7th/cmp-path";
    "hrsh7th/cmp-cmdline";
    "quangnguyen30192/cmp-nvim-ultisnips";

    --- Aparência
    -- Tema
    "ellisonleao/gruvbox.nvim";
    -- indica indentação
    "lukas-reineke/indent-blankline.nvim";
    -- statusline
    "famiu/feline.nvim";
}

local function clone_paq()
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
end

local function bootstrap_paq()
    clone_paq()

    -- Load Paq
    vim.cmd('packadd paq-nvim')
    local paq = require('paq')

    -- Exit nvim after installing plugins
    vim.cmd('autocmd User PaqDoneInstall quit')

    -- Read and install packages
    paq(PKGS)
    paq.install()
end

return { bootstrap_paq = bootstrap_paq }
