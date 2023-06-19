---@diagnostic disable: assign-type-mismatch
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " " -- make sure to set `mapleader` before lazy so your mappings are correct
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy)

require("lazy").setup("plugins", {
	defaults = {
		lazy = true,
	},
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = false,
		-- try to load one of these colorschemes when starting an installation during startup
		colorscheme = { "tokyonight-night" },
	},
	dev = {
		-- directory where you store your local plugin projects
		path = "~/code/lua/nvim/",
		---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
		patterns = { "lucastavaresa" }, -- For example {"folke"}
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = false,
		notify = false, -- get a notification when changes are found
	},
})
