return {
	--- Miscelânea
	{
		"Darazaki/indent-o-matic",
		lazy = false,
		opts = {
			max_lines = 2048,
			standard_widths = { 2, 4, 8 },
			skip_multiline = true,
			-- Disable indent-o-matic for c files
			filetype_c = {
				max_lines = 0,
			},
		},
	},
	-- abre arquivos encriptados
	{
		"jamessan/vim-gnupg",
		lazy = false,
	},
	-- cria commandos com previsão
	{
		"smjonas/live-command.nvim",
		event = "CmdlineEnter",
		config = function()
			require("live-command").setup({
				commands = {
					Norm = { cmd = "norm" },
					D = { cmd = "d" },
					G = { cmd = "g" },
				},
			})
		end,
	},
	-- previne copia ao colar/deletar
	{
		"tenxsoydev/karen-yank.nvim",
		lazy = false,
		config = true,
	},
	-- desativa funções em arquivos muito grandes
	{
		"LunarVim/bigfile.nvim",
		lazy = false,
		config = true,
	},
	-- previsão e seleção de cores
	{
		"NvChad/nvim-colorizer.lua",
		lazy = false,
		keys = {
			{ "zc", vim.cmd.ColorizerToggle },
		},
		init = function()
			vim.opt.termguicolors = true
		end,
		config = true,
	},
	-- salva posição do cursor
	{
		"ethanholz/nvim-lastplace",
		lazy = false,
		config = true,
	},
	-- Trata jj como escape
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup({
				mapping = { "jj" },     -- a table with mappings to use
				timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
				clear_empty_lines = false, -- clear line after escaping if there is only whitespace
				keys = function()
					return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
				end,
			})
		end,
	},

	--- Editar
	-- :substitute using lua
	{
		"chrisgrieser/nvim-alt-substitute",
		opts = true,
		-- lazy-loading with `cmd =` does not work well with incremental preview
		event = "CmdlineEnter",
	},
	-- troca/coloca aspas/parenteses
	{
		"kylechui/nvim-surround",
		keys = {
			{ "S", mode = "v" },
			{ "ds" },
			{ "cs" },
		},
		config = true,
	},
	-- arvore de undos
	{
		"jiaoshijie/undotree",
		keys = {
			{
				"zu",
				function()
					require("undotree").toggle()
				end,
				noremap = true,
			},
		},
		config = true,
	},
	-- remove espaços em linhas editadas
	{
		"lewis6991/spaceless.nvim",
		lazy = false,
		config = true,
	},
	-- extende a funcionalidade de f,F,t,T
	{
		"echasnovski/mini.jump",
		keys = { "f", "F", "t", "T" },
		config = function()
			require("mini.jump").setup()
		end,
	},
	-- hexadecimal
	{
		"RaafatTurki/hex.nvim",
		cmd = "HexToggle",
		config = true,
	},
	-- pula usando pesquisas
	{
		"rlane/pounce.nvim",
		keys = { { "s", "<cmd>Pounce<cr>", mode = { "n", "v" } } },
	},

	--- Code
	-- indicação de syntaxe nelua
	{ "edubart/nelua-vim",      ft = "nelua" },
	-- lidar com conflitos git
	{
		"akinsho/git-conflict.nvim",
		lazy = false,
		config = true,
	},
	-- avaliar código
	{
		"michaelb/sniprun",
		ft = {
			"sh",
			"bash",
			"markdown",
			"org",
			"norg",
			"haskell",
			"c",
			"cs",
			"cpp",
			"go",
			"java",
			"javascript",
			"typescript",
			"rust",
			"lisp",
			"fennel",
			"lua",
			"python",
			"clojure",
			"cl",
			"scheme",
		},
		build = "bash ./install.sh",
		opts = { display = { "Terminal" } },
		keys = {
			{
				"<leader>ee",
				function()
					require("sniprun").run()
				end,
			},
			{
				"<leader>ee",
				function()
					require("sniprun").run("v")
				end,
				mode = { "v" },
			},
		},
	},
	-- balanceia parenteses
	{ "gpanders/nvim-parinfer", lazy = false },

	--- Aparência
	{
		"tzachar/highlight-undo.nvim",
		lazy = false,
		opts = true,
	},
	-- statuscolumn
	{
		"luukvbaal/statuscol.nvim",
		lazy = false,
		config = function()
			local builtin = require("statuscol.builtin")

			require("statuscol").setup({
				setopt = true,       -- Whether to set the 'statuscolumn' option
				ft_ignore = { "netrw" }, -- lua table with filetypes for which 'statuscolumn' will be unset
				bt_ignore = nil,     -- lua table with 'buftype' values for which 'statuscolumn' will be unset
				segments = {
					{ text = { "%s" }, click = "v:lua.ScSa" },
					{
						text = { builtin.lnumfunc },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
					{ text = { "🮇" } },
				},
			})
		end,
	},
	-- notificações menos intrusivas
	{
		"j-hui/fidget.nvim",
		lazy = false,
		opts = {},
	},
	-- indica palavra selecionada
	{
		"tzachar/local-highlight.nvim",
		lazy = false,
		config = function()
			require("local-highlight").setup({
				hlgroup = "CursorLine",
			})
		end,
	},
	-- indicador de indentação
	{
		"lucastavaresa/simpleIndentGuides.nvim",
		lazy = false,
		config = function()
			require("simpleIndentGuides").setup("│", "·")
		end,
	},
	-- tema
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			style = "night",                   -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			transparent = true,                -- Enable this to disable setting the background color
			sidebars = { "qf", "help", "netrw" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
			hide_inactive_statusline = false,  -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
			dim_inactive = false,              -- dims inactive windows
		},
	},
	-- indica modo atual no cursor
	{
		"doums/monark.nvim",
		lazy = false,
		config = function()
			require("monark").setup({
				clear_on_normal = true,
				sticky = true,
				offset = 1,
				timeout = 300,
				modes = {
					normal = { "N", "monarkNormal" },
					visual = { "V", "monarkVisual" },
					visual_l = { "VL", "monarkVisual" },
					visual_b = { "VB", "monarkVisual" },
					select = { "S", "monarkVisual" },
					insert = { "I", "monarkInsert" },
					replace = { "R", "monarkReplace" },
					terminal = { "T", "monarkInsert" },
				},
				hl_mode = "combine",
			})
		end,
	},

	--- Escrever
	-- traduz texto
	{
		"uga-rosa/translate.nvim",
		keys = {
			{
				"<leader>t",
				function()
					vim.cmd.Translate("en")
				end,
				mode = { "n", "v" },
			},
		},
		config = true,
	},
	-- edita blocos de código em um pop-up confiável
	{
		"AckslD/nvim-FeMaco.lua",
		keys = { { "<leader>fm", vim.cmd.FeMaco } },
		config = true,
	},
}
