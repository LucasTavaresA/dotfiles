require("impatient")
require("keys")
local vo = vim.opt
local vg = vim.g
local vc = vim.cmd
local vanca = vim.api.nvim_create_autocmd
local vansh = vim.api.nvim_set_hl

----- Configuração -----
vc("filetype plugin on")
vc("filetype indent on")
-- desabilita swapfile
vo.swapfile = false
-- undo persistente
vo.undofile = true
-- muda o titulo da janela
vo.title = true
vo.titlestring = "nvim"
vo.titleold = os.getenv("TERMINAL")
-- da a volta entre linhas
vo.whichwrap = vo.whichwrap + "<,>,h,l,[,]"
-- desativa uso do mouse
vo.mouse = ""
-- copiar e colar para o neovim
vanca("InsertEnter", { pattern = { "*" }, command = "set cul" })
vanca("InsertLeave", { pattern = { "*" }, command = "set nocul" })
vo.clipboard:append({ "unnamedplus" })
-- procura ignorando maiúsculas
vo.ignorecase = true
vo.smartcase = true
-- habilita a compleção de comandos
vo.wildmode = { "longest", "list", "full" }
vo.completeopt = { "menu", "menuone", "preview", "noselect" }
-- divide a tela do lado e para baixo
vo.splitbelow = true
vo.splitright = true
vo.diffopt:append({ "horizontal" })
-- não vai automaticamente para os itens pesquisados
vo.incsearch = false
-- linhas não dão a volta na tela
vo.wrap = false
-- desativa comentar automaticamente a próxima linha
vanca("FileType", { pattern = { "*" }, command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" })
-- Ativa checagem ortografica em arquivos
vanca("FileType", { pattern = { "org" }, command = "setlocal spell spelllang=pt" })
vanca("FileType", { pattern = { "markdown" }, command = "setlocal spell spelllang=pt" })
vanca("FileType", { pattern = { "gitcommit" }, command = "setlocal spell spelllang=pt" })
--- Writegood mode
vanca("FileType", { pattern = { "org" }, command = "call timer_start(100, { tid -> execute('WritegoodEnable')})" })
vanca("FileType", {
  pattern = { "markdown" },
  command = "call timer_start(100, { tid -> execute('WritegoodEnable')})",
})
--- Greplace
-- usa o git grep
vo.grepprg = "git grep -nIi"
if vim.fn.getcwd() == os.getenv("HOME") then
  vim.env.GIT_DIR = vim.fn.expand("~/.dotfiles")
  vim.env.GIT_WORK_TREE = vim.fn.expand("~")
end
--- zen-mode
-- ativa zen em arquivos especificos
vanca("FileType", { pattern = { "org" }, command = "call timer_start(100, { tid -> execute('ZenMode')})" })
vanca("FileType", { pattern = { "markdown" }, command = "call timer_start(100, { tid -> execute('ZenMode')})" })

--- Netrw
-- define o modo de listagem de arquivos
vg.netrw_liststyle = 3
-- remove o banner
vg.netrw_banner = 0
-- define onde abrir arquivos
vg.netrw_browse_split = 4
-- tamanho da split
vg.netrw_winsize = 20

--- Tabs/Espaços
vo.tabstop = 4
vo.shiftwidth = 4
-- troca tabs por espaços
vo.expandtab = true
-- tabs em arquivos lua
vanca("FileType", { pattern = { "lua" }, command = "setlocal tabstop=2 shiftwidth=2" })
-- formata com o stylua
if vim.fn.getcwd() == os.getenv("HOME") then
  vanca("BufWritePost", { pattern = { "*.lua" }, command = "!stylua --config-path ./.config/stylua.toml %" })
else
  vanca("BufWritePost", { pattern = { "*.lua" }, command = "!stylua %" })
end

--- Aparência
-- indicação de sintaxe
vc.syntax("on")
-- mostra numero de linhas relativo
vo.number = true
vo.numberwidth = 1
vo.relativenumber = true
-- remove numeor de linhas no terminal
vanca("TermOpen", { pattern = { "*" }, command = "setlocal nonumber norelativenumber" })
-- indicação de espaços e tabs
vo.list = true
vo.listchars = {
  tab = "> ",
  extends = "⟩",
  precedes = "⟨",
  trail = "~",
  multispace = "··",
  leadmultispace = "│···",
  conceal = "*",
}
-- folding
vg.sh_fold_enabled = 1
vg.foldenabled = true
vo.foldmethod = "syntax"
vo.foldcolumn = "0"
vo.foldnestmax = 3
vo.foldopen:append("jump")
-- tema
vc.colorscheme("kanagawa")
-- prefere modo escuro
vo.background = "dark"
-- esconde marcação
vo.conceallevel = 3
vg.vim_markdown_conceal_code_blocks = 0
-- melhora suporte de cores
vo.termguicolors = true
-- indica linha selecionada no modo normal
vo.cursorline = false
-- define quando a barra superior aparece
vo.showtabline = 0
-- mostra a modeline
vo.laststatus = 3
-- diminui tamanho da barra inferior
vo.cmdheight = 0
-- transparência
vansh(0, "Normal", { bg = nil, ctermbg = nil })
vansh(0, "EndOfBuffer", { bg = nil, ctermbg = nil })
vansh(0, "FloatBorder", { bg = nil, ctermbg = nil })
-- cor das palavras procuradas
vansh(0, "Search", { fg = "#ffff00", bg = nil, undercurl = true, bold = true })
-- cor da linha atual
vansh(0, "CursorLine", { bg = "#333333" })
-- cor da area selecionada
vansh(0, "Visual", { bg = "#0055ff" })
-- indica parentese correspondente
vansh(0, "MatchParen", {
  cterm = nil,
  bold = true,
  fg = "#ff0000",
  bg = nil,
})
vansh(0, "NormalFloat", { bg = "#000000" })
-- signcolumn transparente
vansh(0, "SignColumn", { bg = nil, ctermbg = nil })
require("statusline")
-- estilo das splits
vansh(0, "VertSplit", { fg = "#ffffff", bg = nil, ctermbg = nil })
-- Remove fundo cinza e melhores cores - gitsigns
vansh(0, "GitSignsDelete", {
  bg = nil,
  ctermbg = nil,
  fg = "#ff0000",
  ctermfg = "Red",
})
vansh(0, "GitSignsChange", {
  bg = nil,
  ctermbg = nil,
  fg = "#ffff00",
  ctermfg = "yellow",
})
vansh(0, "GitSignsAdd", {
  bg = nil,
  ctermbg = nil,
  fg = "#008800",
  ctermfg = "green",
})

--- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "buffer" },
    { name = "spell" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  sources = cmp.config.sources({
    { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = "buffer" },
  }),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
require("lspconfig").ccls.setup({
  on_attach = On_attach,
  capabilities = capabilities,
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { "-frounding-math" },
    },
  },
})

-- necessario `npm i -g vscode-langservers-extracted`
require("lspconfig").cssls.setup({
  on_attach = On_attach,
  capabilities = capabilities,
})
require("lspconfig").html.setup({
  capabilities = capabilities,
})

-- instale o omnisharp
require("lspconfig").omnisharp.setup({
  cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },
  on_attach = On_attach,
  capabilities = capabilities,
})

-- instale o lua-language-server
require("lspconfig").sumneko_lua.setup({
  on_attach = On_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
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
})
