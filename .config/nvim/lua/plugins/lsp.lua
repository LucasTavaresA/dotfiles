return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"seblj/roslyn.nvim",
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
							-- make
							null_ls.builtins.diagnostics.checkmake,
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
			On_attach = function(client, bufnr)
				local function buf_set_option(...)
					vim.api.nvim_buf_set_option(bufnr, ...)
				end

				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

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
			require("lspconfig").ccls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})
			require("lspconfig").clangd.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- npm i -g vscode-langservers-extracted
			require("lspconfig").cssls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})
			require("lspconfig").html.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- npm i -g cssmodules-language-server
			require("lspconfig").cssmodules_ls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- npm i -g @tailwindcss/language-server
			require("lspconfig").tailwindcss.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			require("typescript-tools").setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- npm i -g quick-lint-js
			require("lspconfig").quick_lint_js.setup({})

			-- go install github.com/nametake/golangci-lint-langserver@latest
			-- go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
			require("lspconfig").golangci_lint_ls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})
			require("lspconfig").gopls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- npm i -g bash-language-server
			require("lspconfig").bashls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			require("lspconfig").nelua_lsp.setup({
				cmd = {
					"nelua",
					"-L",
					"/home/lucas/code/nelua/nelua-lsp/",
					"--script",
					"/home/lucas/code/nelua/nelua-lsp/nelua-lsp.lua",
				},
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- instale o omnisharp
			require("roslyn").setup({
				config = {
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
					settings = {
						FormattingOptions = {
							-- Enables support for reading code style, naming convention and analyzer
							-- settings from .editorconfig.
							EnableEditorConfigSupport = nil,
							-- Specifies whether 'using' directives should be grouped and sorted during
							-- document formatting.
							OrganizeImports = true,
						},
						MsBuild = {
							-- If true, MSBuild project system will only load projects for files that
							-- were opened in the editor. This setting is useful for big C# codebases
							-- and allows for faster initialization of code navigation features only
							-- for projects that are relevant to code that is being edited. With this
							-- setting enabled OmniSharp may load fewer projects and may thus display
							-- incomplete reference lists for symbols.
							-- REALLY SLOW
							LoadProjectsOnDemand = true,
						},
						RoslynExtensionsOptions = {
							-- Enables support for roslyn analyzers, code fixes and rulesets.
							EnableAnalyzersSupport = nil,
							-- Enables support for showing unimported types and unimported extension
							-- methods in completion lists. When committed, the appropriate using
							-- directive will be added at the top of the current file. This option can
							-- have a negative impact on initial completion responsiveness,
							-- particularly for the first few completion sessions after opening a
							-- solution.
							EnableImportCompletion = nil,
							-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
							-- true
							AnalyzeOpenDocumentsOnly = nil,
						},
						Sdk = {
							-- Specifies whether to include preview versions of the .NET SDK when
							-- determining which version to use for project loading.
							IncludePrereleases = true,
						},
					},
					cmd = {
						"dotnet",
						vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
					}
				},
				-- NOTE: Set `filewatching` to false if you experience performance problems.
				-- Defaults to true, since turning it off is a hack.
				-- If you notice that the server is _super_ slow, it is probably because of file watching
				-- Neovim becomes super unresponsive on some large codebases, because it schedules the file watching on the event loop.
				-- This issue goes away by disabling this capability, but roslyn will fallback to its own file watching,
				-- which can make the server super slow to initialize.
				-- Setting this option to false will indicate to the server that neovim will do the file watching.
				-- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
				-- a lot faster to initialize.
				filewatching = "auto",
				on_attach = On_attach,
			})

			-- dotnet tool install --global csharp-ls
			-- require("lspconfig").csharp_ls.setup({
			--   on_attach = On_attach,
			--   capabilities = capabilities,
			--   handlers = {
			--     ["textDocument/definition"] = require("csharpls_extended").handler,
			--   },
			-- })

			-- instale o lua-language-server
			require("lspconfig").lua_ls.setup({
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
		end,
	},
}
