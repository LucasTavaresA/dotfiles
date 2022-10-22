----- PLUGINS -----
require('impatient')
require 'nvim-lastplace'.setup {}
require("nvim-surround").setup()
require 'spaceless'.setup()
vim.opt.termguicolors = true
require 'colorizer'.setup({'*'} , {})
require('Comment').setup()
require('cleanfold').setup()
require("color-picker")

----- Configuração -----
--- Vim
vim.g.nocompatible = true
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
-- mantem configurações de buffers
vim.opt.hidden = true

--- Arquivos
-- desabilita swapfile
vim.opt.swapfile = false
--- netrw
-- define o modo de listagem de arquivos
vim.g.netrw_liststyle = 3
-- remove o banner
vim.g.netrw_banner = 0
-- define onde abrir arquivos
vim.g.netrw_browse_split = 4
-- tamanho da split
vim.g.netrw_winsize = 20

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
vim.opt.titleold = os.getenv("TERMINAL")
-- da a volta entre linhas
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,h,l,[,]"
-- ativa uso do mouse
vim.opt.mouse = "a"
-- copiar e colar para o neovim
vim.api.nvim_create_autocmd("InsertEnter", { pattern = { "*" }, command = "set cul", })
vim.api.nvim_create_autocmd("InsertLeave", { pattern = { "*" }, command = "set nocul", })
vim.opt.clipboard:append { "unnamedplus" }
-- atualiza o neovim mais rápido
vim.opt.updatetime = 100
-- procura ignorando maiúsculas
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- habilita a compleção de comandos
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.completeopt = { "menu", "menuone", "noselect" }
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
    { pattern = { "*" }, command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o", })
-- Ativa checagem ortografica em arquivos
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "org" }, command = "setlocal spell spelllang=pt", })
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "markdown" }, command = "setlocal spell spelllang=pt", })
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "gitcommit" }, command = "setlocal spell spelllang=pt", })

--- Aparência
-- indicação de sintaxe
vim.cmd.syntax('on')
-- mostra numero de linhas relativo
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.relativenumber = true
-- indicação de espaços e tabs
vim.opt.list = true
vim.opt.listchars = {
    tab = '> ',
    extends = '⟩',
    precedes = '⟨',
    trail = '~',
    multispace = '··',
    leadmultispace = '│···',
    conceal = '*',
}
-- folding
vim.g.sh_fold_enabled = 1
vim.g.foldenabled = true
vim.opt.foldmethod = 'syntax'
vim.opt.foldcolumn = '0'
vim.opt.foldnestmax = 3
vim.opt.foldopen:append('jump')
-- tema
-- prefere modo escuro
vim.opt.background = "dark"
-- esconde marcação
vim.opt.conceallevel = 3
vim.g.vim_markdown_conceal_code_blocks = 0
-- tema
require("gruvbox").setup({
    invert_selection = true,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "hard", -- can be "hard", "soft" or empty string
    dim_inactive = false,
    transparent_mode = true,
})
vim.cmd.colorscheme('gruvbox')
-- melhora suporte de cores
vim.opt.termguicolors = true
-- indica linha selecionada no modo normal
vim.opt.cursorline = false
-- define quando a barra superior aparece
vim.opt.showtabline = 0
-- mostra a modeline
vim.opt.laststatus = 3
-- diminui tamanho da barra inferior
-- vim.opt.cmdheight = 0
-- transparência
vim.api.nvim_set_hl(0, 'Normal', { bg = NONE, ctermbg = NONE })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = NONE, ctermbg = NONE })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = NONE, ctermbg = NONE })
-- cor da linha atual
vim.api.nvim_set_hl(0, 'CursorLine', { bg = "#333333" })
-- indica parentese correspondente
vim.api.nvim_set_hl(0, 'MatchParen', {
    cterm = { NONE,bold },
    bold = true,
    fg = "#ff0000",
    bg = NONE,
})
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#000000' })
-- não deleta pares automaticamente
require('nvim-autopairs').setup({
    map_bs = false,
})
-- signcolumn transparente
vim.api.nvim_set_hl(0, 'SignColumn', { bg = NONE, ctermbg = NONE })
require('statusline')

--- hover.nvim
require("hover").setup {
    init = function()
        require("hover.providers.lsp")
    end,
    preview_opts = {
        border = nil
    },
    -- Whether the contents of a currently open hover window should be moved
    -- to a :h preview-window when pressing the hover keymap.
    preview_window = true,
    title = true
}

