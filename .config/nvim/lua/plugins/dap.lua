return {
  "mfussenegger/nvim-dap",
  lazy = true,
  ft = { "cs" },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      config = function()
        require("dapui").setup()
      end,
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      config = function()
        require("nvim-dap-virtual-text").setup({})
      end,
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = "nvim-telescope/telescope.nvim",
      config = function()
        require("telescope").load_extension("dap")
      end,
    },
  },
  config = function()
    vim.keymap.set(
      { "n", "v" },
      "<F4>",
      ":lua require'dapui'.toggle()<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<F5>",
      ":lua require'dap'.continue()<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<F10>",
      ":lua require'dap'.step_over()<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<F11>",
      ":lua require'dap'.step_into()<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<F12>",
      ":lua require'dap'.step_out()<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>db",
      ":lua require'dap'.toggle_breakpoint()<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>dB",
      ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>dp",
      ":lua require'dap'.require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>dr",
      ":lua require'dap'.repl.open()<CR>",
      { noremap = true, silent = true }
    )
    vim.keymap.set(
      { "n", "v" },
      "<leader>dl",
      ":lua require'dap'.run_last()<CR>",
      { noremap = true, silent = true }
    )
    if vim.bo.filetype == "cs" then
      -- netcoredbg
      require("dap").adapters.coreclr = {
        type = "executable",
        command = os.getenv("XDG_DATA_HOME") .. "/netcoredbg/netcoredbg",
        args = { "--interpreter=vscode" },
      }
      require("dap").configurations.cs = {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          return vim.fn.input({
            "Project dll: ",
            vim.fn.getcwd() .. "/bin/Debug/",
            "file",
          })
        end,
      }
    end
  end,
}
