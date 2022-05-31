----- PLUGINS -----
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
    --- Iniciar
    -- vim mais rápido
    "lewis6991/impatient.nvim";
    -- gerenciador de pacotes
    "savq/paq-nvim";

    --- Miscelânea
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
    -- procura arquivos usando fzf
    { "junegunn/fzf", run = './install --bin', };
    "junegunn/fzf.vim";
    -- procura arquivos rapidamente
    "ctrlpvim/ctrlp.vim";
    -- procura linhas no buffer
    "pelodelfuego/vim-swoop";
    -- arvore de undos
    "mbbill/undotree";

    --- Code
    -- Escreve codigo com IA
    "github/copilot.vim";
    -- indentação e indicação de sintaxe
    "sheerun/vim-polyglot";
    "nvim-treesitter/nvim-treesitter";
    -- fecha parenteses apertando enter
    "jiangmiao/auto-pairs";
    -- indica diffs
    "mhinz/vim-signify";
    -- melhor visão de diffs
    "nvim-lua/plenary.nvim";
    "sindrets/diffview.nvim";
    -- LSP
    "neovim/nvim-lspconfig";
    "williamboman/nvim-lsp-installer";
    -- buffer com erros no codigo
    "kyazdani42/nvim-web-devicons";
    { "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
        require("trouble").setup {
            padding = false,
            icons = false,
            fold_open = "v",
            fold_closed = ">",
            indent_lines = false,
            signs = {
                error = "error",
                warning = "warn",
                hint = "hint",
                information = "info"
            },
            use_diagnostic_signs = false
        }
      end
    };
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
    -- "metakirby5/codi.vim";
    -- debug de código
    "puremourning/vimspector";
    "gavinok/spaceway.vim";
})

-- carrega plugins locais
vim.opt.runtimepath:append("~/.config/nvim/plugins/lite-dfm")

----- Configuração -----
--- Vim
vim.cmd("filetype plugin on")
vim.cmd("filetype indent on")
-- mantem configurações de buffers
vim.opt.hidden = true
-- diminui recarregamentos da tela
vim.opt.lazyredraw = true
-- melhora suporte ao terminal
vim.opt.termguicolors = true

--- Arquivos
-- desabilita swapfile
vim.opt.swapfile = false

--- Tabs/Espaços
-- limita tabs em 4 espaços
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- troca tabs por espaços
vim.opt.expandtab = true

--- Miscelânea
-- muda o titulo da janela
vim.opt.title = true
vim.opt.titlestring = "nvim"
vim.opt.titleold = "st-256color"
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
vim.opt.diffopt:append { "horizontal" }
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

--- Aparência
-- indicação de sintaxe
vim.cmd("syntax on")
-- inicia sem a barra - LiteDFM
vim.cmd("autocmd VimEnter * LiteDFMToggle")
-- tema - moonlight
vim.cmd("colorscheme spaceway")
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
-- não deleta pares automaticamente
vim.g.AutoPairsMapBS = 0

--- Treesitter
-- indentação e indicação de sintaxe
local configs = require'nvim-treesitter.configs'
configs.setup {
    ensure_installed = "all",
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

--- Markdown
vim.g.vim_markdown_frontmatter = 1  -- para formatar YAML
vim.g.vim_markdown_toml_frontmatter = 1 -- para formatar TOML
vim.g.vim_markdown_json_frontmatter = 1 -- para formatar JSON
-- função para fechar e abrir o sumario
vim.cmd([[
function s:TocToggle()
    if index(["markdown", "qf"], &filetype) == -1
        return
    endif

    if get(getloclist(0, {'winid':0}), 'winid', 0)
        " caso esteja aberto
        lclose
    else
        " caso fechado
        Toc
    endif
endfunction
command TocToggle call s:TocToggle()
]])
-- tabelas em markdown
vim.g.table_mode_corner = '|'

--- LSP
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
  local opts = {}
  server:setup(opts)
end)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
        virtual_text = false,
        signs = false,
        update_in_insert = false,
        underline = true,
    }
)

--- Copilot
-- desativa o copilot ao iniciar
vim.cmd("autocmd VimEnter * Copilot disable")
-- função para fechar e abrir copilot - copilot
vim.cmd([[
function s:CopilotToggle()
    if !get(g:, 'copilot_enabled', 1)
        Copilot enable
    else
        Copilot disable
    endif
endfunction
command CopilotToggle call s:CopilotToggle()
]])

--- Ctrlp
-- abre arquivos no repositório atual de acordo com o gitignore
vim.cmd([[
    let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
]])

--- vimspector
vim.cmd([[
    let g:vimspector_base_dir=expand( '$HOME/.config/nvim/data/vimspector' )
]])

