---@diagnostic disable: assign-type-mismatch
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
  -- dependência de múltiplos pacotes
  use("nvim-lua/plenary.nvim")

  --- Miscelânea
  -- Popup enquanto cicla por buffers
  use({
    "ghillb/cybu.nvim",
    requires = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    config = function()
      local ok, cybu = pcall(require, "cybu")
      if not ok then
        return
      end
      cybu.setup()
      vim.keymap.set({ "n", "v" }, "<c-s-tab>", "<plug>(CybuLastusedPrev)")
      vim.keymap.set({ "n", "v" }, "<c-tab>", "<plug>(CybuLastusedNext)")
    end,
  })
  -- interage com a openai
  use({
    "aduros/ai.vim",
    setup = function()
      vim.api.nvim_set_keymap("n", "<A-a>", ":AI ", { noremap = true })
      vim.api.nvim_set_keymap("v", "<A-a>", ":AI ", { noremap = true })
      vim.api.nvim_set_keymap("i", "<A-a>", "<Esc>:AI<CR>a", { noremap = true })
      vim.g.ai_no_mappings = true
      vim.env.OPENAI_API_KEY =
        io.open(os.getenv("HOME") .. "/.gnupg/openai_key", "r")
          :read("*all")
          :sub(1, -2)
    end,
  })
  -- previne copia ao colar/deletar
  use({
    "tenxsoydev/karen-yank.nvim",
    config = function()
      require("karen-yank").setup()
    end,
  })
  -- seletor de cores
  use({
    "ziontee113/color-picker.nvim",
    opt = true,
    cmd = "PickColor",
    config = function()
      require("color-picker")
    end,
  })
  -- desativa funções em arquivos muito grandes
  use({
    "LunarVim/bigfile.nvim",
    config = function()
      require("bigfile").setup()
    end,
  })
  -- previsão e seleção de cores
  use({
    "NvChad/nvim-colorizer.lua",
    config = function()
      vim.opt.termguicolors = true
      require("colorizer").setup({})
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
      { "jvgrootveld/telescope-zoxide" },
      {
        "sudormrfbin/cheatsheet.nvim",
        requires = {
          { "nvim-lua/popup.nvim" },
          { "nvim-lua/plenary.nvim" },
        },
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
              ["<C-s>"] = {
                before_action = function(_)
                  print("before C-s")
                end,
                action = function(selection)
                  vim.cmd("edit " .. selection.path)
                end,
              },
              ["<C-q>"] = {
                action = require("telescope._extensions.zoxide.utils").create_basic_command(
                  "split"
                ),
              },
            },
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
      require("telescope").load_extension("zoxide")
      require("telescope").load_extension("ui-select")
    end,
  })
  -- cicla estado de folds
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

  --- Editar
  -- troca/coloca aspas/parenteses
  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup()
    end,
  })
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
  -- ações usando indicadores
  use({
    "Weissle/easy-action",
    requires = {
      {
        "kevinhwang91/promise-async",
        module = { "async" },
      },
    },
    config = function()
      require("easy-action").setup({
        jump_provider = "leap",
        jump_provider_config = {
          leap = {
            action_select = {
              default = function()
                require("leap").leap({
                  target_windows = vim.tbl_filter(function(win)
                    return vim.api.nvim_win_get_config(win).focusable
                  end, vim.api.nvim_tabpage_list_wins(0)),
                })
              end,
            },
          },
        },
      })
    end,
  })
  -- movimento usando indicadores
  use({
    "ggandor/leap.nvim",
    config = function()
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
      vim.api.nvim_set_hl(0, "LeapMatch", {
        fg = "white", -- for light themes, set to 'black' or similar
        bold = true,
        nocombine = true,
      })
      require("leap").opts.highlight_unlabeled_phase_one_targets = true
    end,
  })
  -- extende a funcionalidade de f,F,t,T
  use({
    "ggandor/flit.nvim",
    config = function()
      require("flit").setup({})
    end,
  })
  -- múltiplos cursores
  use({
    "mg979/vim-visual-multi",
    branch = "master",
  })

  --- Code
  -- cria prints para debug
  use({
    "rareitems/printer.nvim",
    config = function()
      require("printer").setup({
        keymap = "<C-p>", -- Plugin doesn't have any keymaps by default
      })
    end,
  })
  -- fecha if case etc
  use({
    "RRethy/nvim-treesitter-endwise",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  -- executar código dependendo do cwd
  use({
    "LucasTavaresA/command.nvim",
    config = function()
      require("command").setup()
    end,
  })
  -- refatorar código
  use({
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          java = false,
          cpp = false,
          hpp = false,
          cxx = true,
          go = true,
          c = true,
          h = true,
          javascript = true,
          python = true,
          lua = true,
        },
        prompt_func_param_type = {
          java = false,
          cpp = false,
          hpp = false,
          cxx = true,
          go = true,
          c = true,
          h = true,
          javascript = true,
          python = true,
          lua = true,
        },
        printf_statements = {},
        print_var_statements = {},
      })
    end,
  })
  -- avalia código
  use({
    "michaelb/sniprun",
    opt = true,
    ft = {
      "sh",
      "bash",
      "markdown",
      "org",
      "norg",
      "haskell",
      "c",
      "cpp",
      "go",
      "java",
      "javascript",
      "typescript",
      "rust",
    },
    cmd = { "SnipRun" },
    run = "bash ./install.sh",
  })
  -- avalia mais código
  use({
    "Olical/conjure",
    requires = "nvim-treesitter/nvim-treesitter",
    opt = true,
    ft = { "lisp", "fennel", "lua", "python", "clojure", "cl", "scheme" },
    cmd = { "ConjureEval" },
    config = function()
      vim.g["conjure#extract#tree_sitter#enabled"] = true
      vim.g["conjure#mapping#eval_current_form"] = "ee"
      vim.g["conjure#mapping#eval_motion"] = "e"
      vim.g["conjure#mapping#eval_visual"] = "e"
      vim.g["conjure#mapping#doc_word"] = false
      vim.g["conjure#mapping#def_word"] = false
    end,
  })
  -- comenta linhas
  use({
    "echasnovski/mini.comment",
    config = function()
      require("mini.comment").setup({})
    end,
  })
  -- fecha parenteses automaticamente
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })
  -- indentação e indicação de sintaxe
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update =
        require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
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
          vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#505000" })
        end,
      },
      -- visualiza arvore treesitter
      { "nvim-treesitter/playground", opt = true, cmd = "TSPlaygroundToggle" },
      { "ziontee113/query-secretary" },
      { "p00f/nvim-ts-rainbow" },
      -- melhor indicação de parâmetros e seu uso
      {
        "m-demare/hlargs.nvim",
        config = function()
          require("hlargs").setup()
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
          "markdown",
          "markdown_inline",
          "lua",
          "sql",
          "nix",
          "zig",
          "json",
          "yaml",
          "toml",
          "http",
          "rust",
          "help",
          "norg",
          "scheme",
          "haskell",
          "gdscript",
          "godot_resource",
          "gitignore",
          "git_rebase",
          "typescript",
          "commonlisp",
          "dockerfile",
          "gitattributes",
          "c_sharp",
          "java",
          "fish",
          "bash",
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
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats =
              pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<S-k>",
            node_incremental = "<S-k>",
            node_decremental = "<S-j>",
          },
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
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = {
                query = "@class.inner",
                desc = "Select inner part of a class region",
              },
            },
            include_surrounding_whitespace = true,
          },
          swap = {
            enable = true,
            swap_next = {
              ["<A-l>"] = "@parameter.inner",
            },
            swap_previous = {
              ["<A-h>"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]]"] = "@function.outer",
              ["]m"] = { query = "@class.outer", desc = "Next class start" },
            },
            goto_next_end = {
              ["]["] = "@function.outer",
              ["]M"] = "@class.outer",
            },
            goto_previous_start = {
              ["[["] = "@function.outer",
              ["[m"] = "@class.outer",
            },
            goto_previous_end = {
              ["[]"] = "@function.outer",
              ["[M"] = "@class.outer",
            },
          },
          lsp_interop = {
            enable = true,
            border = "none",
            peek_definition_code = {
              ["gp"] = "@function.outer",
              ["gP"] = "@class.outer",
            },
          },
        },
        rainbow = {
          enable = true,
          extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        },
        endwise = {
          enable = true,
        },
      })
    end,
  })
  -- lsp
  use({
    "neovim/nvim-lspconfig",
    requires = {
      -- neovim
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup()
        end,
      },
      -- mostra parâmetros ao digitar
      {
        "ray-x/lsp_signature.nvim",
        config = function()
          require("lsp_signature").setup({
            bind = true,
            handler_opts = {
              border = "single",
            },
            hint_prefix = "! ",
          })
        end,
      },
      -- indicação de carregamento lsp
      {
        "j-hui/fidget.nvim",
        opt = true,
        event = "LspAttach",
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
      -- mostra previsão de code-actions
      {
        "weilbith/nvim-code-action-menu",
        opt = true,
        cmd = "CodeActionMenu",
      },
      -- mostra informação do código no cursor
      {
        "lewis6991/hover.nvim",
        config = function()
          require("hover").setup({
            init = function()
              require("hover.providers.lsp")
              require("hover.providers.man")
              require("hover.providers.dictionary")
            end,
            -- Whether the contents of a currently open hover window should be moved
            -- to a :h preview-window when pressing the hover keymap.
            preview_window = true,
          })
        end,
      },
      -- diagnósticos, formatação e outros
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          local null_ls = require("null-ls")
          null_ls.setup({
            sources = {
              -- c
              null_ls.builtins.diagnostics.clang_check,
              null_ls.builtins.formatting.clang_format,
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
              -- javascript
              null_ls.builtins.diagnostics.eslint,
              null_ls.builtins.code_actions.eslint,
              -- json
              null_ls.builtins.formatting.fixjson,
              -- shell
              null_ls.builtins.code_actions.shellcheck,
              null_ls.builtins.formatting.shfmt.with({
                extra_args = { "-i", "4", "-ci" },
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
                    vim.lsp.buf.format({ bufnr = bufnr })
                  end,
                })
              end
            end,
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
          { "mtoohey31/cmp-fish", ft = "fish" },
          { "bydlw98/cmp-env", ft = { "fish", "zsh", "sh", "bash" } },
          { "dcampos/cmp-snippy" },
          { "f3fora/cmp-spell" },
          { "amarakon/nvim-cmp-fonts", ft = { "conf", "config", "css" } },
          { "davidsierradz/cmp-conventionalcommits" },
          -- ícones em pop-ups da lsp
          {
            "onsails/lspkind.nvim",
            config = function()
              require("cmp").setup({
                experimental = { ghost_text = true },
                window = {
                  completion = {
                    winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                    col_offset = -3,
                    side_padding = 0,
                  },
                },
                formatting = {
                  fields = { "kind", "abbr", "menu" },
                  format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format({
                      mode = "symbol_text",
                      maxwidth = 25,
                      ellipsis_char = "…", -- when pop-up menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    })(entry, vim_item)
                    local strings =
                      vim.split(kind.kind, "%s", { trimempty = true })
                    kind.kind = " " .. strings[1] .. " "
                    kind.menu = "    (" .. strings[2] .. ")"
                    return kind
                  end,
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
          local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0
              and vim.api
                  .nvim_buf_get_lines(0, line - 1, line, true)[1]
                  :sub(col, col)
                  :match("%s")
                == nil
          end
          local snippy = require("snippy")
          local cmp = require("cmp")
          cmp.setup({
            preselect = cmp.PreselectMode.None,
            view = {
              entries = "custom", -- can be "custom", "wildmenu" or "native"
            },
            snippet = {
              expand = function(args)
                snippy.expand_snippet(args.body)
              end,
            },
            mapping = cmp.mapping.preset.insert({
              ["<A-e>"] = cmp.mapping.complete({}),
              ["<CR>"] = cmp.mapping.confirm({ select = false }),
              ["<Up>"] = function(fallback)
                fallback()
              end,
              ["<Down>"] = function(fallback)
                fallback()
              end,
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif snippy.can_expand_or_advance() then
                  snippy.expand_or_advance()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif snippy.can_jump(-1) then
                  snippy.previous()
                else
                  fallback()
                end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "path" },
              { name = "env" },
              { name = "plugins" },
              { name = "fish" },
              { name = "buffer" },
              { name = "snippy" },
              { name = "nvim_lsp" },
              { name = "nvim_lua" },
              { name = "fonts", option = { space_filter = "-" } },
              { name = "spell" },
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

          -- Only enable `fonts` for `conf`, `config` and `css` file types
          require("cmp").setup.filetype(
            { "conf", "config", "css" },
            { sources = { { name = "fonts" } } }
          )

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ "/", "?" }, {
            view = {
              entries = "custom", -- can be "custom", "wildmenu" or "native"
            },
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = "buffer" },
            },
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(":", {
            view = {
              entries = "custom", -- can be "custom", "wildmenu" or "native"
            },
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

      -- Ativa quando o lsp esta ativo
      On_attach = function(_, bufnr)
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        local bns = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set({ "v", "n" }, "ga", vim.cmd.CodeActionMenu, bns)
        vim.keymap.set({ "n", "v" }, "gD", vim.lsp.buf.declaration, bns)
        vim.keymap.set(
          { "n", "v" },
          "gd",
          require("telescope.builtin").lsp_definitions,
          bns
        )
        vim.keymap.set(
          { "n", "v" },
          "gi",
          require("telescope.builtin").lsp_implementations,
          bns
        )
        vim.keymap.set(
          { "n", "v" },
          "gr",
          require("telescope.builtin").lsp_references,
          bns
        )
        vim.keymap.set(
          { "n", "v" },
          "gs",
          require("telescope.builtin").lsp_document_symbols,
          bns
        )
        vim.keymap.set(
          { "n", "v" },
          "gS",
          require("telescope.builtin").lsp_workspace_symbols,
          bns
        )
        vim.keymap.set({ "n", "v" }, "<C-h>", vim.lsp.buf.signature_help, bns)
        vim.keymap.set({ "n", "v" }, "<leader>I", function()
          vim.lsp.buf.format({ async = true })
        end, bns)
        vim.keymap.set({ "n", "v" }, "<C-S-r>", vim.lsp.buf.rename, bns)
      end

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

      -- npm i -g vscode-langservers-extracted
      require("lspconfig").eslint.setup({
        on_attach = On_attach,
        capabilities = capabilities,
      })
      require("lspconfig").cssls.setup({
        on_attach = On_attach,
        capabilities = capabilities,
      })
      require("lspconfig").html.setup({
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
      -- require("lspconfig").omnisharp.setup({
      --   on_attach = On_attach,
      --   capabilities = capabilities,
      --   cmd = {
      --     "dotnet",
      --     os.getenv("XDG_DATA_HOME") .. "/omnisharp/OmniSharp.dll",
      --   },
      --
      --   -- Enables support for reading code style, naming convention and analyzer
      --   -- settings from .editorconfig.
      --   enable_editorconfig_support = true,
      --
      --   -- If true, MSBuild project system will only load projects for files that
      --   -- were opened in the editor. This setting is useful for big C# codebases
      --   -- and allows for faster initialization of code navigation features only
      --   -- for projects that are relevant to code that is being edited. With this
      --   -- setting enabled OmniSharp may load fewer projects and may thus display
      --   -- incomplete reference lists for symbols.
      --   enable_ms_build_load_projects_on_demand = false,
      --
      --   -- Enables support for roslyn analyzers, code fixes and rulesets.
      --   enable_roslyn_analyzers = true,
      --
      --   -- Specifies whether 'using' directives should be grouped and sorted during
      --   -- document formatting.
      --   organize_imports_on_format = false,
      --
      --   -- Enables support for showing unimported types and unimported extension
      --   -- methods in completion lists. When committed, the appropriate using
      --   -- directive will be added at the top of the current file. This option can
      --   -- have a negative impact on initial completion responsiveness,
      --   -- particularly for the first few completion sessions after opening a
      --   -- solution.
      --   enable_import_completion = false,
      --
      --   -- Specifies whether to include preview versions of the .NET SDK when
      --   -- determining which version to use for project loading.
      --   sdk_include_prereleases = true,
      --
      --   -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
      --   -- true
      --   analyze_open_documents_only = false,
      -- })

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
            ["<Tab>"] = "next",
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
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitStatusRefreshed",
        command = "setlocal nospell",
      })
    end,
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
  -- esconde indicadores de cursor em janelas sem foco
  use({
    "amarakon/nvim-unfocused-cursor",
    config = function()
      require("unfocused-cursor").setup()
    end,
  })
  -- esconde palavras pesquisadas
  use("romainl/vim-cool")
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
      require("simpleIndentGuides").setup("│", "·")
    end,
  })
  -- indica instancias da palavra no cursor
  use({
    "echasnovski/mini.cursorword",
    config = function()
      vim.api.nvim_set_hl(0, "MiniCursorWord", { bg = "#505000" })
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
  -- traduz texto
  use({
    "uga-rosa/translate.nvim",
    opt = true,
    cmd = "Translate",
    config = function()
      require("translate").setup({})
    end,
  })
  -- marca checkboxes
  use({
    "opdavies/toggle-checkbox.nvim",
    opt = true,
    ft = { "markdown", "org", "norg", "txt" },
    config = function()
      vim.cmd([[
      call timer_start(100, { tid -> execute("nnoremap <silent><buffer> zx :lua require('toggle-checkbox').toggle()<CR>")})
      ]])
    end,
  })
  --  melhora aparência de headings, blocos de código, etc...
  --  funciona em org, markdown e norg
  use({
    "lukas-reineke/headlines.nvim",
    config = function()
      require("headlines").setup()
    end,
  })
  -- previsão de markdown
  use({ "ellisonleao/glow.nvim", opt = true, cmd = { "Glow" } })
  -- edita blocos de código em um pop-up confiável
  use({
    "AckslD/nvim-FeMaco.lua",
    cmd = "FeMaco",
    config = function()
      require("femaco").setup()
    end,
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
