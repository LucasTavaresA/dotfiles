local search_paths = function()
	return [[printf "%s\n%s" "]] .. vim.fn.getcwd() .. [[" "$(zoxide query -l)"]]
end

return {
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		config = function()
			require("fzf-lua").setup({
				winopts = {
					width = 1,
					height = 1,
					row = 1,
					col = 1,
					preview = { default = "bat" },
				},
				defaults = {
					file_icons = false,
				},
			})
			require("fzf-lua").register_ui_select()
		end,
		keys = {
			{ "<leader><leader>", "<cmd>FzfLua oldfiles preview<cr>" },
			{ "<leader>ff",       "<cmd>FzfLua git_files<cr>" },
			{ "<leader>F",        "<cmd>FzfLua files<cr>" },
			{ "<leader>hh",       "<cmd>FzfLua help_tags<cr>" },
			{ "<leader>hH",       "<cmd>FzfLua highlights<cr>" },
			{ "<leader>hc",       "<cmd>FzfLua commands<cr>" },
			{ "<leader>hm",       "<cmd>FzfLua man_pages<cr>" },
			{ "<leader>hk",       "<cmd>FzfLua keymaps<cr>" },
			{ "z=",               "<cmd>FzfLua spell_suggest<cr>" },
			{ [[\]],              "<cmd>FzfLua blines<cr>" },
			{ "<leader>q",        "<cmd>FzfLua quickfix<cr>" },
			{ "<leader>Q",        "<cmd>FzfLua quickfix_stack<cr>" },
			{
				"<leader>gg",
				function()
					local old_cwd = vim.fn.getcwd()

					require("fzf-lua").fzf_exec(search_paths(), {
						actions = {
							["default"] = {
								function(folder)
									vim.cmd.cd(folder[1])
									Update_cwd()

									require("fzf-lua").live_grep({
										cmd = "git grep -Ini --column --color=always",
										actions = {
											["default"] = function(selected, opts)
												require("fzf-lua.actions").vimcmd_file(
													"e",
													selected,
													opts
												)
												vim.cmd.cd(old_cwd)
												Update_cwd()
											end,
										},
									})
								end,
							},
						},
					})
				end,
			},
			{
				"<leader>G",
				function()
					require("fzf-lua").fzf_exec(search_paths(), {
						actions = {
							["default"] = {
								function(folder)
									require("fzf-lua").live_grep({
										cwd = folder[1],
									})
								end,
							},
						},
					})
				end,
			},
			{
				"<leader>lr",
				function()
					require("fzf-lua").fzf_live(
						"git rev-list --all | xargs git grep --line-number --column --color=always <query>",
						{
							fzf_opts = {
								["--delimiter"] = ":",
								["--preview-window"] = "nohidden,down,60%,border-top,+{3}+3/3,~3",
							},
							preview = "git show {1}:{2} | "
									.. "bat --style=default --color=always --file-name={2} --highlight-line={3}",
						}
					)
				end,
			},
			{
				"<leader>z",
				function()
					require("fzf-lua").fzf_exec(search_paths(), {
						actions = {
							["default"] = {
								function(selected)
									vim.notify("Changed cwd to: " .. selected[1])
									vim.cmd.cd(selected[1])
									Update_cwd()
								end,
							},
						},
					})
				end,
			},
		},
	},
}