--- diffview
local cb = require'diffview.config'.diffview_callback
require'diffview'.setup {
    enhanced_diff_hl = true,
    file_panel = {
        position = "left",                  -- One of 'left', 'right', 'top', 'bottom'
        width = 25,                        -- Only applies when position is 'top' or 'bottom'
        listing_style = "list",             -- One of 'list' or 'tree'
    },
    file_history_panel = {
        position = "bottom",
        height = 15,
        log_options = {
            max_count = 256,      -- Limit the number of commits
            follow = false,       -- Follow renames (only for single file)
            all = false,          -- Include all refs under 'refs/' including HEAD
            merges = false,       -- List only merge commits
            no_merges = false,    -- List no merge commits
            reverse = false,      -- List commits in reverse order
        },
    },
    default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
    },
}

----- Teclas -----
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
-- mudar o typo de arquivo
keymap("n", "ft", ":set filetype=", {})
-- navega entre as divisórias
keymap("n", "<A-Tab>", ":wincmd w<CR>", nr)
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
keymap("n", "tn", ":set number!<CR>", {})
-- procura palavra no cursor
keymap("n", "?", "*", {})
-- abrir e Fechar Toc
keymap("n", "<leader><Tab>", "<CR>:TocToggle<CR>", {})
-- abre terminal no local do arquivo atual
keymap("n", "<leader><return>", ":!sh -c 'cd %:p:h ; st' &<CR><CR>", {})
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

--- Plugins
-- atualiza plugins do paq - paq
keymap("n", "<leader>ps", ":PaqSync<CR>", {})
-- remove plugins não utilizados - paq
keymap("n", "<leader>pc", ":PaqClean<CR>", {})
-- prevê arquivo markdown - markdown-preview
keymap("n", "mp", ":MarkdownPreview<CR>", {})
-- ativa/desativa a barra - litedfm
keymap("n", "tb", ":LiteDFMToggle<CR>", {})
-- ativa o copilot - copilot
keymap("n", "tC", ":CopilotToggle<CR>", {})
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
-- criar cursor abaixo/acima - visual multi
keymap("n", "<leader><Up>", "<C-Up>", {})
keymap("n", "<leader><Down>", "<C-Down>", {})
-- procura linhas no buffer - swoop
keymap("n", ";", ":call Swoop()<CR>", {})
keymap("v", ";", ":call SwoopSelection()<CR>", {})
-- abre arquivos no repositório atual - ctrlp
keymap("n", "ff", ":CtrlP<CR>", {})
-- abre arquivos aberto recentemente - ctrlp
keymap("n", "fh", ":CtrlPMRUFiles<CR>", {})
-- trocar de buffer - ctrlp
keymap("n", "<S-Tab>", ":CtrlPBuffer<CR>", {})
-- abre arquivos na home - fzf
keymap("n", "f~", ":Files ~<CR>", {})
-- comentar linhas - vim comentary
keymap("n", "cc", "gccj", {})
keymap("v", "cc", "gc", {})
-- ativa previsão de cores - nvimcolorizer
keymap("n", "tc", ":ColorizerToggle<CR>", {})
-- abrir e fechar o buffer de diagnostico - Trouble
keymap("n", "td", ":TroubleToggle<CR>", {})
-- abrir e fechar arvore de undos - undotree
keymap("n", "tu", ":UndotreeToggle<CR>:UndotreeFocus<CR>", {})
-- ve o diff do repositório atual - diffview
keymap("n", "dv", ":DiffviewOpen<CR>", {})
-- editar snippets para o tipo de arquivo atual - ultisnips
keymap("n", "<leader>es", ":UltiSnipsEdit<CR>", {})
-- troca entre partes do snippet - ultisnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-Tab>"

--- LSP
-- lua
keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", {})
keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", {})
keymap("n", "gi", ":lua vim.lsp.buf.implementation()<CR>", {})
keymap("n", "gw", ":lua vim.lsp.buf.document_symbol()<CR>", {})
keymap("n", "gw", ":lua vim.lsp.buf.workspace_symbol()<CR>", {})
keymap("n", "gr", ":lua vim.lsp.buf.references()<CR>", {})
keymap("n", "gt", ":lua vim.lsp.buf.type_definition()<CR>", {})
keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", {})
keymap("n", "<c-k>", ":lua vim.lsp.buf.signature_help()<CR>", {})
keymap("n", "<leader>af", ":lua vim.lsp.buf.code_action()<CR>", {})
keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", {})

--- vimspector
keymap("n", "Dd", ":call vimspector#Continue()<CR>", {})
keymap("n", "Ds", ":call vimspector#Stop()<CR>", {})
keymap("n", "Dr", ":call vimspector#Restart()<CR>", {})
keymap("n", "DD", ":call vimspector#ToggleBreakpoint()<CR>", {})
keymap("n", "D<Up>", ":call vimspector#StepOut()<CR>", {})
keymap("n", "D<Right>", ":call vimspector#StepInto()<CR>", {})
keymap("n", "D<Down>", ":call vimspector#StepOver()<CR>", {})
