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
    -- move linhas
    "matze/vim-move";

    --- Code
    -- indentação e indicação de sintaxe
    "sheerun/vim-polyglot";
    { "nvim-treesitter/nvim-treesitter", run = ':TSUpdate', };
    -- fecha parenteses apertando enter
    "jiangmiao/auto-pairs";
    -- indica diffs
    "mhinz/vim-signify";
    -- snippets
    "SirVer/ultisnips";
    "honza/vim-snippets";

    --- Aparência
    -- Tema
    "morhetz/gruvbox";
})
require('impatient')
