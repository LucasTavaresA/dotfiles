return {
	{
		"ibhagwan/fzf-lua",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzf-lua").setup({
				winopts = {
					width = 1,
					height = 0.6,
					row = 1,
					col = 1,
					border = "single",
					preview = { default = "bat", layout = "vertical" },
				},
			})
			require("fzf-lua").register_ui_select()
		end,
		keys = {
			{ "<leader><leader>", "<cmd>FzfLua oldfiles preview<cr>" },
			{ "<leader>ff", "<cmd>FzfLua git_files<cr>" },
			{ "<leader>F", "<cmd>FzfLua files<cr>" },
			{ "<leader>hh", "<cmd>FzfLua help_tags<cr>" },
			{ "<leader>hH", "<cmd>FzfLua highlights<cr>" },
			{ "<leader>hc", "<cmd>FzfLua commands<cr>" },
			{ "<leader>hm", "<cmd>FzfLua man_pages<cr>" },
			{ "<leader>hk", "<cmd>FzfLua keymaps<cr>" },
			{ "z=", "<cmd>FzfLua spell_suggest<cr>" },
			{ [[\]], "<cmd>FzfLua blines<cr>" },
			{ "<leader>q", "<cmd>FzfLua quickfix<cr>" },
			{ "<leader>Q", "<cmd>FzfLua quickfix_stack<cr>" },
			{
				"<leader>lg",
				function()
					require("fzf-lua").live_grep({
						cmd = "git grep -Ini --column --color=always",
					})
				end,
			},
			{
				"<leader>lG",
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
					require("fzf-lua").fzf_exec("zoxide query -l", {
						actions = {
							["default"] = {
								function(selected)
									print("Changed cwd to: " .. selected[1])
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
