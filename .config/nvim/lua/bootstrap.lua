-- bootstrap packer:
-- nvim --headless -u NONE -c 'lua require("bootstrap")' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
  -- vim mais rápido
  use("lewis6991/impatient.nvim")
  -- gerenciador de pacotes
  use("wbthomason/packer.nvim")
  -- mostra tempo para iniciar
  use({ "dstein64/vim-startuptime", opt = true, cmd = { "StartupTime" } })
  -- dependencia de multiplos pacotes
  use("nvim-lua/plenary.nvim")

  --- Miscelânea
  -- previsão de cores
  use({
    "lewis6991/nvim-colorizer.lua",
    config = function()
      vim.opt.termguicolors = true
      require("colorizer").setup({ "*" }, {})
    end,
  })
  -- salva posição do cursor
  use({
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({})
    end,
  })
  -- procura rapidamente
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-ui-select.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          theme = "dropdown",
          preview = false,
        },
        pickers = {
          find_files = {
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
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("ui-select")
    end,
  })
  -- escolher cores
  use({
    "ziontee113/color-picker.nvim",
    opt = true,
    cmd = { "PickColor" },
    config = function()
      require("color-picker").setup({
        ["keymap"] = {
          ["<Left>"] = "<Plug>ColorPickerSlider1Decrease",
          ["<Right>"] = "<Plug>ColorPickerSlider1Increase",
          ["<S-Left>"] = "<Plug>ColorPickerSlider100Decrease",
          ["<S-Right>"] = "<Plug>ColorPickerSlider100Increase",
        },
      })
    end,
  })

  --- Editar
  -- troca/coloca aspas/parenteses
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  })
  -- expande região selecionada
  use("terryma/vim-expand-region")
  -- arvore de undos
  use({
    "jiaoshijie/undotree",
    config = function()
      require("undotree").setup()
    end,
  })
  -- move linhas
  use("fedepujol/move.nvim")
  -- remove espaços em linhas editadas
  use({
    "lewis6991/spaceless.nvim",
    config = function()
      require("spaceless").setup()
    end,
  })
  -- procura e edita varias ocorrências de uma palavra
  use({ "yegappan/greplace", opt = true, cmd = { "Gsearch" } })
  -- alinha texto
  use("Vonr/align.nvim")

  --- Code
  -- comenta linhas
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  -- fecha parenteses automaticamente
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        map_bs = false,
      })
    end,
  })
  -- indentação e indicação de sintaxe
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      -- mostra função atual no topo
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup({
            enable = true,
            max_lines = 5,
            trim_scope = "outer",
          })
        end,
      },
    },
    config = function()
      require("nvim-treesitter").define_modules({
        fold = {
          attach = function()
            vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
            vim.opt_local.foldmethod = "expr"
            vim.cmd.normal("zx") -- recompute folds
          end,
          detach = function() end,
        },
      })
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "lua",
          "c_sharp",
          "fish",
          "css",
          "comment",
          "go",
          "html",
          "javascript",
          "make",
          "org",
          "python",
          "vim",
          "regex",
        },
        highlight = { -- Indicação de sintaxe
          enable = true,
        },
        indent = {
          enable = true, -- Indentação
        },
        fold = {
          enable = true,
          disable = { "rst", "make" },
        },
        context_commentstring = { enable = true },
      })
    end,
  })
  -- lsp
  use({
    "neovim/nvim-lspconfig",
    requires = {
      -- indicação de carregamento lsp
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({
            text = {
              spinner = "dots",
            },
            fmt = {
              stack_upwards = false,
              task = function(task_name, message, percentage)
                local pct = percentage and string.format(" (%s%%)", percentage) or ""
                if task_name then
                  return string.format("%s%s [%s]", message, pct, task_name)
                else
                  return string.format("%s%s", message, pct)
                end
              end,
            },
          })
        end,
      },
      -- mostra informação do codigo no cursor
      {
        "ray-x/lsp_signature.nvim",
        config = function()
          require("lsp_signature").setup({
            bind = true,
            handler_opts = {
              border = "rounded",
            },
          })
        end,
      },
      -- autocompleção
      {
        "hrsh7th/nvim-cmp",
        requires = {
          { "hrsh7th/cmp-nvim-lsp" },
          { "hrsh7th/cmp-nvim-lsp-signature-help" },
          { "hrsh7th/cmp-nvim-lua" },
          { "hrsh7th/cmp-buffer" },
          { "hrsh7th/cmp-path" },
          { "hrsh7th/cmp-cmdline" },
          { "saadparwaiz1/cmp_luasnip" },
          { "f3fora/cmp-spell" },
        },
      },
    },
  })
  -- debug
  use({
    "mfussenegger/nvim-dap",
    opt = true,
    ft = { "cs" },
    requires = {
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
        requires = { "nvim-telescope/telescope.nvim" },
        config = function()
          require("telescope").load_extension("dap")
        end,
      },
    },
    config = function()
      if vim.bo.filetype == "cs" then
        -- netcoredbg
        require("dap").adapters.coreclr = {
          type = "executable",
          command = "/usr/bin/netcoredbg",
          args = { "--interpreter=vscode" },
        }
        require("dap").configurations.cs = {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            return vim.fn.input("Project dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
        }
      end
    end,
  })
  -- mostra informação do codigo no cursor
  use({
    "lewis6991/hover.nvim",
    config = function()
      require("hover").setup({
        init = function()
          require("hover.providers.lsp")
        end,
        preview_opts = {
          border = nil,
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = true,
        title = true,
      })
    end,
  })

  -- indica diffs
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        worktrees = {
          {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/.dotfiles",
          },
        },
      })
    end,
  })
  -- snippets
  use({
    "L3MON4D3/LuaSnip",
    requires = { "honza/vim-snippets" },
    config = function()
      require("luasnip").config.set_config({
        history = true, -- keep around last snippet local to jump back
        enable_autosnippets = true,
      })
      require("luasnip.loaders.from_snipmate").lazy_load({
        paths = { "/home/lucas/.config/nvim/Ultisnips/" },
      })
    end,
  })

  --- Aparência
  -- icones usados em varios plugins
  use("kyazdani42/nvim-web-devicons")
  -- tema
  use("rebelot/kanagawa.nvim")
  -- statusline
  use("famiu/feline.nvim")
  -- fold mais bonitas
  use({
    "lewis6991/cleanfold.nvim",
    config = function()
      require("cleanfold").setup()
    end,
  })
  -- indicadores em foldings
  use({
    "lewis6991/foldsigns.nvim",
    config = function()
      require("foldsigns").setup({
        exclude = { "GitSigns.*" },
      })
    end,
  })

  --- Escrever
  -- esconde distrações ao escrever
  use({
    "folke/zen-mode.nvim",
    opt = true,
    cmd = { "ZenMode" },
    config = function()
      require("zen-mode").setup({
        window = {
          width = 80, -- width of the Zen window
          height = 30, -- height of the Zen window
          options = {
            -- signcolumn = "no", -- disable signcolumn
            number = false, -- disable number column
            relativenumber = false, -- disable relative numbers
            cursorline = false, -- disable cursorline
            cursorcolumn = false, -- disable cursor column
            foldcolumn = "0", -- disable fold column
            list = false, -- disable whitespace characters
          },
        },
        -- callback where you can add custom code when the Zen window opens
        on_open = function(win) end,
        -- callback where you can add custom code when the Zen window closes
        on_close = function()
          vim.cmd.quit()
        end,
      })
    end,
  })
  -- previsão de markdown
  -- markdown
  use({
    "preservim/vim-markdown",
    opt = true,
    ft = { "markdown" },
    requires = {
      { "ellisonleao/glow.nvim", opt = true, cmd = { "Glow" } },
      { "godlygeek/tabular", opt = true, ft = { "markdown" } },
    },
  })
  -- indica mals habitos de escrita
  use({ "davidbeckingsale/writegood.vim", opt = true, cmd = { "WritegoodEnable" } })
  -- move entre headings
  use({
    "crispgm/telescope-heading.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("heading")
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
