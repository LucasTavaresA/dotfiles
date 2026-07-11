return {
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		dependencies = {
			{
				"dcampos/nvim-snippy",
				dependencies = "honza/vim-snippets",
				config = true,
			},
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"dcampos/cmp-snippy",
			"hrsh7th/cmp-buffer",
			"JMarkin/cmp-diag-codes",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"davidsierradz/cmp-conventionalcommits",
			"mtoohey31/cmp-fish",
			"bydlw98/cmp-env",
			"f3fora/cmp-spell",
			{ "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim" },
		},
		config = function()
			local has_words_before = function()
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
						and vim.api
						.nvim_buf_get_lines(0, line - 1, line, true)[1]
						:sub(col, col)
						:match("%s")
						== nil
			end
			local snippy = require("snippy")
			local cmp = require("cmp")

			local base_sources = {
				{
					name = "diag-codes",
					option = { in_comment = true },
				},
				{ name = "path" },
				{ name = "git" },
				{ name = "snippy" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "buffer" },
			}

			-- nvim-cmp has no per-source `ft` field, sources are scoped
			-- per filetype with cmp.setup.filetype below
			local function sources_with(extra)
				local list = vim.deepcopy(extra)
				vim.list_extend(list, base_sources)
				return cmp.config.sources(list)
			end

			cmp.setup({
				preselect = cmp.PreselectMode.None,
				view = {
					entries = "custom", -- can be "custom", "wildmenu" or "native"
				},
				snippet = {
					expand = function(args)
						snippy.expand_snippet(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<A-e>"] = cmp.mapping.complete({}),
					["<C-j>"] = cmp.mapping(function(fallback)
						if snippy.is_active() then
							snippy.next()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-k>"] = cmp.mapping(function(fallback)
						if snippy.is_active() then
							snippy.previous()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Up>"] = function(fallback)
						fallback()
					end,
					["<Down>"] = function(fallback)
						fallback()
					end,
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif snippy.can_expand_or_advance() then
							snippy.expand_or_advance()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif snippy.can_jump(-1) then
							snippy.previous()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources(vim.deepcopy(base_sources)),
			})

			cmp.setup.filetype("fish", {
				sources = sources_with({ { name = "env" }, { name = "fish" } }),
			})
			cmp.setup.filetype({ "zsh", "sh", "bash" }, {
				sources = sources_with({ { name = "env" } }),
			})
			cmp.setup.filetype("gitcommit", {
				sources = sources_with({
					{ name = "conventionalcommits" },
					{ name = "spell" },
				}),
			})
			cmp.setup.filetype("lua", {
				sources = sources_with({
					-- group index 0 skips loading LuaLS completions
					{ name = "lazydev", group_index = 0 },
				}),
			})
			cmp.setup.filetype({
				"conf",
				"config",
				"css",
				"yml",
				"toml",
				"dosini",
				"git",
				"gitrebase",
				"markdown",
				"org",
				"norg",
				"txt",
			}, {
				sources = sources_with({ { name = "spell" } }),
			})

			require("cmp_git").setup({})

			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				view = {
					entries = "custom", -- can be "custom", "wildmenu" or "native"
				},
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				view = {
					entries = "custom", -- can be "custom", "wildmenu" or "native"
				},
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
