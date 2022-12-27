--- Variáveis
local close = function()
  vim.keymap.set(
    { "n", "i" },
    "<esc>",
    "<esc>:bd!<CR>",
    { buffer = true, noremap = true, silent = true }
  )
end
local vg = vim.g
local vks = vim.keymap.set
local n = { noremap = true }
local s = { silent = true }
local ns = { noremap = true, silent = true }
local nvi = { "n", "v", "i" }
local nv = { "n", "v" }
vg.mapleader = " "
vg.maplocalleader = " "

-- treesitter incremental_selection
vks("n", "<S-j>", "")
-- não sai do insert mode com escape/C-c
vks("i", "<esc>", "", ns)
vks("i", "<C-c>", "", ns)
-- sobe/desce uma tela
vks(nvi, "<C-j>", "<C-d>", ns)
vks(nvi, "<C-k>", "<C-u>", ns)
-- colar na linha de baixo
vks(nv, "P", ":norm o<CR>p", ns)
-- trocar de split
vks(nvi, "<A-Tab>", "<esc><C-w>w")
-- formatar buffer
vks(nv, "<leader>I", "gg=G<C-o>")
-- formatar paragrafo
vks(nv, "<leader>ii", "{=}<C-o>")
-- alinhar texto
vks("v", "<leader>A", ":'<,'>!column -t -o ' '<CR>", s)
-- abre arquivos no diretório atual
vks(nv, "<leader>fF", function()
  local dir = vim.fn.expand("%:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  vim.cmd.Ex(dir)
end)
-- mudar o typo de arquivo
vks(nv, "<leader>ft", ":setlocal filetype=")
-- salvar e fechar buffer
vks(nv, "ZX", ":wq<CR>", s)
-- salvar buffer
vks(nv, "ZZ", ":w<CR>:e<CR>", s)
-- deletar buffer
vks(nv, "<leader>k", ":bd<CR>", s)
-- abre o buffer de mensagens
vks(nv, "<leader>m", ":message<CR>", s)
-- carregar buffer
vks(n, "<leader>eb", ":source %<CR>", s)
-- divide a tela do lado
vks(nvi, "<C-A-l>", "<esc>:vs<CR>", s)
-- divide a tela abaixo
vks(nvi, "<C-A-j>", "<esc>:sp<CR>", s)
-- copiar buffer
vks(nv, "<leader>bc", "ggVGy<C-o>zz", n)
-- ativa/desativa números de linha
vks(nv, "zn", ":setlocal number! relativenumber!<CR>", s)
-- ativa/desativa indicação de linha
vks(nv, "zl", ":setlocal cursorline!<CR>", s)
-- ativa/desativa o corretor ortográfico
vks(nv, "zs", ":setlocal spell!<CR>", s)
-- procura palavra no cursor
vks(nv, "?", "*")
-- procura e substitui no arquivo
vks("n", "<leader>S", ":%s//gc<left><left><left>")
-- procura e substitui na região selecionada
vks("v", "<leader>S", ":s//gc<left><left><left>")
-- compilar código e lembrar commando
vks(nv, "<leader>c", function()
  require("command").command()
end)
-- abre terminal do sistema no local do arquivo atual
vks(nv, "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>", s)
-- abre terminal nativo em uma split
vks(nvi, "<M-CR>", TerminalToggle)
vks("t", "<M-CR>", TerminalToggle)
-- executa um macro
vks("n", "Q", "@")
-- vai para diagnostico
vks(nv, "[d", vim.diagnostic.goto_prev, ns)
vks(nv, "]d", vim.diagnostic.goto_next, ns)
-- fecha buffers de ajuda
Autocmd("FileType", { "help" }, function()
  close()
end)

--- Plugins
-- pula para palavras usando indicadores - leap
vks(nv, "s", function()
  require("leap").leap({
    target_windows = vim.tbl_filter(function(win)
      return vim.api.nvim_win_get_config(win).focusable
    end, vim.api.nvim_tabpage_list_wins(0)),
  })
end)
-- pula e faz uma ação no indicador - easyaction
vks("n", "'", "<cmd>BasicEasyAction<cr>", { silent = true, remap = false })
-- traduz - translate
vks(nv, "<leader>t", "<cmd>Translate en<CR>")
-- neogit
Autocmd("FileType", { "NeogitStatus" }, function()
  close()
end)
vks(nv, "<leader>gg", ":Neogit<CR>", s)
-- mostra git blame - gitsigns
vks(nv, "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", s)
-- navega entre diffs - gitsigns
vks(nv, "[g", ":Gitsigns prev_hunk<CR>", s)
vks(nv, "]g", ":Gitsigns next_hunk<CR>", s)
-- move linha - move.nvim
vks("n", "<A-j>", ":MoveLine(1)<CR>", ns)
vks("n", "<A-k>", ":MoveLine(-1)<CR>", ns)
vks("v", "<A-j>", ":MoveBlock(1)<CR>", ns)
vks("v", "<A-k>", ":MoveBlock(-1)<CR>", ns)
vks("i", "<A-j>", "<esc>:MoveLine(1)<CR>", ns)
vks("i", "<A-k>", "<esc>:MoveLine(-1)<CR>", ns)
-- alinhar texto - align
vks("v", "<leader>a", function()
  require("align").align_to_string(false, true, true)
end, ns)
-- abre/fecha fold - fold-cycle
vks(nvi, "<tab>", function()
  require("fold-cycle").open()
end, s)
-- fecha com esc - telescope
Autocmd("FileType", { "TelescopePrompt" }, function()
  close()
end)
-- lista de diagnostico - telescope
vks(nv, "<leader>D", function()
  require("telescope.builtin").diagnostics({})
end, ns)
-- abre arquivos no diretório atual - telescope
vks(nv, "<leader>F", ":Telescope find_files<CR>", s)
-- abre arquivos abertos recentemente - telescope
vks(nv, "<leader><leader>", ":Telescope oldfiles<CR>", s)
-- abre arquivos no repositório atual - telescope
vks(nv, "<leader>ff", ":Telescope git_files<CR>", s)
-- procura linhas no buffer - telescope
vks(nv, "\\", ":Telescope current_buffer_fuzzy_find<CR>", s)
-- pesquisar por correções - telescope
vks(nv, "z=", ":Telescope spell_suggest<CR>", s)
-- pesquisar por comandos - telescope
vks(nv, "<leader>hc", ":Telescope commands<CR>", s)
-- pesquisar por opções - telescope
vks(nv, "<leader>ho", ":Telescope vim_options<CR>", s)
-- pesquisar por documentação - telescope
vks(nv, "<leader>hh", ":Telescope help_tags<CR>", s)
-- pesquisar por teclas - telescope
vks(nv, "<leader>hk", ":Telescope keymaps<CR>", s)
-- pesquisar por highlights - telescope
vks(nv, "<leader>hH", ":Telescope highlights<CR>", s)
-- pesquisar por manpages - telescope
vks(nv, "<leader>hm", ":Telescope man_pages<CR>", s)
-- navegar por headings - telescope-heading
vks(nv, "<leader>v", ":Telescope heading<CR>", s)
-- procura e edita ocorrências de uma palavra - greplace
vks(nv, "<leader>gs", ":Gsearch  ./<left><left><left>")
-- confirma todas as modificações - greplace
vks(nv, "<leader>gr", ":Greplace<CR>", s)
-- ativa previsão de cores - colorizer.lua
vks(nv, "zc", ":ColorizerToggle<CR>", s)
-- escolher cor - color-picker
vks(nv, "<leader>C", "<cmd>PickColor<cr>", ns)
-- abrir e fechar arvore de undos - undotree
vks(nv, "zu", function()
  require("undotree").toggle()
end, ns)
-- snippets
vks(nv, "es", ":e ~/.config/nvim/snippets/")
-- avaliar código - SnipRun
vks("n", "<leader>e", "<Plug>SnipRunOperator", { silent = true })
vks(nv, "<leader>ee", ":SnipRun<CR>", { silent = true })
-- pop-up com documentação do simbolo selecionado - hover
vks(nv, "H", function()
  require("hover").hover()
end, { desc = "hover.nvim" })
-- seleciona documentação do simbolo selecionado - hover
vks(nv, "gH", function()
  require("hover").hover_select()
end, { desc = "hover.nvim (select)" })

--- DAP
vks(nv, "<F4>", ":lua require'dapui'.toggle()<CR>", ns)
vks(nv, "<F5>", ":lua require'dap'.continue()<CR>", ns)
vks(nv, "<F10>", ":lua require'dap'.step_over()<CR>", ns)
vks(nv, "<F11>", ":lua require'dap'.step_into()<CR>", ns)
vks(nv, "<F12>", ":lua require'dap'.step_out()<CR>", ns)
vks(nv, "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", ns)
vks(
  nv,
  "<leader>dB",
  ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  ns
)
vks(
  nv,
  "<leader>dp",
  ":lua require'dap'.require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  ns
)
vks(nv, "<leader>dr", ":lua require'dap'.repl.open()<CR>", ns)
vks(nv, "<leader>dl", ":lua require'dap'.run_last()<CR>", ns)

-- ajuda na criação de querys treesitter
vks("n", "<F2>", function()
  require("query-secretary").query_window_initiate()
end, {})

--- Refactoring
vks("v", "<leader>re", function()
  require("refactoring").refactor("Extract Function")
end, { noremap = true, silent = true, expr = false })
vks("v", "<leader>rf", function()
  require("refactoring").refactor("Extract Function To File")
end, { noremap = true, silent = true, expr = false })
vks("v", "<leader>rv", function()
  require("refactoring").refactor("Extract Variable")
end, { noremap = true, silent = true, expr = false })
vks("v", "<leader>ri", function()
  require("refactoring").refactor("Inline Variable")
end, { noremap = true, silent = true, expr = false })

-- Extract block doesn't need visual mode
vks("n", "<leader>rb", function()
  require("refactoring").refactor("Extract Block")
end, { noremap = true, silent = true, expr = false })
vks("n", "<leader>rbf", function()
  require("refactoring").refactor("Extract Block To File")
end, { noremap = true, silent = true, expr = false })

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vks("n", "<leader>ri", function()
  require("refactoring").refactor("Inline Variable")
end, { noremap = true, silent = true, expr = false })
