--- Variáveis
local vg = vim.g
local n = { noremap = true }
local s = { silent = true }
local ns = { noremap = true, silent = true }
local nv = { "n", "v" }
local nvi = { "n", "v", "i" }
vg.mapleader = " "
vg.maplocalleader = " "

function Keymaps(maps)
  for i, _ in pairs(maps) do
    if maps[i][4] == nil then
      maps[i][4] = {}
    end
    vim.keymap.set(maps[i][1], maps[i][2], maps[i][3], maps[i][4])
  end
end

Keymaps({
  -- sobe/desce uma tela
  { nvi, "<C-j>", "<C-d>", ns },
  { nvi, "<C-k>", "<C-u>", ns },
  -- colar na linha de baixo
  { nv, "P", ":norm o<CR>p", ns },
  -- trocar de split
  { nvi, "<A-Tab>", "<esc><C-w>w" },
  -- formatar buffer
  { nv, "<leader>I", "gg=G<C-o>" },
  -- formatar paragrafo
  { nv, "<leader>ii", "{=}<C-o>" },
  -- alinhar texto
  { "v", "<leader>A", ":'<,'>!column -t -o ' '<CR>", s },
  -- abre arquivos no diretório atual
  {
    nv,
    "<leader>fF",
    function()
      local dir = vim.fn.expand("%:h")
      if dir == "" then
        dir = vim.fn.getcwd()
      end
      vim.cmd.Ex(dir)
    end,
  },
  -- mudar o typo de arquivo
  { nv, "<leader>ft", ":setlocal filetype=" },
  -- salvar e fechar buffer
  { nv, "ZX", ":wq<CR>", s },
  -- salvar buffer
  { nv, "ZZ", ":w<CR>:e<CR>", s },
  -- deletar buffer
  { nv, "<leader>k", ":bd<CR>", s },
  -- abre o buffer de mensagens
  { nv, "<leader>m", ":message<CR>", s },
  -- carregar buffer
  { n, "<leader>eb", ":source %<CR>", s },
  -- divide a tela do lado
  { nvi, "<C-A-l>", "<esc>:vs<CR>", s },
  -- divide a tela abaixo
  { nvi, "<C-A-j>", "<esc>:sp<CR>", s },
  -- copiar buffer
  { nv, "<leader>bc", "ggVGy<C-o>zz", n },
  -- ativa/desativa números de linha
  { nv, "zn", ":setlocal number! relativenumber!<CR>", s },
  -- ativa/desativa indicação de linha
  { nv, "zl", ":setlocal cursorline!<CR>", s },
  -- ativa/desativa o corretor ortográfico
  { nv, "zs", ":setlocal spell!<CR>", s },
  -- procura palavra no cursor
  { nv, [[?]], [[*]] },
  -- procura e substitui no arquivo
  { "n", "<leader>s", ":%s//gc<left><left><left>" },
  -- procura e substitui na região selecionada
  { "v", "<leader>s", ":s//gc<left><left><left>" },
  -- abre terminal do sistema no local do arquivo atual
  { nv, "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>", s },
  -- abre terminal nativo em uma split
  { nvi, "<M-CR>", TerminalToggle },
  { "t", "<M-CR>", TerminalToggle },
  -- executa um macro
  { "n", "Q", "@" },
  -- vai para diagnostico
  { nv, "[d", vim.diagnostic.goto_prev, ns },
  { nv, "]d", vim.diagnostic.goto_next, ns },
  -- abre snippets
  { nv, "<leader>S", ":e ~/.config/nvim/snippets/" },
  -- no cmd deleta palavras com backspace
  { "c", "<backspace>", "<C-w>" },
})

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
