return {
  -- vim mais rápido
  "lewis6991/impatient.nvim",

  --- Miscelânea
  --- mostra informações no cursor
  {
    "lewis6991/hover.nvim",
    lazy = true,
    keys = {
      {
        "H",
        function()
          require("hover").hover()
        end,
        mode = { "n", "v" },
      },
      {
        "gH",
        function()
          require("hover").hover_select()
        end,
        mode = { "n", "v" },
      },
    },
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
  -- pequenas melhorias ao netrw
  {
    "prichrd/netrw.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    lazy = true,
    keys = {
      {
        "<A-f>",
        function()
          NetrwToggle()
        end,
      },
    },
    config = function()
      require("netrw").setup()
    end,
  },
  -- Popup enquanto cicla por buffers
  {
    "ghillb/cybu.nvim",
    lazy = true,
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-lua/plenary.nvim" },
    keys = {
      { "<c-s-tab>", "<plug>(CybuLastusedPrev)" },
      { "<c-tab>", "<plug>(CybuLastusedNext)" },
    },
    config = function()
      local ok, cybu = pcall(require, "cybu")
      if not ok then
        return
      end
      cybu.setup()
    end,
  },
  -- interage com a openai
  {
    "aduros/ai.vim",
    lazy = true,
    cmd = "AI",
    keys = {
      { "<A-a>", ":AI ", noremap = true },
      { "<A-a>", ":AI ", mode = "v", noremap = true },
      { "<A-a>", "<Esc>:AI ", mode = "i", noremap = true },
    },
    init = function()
      vim.g.ai_no_mappings = true
      vim.env.OPENAI_API_KEY =
        io.open(os.getenv("HOME") .. "/.gnupg/openai_key", "r")
          :read("*all")
          :sub(1, -2)
    end,
  },
  -- previne copia ao colar/deletar
  {
    "tenxsoydev/karen-yank.nvim",
    lazy = false,
    config = function()
      require("karen-yank").setup()
    end,
  },
  -- seletor de cores
  {
    "ziontee113/color-picker.nvim",
    lazy = true,
    cmd = "PickColor",
    keys = {
      { "<leader>C", vim.cmd.PickColor, noremap = true },
    },
    config = function()
      require("color-picker")
    end,
  },
  -- desativa funções em arquivos muito grandes
  {
    "LunarVim/bigfile.nvim",
    lazy = false,
    config = function()
      require("bigfile").setup()
    end,
  },
  -- previsão e seleção de cores
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    keys = {
      { "zc", vim.cmd.ColorizerToggle },
    },
    config = function()
      vim.opt.termguicolors = true
      require("colorizer").setup({})
    end,
  },
  -- salva posição do cursor
  {
    "ethanholz/nvim-lastplace",
    lazy = false,
    config = function()
      require("nvim-lastplace").setup({})
    end,
  },
  -- cicla estado de folds
  {
    "jghauser/fold-cycle.nvim",
    lazy = true,
    keys = {
      {
        "<tab>",
        function()
          require("fold-cycle").open()
        end,
        mode = { "n", "v", "i" },
        silent = true,
      },
    },
    config = function()
      require("fold-cycle").setup()
    end,
  },
  -- Trata jj como escape
  {
    "max397574/better-escape.nvim",
    lazy = true,
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        mapping = { "jj" }, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = function()
          return vim.api.nvim_win_get_cursor(0)[2] > 1 and "<esc>l" or "<esc>"
        end,
      })
    end,
  },

  --- Editar
  -- troca/coloca aspas/parenteses
  {
    "kylechui/nvim-surround",
    lazy = true,
    keys = {
      { "S", mode = "v" },
      { "ds" },
      { "cs" },
    },
    config = function()
      require("nvim-surround").setup()
    end,
  },
  -- arvore de undos
  {
    "jiaoshijie/undotree",
    keys = {
      {
        "zu",
        function()
          require("undotree").toggle()
        end,
        noremap = true,
      },
    },
    config = function()
      require("undotree").setup()
    end,
  },
  -- move linhas
  {
    "fedepujol/move.nvim",
    lazy = true,
    keys = {
      { "<A-j>", ":MoveLine(1)<CR>", mode = "n", silent = true },
      { "<A-k>", ":MoveLine(-1)<CR>", mode = "n", silent = true },
      { "<A-j>", ":MoveBlock(1)<CR>", mode = "v", silent = true },
      { "<A-k>", ":MoveBlock(-1)<CR>", mode = "v", silent = true },
      { "<A-j>", "<esc>:MoveLine(1)<CR>i", mode = "i", silent = true },
      { "<A-k>", "<esc>:MoveLine(-1)<CR>i", mode = "i", silent = true },
    },
  },
  -- remove espaços em linhas editadas
  {
    "lewis6991/spaceless.nvim",
    lazy = false,
    config = function()
      require("spaceless").setup()
    end,
  },
  -- procura e edita varias ocorrências de uma palavra
  {
    "yegappan/greplace",
    lazy = true,
    cmd = { "Gsearch" },
    keys = {
      { "<leader>gs", ":Gsearch  ./<left><left><left>", mode = { "n", "v" } },
      { "<leader>gr", vim.cmd.Greplace, mode = { "n", "v" }, silent = true },
    },
    config = function()
      -- usa o git grep
      vim.opt.grepprg = "git grep -nIi"
    end,
  },
  -- alinha texto
  {
    "Vonr/align.nvim",
    lazy = true,
    keys = {
      {
        "<leader>a",
        function()
          require("align").align_to_string(false, true, true)
        end,
        mode = "v",
      },
    },
  },
  -- ações usando indicadores
  {
    "Weissle/easy-action",
    lazy = true,
    dependencies = {
      {
        "kevinhwang91/promise-async",
        module = { "async" },
      },
    },
    keys = {
      { [[']], vim.cmd.BasicEasyAction, { silent = true, noremap = true } },
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
  },
  -- movimento usando indicadores
  {
    "ggandor/leap.nvim",
    lazy = true,
    keys = {
      {
        "s",
        function()
          require("leap").leap({
            target_windows = vim.tbl_filter(function(win)
              return vim.api.nvim_win_get_config(win).focusable
            end, vim.api.nvim_tabpage_list_wins(0)),
          })
        end,
      },
    },
    config = function()
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
      vim.api.nvim_set_hl(0, "LeapMatch", {
        fg = "white", -- for light themes, set to 'black' or similar
        bold = true,
        nocombine = true,
      })
      require("leap").opts.highlight_unlabeled_phase_one_targets = true
    end,
  },
  -- extende a funcionalidade de f,F,t,T
  {
    "ggandor/flit.nvim",
    dependencies = "ggandor/leap.nvim",
    keys = { "f", "F", "t", "T" },
    config = function()
      require("flit").setup({})
    end,
  },
  -- múltiplos cursores
  {
    "mg979/vim-visual-multi",
    lazy = true,
    keys = { "<C-Down>", "<C-Up>", "<C-n>" },
    branch = "master",
  },

  --- Code
  -- executar código dependendo do cwd
  {
    "lucastavaresa/command.nvim",
    lazy = true,
    keys = {
      {
        "<leader>c",
        function()
          require("command").command()
        end,
      },
    },
    config = function()
      require("command").setup()
    end,
  },
  -- avaliar código
  {
    "michaelb/sniprun",
    lazy = true,
    ft = {
      "sh",
      "bash",
      "markdown",
      "org",
      "norg",
      "haskell",
      "c",
      "cs",
      "cpp",
      "go",
      "java",
      "javascript",
      "typescript",
      "rust",
    },
    build = "bash ./install.sh",
    config = function()
      vim.keymap.set(
        "n",
        "<leader>e",
        "<Plug>SnipRunOperator",
        { silent = true }
      )
      vim.keymap.set({ "v", "n" }, "<leader>ee", vim.cmd.SnipRun)
    end,
  },
  -- avalia mais código
  {
    "Olical/conjure",
    lazy = true,
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = { "lisp", "fennel", "lua", "python", "clojure", "cl", "scheme" },
    config = function()
      vim.g["conjure#extract#tree_sitter#enabled"] = true
      vim.g["conjure#mapping#log_jump_to_latest"] = false
      vim.g["conjure#mapping#log_split"] = false
      vim.g["conjure#mapping#log_vsplit"] = false
      vim.g["conjure#mapping#log_tab"] = false
      vim.g["conjure#mapping#log_buf"] = false
      vim.g["conjure#mapping#log_toggle"] = false
      vim.g["conjure#mapping#log_reset_soft"] = false
      vim.g["conjure#mapping#log_reset_hard"] = false
      vim.g["conjure#mapping#log_jump_to_latest"] = false
      vim.g["conjure#mapping#log_close_visible"] = false
      vim.g["conjure#mapping#eval_current_form"] = "ee"
      vim.g["conjure#mapping#eval_comment_current_form"] = false
      vim.g["conjure#mapping#eval_root_form"] = false
      vim.g["conjure#mapping#eval_comment_root_form"] = false
      vim.g["conjure#mapping#eval_word"] = false
      vim.g["conjure#mapping#eval_comment_word"] = false
      vim.g["conjure#mapping#eval_replace_form"] = false
      vim.g["conjure#mapping#eval_marked_form"] = false
      vim.g["conjure#mapping#eval_comment_form"] = false
      vim.g["conjure#mapping#eval_file"] = false
      vim.g["conjure#mapping#eval_buf"] = "eb"
      vim.g["conjure#mapping#eval_visual"] = "e"
      vim.g["conjure#mapping#eval_motion"] = "e"
      vim.g["conjure#mapping#def_word"] = false
      vim.g["conjure#mapping#doc_word"] = false
    end,
  },
  -- comenta linhas
  {
    "echasnovski/mini.comment",
    lazy = false,
    config = function()
      require("mini.comment").setup({})
    end,
  },
  -- fecha parenteses automaticamente
  {
    "windwp/nvim-autopairs",
    lazy = false,
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  -- snippets
  {
    "dcampos/nvim-snippy",
    dependencies = "honza/vim-snippets",
    lazy = false,
    config = function()
      require("snippy").setup({})
    end,
  },
  -- git
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    lazy = true,
    cmd = "Neogit",
    keys = {
      { "<leader>gg", vim.cmd.Neogit },
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "NeogitStatusRefreshed",
        command = "setlocal nospell",
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "NeogitStatus" },
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
  -- balanceia parenteses
  { "gpanders/nvim-parinfer", lazy = false },

  --- Aparência
  -- estabiliza janela ao abrir splits
  -- TODO: Adicionada no neovim 9
  {
    "luukvbaal/stabilize.nvim",
    lazy = false,
    config = function()
      require("stabilize").setup()
    end,
  },
  -- esconde indicadores de cursor em janelas sem foco
  {
    "amarakon/nvim-unfocused-cursor",
    lazy = false,
    config = function()
      require("unfocused-cursor").setup()
    end,
  },
  -- esconde palavras pesquisadas
  { "romainl/vim-cool", lazy = true, keys = { "n", "N", [[/]], [[?]], [[\]] } },
  -- mantem cursor no centro da tela
  {
    "vvvvv/yfix.nvim",
    lazy = false,
    config = function()
      require("yfix").setup()
    end,
  },
  -- indicador de indentação
  {
    "lucastavaresa/simpleIndentGuides.nvim",
    lazy = false,
    config = function()
      require("simpleIndentGuides").setup("│", "·")
    end,
  },
  -- indica instancias da palavra no cursor
  {
    "echasnovski/mini.cursorword",
    lazy = false,
    config = function()
      vim.api.nvim_set_hl(0, "MiniCursorWord", { bg = "#505000" })
      require("mini.cursorword").setup({ delay = 1000 })
    end,
  },
  -- ícones usados em vários plugins
  -- "kyazdani42/nvim-web-devicons",
  -- tema
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })
    end,
  },
  -- statusline
  {
    "famiu/feline.nvim",
    lazy = false,
    config = function()
      vim.opt.termguicolors = true
      require("statusline")
    end,
  },
  -- fold mais bonitas
  {
    "anuvyklack/pretty-fold.nvim",
    lazy = false,
    config = function()
      require("pretty-fold").setup({
        fill_char = "─",
      })
    end,
  },
  -- indicadores em foldings
  {
    "lewis6991/foldsigns.nvim",
    lazy = false,
    config = function()
      require("foldsigns").setup({
        exclude = { "GitSigns.*" },
      })
    end,
  },
  -- indica modo atual no cursor
  {
    "doums/monark.nvim",
    lazy = false,
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
  },

  --- Escrever
  -- traduz texto
  {
    "uga-rosa/translate.nvim",
    lazy = true,
    keys = {
      {
        "<leader>t",
        function()
          vim.cmd.Translate("en")
        end,
        mode = { "n", "v" },
      },
    },
    config = function()
      require("translate").setup({})
    end,
  },
  -- marca checkboxes
  {
    "opdavies/toggle-checkbox.nvim",
    lazy = true,
    ft = { "markdown", "org", "norg", "txt" },
    config = function()
      vim.cmd([[
      call timer_start(100, { tid -> execute("nnoremap <silent><buffer> zx :lua require('toggle-checkbox').toggle()<CR>")})
      ]])
    end,
  },
  --  melhora aparência de headings, blocos de código, etc...
  --  funciona em org, markdown e norg
  {
    "lukas-reineke/headlines.nvim",
    lazy = true,
    ft = { "markdown", "org", "norg" },
    config = function()
      require("headlines").setup()
    end,
  },
  -- previsão de markdown
  { "ellisonleao/glow.nvim", lazy = true, cmd = { "Glow" } },
  -- edita blocos de código em um pop-up confiável
  {
    "AckslD/nvim-FeMaco.lua",
    cmd = "FeMaco",
    config = function()
      require("femaco").setup()
    end,
  },
}
