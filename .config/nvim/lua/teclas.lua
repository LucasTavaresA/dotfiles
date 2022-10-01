local keymap = vim.api.nvim_set_keymap
local nr = { noremap = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- cancela indicação de palavras procuradas
keymap("n", "<esc><esc>", ":noh<CR>", {})
-- colar na linha abaixo
keymap("n", "P", ":norm o<CR>p", {})
-- ativa/desativa o corretor ortográfico
keymap("n", "tt", ":setlocal spell! spelllang=pt<CR>", {})
keymap("n", "te", ":setlocal spell! spelllang=en<CR>", {})
-- mudar o typo de arquivo
keymap("n", "ft", ":set filetype=", {})
-- salvar buffer
keymap("n", "<leader>ww", ":w<CR>", {})
-- sair e salvar
keymap("n", "<leader>wq", ":wq!<CR>", {})
-- fecha sem salvar
keymap("n", "<leader>qq", ":q!<CR>", {})
-- salvar e recarregar arquivo
keymap("n", "<leader>wr", ":w<CR>:e<CR>", {})
-- abre ultima mensagem
keymap("n", "<leader>m", ":message<CR>", {})
-- divide a tela do lado
keymap("n", "<C-A-Right>", ":vs<CR>", {})
-- divide a tela abaixo
keymap("n", "<C-A-Down>", ":sp<CR>", {})
-- copiar buffer
keymap("n", "cb", "ggVGy", nr)
-- ativa/desativa números de linha
keymap("n", "zn", ":set number!<CR>", {})
-- procura palavra no cursor
keymap("n", "?", "*", {})
-- abre terminal no local do arquivo atual
keymap("n", "<leader><return>", ":!sh -c 'cd %:p:h ; term_open' &<CR><CR>", {})
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
-- expande região selecionada - expand region
keymap("n", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("n", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("v", "<S-Up>", "<Plug>(expand_region_expand)", {})
keymap("v", "<S-Down>", "<Plug>(expand_region_shrink)", {})
keymap("i", "<S-Up>", "<esc><Plug>(expand_region_expand)", {})
keymap("i", "<S-Down>", "<esc><Plug>(expand_region_shrink)", {})
-- Criar cursor na próxima palavra - visual multi
keymap("n", "<C-s>", "<C-n>", {})
keymap("v", "<C-s>", "<C-n>", {})
-- criar cursor abaixo - visual multi
keymap("n", "<A-s>", "<C-Down>", {})
-- procura linhas no buffer - swoop
keymap("n", ";", ":call Swoop()<CR>", {})
keymap("v", ";", ":call SwoopSelection()<CR>", {})
-- abre arquivos no repositório atual - ctrlp
keymap("n", "ff", ":CtrlP<CR>", {})
-- abre arquivos abertos recentemente - ctrlp
keymap("n", "<leader><leader>", ":CtrlPMRUFiles<CR>", {})
-- trocar de buffer
keymap("n", "<C-Tab>", ":bn<CR>", {})
-- abre arquivos na home - fzf
keymap("n", "fh", ":Files ~<CR>", {})
-- comentar linhas - vim comentary
keymap("n", ",,", "gccj", {})
keymap("v", ",,", "gc", {})
-- ativa previsão de cores - nvimcolorizer
keymap("n", "zr", ":ColorizerToggle<CR>", {})
-- abrir e fechar arvore de undos - undotree
keymap("n", "zu", ":UndotreeToggle<CR>:UndotreeFocus<CR>", {})
-- editar snippets para o tipo de arquivo atual - ultisnips
keymap("n", "<leader>es", ":UltiSnipsEdit<CR>", {})
-- troca entre partes do snippet - ultisnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"
