-- bootstrap paq:
-- nvim --headless -u NONE -c 'lua require("bootstrap")' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
    -- vim mais rápido
    use "lewis6991/impatient.nvim"
    -- gerenciador de pacotes
    use 'wbthomason/packer.nvim'

    --- Miscelânea
    -- previsão de cores
    use "lewis6991/nvim-colorizer.lua"
    -- salva posição do cursor
    use "ethanholz/nvim-lastplace"
    -- procura rapidamente
    use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
    use "nvim-telescope/telescope-ui-select.nvim"
    use "nvim-lua/plenary.nvim"
    use "nvim-telescope/telescope.nvim"
    -- escolher cores
    use "ziontee113/color-picker.nvim"

    --- Editar
    -- troca/coloca aspas/parenteses
    use "kylechui/nvim-surround"
    -- expande região selecionada
    use "terryma/vim-expand-region"
    -- arvore de undos
    use "jiaoshijie/undotree"
    -- move linhas
    use "fedepujol/move.nvim"
    -- remove espaços em linhas editadas
    use "lewis6991/spaceless.nvim"
    -- procura e edita varias ocorrências de uma palavra
    use "yegappan/greplace"
    -- alinha texto
    use "Vonr/align.nvim"

    --- Code
    -- comenta linhas
    use "numToStr/Comment.nvim"
    -- fecha parenteses automaticamente
    use "windwp/nvim-autopairs"
    -- indentação e indicação de sintaxe
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use "nvim-treesitter/nvim-treesitter-textobjects"
    use "JoosepAlviste/nvim-ts-context-commentstring"
    -- mostra função atual no topo
    use "nvim-treesitter/nvim-treesitter-context"
    -- lsp
    use "neovim/nvim-lspconfig"
    -- indica diffs
    use "lewis6991/gitsigns.nvim"
    -- snippets
    use "L3MON4D3/LuaSnip"
    use "honza/vim-snippets"
    -- autocompletion
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-nvim-lua"
    use "hrsh7th/cmp-nvim-lsp-signature-help"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "saadparwaiz1/cmp_luasnip"
    use "f3fora/cmp-spell"
    -- mostra informação do codigo no cursor
    use "lewis6991/hover.nvim"
    use "ray-x/lsp_signature.nvim"
    -- debug
    use "rcarriga/nvim-dap-ui"
    use "theHamsta/nvim-dap-virtual-text"
    use "nvim-telescope/telescope-dap.nvim"
    use "mfussenegger/nvim-dap"
    -- indicação de carregamento lsp
    use "j-hui/fidget.nvim"

    --- Aparência
    -- tema
    use "ellisonleao/gruvbox.nvim"
    -- statusline
    use "famiu/feline.nvim"
    -- fold mais bonitas
    use "lewis6991/cleanfold.nvim"
    -- indicadores em foldings
    use "lewis6991/foldsigns.nvim"

    --- Escrever
    -- esconde distrações ao escrever
    use "folke/zen-mode.nvim"
    -- previsão de markdown
    use "ellisonleao/glow.nvim"
    -- markdown
    use "godlygeek/tabular"
    use "preservim/vim-markdown"
    -- indica mals habitos de escrita
    use "davidbeckingsale/writegood.vim"
    -- move entre headings
    use "crispgm/telescope-heading.nvim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
