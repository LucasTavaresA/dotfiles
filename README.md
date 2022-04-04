# Archlinux dotfiles

Arquivos de configuração do archlinux

Blocos de código são salvos em seus arquivos usando [md-tangle](https://github.com/joakimmj/md-tangle)

## Sumario

-   [Emacs](#emacs)
-   [Neovim](#neovim)
-   [Shells](#shells)
-   [Desktop](#desktop)
-   [Teclas](#teclas)
-   [Qutebrowser](#qutebrowser)
    -   [Configuração](#configuração)
    -   [Tema escuro](#tema-escuro)
-   [Lf](#lf)
-   [Extras](#extras)

## Emacs

[Minha configuração do doom emacs](https://github.com/LucasTavaresA/dotfiles/blob/main/.config/doom/config.org)

## Neovim

[Minha configuração do neovim](https://github.com/LucasTavaresA/dotfiles/blob/main/.config/nvim/nvim.md)

## Shells

[Todos os shells do sistema](https://github.com/LucasTavaresA/dotfiles/blob/main/extras/shells.md)

## Desktop

[Configurações do Xorg e diversos window managers](https://github.com/LucasTavaresA/dotfiles/blob/main/extras/desktop.md)

## Teclas

[Todas as teclas do sxhkd](https://github.com/LucasTavaresA/dotfiles/blob/main/extras/teclas.md)

## Qutebrowser

Navegador controlado majoritariamente pelo teclado inspirado no **vim**

### Configuração

- `~/.config/qutebrowser/config.py`

```python tangle:~/.config/qutebrowser/config.py
# carregar o autoconfig.yml
config.load_autoconfig()

#### Configurações padrão ####
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
config.set('content.cookies.accept', 'all', 'devtools://*')
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')
config.set('content.images', True, 'chrome-devtools://*')
config.set('content.images', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
config.set('content.javascript.enabled', True, 'devtools://*')
config.set('content.javascript.enabled', True, 'chrome://*/*')
config.set('content.javascript.enabled', True, 'qute://*/*')

#### Minhas configurações ####
# tela cheia limitada a janela do navegador
config.set('content.fullscreen.window', True)
# diminuiu javascript lento nos sites
config.set('content.prefers_reduced_motion', True)
# vê pdfs no browser usando o pdfjs
config.set('content.pdfjs', True)
# javascript desativado por padrão
config.set('content.javascript.enabled', False)
# abre novas abas de fundo
config.set('new_instance_open_target', 'window')
# salva a sessão automaticamente
config.set('auto_save.session', True)
# não sai do modo de inserção automaticamente
config.set('input.insert_mode.auto_leave', False)
config.set('input.insert_mode.leave_on_load', False)
# o que fazer caso a ultima pagina seja fechada
config.set("tabs.last_close", "ignore")
# abre abas como janelas
config.set("tabs.tabs_are_windows", True)
# confirma antes de sair
config.set('confirm_quit', ["multiple-tabs"])
# muda ordem do menu de compleção
config.set("completion.open_categories", ["bookmarks", "history", "filesystem"])
# vídeos não tocam automaticamente
config.set("content.autoplay", False)
# mostra a barra de scroll quando procurando uma palavra
config.set('scrolling.bar', 'when-searching')
# encolhe janela de completação dependendo das opções
config.set('completion.shrink', True)
# barra escondida
config.set("statusbar.show", "in-mode")
config.set("tabs.show", "switching")
# formatação dos títulos das abas
config.set("tabs.title.format", "{perc}{private}{current_title}")
# formatação de horários
config.set('completion.timestamp_format', '%A %d/%m/%Y - %H:%M')
# corretor ortográfico
config.set('spellcheck.languages', ["pt-BR", "en-US"])
# conteúdo da barra de status
config.set('statusbar.widgets', ["keypress", "url", "progress"])
# posição da barra de status
config.set('statusbar.position', 'top')
c.tabs.position = "top"
# tamanho da barra de compleção
config.set('completion.height', '100%')
# editor
c.editor.command = ['nvim', '{}']

#### Adblock ####
config.set('content.blocking.method', 'both')
c.content.blocking.adblock.lists = [
        'https://easylist.to/easylist/easylist.txt',
        'https://easylist.to/easylist/easyprivacy.txt',
        'https://easylist-downloads.adblockplus.org/easylistdutch.txt',
        'https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt',
        'https://www.i-dont-care-about-cookies.eu/abp/',
        'https://secure.fanboy.co.nz/fanboy-cookiemonster.txt',
        "https://easylist.to/easylist/fanboy-social.txt",
        "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
        "https://pgl.yoyo.org/adservers/serverlist.php?showintro=0;hostformat=hosts",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/legacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2020.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2021.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
        ]

# usa o lf para mandar arquivos
config.set("fileselect.handler", "external")
config.set("fileselect.single_file.command", ["st", "-e", "lf", "-selection-path", "{}"])
config.set("fileselect.multiple_files.command", ["st", "-e", "lf", "-selection-path", "{}"])

# permitir notificações.
config.set('content.notifications.enabled', True, 'https://www.youtube.com/*')
config.set('content.notifications.enabled', True, 'https://twitter.com/*')
config.set('content.notifications.enabled', True, 'https://facebook.com/*')

#### Ferramentas de pesquisa ####
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}'
                    ,  'yt':   'https://www.youtube.com/results?search_query={}'
                    ,  'r':    'https://www.reddit.com/search/?q={}'
                    ,  'gh':   'https://github.com/search?q={}'
                    ,  'gl':   'https://gitlab.com/search?search={}'
                    ,  'se':   'https://stackexchange.com/search?q={}'
                    ,  'aw':   'https://wiki.archlinux.org/index.php?search={}'
                    ,  'gt':   'https://translate.google.com/?sl=auto&tl=en&text={}'
                    ,  'b':    'https://brainly.com.br/app/ask?q={}'
                    ,  'tw':   'https://twitter.com/search?q={}'
                    ,  'sc':   'https://soundcloud.com/search?q={}'
                    ,  'al':   'https://anilist.co/search/anime?search={}&sort=SEARCH_MATCH'
                    ,  'alm':  'https://anilist.co/search/manga?search={}&sort=SEARCH_MATCH'
                    ,  'md':   'https://mangadex.org/titles?page=1&q={}&order=relevance.desc'
                    ,  'vn':   'https://vndb.org/v?sq={}'
                    ,  'imdb': 'https://www.imdb.com/find?q={}&ref_=nv_sr_sm'
                    ,  'gm':   'https://www.google.com.br/maps/search/{}'
                    ,  'sf':   'https://sourceforge.net/directory/?q={}'
                    ,  'gf':   'https://greasyfork.org/en/scripts?q={}'
                    ,  'ud':   'https://www.urbandictionary.com/define.php?term={}'
                    ,  'tg':   'https://trends.google.com.br/trends/explore?q={}'
                    ,  'wm':   'https://web.archive.org/web/*/{}'
                    }

#### Atalhos ####
config.unbind('M')
config.unbind('m')
config.unbind('u')
config.unbind('d')
config.unbind('.')
config.unbind('q')
config.unbind('<Shift-H>')
config.unbind('<Shift-L>')

config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Left>', 'tab-prev')
config.bind('<Ctrl-Right>', 'tab-next')
config.bind('<Ctrl-a>', 'back')
config.bind('<Ctrl-d>', 'forward')
config.bind('u', 'undo --window')
# atalho para assistir link com mpv
config.bind('zvw', 'hint links spawn mpv {hint-url}')
# baixar imagem selecionada
config.bind('zid', 'hint images download')
# baixar como video
config.bind('zvd', 'hint links spawn st -c st_download -e yt {hint-url}')
# baixar como audio
config.bind('zad', 'hint links spawn st -c st_download -e yta {hint-url}')
# abre no firefox
config.bind('zf', 'hint links spawn firefox {url}')
# ativa/desativa a barra
config.bind('zx', 'config-cycle statusbar.show always in-mode;; config-cycle tabs.show always switching')
# ativa/desativa tema escuro
config.bind('zd', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/dark.css ""')
# ativa/desativa javascript para um site
config.bind('zj', 'config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload')
# ativa/desativa adblocking para um site
config.bind('zb', 'config-cycle -p -u *://*.{url:host}/* content.blocking.enabled ;; reload')
# modo leitura
config.bind('zr', 'spawn --userscript readability')
# traduz a pagina
config.bind('ztp', 'spawn --userscript translate')
# traduz o texto selecionado
config.bind('zts', 'spawn --userscript translate --text')
# copia links
config.bind('cl', 'hint links yank')
# copia trechos de código
config.bind('cc', 'hint code userscript code_select.py')
c.hints.selectors["code"] = [
    # seleciona code tags onde o parente não é uma tag pre
    ":not(pre) > code",
    "pre"
]

# diretório de downloads
c.downloads.location.directory = '~/Downloads'

# pagina inicial e novas abas
# quando usando comandos como :open -t e :open -w .
c.url.default_page = 'https://www.google.com/'
c.url.start_pages = 'https://www.google.com/'

#### CORES ####
# pedir modo escuro aos sites que o suportam
config.set('colors.webpage.preferred_color_scheme', 'dark')
# cor do texto da barra de compleção
c.colors.completion.fg = '#ffffff'
# cor de fundo da barra de compleção.
c.colors.completion.odd.bg = '#000000'
c.colors.completion.even.bg = '#000000'
# cor do texto das categorias.
c.colors.completion.category.fg = '#ffffff'
# cor de fundo das categorias.
c.colors.completion.category.bg = '#000000'
# cor da borda superior de categorias.
c.colors.completion.category.border.top = '#ffffff'
# cor da borda inferior de categorias.
c.colors.completion.category.border.bottom = '#ffffff'
# cor de texto selecionado na barra de seleção
c.colors.completion.item.selected.fg = '#000000'
# cor de fundo de texto selecionado na barra de compleção
c.colors.completion.item.selected.bg = '#ffffff'
# cor do texto procurado quando selecionado na barra de compleção
c.colors.completion.item.selected.match.fg = '#000000'
# cor de texto procurado na aba de compleção.
c.colors.completion.match.fg = '#ffff00'
# cor da barra de scroll na aba de compleção
c.colors.completion.scrollbar.fg = '#000000'
# cor de fundo da barra de download
c.colors.downloads.bar.bg = '#000000'
# cor de fundo de downloads com erro
c.colors.downloads.error.bg = '#ff0000'
# cor da fonte de indicadores de links
c.colors.hints.fg = '#ffffff'
# cor de fundo de indicadores de links
c.colors.hints.bg = '#000000'
# borda de indicadores de links
config.set('hints.border', '1px solid #ffffff')
config.set('hints.radius', 0)
# cor da fonte em partes procuradas
c.colors.hints.match.fg = '#ff0000'
# cor de fundo de informações importantes
c.colors.messages.info.bg = '#000000'
# cor de fundo da barra de status
c.colors.statusbar.normal.bg = '#000000'
# cor do texto da barra de status quando inserindo texto
c.colors.statusbar.insert.fg = '#ffffff'
# cor da barra de status quando inserindo texto
c.colors.statusbar.insert.bg = '#008800'
# cor da barra de status no modo passthrough
c.colors.statusbar.passthrough.bg = '#000000'
# cor de fundo da barra de status quando digitando comandos
c.colors.statusbar.command.bg = '#000000'
# cor do texto da barra de status quando em alerta
c.colors.statusbar.url.warn.fg = '#ff0000'
# cor de fundo da barra de abas abertas
c.colors.tabs.bar.bg = '#000000'
# cor de fundo de abas não selecionadas
c.colors.tabs.odd.bg = '#000000'
c.colors.tabs.even.bg = '#000000'
# cor de fundo de abas selecionadas
c.colors.tabs.selected.odd.bg = '#333333'
c.colors.tabs.selected.even.bg = '#333333'
# cor de fundo de abas fixadas não selecionadas
c.colors.tabs.pinned.odd.bg = '#000000'
c.colors.tabs.pinned.even.bg = '#000000'
# cor de fundo de abas fixadas selecionadas
c.colors.tabs.pinned.selected.odd.bg = '#333333'
c.colors.tabs.pinned.selected.even.bg = '#333333'
# cor das fontes de abas não selecionadas
c.colors.tabs.even.fg = '#ffffff'
c.colors.tabs.odd.fg = '#ffffff'
c.colors.tabs.pinned.even.fg = '#ffffff'
c.colors.tabs.pinned.odd.fg = '#ffffff'
# cor das fontes de abas selecionadas
c.colors.tabs.pinned.selected.odd.fg = '#ffffff'
c.colors.tabs.pinned.selected.even.fg = '#ffffff'
c.colors.tabs.selected.even.fg = '#ffffff'
c.colors.tabs.selected.odd.fg = '#ffffff'
# cor da borda do texto selecionado na barra de compleção
c.colors.completion.item.selected.border.bottom = '#ffffff'
c.colors.completion.item.selected.border.top = '#ffffff'

#### Fontes ####
# fonte padrão
c.fonts.default_family = '"monospace"'
# tamanho padrão das fontes
c.fonts.default_size = '14px'
# fonte usada nas abas de completação de comandos.
c.fonts.completion.entry = '14px "monospace"'
# fonte used for the debugging console.
c.fonts.debug_console = '14px "monospace"'
# fonte usada nos prompts.
c.fonts.prompts = 'default_size "monospace"'
# fonte usada na barra de status.
c.fonts.statusbar = '14px "monospace"'
```

### Tema escuro

-   [dark.css](https://github.com/LucasTavaresA/dotfiles/blob/main/.config/qutebrowser/styles/dark.css)

## Lf

Explorador de arquivos lf

- `~/.config/lf/lfrc`

```sh tangle:~/.config/lf/lfrc
# shell
set shell sh
set shellopts '-eu'
set period 1

# novas linhas
set ifs "\n"
# arquivos ocultos
set hidden on
# informação mostrada do lado do arquivo
set info "size"
# previa de arquivos
set previewer lf-previewer
set cleaner lf-cleaner
# fração das abas
set ratios 1:2
# da a volta nos items
set wrapscroll on
# informação no topo das abas
set promptfmt "\033[32;1m\033[0m\033[34;1m%d\033[0m\033[1m%f\033[0m"
# borda ao redor das abas
set drawbox on
# abre espaço na parte superior e inferior da tela
set scrolloff 0

# Comandos #

cmd open ${{
    case $(file --mime-type "$(readlink -f $f)" -b) in
        application/vnd.openxmlformats-officedocument.wordprocessingml.document) libreoffice $f ;;
        image/vnd.djvu|application/pdf|application/octet-stream|application/postscript) zathura $fx ;;
        application/pdf|application/vnd*|application/epub*) zathura $fx ;;
        application/pgp-encrypted) nvim $fx ;;
        text/*) nvim $fx ;;
        audio/*) mpv -no-video $fx ;;
        image/*) nsxiv . ;;
        video/*) mpv $fx ;;
        *) xdg-open $fx ;;
    esac
}}

cmd delete ${{
    clear; tput cup $(($(tput lines)/3)); tput bold
    set -f
    printf "%s\n\t" "$fx"
    printf "deletar?[y/N]"
    read ans
    [ $ans = "y" ] && rm -rf -- $fx
}}

cmd mkdir ${{
  printf "Nome do diretório: "
  read ans
  mkdir $ans
}}

cmd extract ${{
    clear; tput cup $(($(tput lines)/3)); tput bold
    set -f
    printf "%s\n\t" "$fx"
    printf "extrair?[y/N]"
    read ans
    [ $ans = "y" ] && aunpack $fx
}}

cmd mkfile ${{
  printf "Nome do arquivo: "
  read ans
  if [ $ans != "" ]; then
  touch $ans
  echo " " > $ans
  fi
}}

cmd chmod ${{
    clear; tput cup $(($(tput lines)/3)); tput bold
    set -f
    printf "%s\n\t" "$fx"
    printf "tornar executavel?[y/N]"
    read ans
    if [ $ans = "y" ]; then
  for file in "$fx"
  do
     chmod +x $file
  done

  lf -remote 'send reload'
  fi
}}

#### Teclas ####

map m
map o
map n
map "'"
map '"'
map e
map f

cmd open-with %"$@" $fx
map o push :open-with<space>

map <delete> delete
map t mkfile
map c chmod
map C clear
map m mkdir
map E extract
map i !nsxiv .

#### Atalhos ####
map gC cd ~/.config
map gcc cd ~/code/c
map gcs cd ~/code/shell
map gcS cd ~/code/csharp
map gcw cd ~/code/webPages
map gcu cd ~/code/unity

map gd cd ~/documentos
map gD cd ~/Downloads
map ge cd ~/extras
map gj cd ~/jogos
map gh cd ~
map gM cd ~/mnt

map gmv cd ~/media/videos
map gmi cd ~/media/imagens
map gmm cd ~/media/musicas
map gmc cd ~/media/cursos
```

## Extras

- [Mais configurações](https://github.com/LucasTavaresA/dotfiles/blob/main/extras/extras.md)
