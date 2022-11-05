require("utils")
require("keys")
local vo = vim.opt
local vg = vim.g
local vc = vim.cmd
local vf = vim.fn
local ve = vim.env
local vanca = vim.api.nvim_create_autocmd
local vansh = vim.api.nvim_set_hl
local og = os.getenv
local HOME = og("HOME")
local XDG_DATA_HOME = og("XDG_DATA_HOME")
if XDG_DATA_HOME == "" then
  XDG_DATA_HOME = HOME .. "/.local/share"
end

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
vo.titleold = og("TERMINAL")
-- quantidade de linhas ao redor do cursor
vo.scrolloff = 10
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
-- não divide linhas no meio de palavras
vo.linebreak = true
vo.textwidth = 80
-- da a volta entre linhas
vo.whichwrap = vo.whichwrap + "<,>,h,l,[,]"
-- desativa comentar automaticamente a próxima linha
vanca("FileType", {
  pattern = { "*" },
  command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})
-- Checagem ortográfica em varias linguas
vo.spelllang = { "pt", "en" }
-- Ativa checagem ortografica typos de arquivos
vanca("FileType", { pattern = { "org" }, command = "setlocal spell" })
vanca("FileType", { pattern = { "markdown" }, command = "setlocal spell" })
vanca("FileType", { pattern = { "gitcommit" }, command = "setlocal spell" })
--- Writegood mode
vanca("FileType", {
  pattern = { "org" },
  command = "call timer_start(100, { tid -> execute('WritegoodEnable')})",
})
vanca("FileType", {
  pattern = { "markdown" },
  command = "call timer_start(100, { tid -> execute('WritegoodEnable')})",
})
--- Greplace
-- usa o git grep
vo.grepprg = "git grep -nIi"
if vf.getcwd() == HOME then
  ve.GIT_DIR = HOME .. "/.dotfiles"
  ve.GIT_WORK_TREE = HOME
end
--- zen-mode
-- ativa zen em arquivos específicos
vanca("FileType", {
  pattern = { "org" },
  command = "call timer_start(100, { tid -> execute('ZenMode')})",
})
vanca("FileType", {
  pattern = { "markdown" },
  command = "call timer_start(100, { tid -> execute('ZenMode')})",
})

--- Netrw
-- desabilita o netrw
vg.loaded_netrw = 1
vg.loaded_netrwPlugin = 1
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
vanca(
  "FileType",
  { pattern = { "lua" }, command = "setlocal tabstop=2 shiftwidth=2" }
)
-- formata com o stylua
if vf.getcwd() == HOME then
  vanca("BufWritePost", {
    pattern = { "*.lua" },
    command = "!stylua --config-path ./.config/stylua.toml %",
  })
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
-- remove numero de linhas no terminal
vanca(
  "TermOpen",
  { pattern = { "*" }, command = "setlocal nonumber norelativenumber" }
)
-- indicação de espaços e tabs
vo.list = true
vo.listchars = {
  tab = "> ",
  extends = "⟩",
  precedes = "⟨",
  trail = "~",
  multispace = "··",
  conceal = "*",
}
vanca("FileType", {
  pattern = { "*" },
  callback = function()
    ListChars()
  end,
})
-- folding
vg.sh_fold_enabled = 1
vg.foldenabled = true
vo.foldmethod = "syntax"
vo.foldcolumn = "0"
vo.foldnestmax = 3
vo.foldopen:append("jump")
vanca("FileType", { pattern = { "gitcommit" }, command = "norm zr" })
-- tema
vc.colorscheme("kimbox")
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
-- mostra a statusline
vo.laststatus = 3
-- diminui tamanho da barra inferior
vo.cmdheight = 0
-- transparência
vansh(0, "Normal", { bg = nil, ctermbg = nil })
vansh(0, "NormalNC", { bg = nil, ctermbg = nil })
vansh(0, "EndOfBuffer", { bg = nil, ctermbg = nil })
vansh(0, "FloatBorder", { bg = "#221A02", ctermbg = nil })
-- cores nvim-treesitter-context
vansh(0, "TreesitterContext", { bg = "#221A02" })
-- cor das palavras procuradas
vansh(0, "Search", { fg = "#ffff00", bg = nil, undercurl = true, bold = true })
-- signcolumn transparente
vansh(0, "SignColumn", { bg = nil, ctermbg = nil })
require("statusline")
-- estilo das splits
vansh(0, "VertSplit", { fg = "#221A02", bg = nil, ctermbg = nil })
-- Remove fundo cinza e melhores cores - gitsigns
vansh(0, "GitSignsDeleteNr", {
  bg = "#660000",
  ctermbg = nil,
  fg = "#ff0000",
  ctermfg = "Red",
})
vansh(0, "GitSignsChangeNr", {
  bg = "#666600",
  ctermbg = nil,
  fg = "#ffff00",
  ctermfg = "yellow",
})
vansh(0, "GitSignsAddNr", {
  bg = "#006600",
  ctermbg = nil,
  fg = "#00ff00",
  ctermfg = "green",
})

--- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("snippy").expand_snippet(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<A-e>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
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
    { name = "snippy" },
    { name = "plugins" },
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
    { name = "conventionalcommits" },
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
local capabilities = require("cmp_nvim_lsp").default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)
capabilities.textDocument.completion.completionItem.snippetSupport = true

--- lsp kind - ícones
cmp.setup({
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol", -- show only symbol annotations
      maxwidth = 50, -- prevent the pop-up from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = "…", -- when pop-up menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
    }),
  },
})

--- LSP
-- diagnostico
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  underline = false,
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

-- necessário `npm i -g vscode-langservers-extracted`
require("lspconfig").cssls.setup({
  on_attach = On_attach,
  capabilities = capabilities,
})
require("lspconfig").html.setup({
  capabilities = capabilities,
})

-- instale o omnisharp
require("lspconfig").omnisharp.setup({
  cmd = { "dotnet", XDG_DATA_HOME .. "/dotnet/OmniSharp.dll" },
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
