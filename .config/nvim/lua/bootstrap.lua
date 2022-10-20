-- bootstrap paq:
-- nvim --headless -u NONE -c 'lua require("bootstrap").bootstrap_paq()'
local PKGS = {
    -- vim mais rápido
    "lewis6991/impatient.nvim";
    -- gerenciador de pacotes
    "savq/paq-nvim";

    --- Miscelânea
    -- previsão de cores
    "norcalli/nvim-colorizer.lua";
    -- salva posição do cursor
    "ethanholz/nvim-lastplace";
    -- procura arquivos usando fzf
    { "junegunn/fzf", run = './install --bin', };
    "junegunn/fzf.vim";
    -- procura rapidamente
    "ctrlpvim/ctrlp.vim";

    --- Editar
    -- múltiplos cursores
    { "mg979/vim-visual-multi", branch = 'master' };
    -- troca/coloca aspas/parenteses
    "tpope/vim-surround";
    -- expande região selecionada
    "terryma/vim-expand-region";
    -- arvore de undos
    "mbbill/undotree";
    -- move linhas
    "matze/vim-move";
    -- procura e edita varias ocorrências de uma palavra
    "skwp/greplace.vim";
    -- remove espaços em linhas editadas
    "lewis6991/spaceless.nvim";

    --- Code
    -- comenta linhas
    "numToStr/Comment.nvim";
    -- fecha parenteses automaticamente
    "windwp/nvim-autopairs";
    -- indentação e indicação de sintaxe
    "nvim-treesitter/nvim-treesitter";
    -- lsp
    "neovim/nvim-lspconfig";
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
    -- tema
    "ellisonleao/gruvbox.nvim";
    -- statusline
    "famiu/feline.nvim";

    --- Escrever
    -- centraliza texto e esconde distrações ao escrever
    "junegunn/goyo.vim";
    -- previsão de markdown
    "ellisonleao/glow.nvim";
    -- markdown
    "godlygeek/tabular";
    "preservim/vim-markdown";
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
