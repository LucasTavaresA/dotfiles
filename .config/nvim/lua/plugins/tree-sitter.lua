return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		dependencies = {
			{
				"CKolkey/ts-node-action",
				opts = {},
				keys = {
					{
						"<C-s>",
						function()
							require("ts-node-action").node_action()
						end,
					},
				},
			},
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
				config = function()
					vim.keymap.set("n", "<S-j>", "")
				end,
			},
			"JoosepAlviste/nvim-ts-context-commentstring",
			{
				"HiPhish/rainbow-delimiters.nvim",
				config = function()
					-- This module contains a number of default definitions
					local rainbow_delimiters = require 'rainbow-delimiters'

					vim.g.rainbow_delimiters = {
						strategy = {
							[''] = rainbow_delimiters.strategy['global'],
							commonlisp = rainbow_delimiters.strategy['local'],
						},
						query = {
							[''] = 'rainbow-delimiters',
							lua = 'rainbow-blocks',
						},
						highlight = {
							'RainbowDelimiterRed',
							'RainbowDelimiterYellow',
							'RainbowDelimiterBlue',
							'RainbowDelimiterOrange',
							'RainbowDelimiterGreen',
							'RainbowDelimiterViolet',
							'RainbowDelimiterCyan',
						},
					}
				end,
			},
			"windwp/nvim-ts-autotag",
			"RRethy/nvim-treesitter-endwise",
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
				},
			},
			{
				'daliusd/incr.nvim',
				opts = {
					incr_key = "<S-k>",
					decr_key = "<S-j>",
				},
			},
		},
		config = function()
			require("nvim-treesitter").install({
				"c",
				"query",
				"markdown",
				"markdown_inline",
				"lua",
				"sql",
				"json",
				"yaml",
				"toml",
				"http",
				"rust",
				"vimdoc",
				"haskell",
				"gdscript",
				"godot_resource",
				"gitignore",
				"git_rebase",
				"typescript",
				"dockerfile",
				"gitattributes",
				"c_sharp",
				"java",
				"fish",
				"bash",
				"css",
				"comment",
				"go",
				"html",
				"javascript",
				"tsx",
				"make",
				"python",
				"vim",
				"regex",
			})

			vim.api.nvim_create_autocmd('FileType', {
				pattern = {
					"cs",
					"c",
					"markdown",
					"lua",
					"rust",
					"typescript",
					"dockerfile",
					"cs",
					"java",
					"fish",
					"bash",
					"go",
					"html",
					"javascript",
					"python",
				},
				callback = function() vim.treesitter.start() end,
			})

			vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
				},
				move = {
					-- whether to set jumps in the jumplist
					set_jumps = true,
				},
			})

			vim.keymap.set({ "x", "o" }, "af", function()
				require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
			end)

			vim.keymap.set("n", "<A-l>", function()
				require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
			end)
			vim.keymap.set("n", "<A-h>", function()
				require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
			end)

			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "][", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "]M", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[]", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "[M", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
			end)

			---@diagnostic disable-next-line: missing-fields
			require('nvim-ts-autotag').setup({
				opts = {
					enable_close = true,     -- Auto close tags
					enable_rename = true,    -- Auto rename pairs of tags
					enable_close_on_slash = false -- Auto close on trailing </
				},
			})
		end,
	},
	{
		"lucastavaresa/SingleComment.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		init = function()
			vim.keymap.set(
				"n",
				"gcc",
				require("SingleComment").SingleComment,
				{ expr = true }
			)
			vim.keymap.set("v", "gcc", require("SingleComment").Comment, {})
			vim.keymap.set(
				"n",
				"gca",
				require("SingleComment").ToggleCommentAhead,
				{}
			)
			vim.keymap.set("n", "gcA", require("SingleComment").CommentAhead, {})
			vim.keymap.set({ "n", "v" }, "gcb", require("SingleComment").BlockComment)
			vim.keymap.set({ "n", "v" }, "gcp", require("SingleComment").CommentPaste)
		end,
	},
}
