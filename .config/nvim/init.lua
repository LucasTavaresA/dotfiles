-- clona o paq caso a sua pasta não exista
local path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.fn.system {
        'git',
        'clone',
        '--depth=1',
        'https://github.com/savq/paq-nvim.git',
        path
    }
end

-- adiciona o paq aos pacotes do nvim
vim.cmd('packadd paq-nvim')

-- inicia o paq e seus pacotes
local paq = require('paq')
paq({
    ---- Iniciar
    -- vim mais rápido
    "lewis6991/impatient.nvim";
    -- gerenciador de pacotes
    "savq/paq-nvim";

    ---- Miscelânea
    -- salva posição do cursor
    "farmergreg/vim-lastplace";
    -- múltiplos cursores
    { "mg979/vim-visual-multi", branch = 'master' };
    -- comenta linhas
    "tpope/vim-commentary";
    -- troca/coloca aspas/parenteses
    "tpope/vim-surround";
    -- expande região selecionada
    "terryma/vim-expand-region";
    -- previsão de cores
    { "norcalli/nvim-colorizer.lua", config = function() require('colorizer').setup() end };
    -- procura usando o fzf
    { "junegunn/fzf", run = './install --bin', };
    "junegunn/fzf.vim";
    -- procura linhas no buffer
    "pelodelfuego/vim-swoop";

    ---- Code
    -- indentação e indicação de sintaxe
    "sheerun/vim-polyglot";
    "nvim-treesitter/nvim-treesitter";
    -- fecha parenteses apertando enter
    "rstacruz/vim-closer";
    -- indica diffs
    "mhinz/vim-signify";
    -- LSP
    "neovim/nvim-lspconfig";
    "williamboman/nvim-lsp-installer";
    -- sxhkd
    "baskerville/vim-sxhkdrc";
    -- snippets
    "SirVer/ultisnips";
    "honza/vim-snippets";
    -- prever markdown
    {
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn['mkdp#util#install']() end,
      ft = {'markdown', 'vimwiki'},
      cmd = { 'MarkdownPreview', 'MarkdownPreviewToggle' },
      config = {
        function()
          vim.g.mkdp_auto_close = 0
          vim.g.mkdp_echo_preview_url = 1
        end,
      }
    };
    -- tabelas em markdown
    "dhruvasagar/vim-table-mode";
    -- json
    "elzr/vim-json";
    -- previsão de output para REPL em Python, JavaScript, CoffeeScript, PHP, Lua, C++, TypeScript
    -- -- "metakirby5/codi.vim";
})

-- carrega plugins locais
vim.opt.runtimepath:append("~/.config/nvim/plugins/lite-dfm")
vim.opt.runtimepath:append("~/.config/nvim/plugins/moonlight.nvim")

---- Vim
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
-- mantem configurações de buffers
vim.opt.hidden = true
-- diminui recarregamentos da tela
vim.opt.lazyredraw = true
-- melhora suporte ao terminal
vim.opt.termguicolors = true

---- Arquivos
-- desabilita swapfile
vim.opt.swapfile = false

---- Tabs/Espaços
-- limita tabs em 4 espaços
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- troca tabs por espaços
vim.opt.expandtab = true

