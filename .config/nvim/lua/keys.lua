--- Variáveis
local vo = vim.opt
local vg = vim.g
local vc = vim.cmd
local vf = vim.fn
local vanca = vim.api.nvim_create_autocmd
local vks = vim.keymap.set
local n = { noremap = true }
local ns = { noremap = true, silent = true }
vg.mapleader = " "
vg.maplocalleader = " "

-- Remove setas
vks("n", "<Up>", "<esc>")
vks("n", "<Down>", "<esc>")
vks("n", "<Left>", "<esc>")
vks("n", "<Right>", "<esc>")
vks("i", "<Up>", "<esc>")
vks("i", "<Down>", "<esc>")
vks("i", "<Left>", "<esc>")
vks("i", "<Right>", "<esc>")
vks("n", "<C-S-k>", "k", ns)
vks("n", "<C-S-j>", "j", ns)
vks("n", "<C-S-h>", "h", ns)
vks("n", "<C-S-l>", "l", ns)
vks("n", "k", "")
vks("n", "j", "")
vks("n", "h", "")
vks("n", "l", "")
-- cancela indicação de palavras procuradas
vks("n", "<esc>", ":noh<CR>")
-- colar na linha de baixo
vks("n", "P", ":norm o<CR>p", ns)
-- trocar de buffer
vks("n", "<C-Tab>", ":Telescope buffers<CR>")
-- trocar de split
vks("n", "<A-Tab>", "<C-w>w")
-- formatar buffer
vks("n", "<leader>I", "gg=G<C-o>")
-- formatar paragrafo
vks("n", "<leader>ii", "{=}<C-o>")
-- alinhar texto
vks("v", "<leader>A", ":'<,'>!column -t -o ' '<CR>")
-- abre arquivos no diretório atual
vks("n", "<leader>ff", ":e %:h")
-- mudar o typo de arquivo
vks("n", "<leader>ft", ":setlocal filetype=")
-- salvar buffer
vks("n", "<leader>ww", ":w<CR>")
-- sair e salvar
vks("n", "<leader>wq", ":wq!<CR>")
-- fecha sem salvar
vks("n", "<leader>qq", ":q!<CR>")
-- salvar e recarregar arquivo
vks("n", "<leader>wr", ":w<CR>:e<CR>")
-- deletar buffer
vks("n", "<leader>k", ":bd<CR>")
-- abre o buffer de mensagens
vks("n", "<leader>m", ":message<CR>")
-- avaliar buffer
vks("n", "<leader>eb", ":source %<CR>")
-- divide a tela do lado
vks("n", "<C-A-l>", ":vs<CR>")
-- divide a tela abaixo
vks("n", "<C-A-j>", ":sp<CR>")
-- copiar buffer
vks("n", "<leader>bc", "ggVGy<C-o>zz", n)
-- ativa/desativa números de linha
vks("n", "zn", ":setlocal number! relativenumber!<CR>")
-- ativa/desativa indicação de linha
vks("n", "zl", ":setlocal cursorline!<CR>")
-- ativa/desativa o corretor ortográfico
vks("n", "zs", ":setlocal spell!<CR>")
-- procura palavra no cursor
vks("n", "?", "*")
-- procura e substitui no arquivo
vks("n", "<leader>s", ":%s//gc<left><left><left>")
-- procura e substitui na região selecionada
vks("v", "<leader>s", ":s//gc<left><left><left>")
-- compilar código e lembrar commando
function Compile()
  vim.ui.input({ prompt = "Compile with> ", default = Compile_cmd }, function(input)
    Compile_cmd = input
    if Compile_cmd ~= nil then
      vc(":! " .. Compile_cmd)
    end
  end)
end
vks("n", "<leader>c", Compile)
-- abre terminal do sistema no local do arquivo atual
vks("n", "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>")
-- abre terminal nativo em uma split
local lua_terminal_window = nil
local lua_terminal_buffer = nil
local terminal_split_size = tonumber(vim.api.nvim_exec("echo &lines", true)) / 2.5
function TerminalToggle()
  if vf.win_gotoid(lua_terminal_window) == 1 then
    if vf.win_gotoid(lua_terminal_window) == 1 then
      vc("hide")
    end
  else
    if vf.bufexists(lua_terminal_buffer) == 0 then
      vc("new lua_terminal")
      vc("wincmd J")
      vc("resize " .. terminal_split_size)
      vf.termopen(os.getenv("SHELL"), {
        detach = 1,
      })
      vc("silent file Terminal 1")
      lua_terminal_window = vf.win_getid()
      lua_terminal_buffer = vf.bufnr("%")
      vo.buflisted = false
    else
      if vf.win_gotoid(lua_terminal_window) == 0 then
        vc("sp")
        vc("wincmd J")
        vc("resize " .. terminal_split_size)
        vc("buffer Terminal 1")
        lua_terminal_window = vf.win_getid()
      end
    end
    vc("startinsert")
  end
end
vks("n", "<M-CR>", TerminalToggle)
vks("t", "<M-CR>", TerminalToggle)
-- cria um macro
vks("n", "M", "q", ns)
vks("n", "q", "")
-- executa um macro
vks("n", "m", "@")
-- abre/fecha fold
vks("n", "zz", "za", ns)
vks("n", "za", "")
-- centraliza texto
vks("n", "za", "zz", ns)
-- marca/desmarca caixas
vc([[
    function Marcar()
        let l:line=getline('.')
        let l:curs=winsaveview()
        if l:line=~?'\s*-\s*\[\s*\].*'
            s/\[.\]/[X]/
        elseif l:line=~?'\s*-\s*\[X\].*'
            s/\[X\]/[ ]/
        endif
        call winrestview(l:curs)
    endfunction
]])
vanca("FileType", { pattern = { "markdown" }, command = "nnoremap <silent> zx :call Marcar()<CR>j" })
vanca("FileType", { pattern = { "org" }, command = "nnoremap <silent> zx :call Marcar()<CR>j" })

