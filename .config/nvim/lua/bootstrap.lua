-- bootstrap packer:
-- nvim --headless -u NONE -c 'lua require("bootstrap")' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data")
    .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
    })
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
  -- dependência de múltiplos pacotes
  use("nvim-lua/plenary.nvim")

  --- Miscelânea
  -- previsão e seleção de cores
  use({
    "uga-rosa/ccc.nvim",
    config = function()
      vim.opt.termguicolors = true
      require("ccc").setup({
        highlighter = {
          auto_enable = true,
        },
      })
    end,
  })
  -- salva posição do cursor
  use({
    "lucastavaresa/nvim-lastplace",
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
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          theme = "dropdown",
          border = true,
          preview = false,
          mappings = {
            i = {
              ["<C-Tab>"] = actions.toggle_selection
                + actions.move_selection_worse,
            },
          },
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
  -- cycla estado de folds
  use({
    "jghauser/fold-cycle.nvim",
    config = function()
      require("fold-cycle").setup()
    end,
  })
  -- Trata jj como escape
  use({
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        mapping = { "jj" }, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
        -- example(recommended)
        -- keys = function()
        --   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
        -- end,
      })
    end,
  })
  -- Previne o uso de teclas ineficientes
  use({
    "ja-ford/delaytrain.nvim",
    config = function()
      require("delaytrain").setup({
        ignore_filetypes = { "Neogit" }, -- Example: set to {"help", "NvimTr*"} to
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
  use({
    "yegappan/greplace",
    opt = true,
    cmd = { "Gsearch" },
    config = function()
      -- usa o git grep
      vim.opt.grepprg = "git grep -nIi"
    end,
  })
  -- alinha texto
  use("Vonr/align.nvim")
  -- movimento usando indicadores
  use({ "ggandor/leap.nvim" })
  -- extende a funcionalidade de f,F,t,T
  use({
    "echasnovski/mini.jump",
    config = function()
      require("mini.jump").setup({})
    end,
  })
  -- substitui palavras
  use({
    "otavioschwanck/cool-substitute.nvim",
    config = function()
      require("cool-substitute").setup({
        setup_keybindings = true,
        mappings = {
          start = "<leader>s", -- Mark word / region
          apply_substitute_and_next = "<S-CR>", -- Start substitution / Go to next substitution
        },
      })
    end,
  })

  --- Code
  -- comenta linhas
  use({
    "echasnovski/mini.comment",
    config = function()
      require("mini.comment").setup({})
    end,
  })
  -- fecha parenteses automaticamente
  use({
    "echasnovski/mini.pairs",
    config = function()
      require("mini.pairs").setup({})
    end,
  })
  -- indentação e indicação de sintaxe
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "JoosepAlviste/nvim-ts-context-commentstring" },
      { "nvim-treesitter/playground", opt = true, cmd = "TSPlaygroundToggle" },
      -- { "p00f/nvim-ts-rainbow" },
      -- melhor indicação de parâmetros e seu uso
      {
        "m-demare/hlargs.nvim",
        config = function()
          require("hlargs").setup()
        end,
      },
      -- mostra função atual no topo
      {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
          require("treesitter-context").setup({
            enable = true,
            max_lines = 5,
            trim_scope = "outer",
          })
          vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#39260E" })
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
          "query",
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
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        -- rainbow = {
        --   enable = true,
        --   extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        -- },
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
                local pct = percentage and string.format(" (%s%%)", percentage)
                  or ""
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
      -- mostra informação do código no cursor
      {
        "ray-x/lsp_signature.nvim",
        config = function()
          require("lsp_signature").setup({
            bind = true,
            handler_opts = {
              border = "single",
            },
          })
        end,
      },
      {
        "lewis6991/hover.nvim",
        config = function()
          require("hover").setup({
            init = function()
              require("hover.providers.lsp")
            end,
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = true,
          })
        end,
      },
      -- autocompleção
      {
        "hrsh7th/nvim-cmp",
        requires = {
          { "hrsh7th/cmp-nvim-lsp" },
          { "hrsh7th/cmp-nvim-lua" },
          { "hrsh7th/cmp-buffer" },
          { "hrsh7th/cmp-path" },
          { "hrsh7th/cmp-cmdline" },
          { "dcampos/cmp-snippy" },
          { "f3fora/cmp-spell" },
          { "davidsierradz/cmp-conventionalcommits" },
          -- ícones em pop-ups da lsp
          {
            "onsails/lspkind.nvim",
            config = function()
              require("cmp").setup({
                formatting = {
                  format = require("lspkind").cmp_format({
                    mode = "symbol", -- show only symbol annotations
                    maxwidth = 50, -- prevent the pop-up from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = "…", -- when pop-up menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                  }),
                },
              })
            end,
          },
          -- completa autores e plugins
          {
            "KadoBOT/cmp-plugins",
            config = function()
              require("cmp-plugins").setup({
                files = { "bootstrap.lua" },
              })
            end,
          },
        },
        config = function()
          local cmp = require("cmp")
          cmp.setup({
            snippet = {
              expand = function(args)
                require("snippy").expand_snippet(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<A-e>"] = cmp.mapping.complete(),
              ["<CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
              }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                else
                  fallback()
                end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "nvim_lua" },
              { name = "path" },
              { name = "buffer" },
              { name = "spell" },
              { name = "snippy" },
              { name = "plugins" },
            }, {
              { name = "buffer" },
            }),
          })

          -- Set configuration for specific filetype.
          cmp.setup.filetype("gitcommit", {
            sources = cmp.config.sources({
              { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
            }, {
              { name = "buffer" },
              { name = "conventionalcommits" },
            }),
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer" },
            },
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = "path" },
            }, {
              { name = "cmdline" },
            }),
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

      -- diagnostico
      vim.diagnostic.config({
        virtual_text = true,
        signs = false,
        underline = false,
        update_in_insert = false,
        severity_sort = false,
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

      -- necessário `npm i -g vscode-langservers-extracted`
      require("lspconfig").cssls.setup({
        on_attach = On_attach,
        capabilities = capabilities,
      })
      require("lspconfig").html.setup({
        on_attach = On_attach,
        capabilities = capabilities,
      })

      -- dotnet tool install --global csharp-ls
      require("lspconfig").csharp_ls.setup({
        on_attach = On_attach,
        capabilities = capabilities,
      })

      -- instale o lua-language-server
      require("lspconfig").sumneko_lua.setup({
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
            return vim.fn.input(
              "Project dll: ",
              vim.fn.getcwd() .. "/bin/Debug/",
              "file"
            )
          end,
        }
      end
    end,
  })
  -- indica diffs
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        worktrees = {
          {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/.dotfiles",
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
  })
  -- snippets
  use({
    "dcampos/nvim-snippy",
    requires = { "honza/vim-snippets" },
    config = function()
      require("snippy").setup({
        mappings = {
          is = {
            ["<Tab>"] = "expand_or_advance",
            ["<S-Tab>"] = "previous",
          },
        },
      })
    end,
  })
  -- git
  use({
    "TimUntersberger/neogit",
    requires = "nvim-lua/plenary.nvim",
    cmd = "Neogit",
  })
  -- balanceia parenteses
  use("gpanders/nvim-parinfer")

  --- Aparência
  -- estabiliza janela ao abrir splits
  -- TODO: Adicionada no neovim 9
  use({
    "luukvbaal/stabilize.nvim",
    config = function()
      require("stabilize").setup()
    end,
  })
  -- informações na barra de scroll
  use({
    "lewis6991/satellite.nvim",
    config = function()
      require("satellite").setup()
      vim.api.nvim_set_hl(0, "ScrollView", { bg = "#39260E" })
    end,
  })
  -- mantem cursor no centro da tela
  use({
    "vvvvv/yfix.nvim",
    config = function()
      require("yfix").setup()
    end,
  })
  -- indicador de indentação
  use({
    "lucastavaresa/simpleIndentGuides.nvim",
    config = function()
      require("simpleIndentGuides").setup("│·")
    end,
  })
  -- escurece buffers sem foco
  use({
    "levouh/tint.nvim",
    config = function()
      require("tint").setup({})
    end,
  })
  -- indica instancias da palavra no cursor
  use({
    "echasnovski/mini.cursorword",
    config = function()
      vim.api.nvim_set_hl(0, "MiniCursorWord", { bg = "#39260E" })
      require("mini.cursorword").setup({ delay = 1000 })
    end,
  })
  -- ícones usados em vários plugins
  use("kyazdani42/nvim-web-devicons")
  -- tema
  use({
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })
    end,
  })
  -- statusline
  use({
    "famiu/feline.nvim",
    config = function()
      vim.opt.termguicolors = true
      require("statusline")
    end,
  })
  -- fold mais bonitas
  use({
    "anuvyklack/pretty-fold.nvim",
    config = function()
      require("pretty-fold").setup({
        fill_char = "─",
      })
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
  -- previsão para commandos do vim
  use({
    "smjonas/live-command.nvim",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
        },
      })
    end,
  })
  -- indica modo atual no cursor
  use({
    "doums/monark.nvim",
    config = function()
      require("monark").setup({
        clear_on_normal = true,
        sticky = true,
        offset = 1,
        timeout = 300,
        modes = {
          normal = { "N", "monarkNormal" },
          visual = { "V", "monarkVisual" },
          visual_l = { "VL", "monarkVisual" },
          visual_b = { "VB", "monarkVisual" },
          select = { "S", "monarkVisual" },
          insert = { "I", "monarkInsert" },
          replace = { "R", "monarkReplace" },
          terminal = { "T", "monarkInsert" },
        },
        hl_mode = "combine",
      })
    end,
  })

  --- Escrever
  -- esconde distrações ao escrever
  use({
    "folke/zen-mode.nvim",
    opt = true,
    ft = { "markdown", "org", "txt", "norg" },
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
        on_open = function()
          vim.opt_local.laststatus = 0
          vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
        end,
        -- callback where you can add custom code when the Zen window closes
        on_close = function()
          vim.opt_local.laststatus = 3
          vim.cmd(":wq!")
        end,
      })
      vim.cmd("call timer_start(100, { tid -> execute('ZenMode')})")
    end,
  })
  -- markdown
  use({
    "preservim/vim-markdown",
    opt = true,
    ft = { "markdown" },
    requires = {
      -- previsão de markdown
      { "ellisonleao/glow.nvim", opt = true, cmd = { "Glow" } },
      -- alinha tabelas
      { "godlygeek/tabular", opt = true, ft = { "markdown" } },
    },
    config = function()
      vim.g.vim_markdown_conceal_code_blocks = 0
    end,
  })
  -- indica mals hábitos de escrita
  use({
    "davidbeckingsale/writegood.vim",
    opt = true,
    ft = { "markdown", "org", "norg", "txt" },
    config = function()
      vim.cmd("call timer_start(300, { tid -> execute('WritegoodEnable')})")
    end,
  })
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