--- zen-mode
require("zen-mode").setup {
    window = {
        width = 80, -- width of the Zen window
        height = 30, -- height of the Zen window
        options = {
            signcolumn = "no", -- disable signcolumn
            number = false, -- disable number column
            relativenumber = false, -- disable relative numbers
            cursorline = false, -- disable cursorline
            cursorcolumn = false, -- disable cursor column
            foldcolumn = "0", -- disable fold column
            list = false, -- disable whitespace characters
        },
    },
    -- callback where you can add custom code when the Zen window opens
    on_open = function(win)
    end,
    -- callback where you can add custom code when the Zen window closes
    on_close = function()
        vim.cmd.quit()
    end,
}
-- ativa zen em arquivos especificos
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "org" }, command = "call timer_start(100, { tid -> execute('ZenMode')})", })
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "markdown" }, command = "call timer_start(100, { tid -> execute('ZenMode')})", })

--- gitsigns
require("gitsigns").setup({
    worktrees = { {
        toplevel = vim.env.HOME,
        gitdir = vim.env.HOME .. '/.dotfiles'
    } }
})
-- Remove fundo cinza e melhores cores - gitsigns
vim.api.nvim_set_hl(0, 'GitSignsDelete', {
    bg = NONE,
    ctermbg = NONE,
    fg = "#ff0000",
    ctermfg = Red,
})
vim.api.nvim_set_hl(0, 'GitSignsChange', {
    bg = NONE,
    ctermbg = NONE,
    fg = "#ffff00",
    ctermfg = yellow,
})
vim.api.nvim_set_hl(0, 'GitSignsAdd', {
    bg = NONE,
    ctermbg = NONE,
    fg = "#008800",
    ctermfg = green,
})

-- Luasnip
require('luasnip').config.set_config({
    history = true, -- keep around last snippet local to jump back
    enable_autosnippets = true,
})
require("luasnip.loaders.from_snipmate").lazy_load({
    paths = { "/home/lucas/.config/nvim/Ultisnips/*" }
})

--- Telescope
require('telescope').setup {
    defaults = {
        theme = "dropdown",
        preview = false
    },
    pickers = {
        find_files = {
            find_command = { "fd", "--strip-cwd-prefix", "--base-directory",
                os.getenv('HOME'), "-d", "4", "-t", "f",
                "-E", "*log*", "-E", "*cache*", "-E", "*.local*", "-E", "*media*"
            }
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        }
    }
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('heading')

--- greplace
-- usa o git grep
vim.opt.grepprg = 'git grep -nIi'
if vim.fn.getcwd() == os.getenv('HOME') then
    vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles")
    vim.env.GIT_WORK_TREE = vim.fn.expand("~")
end

--- Treesitter
-- indentação e indicação de sintaxe
require'nvim-treesitter'.define_modules {
    fold = {
        attach = function()
            vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt_local.foldmethod = 'expr'
            vim.cmd.normal'zx' -- recompute folds
        end,
        detach = function() end,
    }
}
require'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 5, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer',
}
require 'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "lua", "c_sharp", "fish", "css",
        "comment", "go", "html", "javascript", "make",
        "norg", "org", "python", "vim" },
    highlight = { -- Indicação de sintaxe
        enable = true,
    },
    indent = {
        enable = true, -- Indentação
    },
    fold = {
        enable = true,
        disable = {'rst', 'make'}
    },
    context_commentstring = { enable = true }
}

----- Modulos -----
--- Teclas
require('keys')

-- compleção - nvim-cmp
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

--- LSP
-- diagnostico
vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = true,
    update_in_insert = false,
    severity_sort = false,
})

-- instale o clang e o ccls
require 'lspconfig'.ccls.setup {
    on_attach = On_attach,
    capabilities = capabilities,
    init_options = {
        compilationDatabaseDirectory = "build";
        index = {
            threads = 0;
        };
        clang = {
            excludeArgs = { "-frounding-math" };
        };
    }
}

-- necessario `npm i -g vscode-langservers-extracted`
require 'lspconfig'.cssls.setup {
    on_attach = On_attach,
    capabilities = capabilities,
}
require 'lspconfig'.html.setup {
    capabilities = capabilities,
}

-- instale o omnisharp
require 'lspconfig'.omnisharp.setup {
    cmd = { 'dotnet', '/usr/lib/omnisharp-roslyn/OmniSharp.dll' },
    on_attach = On_attach,
    capabilities = capabilities,
}

-- instale o lua-language-server
require 'lspconfig'.sumneko_lua.setup {
    on_attach = On_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
    capabilities = capabilities,
}

--- nvim-dap
require("dapui").setup()
require("nvim-dap-virtual-text").setup({})
require('telescope').load_extension('dap')

-- netcoredbg
require('dap').adapters.coreclr = {
    type = 'executable',
    command = '/usr/bin/netcoredbg',
    args = {'--interpreter=vscode'}
}
require('dap').configurations.cs = {{
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Project dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
},
}
