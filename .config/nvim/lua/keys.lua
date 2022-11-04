--- Variáveis
local vg = vim.g
local vanca = vim.api.nvim_create_autocmd
local vks = vim.keymap.set
local n = { noremap = true }
local s = { silent = true }
local ns = { noremap = true, silent = true }
local nvi = { "n", "v", "i" }
local nv = { "n", "v" }
vg.mapleader = " "
vg.maplocalleader = " "

-- sobe/desce uma tela
vks(nvi, "<C-j>", "<C-d>", ns)
vks(nvi, "<C-k>", "<C-u>", ns)
-- cancela indicação de palavras procuradas
vks(nv, "<esc>", ":noh<CR>", ns)
-- não sai do insert mode com espaço/Ctrl-c
vks("i", "<esc>", "", ns)
vks("i", "<C-c>", "", ns)
-- colar na linha de baixo
vks(nv, "P", ":norm o<CR>p", ns)
-- trocar de buffer
vks(nvi, "<C-Tab>", "<esc>:Telescope buffers<CR>", s)
-- trocar de split
vks(nvi, "<A-Tab>", "<esc><C-w>w")
-- formatar buffer
vks(nv, "<leader>I", "gg=G<C-o>")
-- formatar paragrafo
vks(nv, "<leader>ii", "{=}<C-o>")
-- alinhar texto
vks("v", "<leader>A", ":'<,'>!column -t -o ' '<CR>", s)
-- abre arquivos no diretório atual
vks(nv, "<leader>ff", ":e %:h")
-- mudar o typo de arquivo
vks(nv, "<leader>ft", ":setlocal filetype=")
-- salvar buffer
vks(nv, "<leader>ww", ":w<CR>", s)
-- sair e salvar
vks(nv, "<leader>wq", ":wq!<CR>", s)
-- fecha sem salvar
vks(nv, "<leader>qq", ":q!<CR>", s)
-- salvar e recarregar arquivo
vks(nv, "<leader>wr", ":w<CR>:e<CR>", s)
-- deletar buffer
vks(nv, "<leader>k", ":bd<CR>", s)
-- abre o buffer de mensagens
vks(nv, "<leader>m", ":message<CR>", s)
-- avaliar buffer
vks(nv, "<leader>eb", ":source %<CR>", s)
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
vks(nv, "<leader>c", Compile)
-- abre terminal do sistema no local do arquivo atual
vks(nv, "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>", s)
-- abre terminal nativo em uma split
vks(nvi, "<M-CR>", TerminalToggle)
vks("t", "<M-CR>", TerminalToggle)
-- cria um macro
vks("n", "M", "q", ns)
vks("n", "q", "")
-- executa um macro
vks("n", "m", "@")
-- abre/fecha fold
vks(nvi, "<tab>", function()
  require("fold-cycle").open()
end, s)
vks(nv, "zz", function()
  return require("fold-cycle").open()
end, s)
-- centraliza texto
vks(nv, "za", "zz", ns)
-- marca/desmarca caixas
vanca("FileType", { pattern = { "markdown" }, command = "nnoremap <silent> zx :call Marcar()<CR>j" })
vanca("FileType", { pattern = { "org" }, command = "nnoremap <silent> zx :call Marcar()<CR>j" })

