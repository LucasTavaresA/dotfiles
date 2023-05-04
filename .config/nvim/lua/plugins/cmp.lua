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
			"dcampos/cmp-snippy",
			"hrsh7th/cmp-buffer",
			"JMarkin/cmp-diag-codes",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"davidsierradz/cmp-conventionalcommits",
			"mtoohey31/cmp-fish",
			"bydlw98/cmp-env",
			"amarakon/nvim-cmp-fonts",
			"f3fora/cmp-spell",
			{ "petertriho/cmp-git", dependencies = "nvim-lua/plenary.nvim" },
			{
				"KadoBOT/cmp-plugins",
				config = function()
					require("cmp-plugins").setup({
						files = { ".config/nvim/lua/plugins" }, -- Recommended: use static filenames or partial paths
					})
				end,
			},
			{
				"onsails/lspkind.nvim",
				config = function()
					require("cmp").setup({
						experimental = { ghost_text = true },
						window = {
							completion = {
								winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
								col_offset = -3,
								side_padding = 0,
							},
						},
						formatting = {
							fields = { "kind", "abbr", "menu" },
							format = function(entry, vim_item)
								local kind = require("lspkind").cmp_format({
									mode = "symbol_text",
									maxwidth = 25,
									ellipsis_char = "…", -- when pop-up menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
								})(entry, vim_item)
								local strings = vim.split(kind.kind, "%s", { trimempty = true })
								kind.kind = " " .. (strings[1] or "") .. " "
								kind.menu = "    (" .. (strings[2] or "") .. ")"
								return kind
							end,
						},
					})
				end,
			},
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
				sources = cmp.config.sources({
					{
						name = "diag-codes",
						option = { in_comment = true }
					},
					{ name = "path" },
					{ name = "env", ft = { "fish", "zsh", "sh", "bash" } },
					{ name = "fish", ft = "fish" },
					{ name = "plugins", ft = "lua" },
					{ name = "nvim_lua", ft = "lua" },
					{ name = "git" },
					{ name = "conventionalcommits", ft = "gitcommit" },
					{ name = "snippy" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{
						name = "fonts",
						option = { space_filter = "-" },
						ft = { "conf", "config", "css", "yml", "toml", "dosini" },
					},
					{
						name = "spell",
						ft = {
							"conf",
							"config",
							"css",
							"yml",
							"toml",
							"dosini",
							"git",
							"gitcommit",
							"gitrebase",
							"markdown",
							"org",
							"norg",
							"txt",
						},
					},
				}),
			})

			require("cmp_git").setup()

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
