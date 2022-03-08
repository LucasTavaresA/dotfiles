# Configuração do neovim

Configuração do neovim em lua

## Sumario

- [Plugins](#plugins)
- [Miscellanea](#miscellanea)
- [Teclas](#teclas)

## Plugins

```lua tangle:~/.config/nvim/init.lua
require('packer').startup(function()
    ---- Iniciar
    -- Vim mais rapido
    use 'lewis6991/impatient.nvim'
    -- Gerenciador de pacotes
    use 'wbthomason/packer.nvim'

    ---- Aparencia
    -- Tema
    use '~/.config/nvim/plugins/moonlight.nvim'
    -- Esconde a barra
    use '~/.config/nvim/plugins/lite-dfm'

    ---- Miscellanea
    -- Salva posição do cursor
    use 'farmergreg/vim-lastplace'
    -- Múltiplos cursores
    use { 'mg979/vim-visual-multi', branch = 'master' }
    -- Comenta linhas
    use 'tpope/vim-commentary'
    -- Troca/coloca aspas/parenteses
    use 'tpope/vim-surround'
    -- Expande região selecionada
    use 'terryma/vim-expand-region'
    -- Previsão de cores
    use { 'norcalli/nvim-colorizer.lua', config = function() require('colorizer').setup() end }
    -- Procura usando o fzf
    use { 'junegunn/fzf', run = './install --bin', }
    use 'junegunn/fzf.vim'
    -- Procura linhas no buffer
    use 'pelodelfuego/vim-swoop'

    ---- Code
    -- Indentação e indicação de sintaxe
    use 'sheerun/vim-polyglot'
    use 'nvim-treesitter/nvim-treesitter'
    -- Fecha parenteses apertando enter
    use 'rstacruz/vim-closer'
    -- Indica diffs
    use 'mhinz/vim-signify'
    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    -- sxhkd
    use 'baskerville/vim-sxhkdrc'
    -- snippets
    use 'SirVer/ultisnips'
    use 'honza/vim-snippets'
    -- Prever markdown
    use {
      'iamcco/markdown-preview.nvim',
      run = function() vim.fn['mkdp#util#install']() end,
      ft = {'markdown', 'vimwiki'},
      cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle' },
      config = {
        function()
          vim.g.mkdp_auto_close = 0
          vim.g.mkdp_echo_preview_url = 1
        end,
      }
    }
    -- Tabelas em markdown
    use 'godlygeek/tabular'
    -- Json
    use 'elzr/vim-json'
end)

```

## Miscellanea

```lua tangle:~/.config/nvim/init.lua
---- vim
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
-- Mantem configurações de buffers
vim.opt.hidden = true
-- Diminui recarregamentos da tela
vim.opt.lazyredraw = true
-- Melhora support ao terminal
vim.opt.termguicolors = true

---- Arquivos
-- Desabilita swapfile
vim.opt.swapfile = false

---- Tabs/Espaços
-- Limita tabs em 4 espaços
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- Troca tabs por espaços
vim.opt.expandtab = true

---- Miscellanea
-- Muda o titulo da janela
vim.opt.title = true
vim.opt.titlestring = "nvim"
vim.opt.titleold = "st"
-- Da a volta entre linhas
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,h,l,[,]"
-- Ativa uso do mouse
vim.opt.mouse = "a"
-- Copiar e colar para o neovim
vim.cmd("autocmd InsertEnter * set cul")
vim.cmd("autocmd InsertLeave * set nocul")
vim.opt.clipboard:append { "unnamedplus" }
-- Atualiza o neovim mais rápido
vim.opt.updatetime = 100
-- Procura ignorando maiúsculas
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Habilita a compleção de comandos
vim.opt.wildmode = { "longest", "list", "full" }
-- Divide a tela do lado e para baixo
vim.opt.splitbelow = true
vim.opt.splitright = true
-- Não vai automaticamente para os itens pesquisados
vim.opt.incsearch = false
-- Linhas não dão a volta na tela
vim.opt.wrap = false
-- Desativa comentar automaticamente a próxima linha
vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
-- Automaticamente deleta todos os espaços em branco e novas linhas no salvamento do arquivo
vim.cmd [[ autocmd BufWritePre * let currPos = getpos('.') ]]
vim.cmd [[ autocmd BufWritePre * %s/\s\+$//e ]]
vim.cmd [[ autocmd BufWritePre * %s/\n\+\%$//e ]]
vim.cmd [[ autocmd BufWritePre *.[ch] %s/\%$/\r/e ]]
vim.cmd [[ autocmd BufWritePre * cal cursor(currPos[1], currPos[2]) ]]

---- Aparência
-- Indicação de sintaxe
vim.cmd("syntax on")
-- Inicia sem a barra - LiteDFM
vim.cmd("autocmd VimEnter * LiteDFMToggle")
-- Tema - moonlight
vim.cmd("colorscheme moonlight")
-- Tema do visual multi
vim.g.VM_theme = "neon"
-- Indica linha selecionada no modo normal
vim.opt.cursorline = true
-- Define quando a barra superior aparece
vim.opt.showtabline = 0
-- Diminui tamanho da barra inferior
vim.opt.cmdheight = 1
-- Fundo escuro
vim.opt.background = "dark"
-- Transparência
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
-- Cor da linha atual
vim.cmd("hi CursorLine guibg=#2f334d")
vim.cmd("autocmd InsertLeave * set cursorline")
-- Incida parenteses correspondente
vim.cmd("hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=NONE guifg=#ff0000")

---- Treesitter
-- Indentação e indicação de sintaxe
local configs = require'nvim-treesitter.configs'
configs.setup {
  ensure_installed = "maintained", -- Apenas use parsers que são atualizados
  highlight = { -- Indicação de sintaxe
    enable = true,
  },
  indent = {
    enable = true, -- Indentação
  }
}
-- Ativa folding do treesitter
--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

---- Markdown
vim.g.vim_markdown_frontmatter = 1  -- para formatar YAML
vim.g.vim_markdown_toml_frontmatter = 1 -- para formatar TOML
vim.g.vim_markdown_json_frontmatter = 1 -- para formatar JSON
-- Separa código em arquivos markdown ao salvar
vim.cmd([[
augroup RunCommandOnWrite
  autocmd!
  autocmd BufWritePost ~/.config/nvim/nvim.md !md-tangle -f %
  autocmd BufWritePost ~/README.md !md-tangle -f %
  autocmd BufWritePost ~/extras.md !md-tangle -f %
augroup END
]])
-- Função para Fechar e abrir Toc
vim.cmd([[
function s:TocToggle()
    if index(["markdown", "qf"], &filetype) == -1
        return
    endif

    if get(getloclist(0, {'winid':0}), 'winid', 0)
        " the location window is open
        lclose
    else
        " the location window is closed
        Toc
    endif
endfunction

command TocToggle call s:TocToggle()
]])

---- LSP
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
end)

```

## Teclas

```lua tangle:~/.config/nvim/init.lua
local keymap = vim.api.nvim_set_keymap
local nr = { noremap = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Cancela indicação de palavras procuradas
keymap("n", "<esc><esc>", ":noh<CR>", {})
-- Copiar na linha abaixo
keymap("n", "P", ":norm o<CR>p", {})
-- Ativa/Desativa o corretor ortográfico
keymap("n", "<leader>ts", ":setlocal spell! spelllang=pt", {})
-- Navega entre as divisórias
keymap("n", "<A-Tab>", ":wincmd w<CR>", nr)
-- Salvar buffer
keymap("n", "<leader>ww", ":w<CR>", {})
-- Sair e salvar
keymap("n", "<leader>wq", ":wq!<CR>", {})
-- Fecha sem salvar
keymap("n", "<leader>qq", ":q!<CR>", {})
-- Salvar e recarregar arquivo
keymap("n", "<leader>wr", ":w<CR>:e<CR>", {})
-- Divide a tela do lado
keymap("n", "<C-A-Right>", ":vs<CR>", {})
-- Divide a tela abaixo
keymap("n", "<C-A-down>", ":sp<CR>", {})
-- Copiar buffer
keymap("n", "<leader>cb", "ggVGy", nr)
-- Ativa/Desativa números de linha
keymap("n", "<leader>tn", ":set number!<CR>", {})
-- Procura palavra no cursor
keymap("n", "?", "*", {})
-- Abrir e Fechar Toc
keymap("n", "<S-Tab>", "<CR>:TocToggle<CR>", {})
-- Marca/Desmarca caixas
vim.cmd([[
function Marcar()
    let l:line=getline('.')
    let l:curs=winsaveview()
    if l:line=~?'\s*-\s*\[\s*\].*'
        s/\[.\]/[x]/
    elseif l:line=~?'\s*-\s*\[x\].*'
        s/\[x\]/[ ]/
    endif
    call winrestview(l:curs)
endfunction
autocmd FileType markdown nnoremap <silent> <leader><leader> :call Marcar()<CR>
]])

---- Plugins
-- Atualiza plugins do packer - packer
keymap("n", "<leader>ps", ":PackerSync<CR>", {})
-- Remove plugins não utilizados - packer
keymap("n", "<leader>pc", ":PackerClean<CR>", {})
-- Editar snippets para o tipo de arquivo atual - ultisnips
keymap("n", "<leader>es", ":UltiSnipsEdit<CR>", {})
-- Prevê arquivo markdown - markdown-preview
-- Prevê arquivo markdown - markdown-preview
keymap("n", "<leader>mp", ":MarkdownPreview<CR>", {})
keymap("n", "<leader>tb", ":LiteDFMToggle<CR>", {})
-- Expande região selecionada - expand region
keymap("n", "<A-up>", "<Plug>(expand_region_expand)", {})
keymap("n", "<A-down>", "<Plug>(expand_region_shrink)", {})
keymap("v", "<A-up>", "<Plug>(expand_region_expand)", {})
keymap("v", "<A-down>", "<Plug>(expand_region_shrink)", {})
-- Criar cursor na próxima palavra - visual multi
keymap("n", "<A-s-s>", "<C-n>", {})
-- Pular cursor ate a prox palavra - visual multi
keymap("n", "<A-s>", "q", {})
-- Criar cursor abaixo/acima - visual multi
keymap("n", "<C-s-Up>", "<C-Up>", {})
keymap("n", "<C-s-Down>", "<C-Down>", {})
-- Procura linhas no buffer - swoop
keymap("n", ";", ":call Swoop()<CR>", {})
keymap("v", ";", ":call SwoopSelection()<CR>", {})
-- Abre arquivos no diretório atual - fzf
keymap("n", "<leader>ff", ":Files %:p:h<CR>", {})
-- Histórico de arquivos - fzf
keymap("n", "<leader>fh", ":History<CR>", {})
-- Trocar de buffer - fzf
keymap("n", "<leader><Tab>", ":Buffers<CR>", {})
-- Comentar linhas - vim comentary
keymap("n", "cc", ":norm gcc<CR>j", {})
-- Ativa previsão de cores - nvimcolorizer
keymap("n", "<leader>tc", ":ColorizerToggle<CR>", {})

-- LSP
keymap("n", "gd", ":lua vim.lsp.buf.definition()<cr>", {})
keymap("n", "gD", ":lua vim.lsp.buf.declaration()<cr>", {})
keymap("n", "gi", ":lua vim.lsp.buf.implementation()<cr>", {})
keymap("n", "gw", ":lua vim.lsp.buf.document_symbol()<cr>", {})
keymap("n", "gw", ":lua vim.lsp.buf.workspace_symbol()<cr>", {})
keymap("n", "gr", ":lua vim.lsp.buf.references()<cr>", {})
keymap("n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", {})
keymap("n", "K", ":lua vim.lsp.buf.hover()<cr>", {})
keymap("n", "<c-k>", ":lua vim.lsp.buf.signature_help()<cr>", {})
keymap("n", "<leader>af", ":lua vim.lsp.buf.code_action()<cr>", {})
keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>", {})

```
