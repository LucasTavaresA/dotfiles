return {
	--- Miscelânea
	{
		"Darazaki/indent-o-matic",
		lazy = false,
		opts = {
			max_lines = 2048,
			standard_widths = { 2, 4, 8 },
			skip_multiline = true,
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
		"catgoose/nvim-colorizer.lua",
		lazy = false,
		keys = {
			{ "zc", vim.cmd.ColorizerToggle },
		},
		init = function()
			vim.opt.termguicolors = true
		end,
		opts = {},
	},
	-- salva posição do cursor
	{
		"ethanholz/nvim-lastplace",
		lazy = false,
		config = true,
	},
	-- Trata jk como escape
	{
		"max397574/better-escape.nvim",
		lazy = false,
		opts = {
			timeout = vim.o.timeoutlen,
			mappings = {
				i = {
					j = {
						k = "<Esc>",
						j = false,
					},
				},
				c = {
					j = {
						k = "<Esc>",
						j = false,
					},
				},
				t = {
					j = {
						k = "<Esc>",
						j = false,
					},
				},
				v = {
					j = {
						k = false,
						j = false,
					},
				},
				s = {
					j = {
						k = "<Esc>",
						j = false,
					},
				},
			},
		},
	},

	--- Editar
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

	--- Code
	{
		"https://git.sr.ht/~p00f/godbolt.nvim",
		ft = { "c", "cpp", "rust", "cs" },
		opts =
		{
			-- languages = vim.o.filetype
			-- You can get the list of compiler ids by visiting or curling https://godbolt.org/api/compilers/<language>
			-- and the list of libraries by curling or visiting https://godbolt.org/api/libraries/<language>.
			languages = {
				cpp = { compiler = "g122", options = {} },
				c = { compiler = "cg122", options = {} },
				rust = { compiler = "r1650", options = {} },
				cs = { compiler = "dotnet707csharp", options = {} },
			},
			quickfix = {
				enable = false,        -- whether to populate the quickfix list in case of errors
				auto_open = false      -- whether to open the quickfix list in case of errors
			},
			url = "https://godbolt.org" -- can be changed to a different godbolt instance
		}
	},
	-- indicação de syntaxe nelua
	{ "edubart/nelua-vim",      ft = "nelua" },
	-- lidar com conflitos git
	{
		"akinsho/git-conflict.nvim",
		lazy = false,
		config = true,
	},
	-- balanceia parenteses
	{ "gpanders/nvim-parinfer", lazy = false },

	--- Aparência
	{
		'mei28/luminate.nvim',
		event = { 'VeryLazy' },
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
					{ text = { "│" } },
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
	-- indicador de indentação
	{
		"lucastavaresa/simpleIndentGuides.nvim",
		lazy = false,
		config = function()
			require("simpleIndentGuides").setup("│", "·")
		end,
	},
	{
		"lucastavaresa/headers.nvim",
		lazy = false,
		config = function ()
			require("headers").setup({ code_paths = { "/home/lucas/code/" }})
			vim.keymap.set(
				"n",
				"<space>HH",
				require("headers").fix_hovered
			)
			vim.keymap.set(
				"n",
				"<space>HI",
				require("headers").ignore
			)
		end,
	},

	--- Escrever
	-- supermaven ai completion
	{
		"supermaven-inc/supermaven-nvim",
		lazy = false,
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<A-u>",
				},
				-- color = {
				-- 	suggestion_color = "#ffffff",
				-- 	cterm = 244,
				-- },
				disable_inline_completion = false, -- disables inline completion for use with cmp
				disable_keymaps = false,       -- disables built in keymaps for more manual control
				log_level = "off",             -- set to "off" to disable logging completely
			})
		end,
	},
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