---- Miscelânea
-- muda o titulo da janela
vim.opt.title = true
vim.opt.titlestring = "nvim"
vim.opt.titleold = "st"
-- da a volta entre linhas
vim.opt.whichwrap = vim.opt.whichwrap + "<,>,h,l,[,]"
-- ativa uso do mouse
vim.opt.mouse = "a"
-- copiar e colar para o neovim
vim.cmd("autocmd InsertEnter * set cul")
vim.cmd("autocmd InsertLeave * set nocul")
vim.opt.clipboard:append { "unnamedplus" }
-- atualiza o neovim mais rápido
vim.opt.updatetime = 100
-- procura ignorando maiúsculas
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- habilita a compleção de comandos
vim.opt.wildmode = { "longest", "list", "full" }
-- divide a tela do lado e para baixo
vim.opt.splitbelow = true
vim.opt.splitright = true
-- não vai automaticamente para os itens pesquisados
vim.opt.incsearch = false
-- linhas não dão a volta na tela
vim.opt.wrap = false
-- desativa comentar automaticamente a próxima linha
vim.cmd("autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
-- automaticamente deleta todos os espaços em branco e novas linhas no salvamento do arquivo
vim.cmd [[ autocmd BufWritePre * let currPos = getpos('.') ]]
vim.cmd [[ autocmd BufWritePre * %s/\s\+$//e ]]
vim.cmd [[ autocmd BufWritePre * %s/\n\+\%$//e ]]
vim.cmd [[ autocmd BufWritePre *.[ch] %s/\%$/\r/e ]]
vim.cmd [[ autocmd BufWritePre * cal cursor(currPos[1], currPos[2]) ]]

---- Aparência
-- indicação de sintaxe
vim.cmd("syntax on")
-- inicia sem a barra - LiteDFM
vim.cmd("autocmd VimEnter * LiteDFMToggle")
-- tema - moonlight
vim.cmd("colorscheme moonlight")
-- tema do visual multi
vim.g.VM_theme = "neon"
-- indica linha selecionada no modo normal
vim.opt.cursorline = true
-- define quando a barra superior aparece
vim.opt.showtabline = 0
-- diminui tamanho da barra inferior
vim.opt.cmdheight = 1
-- fundo escuro
vim.opt.background = "dark"
-- transparência
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
-- cor da linha atual
vim.cmd("hi CursorLine guibg=#333333")
vim.cmd("autocmd InsertLeave * set cursorline")
-- incida parenteses correspondente
vim.cmd("hi! MatchParen cterm=NONE,bold gui=NONE,bold  guibg=NONE guifg=#ff0000")

---- Treesitter
-- indentação e indicação de sintaxe
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
-- ativa folding do treesitter
--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

---- Markdown
vim.g.vim_markdown_frontmatter = 1  -- para formatar YAML
vim.g.vim_markdown_toml_frontmatter = 1 -- para formatar TOML
vim.g.vim_markdown_json_frontmatter = 1 -- para formatar JSON
-- separa código em arquivos markdown ao salvar
vim.cmd([[
augroup RunCommandOnWrite
  autocmd!
  autocmd BufWritePost ~/.config/nvim/nvim.md !md-tangle -f %
  autocmd BufWritePost ~/README.md !md-tangle -f %
  autocmd BufWritePost ~/extras/extras.md !md-tangle -f %
  autocmd BufWritePost ~/extras/teclas.md !md-tangle -f %
  autocmd BufWritePost ~/extras/shells.md !md-tangle -f %
  autocmd BufWritePost ~/extras/desktop.md !md-tangle -f %
augroup END
]])
-- função para fechar e abrir sumario
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
-- tabelas em markdown
vim.g.table_mode_corner = '|'

---- LSP
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
end)

local keymap = vim.api.nvim_set_keymap
local nr = { noremap = true }
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- cancela indicação de palavras procuradas
keymap("n", "<esc><esc>", ":noh<CR>", {})
-- copiar na linha abaixo
keymap("n", "P", ":norm o<CR>p", {})
-- ativa/desativa o corretor ortográfico
keymap("n", "tt", ":setlocal spell! spelllang=pt<CR>", {})
keymap("n", "te", ":setlocal spell! spelllang=en<CR>", {})
-- navega entre as divisórias
keymap("n", "<leader><Tab>", ":wincmd w<CR>", nr)
-- salvar buffer
keymap("n", "<leader>ww", ":w<CR>", {})
-- sair e salvar
keymap("n", "<leader>wq", ":wq!<CR>", {})
-- fecha sem salvar
keymap("n", "<leader>qq", ":q!<CR>", {})
-- salvar e recarregar arquivo
keymap("n", "<leader>wr", ":w<CR>:e<CR>", {})
-- divide a tela do lado
keymap("n", "<C-A-Right>", ":vs<CR>", {})
-- divide a tela abaixo
keymap("n", "<C-A-down>", ":sp<CR>", {})
-- copiar buffer
keymap("n", "cb", "ggVGy", nr)
-- ativa/desativa números de linha
keymap("n", "tn", ":set number!<CR>", {})
-- procura palavra no cursor
keymap("n", "?", "*", {})
-- abrir e Fechar Toc
keymap("n", "<A-Tab>", "<CR>:TocToggle<CR>", {})
-- abre terminal no local do arquivo atual
keymap("n", "<leader><return>", ":!sh -c 'cd %:p:h ; st' &<CR><CR>", {})
-- centraliza cursor no modo normal
keymap("n", "<Up>", "<Up>zz", {})
keymap("n", "<down>", "<down>zz", {})
-- executa um macro
keymap("n", "m", "@", {})
-- marca/desmarca caixas
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
autocmd FileType markdown nnoremap <silent> <leader><leader> :call Marcar()<CR>j
]])

---- Plugins
-- atualiza plugins do paq - paq
keymap("n", "<leader>ps", ":PaqSync<CR>", {})
-- remove plugins não utilizados - paq
keymap("n", "<leader>pc", ":PaqClean<CR>", {})
-- editar snippets para o tipo de arquivo atual - ultisnips
keymap("n", "<leader>es", ":UltiSnipsEdit<CR>", {})
-- prevê arquivo markdown - markdown-preview
keymap("n", "mp", ":MarkdownPreview<CR>", {})
-- ativa/desativa a barra - litedfm
keymap("n", "tb", ":LiteDFMToggle<CR>", {})
-- expande região selecionada - expand region
keymap("n", "<S-up>", "<Plug>(expand_region_expand)", {})
keymap("n", "<S-down>", "<Plug>(expand_region_shrink)", {})
keymap("v", "<S-up>", "<Plug>(expand_region_expand)", {})
keymap("v", "<S-down>", "<Plug>(expand_region_shrink)", {})
-- Criar cursor na próxima palavra - visual multi
keymap("n", "<C-s>", "<C-n>", {})
keymap("v", "<C-s>", "<C-n>", {})
-- pular cursor ate a próxima palavra - visual multi
keymap("n", "<A-s>", "q", {})
-- criar cursor abaixo/acima - visual multi
keymap("n", "<leader><Up>", "<C-Up>", {})
keymap("n", "<leader><Down>", "<C-Down>", {})
-- procura linhas no buffer - swoop
keymap("n", ";", ":call Swoop()<CR>", {})
keymap("v", ";", ":call SwoopSelection()<CR>", {})
-- abre arquivos no diretório atual - fzf
keymap("n", "ff", ":Files %:p:h<CR>", {})
-- histórico de arquivos - fzf
keymap("n", "fh", ":History<CR>", {})
-- trocar de buffer - fzf
keymap("n", "<S-Tab>", ":Buffers<CR>", {})
-- comentar linhas - vim comentary
keymap("n", "cc", "gccj", {})
keymap("v", "cc", "gc", {})
-- ativa previsão de cores - nvimcolorizer
keymap("n", "tc", ":ColorizerToggle<CR>", {})
-- troca entre partes do snippet - ultisnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"

---- LSP
-- lua
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