--- Plugins
-- neogit
vks("n", "<leader>gg", ":Neogit<CR>")
-- expande região selecionada - expand region
vks("n", "<S-k>", "<Plug>(expand_region_expand)")
vks("n", "<S-j>", "<Plug>(expand_region_shrink)")
vks("v", "<S-k>", "<Plug>(expand_region_expand)")
vks("v", "<S-j>", "<Plug>(expand_region_shrink)")
vks("i", "<S-k>", "<esc><Plug>(expand_region_expand)")
vks("i", "<S-j>", "<esc><Plug>(expand_region_shrink)")
-- move linha - move.nvim
vks("n", "<A-j>", ":MoveLine(1)<CR>", ns)
vks("n", "<A-k>", ":MoveLine(-1)<CR>", ns)
vks("i", "<A-k>", "<esc>:MoveLine(-1)<CR>", ns)
vks("i", "<A-j>", "<esc>:MoveLine(1)<CR>", ns)
vks("v", "<A-j>", ":MoveBlock(1)<CR>", ns)
vks("v", "<A-k>", ":MoveBlock(-1)<CR>", ns)
-- alinhar texto - align
vks("v", "<leader>a", function()
  require("align").align_to_string(false, true, true)
end, ns)
-- abre arquivos no repositório atual - telescope
vks("n", "<leader>F", ":Telescope find_files<CR>")
-- procura linhas no buffer - telescope
vks("n", "\\", ":Telescope current_buffer_fuzzy_find<CR>")
-- pesquisar por comandos - telescope
vks("n", "<leader>hc", ":Telescope commands<CR>")
-- pesquisar por correções - telescope
vks("n", "z=", ":Telescope spell_suggest<CR>")
-- pesquisar por opções - telescope
vks("n", "<leader>ho", ":Telescope vim_options<CR>")
-- pesquisar por documentação - telescope
vks("n", "<leader>hh", ":Telescope help_tags<CR>")
-- pesquisar por teclas - telescope
vks("n", "<leader>hk", ":Telescope keymaps<CR>")
-- pesquisar por highlights - telescope
vks("n", "<leader>hH", ":Telescope highlights<CR>")
-- pesquisar por manpages - telescope
vks("n", "<leader>hm", ":Telescope man_pages<CR>")
-- abre arquivos abertos recentemente - telescope
vks("n", "<leader><leader>", ":Telescope oldfiles<CR>")
-- navegar por headings - telescope-heading
vks("n", "<leader>v", ":Telescope heading<CR>")
-- procura e edita ocorrências de uma palavra - greplace
vks("n", "<leader>r", ":Gsearch  ./<left><left><left>")
-- confirma todas as modificações - greplace
vks("n", "<leader>R", ":Greplace<CR>")
-- ativa previsão de cores - ccc
vks("n", "zc", ":CccHighlighterToggle<CR>")
-- escolher cor
vks("n", "<leader>C", "<cmd>CccPick<cr>", ns)
-- abrir e fechar arvore de undos - undotree
vks("n", "zu", require("undotree").toggle, ns)
-- ativa foco - zen-mode
vks("n", "zf", ":ZenMode<CR>")
-- snippets
vks("n", "es", ":e ~/.config/nvim/snippets/")

--- LSP
-- Ativa essas teclas quando o lsp esta ativo
On_attach = function(_, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local bns = { buffer = bufnr, noremap = true, silent = true }
  vks("n", "H", require("hover").hover, { desc = "hover.nvim" })
  vks("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
  vks("n", "gD", vim.lsp.buf.declaration, bns)
  vks("n", "gd", function()
    require("telescope.builtin").lsp_definitions({})
  end, bns)
  vks("n", "gi", function()
    require("telescope.builtin").lsp_implementations({})
  end, bns)
  vks("n", "gr", function()
    require("telescope.builtin").lsp_references({})
  end, bns)
  vks("n", "<C-k>", vim.lsp.buf.signature_help, bns)
  vks("i", "<C-k>", vim.lsp.buf.signature_help, bns)
  vks("n", "[d", vim.diagnostic.goto_prev, bns)
  vks("n", "]d", vim.diagnostic.goto_next, bns)
  vks("n", "<leader>D", function()
    require("telescope.builtin").diagnostics({})
  end, bns)
  vks("n", "<leader>I", function()
    vim.lsp.buf.format({ async = true })
  end, bns)
  vks("n", "<leader>r", vim.lsp.buf.rename, bns)
end

--- DAP
vks("n", "<F4>", ":lua require'dapui'.toggle()<CR>", ns)
vks("n", "<F5>", ":lua require'dap'.continue()<CR>", ns)
vks("n", "<F10>", ":lua require'dap'.step_over()<CR>", ns)
vks("n", "<F11>", ":lua require'dap'.step_into()<CR>", ns)
vks("n", "<F12>", ":lua require'dap'.step_out()<CR>", ns)
vks("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", ns)
vks("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", ns)
vks(
  "n",
  "<leader>dp",
  ":lua require'dap'.require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
  ns
)
vks("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", ns)
vks("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", ns)
