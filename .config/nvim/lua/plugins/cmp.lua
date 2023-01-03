return {
  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "dcampos/cmp-snippy",
      "f3fora/cmp-spell",
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
          ["<C-j>"] = cmp.mapping(function(fallback)
            if snippy.is_active() then
              snippy.next()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if snippy.is_active() then
              snippy.previous()
            else
              fallback()
            end
          end, { "i", "s" }),
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
          { name = "fish" },
          { name = "buffer" },
          { name = "snippy" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "fonts", option = { space_filter = "-" } },
          { name = "spell" },
        }),
      })
    end,
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = "hrsh7th/nvim-cmp",
    lazy = true,
    event = "LspAttach",
  },
  {
    "hrsh7th/cmp-nvim-lua",
    dependencies = { "hrsh7th/nvim-cmp", "neovim/nvim-lspconfig" },
    lazy = true,
    ft = "lua",
  },
  {
    "hrsh7th/cmp-cmdline",
    dependencies = "hrsh7th/nvim-cmp",
    lazy = true,
    keys = { ":", "?", [[/]] },
    config = function()
      local cmp = require("cmp")
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
  {
    "davidsierradz/cmp-conventionalcommits",
    dependencies = "hrsh7th/nvim-cmp",
    lazy = true,
    ft = "gitcommit",
    config = function()
      local cmp = require("cmp")
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
        }, {
          { name = "buffer" },
          { name = "conventionalcommits" },
        }),
      })
    end,
  },
  {
    "mtoohey31/cmp-fish",
    dependencies = "hrsh7th/nvim-cmp",
    lazy = true,
    ft = "fish",
  },
  {
    "bydlw98/cmp-env",
    dependencies = "hrsh7th/nvim-cmp",
    lazy = true,
    ft = { "fish", "zsh", "sh", "bash" },
  },
  {
    "amarakon/nvim-cmp-fonts",
    dependencies = "hrsh7th/nvim-cmp",
    lazy = true,
    ft = { "conf", "config", "css" },
    config = function()
      require("cmp").setup.filetype(
        { "conf", "config", "css" },
        { sources = { { name = "fonts" } } }
      )
    end,
  },
}
