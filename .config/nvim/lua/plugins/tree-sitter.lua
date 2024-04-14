return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = function()
			local ts_update =
				require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
		dependencies = {
			{
				"lucastavaresa/ts-node-action",
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
				config = function()
					vim.keymap.set("n", "<S-j>", "")
				end,
			},
			{ "haringsrob/nvim_context_vt", config = true },
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
			-- melhor indicação de parâmetros e seu uso
			{
				"m-demare/hlargs.nvim",
				config = true,
			},
		},
		config = function()
			require("nvim-treesitter").define_modules({
				fold = {
					attach = function()
						vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
						vim.opt_local.foldmethod = "expr"
						vim.cmd.normal("zx") -- recompute folds
					end,
					detach = function() end,
				},
			})
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"c",
					"query",
					"markdown",
					"markdown_inline",
					"lua",
					"sql",
					"nix",
					"zig",
					"json",
					"yaml",
					"toml",
					"http",
					"rust",
					"vimdoc",
					"norg",
					"scheme",
					"haskell",
					"gdscript",
					"godot_resource",
					"gitignore",
					"git_rebase",
					"typescript",
					"commonlisp",
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
					"org",
					"python",
					"vim",
					"regex",
					"nim",
				},
				highlight = { -- Indicação de sintaxe
					enable = true,
					disable = function(_, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats =
							pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<S-k>",
						node_incremental = "<S-k>",
						node_decremental = "<S-j>",
					},
				},
				indent = {
					enable = true, -- Indentação
				},
				fold = {
					enable = true,
					disable = { "rst", "make" },
				},
				query_linter = {
					enable = true,
					use_virtual_text = true,
					lint_events = { "BufWrite", "CursorHold" },
				},
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = {
								query = "@class.inner",
								desc = "Select inner part of a class region",
							},
						},
						include_surrounding_whitespace = true,
					},
					swap = {
						enable = true,
						swap_next = {
							["<A-l>"] = "@parameter.inner",
						},
						swap_previous = {
							["<A-h>"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]]"] = "@function.outer",
							["]m"] = { query = "@class.outer", desc = "Next class start" },
						},
						goto_next_end = {
							["]["] = "@function.outer",
							["]M"] = "@class.outer",
						},
						goto_previous_start = {
							["[["] = "@function.outer",
							["[m"] = "@class.outer",
						},
						goto_previous_end = {
							["[]"] = "@function.outer",
							["[M"] = "@class.outer",
						},
					},
				},
				endwise = {
					enable = true,
				},
				autotag = {
					enable = true,
				},
			})

			require "nvim-treesitter.parsers".get_parser_configs().nelua = {
				install_info = {
					url = "~/code/nelua/tree-sitter-nelua",
					files = { "src/parser.c", "src/scanner.cc" },
					branch = "🧬", -- default branch in case of git repo if different from master
				},
			}
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		keys = {
			{
				"<leader>re",
				function()
					require("refactoring").refactor("Extract Function")
				end,
				noremap = true,
				silent = true,
				expr = false,
				mode = "v",
			},
			{
				"<leader>rf",
				function()
					require("refactoring").refactor("Extract Function To File")
				end,
				noremap = true,
				silent = true,
				expr = false,
				mode = "v",
			},
			{
				"<leader>rv",
				function()
					require("refactoring").refactor("Extract Variable")
				end,
				noremap = true,
				silent = true,
				expr = false,
				mode = "v",
			},
			{
				"<leader>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				noremap = true,
				silent = true,
				expr = false,
				mode = "v",
			},

			-- Extract block doesn't need visual mode
			{
				"<leader>rb",
				function()
					require("refactoring").refactor("Extract Block")
				end,
				noremap = true,
				silent = true,
				expr = false,
			},
			{
				"<leader>rbf",
				function()
					require("refactoring").refactor("Extract Block To File")
				end,
				noremap = true,
				silent = true,
				expr = false,
			},

			-- Inline variable can also pick up the identifier currently under the cursor without visual mode
			{
				"<leader>ri",
				function()
					require("refactoring").refactor("Inline Variable")
				end,
				noremap = true,
				silent = true,
				expr = false,
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup({
				prompt_func_return_type = {
					java = false,
					cpp = false,
					hpp = false,
					cxx = true,
					go = true,
					c = true,
					h = true,
					javascript = true,
					python = true,
					lua = true,
				},
				prompt_func_param_type = {
					java = false,
					cpp = false,
					hpp = false,
					cxx = true,
					go = true,
					c = true,
					h = true,
					javascript = true,
					python = true,
					lua = true,
				},
				printf_statements = {},
				print_var_statements = {},
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
		end,
	},
}
