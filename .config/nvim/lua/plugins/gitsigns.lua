return {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	keys = {
		{ "[g", ":Gitsigns prev_hunk<CR>", mode = { "n", "v" }, silent = true },
		{ "]g", ":Gitsigns next_hunk<CR>", mode = { "n", "v" }, silent = true },
		{
			"<leader>gb",
			":Gitsigns toggle_current_line_blame<CR>",
			silent = true,
		},
		{
			"<leader>gp",
			":Gitsigns preview_hunk<CR>",
			silent = true,
		},
		{
			"<leader>gs",
			":Gitsigns stage_hunk<CR>",
			silent = true,
			mode = { "n", "v" },
		},
		{
			"<leader>gS",
			":Gitsigns stage_buffer<CR>",
			silent = true,
		},
		{
			"<leader>gr",
			":Gitsigns reset_hunk<CR>",
			silent = true,
			mode = { "n", "v" },
		},
		{
			"<leader>gR",
			":Gitsigns reset_buffer<CR>",
			silent = true,
		},
	},
	config = function()
		require("gitsigns").setup({
			signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
			numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			worktrees = {
				{
					toplevel = vim.env.HOME,
					gitdir = vim.env.HOME .. "/etc/.dotfiles",
				},
			},
		})

		-- Remove fundo cinza e melhores cores - gitsigns
		vim.api.nvim_set_hl(0, "GitSignsDeleteNr", {
			fg = "#ff0000",
			ctermfg = "Red",
		})
		vim.api.nvim_set_hl(0, "GitSignsChangeNr", {
			fg = "#ffff00",
			ctermfg = "yellow",
		})
		vim.api.nvim_set_hl(0, "GitSignsAddNr", {
			fg = "#00aa00",
			ctermfg = "green",
		})
	end,
}