--- Plugins
-- pula para palavras usando indicadores - mini.jump2d
vks(nv, "q", function()
  require("leap").leap({ target_windows = { vim.fn.win_getid() } })
end)
-- neogit
vks(nv, "<leader>gg", ":Neogit<CR>", s)
-- mostra git blame - gitsigns
vks(nv, "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", s)
-- navega entre diffs - gitsigns
vks(nv, "[g", ":Gitsigns prev_hunk<CR>", s)
vks(nv, "]g", ":Gitsigns next_hunk<CR>", s)
-- expande região selecionada - expand region
vks(nv, "<S-k>", "<Plug>(expand_region_expand)")
vks(nv, "<S-j>", "<Plug>(expand_region_shrink)")
-- move linha - move.nvim
vks(nv, "<A-j>", ":MoveLine(1)<CR>", ns)
vks(nv, "<A-k>", ":MoveLine(-1)<CR>", ns)
vks("i", "<A-k>", "<esc>:MoveLine(-1)<CR>", ns)
vks("i", "<A-j>", "<esc>:MoveLine(1)<CR>", ns)
-- alinhar texto - align
vks("v", "<leader>a", function()
  require("align").align_to_string(false, true, true)
end, ns)
-- abre arquivos no repositório atual - telescope
vks(nv, "<leader>F", ":Telescope find_files<CR>", s)
-- procura linhas no buffer - telescope
vks(nv, "\\", ":Telescope current_buffer_fuzzy_find<CR>", s)
-- pesquisar por comandos - telescope
vks(nv, "<leader>hc", ":Telescope commands<CR>", s)
-- pesquisar por correções - telescope
vks(nv, "z=", ":Telescope spell_suggest<CR>", s)
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
-- abre arquivos abertos recentemente - telescope
vks(nv, "<leader><leader>", ":Telescope oldfiles<CR>", s)
-- navegar por headings - telescope-heading
vks(nv, "<leader>v", ":Telescope heading<CR>", s)
-- procura e edita ocorrências de uma palavra - greplace
vks(nv, "<leader>r", ":Gsearch  ./<left><left><left>")
-- confirma todas as modificações - greplace
vks(nv, "<leader>R", ":Greplace<CR>", s)
-- ativa previsão de cores - ccc
vks(nv, "zc", ":CccHighlighterToggle<CR>", s)
-- escolher cor
vks(nv, "<leader>C", "<cmd>CccPick<cr>", ns)
-- abrir e fechar arvore de undos - undotree
vks(nv, "zu", function()
  require("undotree").toggle()
end, ns)
-- ativa foco - zen-mode
vks(nv, "zf", ":ZenMode<CR>", s)
-- snippets
vks(nv, "es", ":e ~/.config/nvim/snippets/")

--- LSP
-- Ativa essas teclas quando o lsp esta ativo
On_attach = function(_, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local bns = { buffer = bufnr, noremap = true, silent = true }
  vks(nv, "H", function()
    require("hover").hover()
  end, { desc = "hover.nvim" })
  vks(nv, "gH", function()
    require("hover").hover_select()
  end, { desc = "hover.nvim (select)" })
  vks(nv, "gD", vim.lsp.buf.declaration, bns)
  vks(nv, "gd", function()
    require("telescope.builtin").lsp_definitions({})
  end, bns)
  vks(nv, "gi", function()
    require("telescope.builtin").lsp_implementations({})
  end, bns)
  vks(nv, "gr", function()
    require("telescope.builtin").lsp_references({})
  end, bns)
  vks(nvi, "<C-h>", vim.lsp.buf.signature_help, bns)
  vks(nv, "[d", vim.diagnostic.goto_prev, bns)
  vks(nv, "]d", vim.diagnostic.goto_next, bns)
  vks(nv, "<leader>D", function()
    require("telescope.builtin").diagnostics({})
  end, bns)
  vks(nv, "<leader>I", function()
    vim.lsp.buf.format({ async = true })
  end, bns)
  vks(nv, "<leader>r", vim.lsp.buf.rename, bns)
end

--- DAP
vks(nv, "<F4>", ":lua require'dapui'.toggle()<CR>", ns)
vks(nv, "<F5>", ":lua require'dap'.continue()<CR>", ns)
vks(nv, "<F10>", ":lua require'dap'.step_over()<CR>", ns)
vks(nv, "<F11>", ":lua require'dap'.step_into()<CR>", ns)
vks(nv, "<F12>", ":lua require'dap'.step_out()<CR>", ns)
vks(nv, "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", ns)
vks(nv, "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", ns)
vks(
  nv,
  "<leader>dp",
  ":lua require'dap'.require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  ns
)
vks(nv, "<leader>dr", ":lua require'dap'.repl.open()<CR>", ns)
vks(nv, "<leader>dl", ":lua require'dap'.run_last()<CR>", ns)
