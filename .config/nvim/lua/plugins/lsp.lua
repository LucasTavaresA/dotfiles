return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			{
				"seblyng/roslyn.nvim",
				ft = "cs",
				---@module 'roslyn.config'
				---@type RoslynNvimConfig
				opts = {
					-- "auto" | "roslyn" | "off"
					--
					-- - "auto": Does nothing for filewatching, leaving everything as default
					-- - "roslyn": Turns off neovim filewatching which will make roslyn do the filewatching
					-- - "off": Hack to turn off all filewatching. (Can be used if you notice performance issues)
					filewatching = "auto",
				}
			},
			"Hoffs/omnisharp-extended-lsp.nvim",
			-- {
			--   "Decodetalkers/csharpls-extended-lsp.nvim",
			--   dependencies = "neovim/nvim-lspconfig",
			--   ft = "cs",
			-- },
			{ "folke/lazydev.nvim", ft = "lua", config = true },
			{
				"pmizio/typescript-tools.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
				opts = {},
			},
			"ibhagwan/fzf-lua",
			{
				"glepnir/lspsaga.nvim",
				dependencies = {
					--Please make sure you install markdown and markdown_inline parser
					{ "nvim-treesitter/nvim-treesitter" },
				},
				config = function()
					require("lspsaga").setup({
						lightbulb = {
							enable = false,
						},
						diagnostic = {
							-- 1 is max
							max_width = 1,
						},
						symbol_in_winbar = {
							enable = false,
						},
					})

					local vks = vim.keymap.set

					-- LSP finder - Find current symbol's references
					vks("n", "gr", "<cmd>Lspsaga finder ref+tyd+imp+def<CR>")

					-- Code action
					vks({ "n", "v" }, "ga", "<cmd>Lspsaga code_action<CR>")

					-- -- Rename all occurrences of the hovered word for the entire file
					-- vks("n", "<leader>r", "<cmd>Lspsaga rename<CR>")
					-- Rename all occurrences of the hovered word for the selected files
					vks("n", "<leader>R", "<cmd>Lspsaga rename ++project<CR>")

					vks("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

					vks("n", "gd", "<cmd>Lspsaga goto_definition<CR>")

					vks("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
					vks("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")

					vks("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")
					vks("n", "gT", "<cmd>Lspsaga goto_type_definition<CR>")

					-- Show line diagnostics
					vks(
						"n",
						"<leader>d",
						"<cmd>Lspsaga show_line_diagnostics ++unfocus<CR>"
					)

					-- Show buffer diagnostics
					vks(
						"n",
						"<leader>D",
						"<cmd>Lspsaga show_buf_diagnostics ++unfocus<CR>"
					)

					-- Toggle outline
					vks("n", "zo", "<cmd>Lspsaga outline<CR>")

					-- keep the hover window in the top right hand corner
					vks("n", "H", "<cmd>Lspsaga hover_doc ++keep<CR>")
				end,
			},
			{
				"nvimtools/none-ls.nvim",
				config = function()
					local null_ls = require("null-ls")
					null_ls.setup({
						sources = {
							-- git
							null_ls.builtins.code_actions.gitsigns,
							-- css
							null_ls.builtins.diagnostics.stylelint,
							-- go
							null_ls.builtins.diagnostics.golangci_lint,
							-- fish
							null_ls.builtins.diagnostics.fish,
							null_ls.builtins.formatting.fish_indent,
							-- shell
							null_ls.builtins.formatting.shfmt.with({
								extra_args = { "-ci" },
							}),
							null_ls.builtins.hover.printenv,
							-- escrita
							null_ls.builtins.diagnostics.write_good,
							-- csharp
							null_ls.builtins.formatting.csharpier.with({ command = "dotnet-csharpier" }),
						},
					})
				end,
			},
		},
		config = function()
			local XDG_DATA_HOME = os.getenv("XDG_DATA_HOME")
			if XDG_DATA_HOME == "" then
				XDG_DATA_HOME = os.getenv("HOME") .. "/.local/share"
			end

			local capabilities = vim.tbl_deep_extend(
				"force",
				vim.lsp.protocol.make_client_capabilities(),
				require("cmp_nvim_lsp").default_capabilities()
			)
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Ativa quando o lsp esta ativo
			On_attach = function(_, bufnr)
				vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

				local bns = { buffer = bufnr, noremap = true, silent = true }
				vim.keymap.set({ "n", "v" }, "gD", vim.lsp.buf.declaration, bns)
				vim.keymap.set(
					{ "n", "v" },
					"gi",
					"<cmd>FzfLua lsp_implementations<cr>",
					bns
				)
				-- usando lsp_saga
				-- vim.keymap.set(
				--   { "n", "v" },
				--   "gr",
				--   "<cmd>FzfLua lsp_references<cr>",
				--   bns
				-- )
				vim.keymap.set(
					{ "n", "v" },
					"gs",
					"<cmd>FzfLua lsp_document_symbols<cr>",
					bns
				)
				vim.keymap.set(
					{ "n", "v" },
					"gS",
					"<cmd>FzfLua lsp_workspace_symbols<cr>",
					bns
				)
				-- usando lspsaga
				-- vim.keymap.set({ "n", "v" }, "<leader>r", vim.lsp.buf.rename, bns)
			end

			-- diagnostico
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- instale o clang
			vim.lsp.config('clangd', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('clangd')

			-- npm i -g vscode-langservers-extracted
			vim.lsp.config('cssls', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.config('html', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('cssls')
			vim.lsp.enable('html')

			-- npm i -g cssmodules-language-server
			vim.lsp.config('cssmodules_ls', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('cssmodules_ls')

			-- npm i -g @tailwindcss/language-server
			vim.lsp.config('tailwindcss', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('tailwindcss')

			require("typescript-tools").setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('typescript-tools')

			-- npm i -g quick-lint-js
			vim.lsp.config('quick_lint_js', {})
			vim.lsp.enable('quick_lint_js')

			-- go install github.com/nametake/golangci-lint-langserver@latest
			-- go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
			vim.lsp.config('golangci_lint_ls', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.config('gopls', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('golangci_lint_ls')
			vim.lsp.enable('gopls')

			-- npm i -g bash-language-server
			vim.lsp.config('bashls', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('bashls')

			vim.lsp.config('pyright', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('pyright')

			vim.lsp.config('ols', {
				on_attach = On_attach,
				capabilities = capabilities,
			})
			vim.lsp.enable('ols')

			-- instale o omnisharp
			vim.lsp.config("roslyn", {
				cmd = {
					"dotnet",
					vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn/content/LanguageServer/linux-x64/", "Microsoft.CodeAnalysis.LanguageServer.dll"),
					"--logLevel=Information",
					"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
					"--stdio",
				},
				-- Here you can pass in any options that that you would like to pass to `vim.lsp.start`.
				-- Use `:h vim.lsp.ClientConfig` to see all possible options.
				-- The only options that are overwritten and won't have any effect by setting here:
				--     - `name`
				--     - `cmd`
				--     - `root_dir`
				handlers = {
					["textDocument/definition"] = require('omnisharp_extended').definition_handler,
					["textDocument/typeDefinition"] = require('omnisharp_extended').type_definition_handler,
					["textDocument/references"] = require('omnisharp_extended').references_handler,
					["textDocument/implementation"] = require('omnisharp_extended').implementation_handler,
				},
				on_attach = On_attach,
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "full-solution",
						dotnet_compiler_diagnostics_scope = "full-solution",
					},
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
					},
					["csharp|code_lens"] = {
						dotnet_enable_references_code_lens = true,
					},
					["csharp|formatting"] = {
						enableEditorConfigSupport = true,
						-- Specifies whether 'using' directives should be grouped and sorted during
						-- document formatting.
						dotnet_organize_imports_on_format = true,
					},
				},
			})

			-- dotnet tool install --global csharp-ls
			-- vim.lsp.config('csharp_ls', {
			--   on_attach = On_attach,
			--   capabilities = capabilities,
			--   handlers = {
			--     ["textDocument/definition"] = require("csharpls_extended").handler,
			--   },
			-- })

			-- instale o lua-language-server
			vim.lsp.config('lua_ls', {
				on_attach = On_attach,
				capabilities = capabilities,
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
						-- workspace = {
						-- 	-- Make the server aware of Neovim runtime files
						-- 	library = vim.api.nvim_get_runtime_file("", true),
						-- 	checkThirdParty = false, -- removes annoying messages
						-- },
						telemetry = {
							enable = false,
						},
					},
				},
			})
			vim.lsp.enable('lua_ls')
		end,
	},
}
