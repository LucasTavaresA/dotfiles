--- Variáveis
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
-- abre snippets
vks(nv, "es", ":e ~/.config/nvim/snippets/")
-- no cmd deleta palavras com backspace
vks("c", "<backspace>", "<C-w>")
-- fecha buffers de ajuda
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help" },
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<esc>",
      "<esc>:bd!<CR>",
      { buffer = true, noremap = true, silent = true }
    )
  end,
})
