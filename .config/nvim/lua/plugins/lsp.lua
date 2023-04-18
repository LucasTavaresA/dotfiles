return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		dependencies = {
			"folke/neodev.nvim",
			"ibhagwan/fzf-lua",
			{
				"glepnir/lspsaga.nvim",
				dependencies = {
					{ "nvim-tree/nvim-web-devicons" },
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
					vks("n", "gr", "<cmd>Lspsaga lsp_finder<CR>")

					-- Code action
					vks({ "n", "v" }, "ga", "<cmd>Lspsaga code_action<CR>")

					-- -- Rename all occurrences of the hovered word for the entire file
					-- vks("n", "<leader>r", "<cmd>Lspsaga rename<CR>")
					-- Rename all occurrences of the hovered word for the selected files
					vks("n", "<leader>R", "<cmd>Lspsaga rename ++project<CR>")

					-- using treesitter-textobjects instead
					-- vks("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

					-- using the default vim.lsp.buf.definition()
					-- vks("n", "gd", "<cmd>Lspsaga goto_definition<CR>")

					-- Peek type definition
					vks("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

					-- Go to type definition
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
				"ray-x/lsp_signature.nvim",
				config = function()
					require("lsp_signature").setup({
						bind = true,
						handler_opts = {
							border = "single",
						},
						hint_prefix = "! ",
						floating_window = false, -- show hint in a floating window
					})
				end,
			},
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
					local null_ls = require("null-ls")
					null_ls.setup({
						sources = {
							-- c
							null_ls.builtins.diagnostics.clang_check,
							null_ls.builtins.formatting.clang_format.with({
								disabled_filetypes = { "cs" },
							}),
							-- git
							null_ls.builtins.code_actions.gitsigns,
							-- css
							null_ls.builtins.diagnostics.stylelint,
							-- go
							null_ls.builtins.diagnostics.golangci_lint,
							-- refactoring
							null_ls.builtins.code_actions.refactoring,
							-- make
							null_ls.builtins.diagnostics.checkmake,
							-- fish
							null_ls.builtins.diagnostics.fish,
							null_ls.builtins.formatting.fish_indent,
							-- python
							null_ls.builtins.diagnostics.flake8,
							-- web
							null_ls.builtins.formatting.prettier,
							-- shell
							null_ls.builtins.code_actions.shellcheck,
							null_ls.builtins.formatting.shfmt.with({
								extra_args = { "-ci" },
							}),
							null_ls.builtins.hover.printenv,
							-- csharp
							null_ls.builtins.formatting.csharpier,
							-- escrita
							null_ls.builtins.diagnostics.write_good,
						},
						on_attach = function(client, bufnr)
							if client.supports_method("textDocument/formatting") then
								vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
								vim.api.nvim_create_autocmd("BufWritePre", {
									group = augroup,
									buffer = bufnr,
									callback = function()
										local ft = vim.bo.ft
										if ft ~= "c" and ft ~= "cpp" then
											vim.lsp.buf.format({ bufnr = bufnr, async = false })
										end
									end,
								})
							end
						end,
					})
				end,
			},
		},
		config = function()
			local XDG_DATA_HOME = os.getenv("XDG_DATA_HOME")
			if XDG_DATA_HOME == "" then
				XDG_DATA_HOME = os.getenv("HOME") .. "/.local/share"
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities(
				vim.lsp.protocol.make_client_capabilities()
			)
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Ativa quando o lsp esta ativo
			On_attach = function(client, bufnr)
				local function buf_set_option(...)
					vim.api.nvim_buf_set_option(bufnr, ...)
				end

				-- TODO: Remove when omnisharp get his shit together
				-- https://github.com/OmniSharp/omnisharp-roslyn/issues/2483#issuecomment-1492605642
				if vim.o.ft == "cs" then
					client.server_capabilities.semanticTokensProvider = nil
				end

				buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

				local bns = { buffer = bufnr, noremap = true, silent = true }
				vim.keymap.set({ "n", "v" }, "gD", vim.lsp.buf.declaration, bns)
				vim.keymap.set({ "n", "v" }, "gd", vim.lsp.buf.definition, bns)
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
				vim.keymap.set(
					{ "n", "v", "i" },
					"<C-h>",
					vim.lsp.buf.signature_help,
					bns
				)
				vim.keymap.set({ "n", "v" }, "<leader>I", function()
					vim.lsp.buf.format({ async = true })
				end, bns)
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

			-- instale o clang e o ccls
			require("lspconfig").ccls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
				init_options = {
					compilationDatabaseDirectory = "build",
					index = {
						threads = 0,
					},
					clang = {
						excludeArgs = { "-frounding-math" },
					},
				},
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

			-- npm install -g @tailwindcss/language-server
			require("lspconfig").tailwindcss.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- npm install -g typescript typescript-language-server
			require("lspconfig").tsserver.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

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

			-- pip install --user jedi-language-server
			require("lspconfig").jedi_language_server.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- npm i -g bash-language-server
			require("lspconfig").bashls.setup({
				on_attach = On_attach,
				capabilities = capabilities,
			})

			-- instale o omnisharp
			local pid = vim.fn.getpid()
			local omnisharp_bin = os.getenv("XDG_DATA_HOME") .. "/omnisharp/OmniSharp"
			require("lspconfig").omnisharp.setup({
				on_attach = On_attach,
				capabilities = capabilities,
				cmd = {
					omnisharp_bin,
					"--languageserver",
					"--hostPID",
					tostring(pid),
				},
				-- cmd = {
				--   "dotnet",
				--   os.getenv("XDG_DATA_HOME") .. "/omnisharp/OmniSharp.dll",
				-- },

				handlers = {
					["textDocument/definition"] = require("omnisharp_extended").handler,
				},

				-- Enables support for reading code style, naming convention and analyzer
				-- settings from .editorconfig.
				enable_editorconfig_support = true,

				-- If true, MSBuild project system will only load projects for files that
				-- were opened in the editor. This setting is useful for big C# codebases
				-- and allows for faster initialization of code navigation features only
				-- for projects that are relevant to code that is being edited. With this
				-- setting enabled OmniSharp may load fewer projects and may thus display
				-- incomplete reference lists for symbols.
				enable_ms_build_load_projects_on_demand = false,

				-- Enables support for roslyn analyzers, code fixes and rulesets.
				enable_roslyn_analyzers = true,

				-- Specifies whether 'using' directives should be grouped and sorted during
				-- document formatting.
				organize_imports_on_format = false,

				-- Enables support for showing unimported types and unimported extension
				-- methods in completion lists. When committed, the appropriate using
				-- directive will be added at the top of the current file. This option can
				-- have a negative impact on initial completion responsiveness,
				-- particularly for the first few completion sessions after opening a
				-- solution.
				enable_import_completion = false,

				-- Specifies whether to include preview versions of the .NET SDK when
				-- determining which version to use for project loading.
				sdk_include_prereleases = true,

				-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
				-- true
				analyze_open_documents_only = false,
			})

			-- dotnet tool install --global csharp-ls
			-- require("lspconfig").csharp_ls.setup({
			--   on_attach = On_attach,
			--   capabilities = capabilities,
			--   handlers = {
			--     ["textDocument/definition"] = require("csharpls_extended").handler,
			--   },
			-- })

			require("neodev").setup()

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
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false, -- removes annoying messages
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	},
	--- csharp
	{
		"Hoffs/omnisharp-extended-lsp.nvim",
		dependencies = "neovim/nvim-lspconfig",
		ft = "cs",
	},
	-- {
	--   "Decodetalkers/csharpls-extended-lsp.nvim",
	--   dependencies = "neovim/nvim-lspconfig",
	--   ft = "cs",
	-- },
}
