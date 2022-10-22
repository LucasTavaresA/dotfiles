--- Variaveis
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- cancela indicação de palavras procuradas
keymap("n", "<esc>", ":noh<CR>", {})
-- colar na linha de baixo
keymap("n", "P", ":norm o<CR>p", opts)
-- trocar de buffer
keymap("n", "<C-Tab>", ":bn<CR>", {})
-- trocar de split
keymap("n", "<A-Tab>", "<C-w>w", {})
-- formatar buffer
keymap("n", "<leader>I", "gg=G", {})
-- formatar paragrafo
keymap("n", "<leader>ii", "{=}", {})
-- alinhar texto
keymap("v", "<leader>a", ":'<,'>!column -t -o ' '<CR>", {})
-- mudar o typo de arquivo
keymap("n", "<leader>ft", ":set filetype=", {})
-- abrir o explorador de arquivos
keymap("n", "<A-f>", ":Lexplore<CR>", {})
-- salvar buffer
keymap("n", "<leader>ww", ":w<CR>", {})
-- sair e salvar
keymap("n", "<leader>wq", ":wq!<CR>", {})
-- fecha sem salvar
keymap("n", "<leader>qq", ":q!<CR>", {})
-- salvar e recarregar arquivo
keymap("n", "<leader>wr", ":w<CR>:e<CR>", {})
-- deletar buffer
keymap("n", "<leader>k", ":bd<CR>", {})
-- abre o buffer de mensagems
keymap("n", "<leader>m", ":message<CR>", {})
-- divide a tela do lado
keymap("n", "<C-A-Right>", ":vs<CR>", {})
-- divide a tela abaixo
keymap("n", "<C-A-Down>", ":sp<CR>", {})
-- copiar buffer
keymap("n", "<leader>bc", "ggVGy", { noremap = true })
-- ativa/desativa números de linha
keymap("n", "zn", ":set number!<CR>", {})
-- ativa/desativa indicação de linha
keymap("n", "zl", ":set cursorline!<CR>", {})
-- ativa/desativa o corretor ortográfico
keymap("n", "zs", ":setlocal spell! spelllang=pt<CR>", {})
keymap("n", "zS", ":setlocal spell! spelllang=en<CR>", {})
-- procura palavra no cursor
keymap("n", "?", "*", {})
-- procura e substitui
keymap("n", "<A-s>", ":%s//gc<left><left><left>", {})
-- abre terminal do sistema no local do arquivo atual
keymap("n", "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>", {})
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

vim.keymap.set("n", "<M-CR>", TerminalToggle)
vim.keymap.set("t", "<M-CR>", TerminalToggle)
-- cria um macro
keymap("n", "M", "q", opts)
keymap("n", "q", "", {})
-- executa um macro
keymap("n", "m", "@", {})
-- abre/fecha fold
keymap("n", "zz", "za", {})
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
keymap("n", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("n", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("v", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("v", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("i", "<S-Up>", "<esc><Plug>(expand_region_expand)", {})
keymap("i", "<S-Down>", "<esc><Plug>(expand_region_shrink)", {})
-- move linha - move.nvim
vim.keymap.set('n', "<A-Down>", ':MoveLine(1)<CR>', opts)
vim.keymap.set('n', "<A-Up>", ':MoveLine(-1)<CR>', opts)
vim.keymap.set('i', "<A-Up>", '<esc>:MoveLine(-1)<CR>', opts)
vim.keymap.set('i', "<A-Down>", '<esc>:MoveLine(1)<CR>', opts)
vim.keymap.set('v', "<A-Down>", ':MoveBlock(1)<CR>', opts)
vim.keymap.set('v', "<A-Up>", ':MoveBlock(-1)<CR>', opts)
-- abre arquivos no repositório atual - telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", {})
-- procura linhas no buffer - telescope
keymap("n", "\\", ":Telescope current_buffer_fuzzy_find<CR>", {})
-- pesquisar por comandos - telescope
keymap("n", "<leader>hc", ":Telescope commands<CR>", {})
-- pesquisar por correções - telescope
keymap("n", "z=", ":Telescope spell_suggest<CR>", {})
-- pesquisar por opções - telescope
keymap("n", "<leader>ho", ":Telescope vim_options<CR>", {})
-- pesquisar por documentação - telescope
keymap("n", "<leader>hh", ":Telescope help_tags<CR>", {})
-- pesquisar por highlights - telescope
keymap("n", "<leader>hH", ":Telescope highlights<CR>", {})
-- pesquisar por manpages - telescope
keymap("n", "<leader>hm", ":Telescope man_pages<CR>", {})
-- abre arquivos abertos recentemente - telescope
keymap("n", "<leader><leader>", ":Telescope oldfiles<CR>", {})
-- navegar por headings - telescope-heading
keymap("n", "<leader>v", ":Telescope heading<CR>", {})
-- procura e edita ocorrencias de uma palavra - greplace
keymap("n", "<leader>gg", ":Gsearch  ./<left><left><left>", {})
-- confirma todas as modificações - greplace
keymap("n", "<leader>gr", ":Greplace<CR>", {})
-- ativa previsão de cores - nvimcolorizer
keymap("n", "zc", ":ColorizerToggle<CR>", {})
-- abrir e fechar arvore de undos - undotree
keymap("n", "zu", ":UndotreeToggle<CR>:UndotreeFocus<CR>", {})
-- ativa foco - zen
keymap("n", "zf", ":ZenMode<CR>", {})
-- luasnip
vim.cmd([[
    " press <Tab> to expand or jump in a snippet. These can also be mapped separately
    " via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
    imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
    " -1 for jumping backwards.
    inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

    snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
    snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

    " For changing choices in choiceNodes (not strictly necessary for a basic setup).
    imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
    smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]])
-- editar snippets
keymap("n", "<leader>es", ":e ~/.config/nvim/Ultisnips/", {})

--- LSP
-- Ativa essas teclas quando o lsp esta ativo
On_attach = function(_, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    opts = { buffer = bufnr, noremap = true, silent = true }
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', function() require'telescope.builtin'.lsp_definitions{} end, opts)
    vim.keymap.set('n', 'gi', function() require'telescope.builtin'.lsp_implementations{} end, opts)
    vim.keymap.set('n', 'gr', function() require'telescope.builtin'.lsp_references{} end, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>D', function() require'telescope.builtin'.diagnostics{} end, opts)
    vim.keymap.set('n', '<leader>I', function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
end
