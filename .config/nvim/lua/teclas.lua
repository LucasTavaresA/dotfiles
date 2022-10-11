--- Variaveis
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- cancela indicação de palavras procuradas
keymap("n", "<esc>", ":noh<CR>", {})
-- colar na linha abaixo/acima
keymap("n", "p", ":norm o<CR>p", opts)
keymap("n", "P", ":norm O<CR>p", {})
-- trocar de buffer
keymap("n", "<C-Tab>", ":bn<CR>", {})
-- trocar de split
keymap("n", "<A-Tab>", "<C-w>w", {})
-- formatar buffer
keymap("n", "<leader>F", "gg=G", {})
-- formatar paragrafo
keymap("n", "<leader>ii", "{=}", {})
-- alinhar texto
keymap("v", "<leader>a", ":'<,'>!column -t -o ' '<CR>", {})
-- mudar o typo de arquivo
keymap("n", "<leader>ft", ":set filetype=", {})
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
-- abre terminal no local do arquivo atual
keymap("n", "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>", {})
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
    autocmd FileType markdown nnoremap <silent> zx :call Marcar()<CR>j
    autocmd FileType org nnoremap <silent> zx :call Marcar()<CR>j
]])

--- Plugins
-- atualiza plugins do paq - paq
keymap("n", "<leader>ps", ":PaqSync<CR>", {})
-- remove plugins não utilizados - paq
keymap("n", "<leader>pc", ":PaqClean<CR>", {})
-- pula para uma palavra - hop
keymap("n", "f", ":HopWord<CR>", {})
-- expande região selecionada - expand region
keymap("n", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("n", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("v", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("v", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("i", "<S-Up>", "<esc><Plug>(expand_region_expand)", {})
keymap("i", "<S-Down>", "<esc><Plug>(expand_region_shrink)", {})
-- move linha - vim-move
keymap("n", "<A-Down>", "<Plug>MoveLineDown", {})
keymap("n", "<A-Up>", "<Plug>MoveLineUp", {})
keymap("i", "<A-Down>", "<esc><Plug>MoveLineDown", {})
keymap("i", "<A-Up>", "<esc><Plug>MoveLineUp", {})
keymap("v", "<A-Down>", "<Plug>MoveBlockDown", {})
keymap("v", "<A-Up>", "<Plug>MoveBlockUp", {})
-- Criar cursor na próxima palavra - visual multi
keymap("n", "<C-s>", "<C-n>", {})
keymap("v", "<C-s>", "<C-n>", {})
-- criar cursor abaixo - visual multi
keymap("n", "<C-S-s>", "<C-Down>", {})
-- procura linhas no buffer - swoop
keymap("n", ";", ":call Swoop()<CR>", {})
keymap("v", ";", ":call SwoopSelection()<CR>", {})
-- abre arquivos no repositório atual - ctrlp
keymap("n", "<leader>ff", ":CtrlP<CR>", {})
-- abre arquivos abertos recentemente - ctrlp
keymap("n", "<leader><leader>", ":CtrlPMRUFiles<CR>", {})
-- abre arquivos na home - fzf
keymap("n", "<leader>fh", ":Files ~<CR>", {})
-- comentar linhas - vim comentary
keymap("n", ",,", "gccj", {})
keymap("v", ",,", "gc", {})
-- ativa previsão de cores - nvimcolorizer
keymap("n", "zc", ":ColorizerToggle<CR>", {})
-- abrir e fechar arvore de undos - undotree
keymap("n", "zu", ":UndotreeToggle<CR>:UndotreeFocus<CR>", {})
-- editar snippets para o tipo de arquivo atual - ultisnips
keymap("n", "<leader>es", ":UltiSnipsEdit<CR>", {})
-- troca entre partes do snippet - ultisnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"

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
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>D', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<leader>F', function() vim.lsp.buf.format { async = true } end, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
end
