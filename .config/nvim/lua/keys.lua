--- Variáveis
local vg = vim.g
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
  { nvi, "<C-j>", "<C-d>" },
  { nvi, "<C-k>", "<C-u>" },
  -- colar na linha de baixo
  { nv, "P", "<cmd>norm o<cr>p" },
  -- trocar de split
  { nvi, "<A-Tab>", "<esc><C-w>w" },
  -- formatar buffer
  { nv, "<leader>I", "gg=G<C-o>" },
  -- formatar paragrafo
  { nv, "<leader>ii", "{=}<C-o>" },
  -- alinhar texto
  { "v", "<leader>A", ":!column -t -o ' '<cr>", { silent = true } },
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
  { nv, "ZX", "<cmd>wq<cr>" },
  -- salvar buffer
  { nv, "ZZ", "<cmd>w<cr><cmd>e<cr>" },
  -- deletar buffer
  { nv, "<leader>k", "<cmd>bd<cr>" },
  -- abre o buffer de mensagens
  { nv, "<leader>m", "<cmd>message<cr>" },
  -- carregar buffer
  { "n", "<leader>eb", "<cmd>source %<cr>" },
  -- divide a tela do lado
  { nvi, "<C-A-l>", "<esc><cmd>vs<cr>" },
  -- divide a tela abaixo
  { nvi, "<C-A-j>", "<esc><cmd>sp<cr>" },
  -- copiar buffer
  { nv, "<leader>bc", "ggVGy<C-o>zz" },
  -- ativa/desativa números de linha
  { nv, "zn", "<cmd>setlocal number! relativenumber!<cr>" },
  -- ativa/desativa indicação de linha
  { nv, "zl", "<cmd>setlocal cursorline!<cr>" },
  -- ativa/desativa o corretor ortográfico
  { nv, "zs", "<cmd>setlocal spell!<cr>" },
  -- procura palavra no cursor
  { nv, [[?]], "*", { remap = true } },
  -- procura e substitui no arquivo
  { "n", "<leader>s", ":%s//gc<left><left><left>" },
  -- procura e substitui na região selecionada
  { "v", "<leader>s", ":s//gc<left><left><left>" },
  -- abre terminal do sistema no local do arquivo atual
  { "n", "<leader><return>", "<cmd>!sh -c 'term_open' &<cr><cr>" },
  -- abre terminal nativo em uma split
  { nvi, "<M-cr>", TerminalToggle },
  { "t", "<M-cr>", TerminalToggle },
  -- executa um macro
  { "n", "Q", "@", { remap = true } },
  -- vai para diagnostico
  { "n", "[d", vim.diagnostic.goto_prev },
  { "n", "]d", vim.diagnostic.goto_next },
  -- abre snippets
  { "n", "<leader>S", ":e ~/.config/nvim/snippets/" },
})

-- fecha buffers de ajuda
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help" },
  callback = function()
    vim.keymap.set(
      { "n", "i" },
      "<esc>",
      "<cmd>bd!<cr>",
      { buffer = true, noremap = true, silent = true }
    )
  end,
})
