----- PLUGINS -----
require('paq_init')

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

--- Aparência
-- indicação de sintaxe
vim.cmd.syntax('on')
-- tema
-- melhora suporte de cores
vim.opt.termguicolors = true
vim.g.gruvbox_italic = 1
vim.g.gruvbox_transparent_bg = 1
vim.g.gruvbox_contrast_dark = "hard"
vim.cmd.colorscheme('gruvbox')
-- tema do visual multi
vim.g.VM_theme = "neon"
-- indica linha selecionada no modo normal
vim.opt.cursorline = false
-- define quando a barra superior aparece
vim.opt.showtabline = 0
-- esconde a modeline
vim.opt.laststatus = 0
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
vim.api.nvim_create_autocmd("InsertLeave", { pattern = { "*" }, command = "set cursorline", })
-- incida parenteses correspondente
vim.cmd("hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=NONE guifg=#ff0000")
-- não deleta pares automaticamente
vim.g.AutoPairsMapBS = 0

--- Ctrlp
-- abre arquivos no repositório atual de acordo com o gitignore
vim.g.ctrlp_user_command = { '.git', 'cd %s && git ls-files -co --exclude-standard' }

--- Treesitter
-- indentação e indicação de sintaxe
local configs = require 'nvim-treesitter.configs'
configs.setup {
    ensure_installed = { "c", "lua", "c_sharp", "fish", "css",
        "comment", "go", "html", "javascript", "make", "markdown",
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
require('teclas')

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
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
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
