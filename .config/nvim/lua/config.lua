---@diagnostic disable: assign-type-mismatch
require("utils")
require("keys")
local vo = vim.opt
local vg = vim.g
local vc = vim.cmd
local og = os.getenv
local HOME = og("HOME")
local XDG_DATA_HOME = og("XDG_DATA_HOME")
if XDG_DATA_HOME == "" then
  XDG_DATA_HOME = HOME .. "/.local/share"
end

----- Configuração -----
--- Miscelânea
vc("filetype plugin on")
vc("filetype indent on")
-- muda o titulo da janela
vo.title = true
vo.titleold = og("TERMINAL")
-- copiar e colar para o neovim
vo.clipboard:append({ "unnamedplus" })
-- procura ignorando maiúsculas
vo.ignorecase = true
vo.smartcase = true
Update_cwd()
vim.opt.grepprg = "git grep -iIn $*"
vo.updatetime = 500

--- Backups
-- desabilita swapfile
vo.swapfile = false
-- undo persistente
vo.undofile = true

--- Movimento
-- quantidade de linhas ao redor do cursor
vo.scrolloff = 10
-- desativa uso do mouse
vo.mouse = ""
-- indica items quando procurando
vo.incsearch = true
-- da a volta entre linhas
vo.whichwrap:append("<,>,h,l,[,]")

--- Spell
vo.spell = true
-- Checagem ortográfica em varias línguas
vo.spelllang = { "pt", "en" }

--- Tabs/Espaços
vo.tabstop = 4
vo.shiftwidth = 4
-- troca tabs por espaços
vo.expandtab = true

--- Formatação
-- divide linhas sem quebrar palavras
vo.linebreak = true
-- tamanho das linhas
vo.textwidth = 80
-- formatação nativa
vo.formatoptions = "tcrqn1j"

----- Aparência -----
--- Miscelânea
-- linhas não dão a volta na tela
vo.wrap = false
-- esconde marcação
vo.conceallevel = 0
-- marcação em 80 caracteres
vo.colorcolumn = "+1"

--- Cores
local vansh = vim.api.nvim_set_hl
-- prefere modo escuro
vo.background = "dark"
-- tema
pcall(vim.cmd.colorscheme, "gruvbox")
-- melhora suporte de cores
vo.termguicolors = true
-- listchars
vansh(0, "Whitespace", { fg = "#222222" })

--- Tabs/Espaços
-- indicação de espaços e tabs
vo.list = true
vo.listchars = {
  tab = "│ ",
  extends = "⟩",
  precedes = "⟨",
  trail = "~",
  multispace = "··",
  conceal = "*",
}

--- UI
-- compleção de comandos
vo.wildignorecase = true
vo.wildmode = { "longest", "list", "full" }
vo.completeopt = { "menu", "menuone", "preview", "noselect" }
-- divide a tela do lado e para baixo
vo.splitbelow = true
vo.splitright = true
vo.diffopt:append({ "horizontal" })
-- mostra a statusline
vo.laststatus = 3
-- mostra o echo buffer
vo.cmdheight = 0
-- mostra a tabline
vo.showtabline = 0
vo.signcolumn = "yes:5"

--- Números
vo.number = true
vo.numberwidth = 3
vo.relativenumber = true

--- Folding
vg.sh_fold_enabled = 1
-- vo.foldmethod = "syntax"
vo.foldcolumn = "9"
vo.foldlevel = 0
vo.foldnestmax = 3
vim.o.foldopen = "block,insert,jump,mark,percent,quickfix,search,tag,undo"

--- Netrw
-- desabilita o netrw
vg.loaded_netrw = 1
vg.loaded_netrwPlugin = 1
-- define o modo de listagem de arquivos
-- vg.netrw_liststyle = 3
-- remove o banner
vg.netrw_banner = 0
-- tamanho da split
vg.netrw_winsize = 20

--- autocmds helper
--@param autocmds table
function Autocmd(autocmds)
  for i, _ in pairs(autocmds) do
    if type(autocmds[i][3]) == "string" then
      vim.api.nvim_create_autocmd(
        autocmds[i][1],
        { pattern = autocmds[i][2], command = autocmds[i][3] }
      )
    elseif type(autocmds[i][3]) == "function" then
      vim.api.nvim_create_autocmd(
        autocmds[i][1],
        { pattern = autocmds[i][2], callback = autocmds[i][3] }
      )
    end
  end
end

Autocmd({
  -- TermOpen
  { "TermOpen", { "*" }, "setlocal nonumber norelativenumber" },

  -- FileType
  { "FileType", { "gitcommit" }, "norm zr" },
  { "FileType", { "diff" }, "setlocal nospell" },
  {
    "FileType",
    { "css" },
    "setlocal formatoptions-=ro tabstop=2 shiftwidth=2",
  },
  { "FileType", { "css" }, "setlocal tabstop=2 shiftwidth=2" },
  { "FileType", { "lua" }, "setlocal tabstop=2 shiftwidth=2" },
  { "FileType", { "make" }, "setlocal tabstop=2 shiftwidth=2" },
  {
    "FileType",
    { "html" },
    "setlocal conceallevel=3 tabstop=2 shiftwidth=2",
  },
  {
    "FileType",
    { "markdown", "org", "txt", "norg" },
    "setlocal nolist conceallevel=3 colorcolumn=0",
  },
  { "FileType", { "help" }, "setlocal nolist colorcolumn=0" },

  -- TextYankPost
  -- indica texto copiado
  {
    "TextYankPost",
    { "*" },
    function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
  },

  -- WinEnter
  -- centraliza buffers quando ha espaço
  {
    "WinEnter",
    { "*" },
    function()
      if vim.api.nvim_win_get_width(0) < 80 then
        vo.foldcolumn = "0"
        vo.signcolumn = "yes:1"
      else
        vo.foldcolumn = "9"
        vo.signcolumn = "yes:5"
      end
    end,
  },
})
