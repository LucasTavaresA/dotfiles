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
vo.titlestring = "nvim"
vo.titleold = og("TERMINAL")
-- copiar e colar para o neovim
vo.clipboard:append({ "unnamedplus" })
-- procura ignorando maiúsculas
vo.ignorecase = true
vo.smartcase = true
-- dotfiles
if vim.fn.getcwd() == HOME then
  vim.env.GIT_DIR = HOME .. "/.dotfiles"
  vim.env.GIT_WORK_TREE = HOME
end

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
-- não vai automaticamente para os itens pesquisados
vo.incsearch = false
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
-- tabs em arquivos lua
Autocmd("FileType", { "lua" }, "setlocal tabstop=2 shiftwidth=2")

--- Formatação
-- divide linhas sem quebrar palavras
vo.linebreak = true
-- tamanho das linhas
vo.textwidth = 80
-- formatação nativa
vo.formatoptions = "tcrqn1j"
-- formatação ao salvar
Autocmd("BufWritePost", { "*.cs" }, "call jobstart('dotnet format')")

----- Aparência -----
--- Miscelânea
-- linhas não dão a volta na tela
vo.wrap = false
-- indica linha selecionada no modo normal
vo.cursorline = true
vo.cursorcolumn = true
-- esconde marcação
vo.conceallevel = 3
-- marcação em 80 caracteres
vo.colorcolumn = "+1"

--- Cores
local vansh = vim.api.nvim_set_hl
-- prefere modo escuro
vo.background = "dark"
-- tema
vc.colorscheme("gruvbox")
-- transparência
vansh(0, "Normal", { bg = nil, ctermbg = nil })
vansh(0, "NormalNC", { bg = nil, ctermbg = nil })
vansh(0, "EndOfBuffer", { bg = nil, ctermbg = nil })
-- cor das palavras procuradas
vansh(0, "Search", { bg = "#ffff00", fg = "#000000" })
-- signcolumn transparente
vansh(0, "SignColumn", { bg = nil, ctermbg = nil })
-- Palavras erradas
vansh(0, "SpellBad", { fg = "#ff0000", ctermfg = "Red", undercurl = true })
-- indicação de linha atual
vansh(0, "CursorLine", { bg = "#151515" })
vansh(0, "CursorColumn", { bg = "#151515" })
-- indicação em 80 caracteres
vansh(0, "ColorColumn", { bg = "#151515" })
-- Indica texto copiado
Autocmd("TextYankPost", { "*" }, function()
  vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
end)
-- indicação de sintaxe
vc.syntax("on")
-- melhora suporte de cores
vo.termguicolors = true

--- Tabs/Espaços
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

--- ajuda
Autocmd(
  "FileType",
  { "help" },
  "call timer_start(50, { tid -> execute('setlocal nolist laststatus=0 colorcolumn=0 nocursorline nocursorcolumn | only')})"
)

--- Números
vo.number = true
vo.numberwidth = 1
vo.relativenumber = true
Autocmd("TermOpen", { "*" }, "setlocal nonumber norelativenumber")

--- Folding
vg.sh_fold_enabled = 1
vo.foldmethod = "syntax"
vo.foldcolumn = "0"
vo.foldlevel = 1
vo.foldnestmax = 3
vo.foldopen:append("jump")
Autocmd("FileType", { "gitcommit" }, "norm zr")

--- Escrita
Autocmd(
  "FileType",
  { "markdown", "org", "txt", "norg" },
  "setlocal nolist laststatus=0 colorcolumn=0 nocursorline nocursorcolumn"
)

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
