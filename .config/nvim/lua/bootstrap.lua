-- bootstrap paq:
-- nvim --headless -u NONE -c 'lua require("bootstrap").bootstrap_paq()'
local PKGS = {
    -- vim mais rápido
    "lewis6991/impatient.nvim";
    -- gerenciador de pacotes
    "savq/paq-nvim";

    --- Miscelânea
    -- previsão de cores
    "lewis6991/nvim-colorizer.lua";
    -- salva posição do cursor
    "ethanholz/nvim-lastplace";
    -- procura rapidamente
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make" };
    "nvim-lua/plenary.nvim";
    "nvim-telescope/telescope.nvim";
    -- escolher cores
    "ziontee113/color-picker.nvim";

    --- Editar
    -- troca/coloca aspas/parenteses
    "kylechui/nvim-surround";
    -- expande região selecionada
    "terryma/vim-expand-region";
    -- arvore de undos
    "jiaoshijie/undotree";
    -- move linhas
    "fedepujol/move.nvim";
    -- remove espaços em linhas editadas
    "lewis6991/spaceless.nvim";
    -- procura e edita varias ocorrências de uma palavra
    "yegappan/greplace";
    -- alinha texto
    "Vonr/align.nvim";

    --- Code
    -- comenta linhas
    "numToStr/Comment.nvim";
    -- fecha parenteses automaticamente
    "windwp/nvim-autopairs";
    -- indentação e indicação de sintaxe
    "nvim-treesitter/nvim-treesitter";
    "nvim-treesitter/nvim-treesitter-textobjects";
    "JoosepAlviste/nvim-ts-context-commentstring";
    -- mostra função atual no topo
    "nvim-treesitter/nvim-treesitter-context";
    -- lsp
    "neovim/nvim-lspconfig";
    -- indica diffs
    "lewis6991/gitsigns.nvim";
    -- snippets
    "L3MON4D3/LuaSnip";
    "honza/vim-snippets";
    -- autocompletion
    "hrsh7th/nvim-cmp";
    "hrsh7th/cmp-nvim-lsp";
    "hrsh7th/cmp-buffer";
    "hrsh7th/cmp-path";
    "hrsh7th/cmp-cmdline";
    "saadparwaiz1/cmp_luasnip";
    -- mostra informação do codigo no cursor
    "lewis6991/hover.nvim";
    -- debug
    "rcarriga/nvim-dap-ui";
    "theHamsta/nvim-dap-virtual-text";
    "nvim-telescope/telescope-dap.nvim";
    "mfussenegger/nvim-dap";

    --- Aparência
    -- tema
    "ellisonleao/gruvbox.nvim";
    -- statusline
    "famiu/feline.nvim";
    -- fold mais bonitas
    "lewis6991/cleanfold.nvim";
    -- indicadores em foldings
    "lewis6991/foldsigns.nvim";

    --- Escrever
    -- esconde distrações ao escrever
    "folke/zen-mode.nvim";
    -- previsão de markdown
    "ellisonleao/glow.nvim";
    -- markdown
    "godlygeek/tabular";
    "preservim/vim-markdown";
    -- move entre headings
    "crispgm/telescope-heading.nvim";
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
    vim.api.nvim_create_autocmd("User", { pattern = { "PaqDoneInstall" }, command = "quit", })

    -- Read and install packages
    paq(PKGS)
    paq.install()
end

return { bootstrap_paq = bootstrap_paq }
