return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      -- usando lspsaga
      -- {
      --   "<leader>D",
      --   function()
      --     require("telescope.builtin").diagnostics({})
      --   end,
      --   mode = { "n", "v" },
      --   silent = true,
      -- },
      {
        "<leader>F",
        function()
          require("telescope.builtin").find_files()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader><leader>",
        function()
          require("telescope.builtin").oldfiles()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").git_files()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        [[\]],
        function()
          require("telescope.builtin").current_buffer_fuzzy_find()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "z=",
        function()
          require("telescope.builtin").spell_suggest()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>hc",
        function()
          require("telescope.builtin").commands()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>ho",
        function()
          require("telescope.builtin").vim_options()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>hh",
        function()
          require("telescope.builtin").help_tags()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>hk",
        function()
          require("telescope.builtin").keymaps()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>hH",
        function()
          require("telescope.builtin").highlights()
        end,
        mode = { "n", "v" },
        silent = true,
      },
      {
        "<leader>hm",
        function()
          require("telescope.builtin").man_pages()
        end,
        mode = { "n", "v" },
        silent = true,
      },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          border = true,
          mappings = {
            i = {
              ["<C-Tab>"] = actions.toggle_selection
                + actions.move_selection_worse,
            },
          },
        },
        pickers = {
          current_buffer_fuzzy_find = {
            theme = "ivy",
            previewer = false,
          },
          oldfiles = {
            theme = "ivy",
            previewer = false,
          },
          git_files = {
            theme = "ivy",
            previewer = false,
          },
          highlights = {
            theme = "ivy",
          },
          man_pages = {
            theme = "ivy",
          },
          commands = {
            theme = "ivy",
          },
          vim_options = {
            theme = "ivy",
          },
          help_tags = {
            theme = "ivy",
          },
          keymaps = {
            theme = "ivy",
          },
          diagnostics = {
            theme = "ivy",
          },
          find_files = {
            theme = "ivy",
            previewer = false,
            find_command = {
              "fd",
              "--strip-cwd-prefix",
              "--base-directory",
              os.getenv("HOME"),
              "-d",
              "4",
              "-t",
              "f",
              "-E",
              "*log*",
              "-E",
              "*cache*",
              "-E",
              "*.local*",
              "-E",
              "*media*",
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "TelescopePrompt" },
        callback = function()
          vim.keymap.set(
            { "n", "i" },
            "<esc>",
            "<esc>:bd!<CR>",
            { buffer = true, noremap = true, silent = true }
          )
        end,
      })
    end,
  },
  {
    "sudormrfbin/cheatsheet.nvim",
    lazy = true,
    keys = { "<leader>?" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "jvgrootveld/telescope-zoxide",
    lazy = true,
    keys = {
      { "<leader>z", ":Telescope zoxide list<CR>", silent = true },
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          zoxide = {
            prompt_title = "[ Zoxide ]",
            mappings = {
              default = {
                after_action = function(selection)
                  print(
                    "Update to (" .. selection.z_score .. ") " .. selection.path
                  )
                  Update_cwd()
                end,
              },
            },
          },
        },
      })
      require("telescope").load_extension("zoxide")
    end,
  },
}
