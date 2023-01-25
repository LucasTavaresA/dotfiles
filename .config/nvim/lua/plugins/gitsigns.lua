return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  keys = {
    {
      "<leader>gb",
      ":Gitsigns toggle_current_line_blame<CR>",
      mode = { "n", "v" },
      silent = true,
    },
    { "[g", ":Gitsigns prev_hunk<CR>", mode = { "n", "v" }, silent = true },
    { "]g", ":Gitsigns next_hunk<CR>", mode = { "n", "v" }, silent = true },
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
      bg = "#660000",
      ctermbg = nil,
      fg = "#ff0000",
      ctermfg = "Red",
    })
    vim.api.nvim_set_hl(0, "GitSignsChangeNr", {
      bg = "#666600",
      ctermbg = nil,
      fg = "#ffff00",
      ctermfg = "yellow",
    })
    vim.api.nvim_set_hl(0, "GitSignsAddNr", {
      bg = "#006600",
      ctermbg = nil,
      fg = "#00ff00",
      ctermfg = "green",
    })
  end,
}
