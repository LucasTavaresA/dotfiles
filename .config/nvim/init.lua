----- PLUGINS -----
require('impatient')
require 'nvim-lastplace'.setup {}
require('gitsigns').setup()
require 'spaceless'.setup()
vim.cmd('set termguicolors')
require('colorizer').setup()
require('Comment').setup()

----- Configuração -----
--- Vim
vim.g.nocompatible = true
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
-- mantem configurações de buffers
vim.opt.hidden = true
-- diminui recarregamentos da tela
vim.opt.lazyredraw = true

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
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
-- cor da linha atual
vim.cmd("hi CursorLine guibg=#333333")
-- incida parenteses correspondente
vim.cmd("hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=NONE guifg=Red")
-- não deleta pares automaticamente
require('nvim-autopairs').setup({
  map_bs = false,
})
-- signcolumn transparente
vim.cmd([[
    hi SignColumn guibg=NONE ctermbg=NONE
]])
require('statusline')
-- ativa goyo em arquivos especificos
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "org" }, command = "call timer_start(100, { tid -> execute('Goyo')})", })
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "markdown" }, command = "call timer_start(100, { tid -> execute('Goyo')})", })

--- gitsigns
-- melhora cores - gitsigns
vim.cmd([[
    hi GitSignsDelete guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=red
    hi GitSignsChange guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=yellow
    hi GitSignsAdd guibg=NONE ctermbg=NONE guifg=#008800 ctermfg=green
]])

--- Ultisnips
vim.g.UltiSnipsSnippetDirectories = {
    "/home/lucas/.config/nvim/Ultisnips/",
}

--- Ctrlp
-- abre arquivos no repositório atual de acordo com o gitignore
vim.g.ctrlp_user_command = "fd --base-directory $HOME -d 4 -t f -E '*log*' -E '*cache*' -E '*.local*' -E '*media*'"

--- greplace
-- usa o git grep
vim.opt.grepprg = 'git grep'
vim.g.grep_cmd_opts = '-nrIi'

--- Treesitter
-- indentação e indicação de sintaxe
local configs = require 'nvim-treesitter.configs'
configs.setup {
    ensure_installed = { "c", "lua", "c_sharp", "fish", "css",
        "comment", "go", "html", "javascript", "make",
        "norg", "org", "python", "vim" },
    highlight = { -- Indicação de sintaxe
        enable = true,
    },
    indent = {
        enable = true, -- Indentação
    }
}

----- Modulos -----
--- Teclas
require('keys')

-- compleção - nvim-cmp
local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end,
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
        { name = 'ultisnips' },
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

