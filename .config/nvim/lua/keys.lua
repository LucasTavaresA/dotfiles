--- Variaveis
local vks = vim.keymap.set
local n = { noremap = true }
local ns = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- cancela indicação de palavras procuradas
vks("n", "<esc>", ":noh<CR>")
-- colar na linha de baixo
vks("n", "P", ":norm o<CR>p", ns)
-- trocar de buffer
vks("n", "<C-Tab>", ":bn<CR>")
-- trocar de split
vks("n", "<A-Tab>", "<C-w>w")
-- formatar buffer
vks("n", "<leader>I", "gg=G")
-- formatar paragrafo
vks("n", "<leader>ii", "{=}<C-o>")
-- formas de alinhar texto
vks('v', '<leader>a', function() require 'align'.align_to_string(false, true, true) end, ns)
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
-- abre o buffer de mensagems
vks("n", "<leader>m", ":message<CR>")
-- avaliar buffer
vks("n", "<leader>eb", ":source %<CR>")
-- divide a tela do lado
vks("n", "<C-A-Right>", ":vs<CR>")
-- divide a tela abaixo
vks("n", "<C-A-Down>", ":sp<CR>")
-- copiar buffer
vks("n", "<leader>bc", "ggVGy<C-o>zz", n)
-- ativa/desativa números de linha
vks("n", "zn", ":setlocal number! relativenumber!<CR>")
-- ativa/desativa indicação de linha
vks("n", "zl", ":setlocal cursorline!<CR>")
-- ativa/desativa o corretor ortográfico
vks("n", "zs", ":setlocal spell! spelllang=pt<CR>")
vks("n", "zS", ":setlocal spell! spelllang=en<CR>")
-- procura palavra no cursor
vks("n", "?", "*")
-- procura e substitui no arquivo
vks("n", "<leader>s", ":%s//gc<left><left><left>")
-- procura e substitui na região selecionada
vks("v", "<leader>s", ":s//gc<left><left><left>")
-- abre netrw em uma split
local lua_netrw_window = nil
local lua_netrw_buffer = nil
function NetrwToggle()
    if vim.fn.win_gotoid(lua_netrw_window) == 1 then
        if vim.fn.win_gotoid(lua_netrw_window) == 1 then
            vim.cmd("hide")
        end
    else
        if vim.fn.bufexists(lua_netrw_buffer) == 0 then
            vim.api.nvim_command("Lexplore")
            vim.api.nvim_command("silent file Netrw 1")
            lua_netrw_window = vim.fn.win_getid()
            lua_netrw_buffer = vim.fn.bufnr('%')
            vim.opt.buflisted = false
        else
            if vim.fn.win_gotoid(lua_netrw_window) == 0 then
                vim.api.nvim_command("Lexplore")
                vim.api.nvim_command("buffer Netrw 1")
                lua_netrw_window = vim.fn.win_getid()
            end
        end
    end
end

vks("n", "<A-f>", NetrwToggle)
vks("i", "<A-f>", NetrwToggle)
vks("t", "<A-f>", NetrwToggle)
-- abre terminal do sistema no local do arquivo atual
vks("n", "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>")
-- abre terminal nativo em uma split
local lua_terminal_window = nil
local lua_terminal_buffer = nil
local terminal_split_size = tonumber(vim.api.nvim_exec("echo &lines", true)) / 2.5
function TerminalToggle()
    if vim.fn.win_gotoid(lua_terminal_window) == 1 then
        if vim.fn.win_gotoid(lua_terminal_window) == 1 then
            vim.api.nvim_command("hide")
        end
    else
        if vim.fn.bufexists(lua_terminal_buffer) == 0 then
            vim.api.nvim_command("new lua_terminal")
            vim.api.nvim_command("wincmd J")
            vim.api.nvim_command("resize " .. terminal_split_size)
            vim.fn.termopen(os.getenv("SHELL"), {
                detach = 1
            })
            vim.api.nvim_command("silent file Terminal 1")
            lua_terminal_window = vim.fn.win_getid()
            lua_terminal_buffer = vim.fn.bufnr('%')
            vim.opt.buflisted = false
        else
            if vim.fn.win_gotoid(lua_terminal_window) == 0 then
                vim.api.nvim_command("sp")
                vim.api.nvim_command("wincmd J")
                vim.api.nvim_command("resize " .. terminal_split_size)
                vim.api.nvim_command("buffer Terminal 1")
                lua_terminal_window = vim.fn.win_getid()
            end
        end
        vim.cmd("startinsert")
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
vim.cmd([[
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
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "markdown" }, command = "nnoremap <silent> zx :call Marcar()<CR>j", })
vim.api.nvim_create_autocmd("FileType",
    { pattern = { "org" }, command = "nnoremap <silent> zx :call Marcar()<CR>j", })

