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
local XDG_STATE_HOME = og("XDG_STATE_HOME")
if XDG_STATE_HOME == "" then
	XDG_STATE_HOME = HOME .. ".local/state"
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
Update_cwd()
vim.opt.grepprg = "git grep -iIn $*"
vo.updatetime = 1000
vo.shell = "sh"

--- Backups
-- desabilita swapfile
vo.swapfile = true
vo.backup = true
vo.backupdir = XDG_STATE_HOME .. "/nvim/backup/"
-- undo persistente
vo.undofile = true

--- Movimento
-- quantidade de linhas ao redor do cursor
vo.scrolloff = 99
-- desativa uso do mouse
vo.mouse = ""
-- indica items quando procurando
vo.incsearch = true
-- da a volta entre linhas
vo.whichwrap:append("<,>,h,l,[,]")

--- Spell
vo.spell = false
-- Checagem ortográfica em varias línguas
vo.spelllang = { "pt", "en" }

--- Tabs/Espaços
vo.tabstop = 2
vo.shiftwidth = 2
-- troca tabs por espaços
vo.expandtab = false

--- Formatação
-- divide linhas sem quebrar palavras
vo.linebreak = true
-- tamanho das linhas
vo.textwidth = 80
-- formatação nativa
vo.formatoptions = "crqn1j"

----- Aparência -----
--- Miscelânea
-- linhas não dão a volta na tela
vo.wrap = false
-- esconde marcação
vo.conceallevel = 0
vo.concealcursor = ""
-- marcação em 80 caracteres
vo.colorcolumn = ""
vo.fillchars:append({ diff = "╱" })
-- indica linha atual
vo.cursorline = false

--- Cores
-- prefere modo escuro
vim.opt.background = "dark"
-- NormalNC causa muita lentidão - comumente ativado por temas
vim.api.nvim_set_hl(0, "NormalNC", {})
vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })

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
vo.signcolumn = "yes:1"

--- Números
vo.number = true
vo.numberwidth = 3
vo.relativenumber = true

--- Folding
vg.sh_fold_enabled = 1
-- vo.foldmethod = "syntax"
vo.foldcolumn = "1"
vo.foldlevel = 99
vo.foldnestmax = 3
vim.o.foldopen = "block,insert,jump,mark,percent,quickfix,search,tag,undo"

--- Netrw
-- desabilita o netrw
-- vg.loaded_netrw = 1
-- vg.loaded_netrwPlugin = 1
-- define o modo de listagem de arquivos
vg.netrw_liststyle = 3
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
	{ "TermOpen", { "*" },                   "setlocal nocursorline nonumber norelativenumber" },

	-- FileType
	{ "FileType", { "gitcommit" },           "norm zr" },
	{ "FileType", { "gitcommit" },           "setlocal spell" },
	{ "FileType", { "diff", "checkhealth" }, "setlocal nospell" },
	{
		"FileType",
		{ "css" },
		"setlocal formatoptions-=ro",
	},
	{
		"FileType",
		{ "markdown", "org", "txt", "norg" },
		"setlocal spell nolist concealcursor=nvic conceallevel=0 nocursorline colorcolumn=0",
	},
	{ "FileType", { "help" },  "setlocal nolist nocursorline colorcolumn=0" },

	-- TextYankPost
	-- indica texto copiado
	{
		"TextYankPost",
		{ "*" },
		function()
			vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
		end,
	},
})
