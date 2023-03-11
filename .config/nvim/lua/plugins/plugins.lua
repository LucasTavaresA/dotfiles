return {
  --- Miscelânea
  -- explorador de arquivos
  {
    "X3eRo0/dired.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    lazy = false,
    keys = { { "<A-f>", vim.cmd.Dired } },
    config = function()
      require("dired").setup({
        path_separator = "/",
        show_banner = false,
        show_hidden = true,
        show_dot_dirs = true,
        show_colors = true,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "dired" },
        callback = function()
          vim.keymap.set(
            { "n", "i" },
            "<A-f>",
            "<cmd>bd!<cr>",
            { buffer = true, noremap = true, silent = true }
          )
          vim.opt_local.spell = false
        end,
      })
    end,
  },
  -- abre arquivos encriptados
  {
    "jamessan/vim-gnupg",
    lazy = false,
  },
  -- melhores macros
  {
    "chrisgrieser/nvim-recorder",
    lazy = false,
    config = function()
      require("recorder").setup({
        mapping = {
          startStopRecording = "q",
          playMacro = "Q",
          switchSlot = "<C-q>",
          editMacro = "cq",
          yankMacro = "yq",
          addBreakPoint = "##",
        },
      })
    end,
  },
  -- cria commandos com previsão
  {
    "smjonas/live-command.nvim",
    event = "CmdlineEnter",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
          D = { cmd = "d" },
          G = { cmd = "g" },
        },
      })
    end,
  },
  -- Popup enquanto cicla por buffers
  {
    "ghillb/cybu.nvim",
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
    config = true,
  },
  -- desativa funções em arquivos muito grandes
  {
    "LunarVim/bigfile.nvim",
    lazy = false,
    config = true,
  },
  -- previsão e seleção de cores
  {
    "NvChad/nvim-colorizer.lua",
    lazy = false,
    keys = {
      { "zc", vim.cmd.ColorizerToggle },
    },
    init = function()
      vim.opt.termguicolors = true
    end,
    config = true,
  },
  -- salva posição do cursor
  {
    "ethanholz/nvim-lastplace",
    lazy = false,
    config = true,
  },
  -- Trata jj como escape
  {
    "max397574/better-escape.nvim",
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
    keys = {
      { "S", mode = "v" },
      { "ds" },
      { "cs" },
    },
    config = true,
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
    config = true,
  },
  -- remove espaços em linhas editadas
  {
    "lewis6991/spaceless.nvim",
    lazy = false,
    config = true,
  },
  -- procura e edita varias ocorrências de uma palavra
  {
    "gabrielpoca/replacer.nvim",
    keys = {
      {
        "<Leader>rr",
        function()
          require("replacer").run()
        end,
        { nowait = true, noremap = true, silent = true },
      },
    },
  },
  -- alinha texto
  {
    "Vonr/align.nvim",
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
  -- extende a funcionalidade de f,F,t,T
  {
    "echasnovski/mini.jump",
    keys = { "f", "F", "t", "T" },
    config = function()
      require("mini.jump").setup()
    end,
  },
  -- hexadecimal
  {
    "RaafatTurki/hex.nvim",
    cmd = "HexToggle",
    config = true,
  },
  -- pula usando pesquisas
  {
    "rlane/pounce.nvim",
    keys = { { "s", "<cmd>Pounce<cr>", mode = { "n", "v" } } },
  },

  --- Code
  -- indicação de syntaxe nelua
  { "stefanos82/nelua.vim", ft = "nelua" },
  -- lidar com conflitos git
  {
    "akinsho/git-conflict.nvim",
    lazy = false,
    config = true,
  },
  -- executar código dependendo do cwd
  {
    "lucastavaresa/simpleCommand.nvim",
    keys = {
      {
        "<leader>c",
        function()
          require("simpleCommand").command()
        end,
      },
      {
        "<leader>C",
        function()
          require("simpleCommand").command(":split term://")
        end,
      },
    },
    config = true,
  },
  -- avaliar código
  {
    "michaelb/sniprun",
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
  -- fecha parenteses automaticamente
  {
    "windwp/nvim-autopairs",
    lazy = false,
    config = true,
  },
  -- balanceia parenteses
  { "gpanders/nvim-parinfer", lazy = false },
  -- melhora visualização de diffs
  {
    "sindrets/diffview.nvim",
    lazy = false,
    dependencies = "nvim-lua/plenary.nvim",
  },
  -- git
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
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
      require("neogit").setup({
        disable_commit_confirmation = true,
        use_magit_keybindings = true,
        kind = "tab",
        commit_popup = {
          kind = "tab",
        },
        popup = {
          kind = "tab",
        },
      })
    end,
  },

  --- Aparência
  -- estabiliza janela ao abrir splits
  -- TODO: Adicionada no neovim 9
  {
    "luukvbaal/stabilize.nvim",
    lazy = false,
    config = true,
  },
  -- notificações menos intrusivas
  {
    "vigoux/notifier.nvim",
    lazy = false,
    config = true,
  },
  -- indica palavra selecionada
  {
    "tzachar/local-highlight.nvim",
    lazy = false,
    config = function()
      require("local-highlight").setup({
        hlgroup = "CursorLine",
      })
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
    keys = {
      {
        "<leader>t",
        function()
          vim.cmd.Translate("en")
        end,
        mode = { "n", "v" },
      },
    },
    config = true,
  },
  -- previsão de markdown
  {
    "ellisonleao/glow.nvim",
    keys = { { "<leader>mp", vim.cmd.Glow } },
    config = true,
  },
  -- edita blocos de código em um pop-up confiável
  {
    "AckslD/nvim-FeMaco.lua",
    keys = { { "mf", vim.cmd.FeMaco } },
    config = true,
  },
}