--- Plugins
-- expande região selecionada - expand region
vks("n", "<S-Up>", "<Plug>(expand_region_expand)")
vks("n", "<S-Down>", "<Plug>(expand_region_shrink)")
vks("v", "<S-Up>", "<Plug>(expand_region_expand)")
vks("v", "<S-Down>", "<Plug>(expand_region_shrink)")
vks("i", "<S-Up>", "<esc><Plug>(expand_region_expand)")
vks("i", "<S-Down>", "<esc><Plug>(expand_region_shrink)")
-- move linha - move.nvim
vks('n', "<A-Down>", ':MoveLine(1)<CR>', ns)
vks('n', "<A-Up>", ':MoveLine(-1)<CR>', ns)
vks('i', "<A-Up>", '<esc>:MoveLine(-1)<CR>', ns)
vks('i', "<A-Down>", '<esc>:MoveLine(1)<CR>', ns)
vks('v', "<A-Down>", ':MoveBlock(1)<CR>', ns)
vks('v', "<A-Up>", ':MoveBlock(-1)<CR>', ns)
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
-- procura e edita ocorrencias de uma palavra - greplace
vks("n", "<leader>r", ":Gsearch  ./<left><left><left>")
-- confirma todas as modificações - greplace
vks("n", "<leader>R", ":Greplace<CR>")
-- ativa previsão de cores - nvimcolorizer
vks("n", "zc", ":ColorizerToggle<CR>")
-- escolher cor
vks("n", "<leader>C", "<cmd>PickColor<cr>", ns)
-- abrir e fechar arvore de undos - undotree
vks('n', 'zu', require('undotree').toggle, ns)
-- ativa foco - zen
vks("n", "zf", ":ZenMode<CR>")
-- luasnip
vks("n", "es", ":e ~/.config/nvim/Ultisnips/")
vim.cmd([[
    " press <Tab> to expand or jump in a snippet. These can also be mapped separately
    " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
    " -1 for jumping backwards.
    inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

    snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
    snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
]])

--- LSP
-- Ativa essas teclas quando o lsp esta ativo
On_attach = function(_, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bns = { buffer = bufnr, noremap = true, silent = true }
    vks("n", "K", require("hover").hover, { desc = "hover.nvim" })
    vks("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
    vks('n', 'gD', vim.lsp.buf.declaration, bns)
    vks('n', 'gd', function() require 'telescope.builtin'.lsp_definitions {} end, bns)
    vks('n', 'gi', function() require 'telescope.builtin'.lsp_implementations {} end, bns)
    vks('n', 'gr', function() require 'telescope.builtin'.lsp_references {} end, bns)
    vks('n', '<C-k>', vim.lsp.buf.signature_help, bns)
    vks('i', '<C-k>', vim.lsp.buf.signature_help, bns)
    vks('n', '[d', vim.diagnostic.goto_prev, bns)
    vks('n', ']d', vim.diagnostic.goto_next, bns)
    vks('n', '<leader>D', function() require 'telescope.builtin'.diagnostics {} end, bns)
    vks('n', '<leader>I', function() vim.lsp.buf.format { async = true } end, bns)
    vks('n', '<leader>r', vim.lsp.buf.rename, bns)
end

--- DAP
vks("n", "<F4>", ":lua require'dapui'.toggle()<CR>", ns)
vks("n", "<F5>", ":lua require'dap'.continue()<CR>", ns)
vks("n", "<F10>", ":lua require'dap'.step_over()<CR>", ns)
vks("n", "<F11>", ":lua require'dap'.step_into()<CR>", ns)
vks("n", "<F12>", ":lua require'dap'.step_out()<CR>", ns)
vks("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", ns)
vks("n", "<leader>dB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", ns)
vks("n", "<leader>dp",
    ":lua require'dap'.require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", ns)
vks("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>", ns)
vks("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", ns)
