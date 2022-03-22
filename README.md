# Archlinux dotfiles

Arquivos de configuração do archlinux

Blocos de código são salvos em seus arquivos usando [md-tangle](https://github.com/joakimmj/md-tangle)

## Sumario

-   [Emacs](#emacs)
-   [Neovim](#neovim)
-   [Shells](#shells)
-   [X11](#x11)
-   [Herbstluftwm](#herbstluftwm)
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

## X11

Configuração do xorg

- `~/.config/x11/xinitrc`

```sh tangle:~/.config/x11/xinitrc
#!/bin/sh

# Mouse
xsetroot -cursor_name left_ptr

# Teclado
setxkbmap -option caps:escape # grep -E "(ctrl|caps):" /usr/share/X11/xkb/rules/base.lst
xset r rate 300 100 # acelera repetição de teclas

# Clipmenu
systemctl --user import-environment DISPLAY
export CM_DIR="$HOME/code/shell/dmenuscripts/listas/clipmenu"
clipmenud &

# Protetor de tela
xautolock -detectsleep -time 30 -locker "slock" -notify 30 -notifier "notify-send Slock -u critical -t 1800000 'BLOQUEANDO A TELA 30 SEGUNDOS'" &

mpd &
dunst &
nitrogen --restore &
nm-applet &
xbanish &
fluxgui &
picom &

if [ "$WM" = "herbstluftwm" ]; then
    sxhkd -c "$HOME/.config/sxhkd/sxhkd_herbstluftwm" &
    flags=" --locked"
elif [ "$WM" = "dwm" ]; then
    sxhkd -c "$HOME/.config/sxhkd/sxhkd_dwm" &
    dwmblocks &
elif [ "$WM" = "bspwm" ]; then
    sxhkd -c "$HOME/.config/sxhkd/sxhkd_bspwm" &
else
    sxhkd -c "$HOME/.config/sxhkd/sxhkd_nowm" &
fi

if [ -n "$flags" ]; then
    exec $WM$flags
else
    exec "$WM"
fi
```

## Herbstluftwm

Gerenciador de janelas

- `~/.config/herbstluftwm/autostart`

```bash tangle:~/.config/herbstluftwm/autostart
#!/usr/bin/env bash

pegar_erros() {
    trap '' ERR
    local frame=0 str
    local stacktrace="Comando fechado com status $1\n\nStack:"
    while str=$(caller $frame); do
        stacktrace+="\nlinha $str"
        frame=$((frame+1))
    done
    notify-send -u critical "Erro de configuração no hlwm" "$stacktrace"
}
set -o errtrace
trap 'pegar_erros $?' ERR

hc() {
    herbstclient "$@"
}

primeira_vez_aberto() {
    ! hc silent get_attr my_loaded 2>/dev/null
}

hc emit_hook reload

# remove todas as teclas de atalho
hc keyunbind --all
hc mouseunbind --all

# Atalhos do mouse
hc mousebind Super-Button1 move
hc mousebind Super-Button2 zoom
hc mousebind Super-Button3 resize

# Adiciona tags no primeiro iniciar
if primeira_vez_aberto; then
    tag_names=( {1..7} )
    hc rename default "${tag_names[0]}" || true
    for i in "${!tag_names[@]}"; do
        hc add "${tag_names[$i]}"
    done
    hc detect_monitors
fi
tag_keys=( {1..7} 0 )
tag_count=$(hc attr tags.count)
for i in "${!tag_keys[@]}"; do
    (( i >= tag_count )) && break
    key="${tag_keys[$i]}"
done

hc attr theme.tiling.reset 1
hc attr theme.floating.reset 1
hc attr theme.active.color '#ffffff'
hc attr theme.normal.color '#000000'
hc attr theme.urgent.color '#ff0000'
hc attr theme.inner_color '#000000'
hc attr theme.floating.outer_color '#000000'
hc attr theme.active.inner_color '#ffffff'
hc attr theme.active.outer_color '#ffffff'
hc attr theme.background_color '#000000'
hc attr theme.inner_width 0
hc attr theme.border_width 1
hc attr theme.floating.border_width 1
hc attr theme.floating.outer_width 0

hc set frame_border_active_color '#00ff00'
hc set frame_border_normal_color '#000000'
hc set frame_bg_active_color '#111111'
hc set frame_bg_normal_color '#000000'
hc set auto_detect_panels true
hc set default_frame_layout max
hc set always_show_frame 0
hc set frame_border_width 1
hc set frame_bg_transparent 1
hc set frame_bg_transparent 1
hc set frame_transparent_width 0
hc set frame_padding 0
hc set frame_gap 0
hc set smart_frame_surroundings 1
hc set smart_window_surroundings 1
hc set window_gap 0
hc set focus_follows_mouse 0
hc set raise_on_focus 1
hc set mouse_recenter_gap 0
hc set swap_monitors_to_get_tag 1
hc set tree_style '╾│ ├└╼─┐'

### Regras
hc unrule -F
hc rule focus=on # Focar novas janelas
hc rule floatplacement=smart
# Programas
hc rule class="qutebrowser" tag=1
hc rule class="Firefox" tag=1
hc rule class="Emacs" tag=2
hc rule class="nvim" tag=2
hc rule class="mpv" tag=3
hc rule class="Gimp" tag=4
hc rule class="discord" tag=5
hc rule class="TelegramDesktop" tag=5
#hc rule class="" tag=6
#hc rule class="" tag=7
# Flutuantes
hc rule class="ncmpcpp" floating=on floatplacement=center
hc rule class="pulsemixer" floating=on floatplacement=center
hc rule class="MEGAsync" floating=on floatplacement=center
hc rule class="Transmission-gtk" floating=on floatplacement=center
hc rule class="Galculator" floating=on floatplacement=center
hc rule class="htop" floating=on floatplacement=center
# Notificações, pop-ups, etc.
hc rule class="qutebrowser" windowtype='_NET_WM_WINDOW_TYPE_UTILITY' floating=on
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on floatplacement=center
hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off
hc rule class="Pinentry-gtk-2" floating=on floatplacement=center

hc unlock
```

## Teclas

[Todas as teclas do sxhkd](https://github.com/LucasTavaresA/dotfiles/blob/main/extras/teclas.md)

## Qutebrowser

Navegador controlado majoritariamente pelo teclado inspirado no **vim**

### Configuração

- `~/.config/qutebrowser/config.py`

```python tangle:~/.config/qutebrowser/config.py
# Autogenerated config.py
#
# NOTE: config.py is intended for advanced users who are comfortable
# with manually migrating the config file on qutebrowser upgrades. If
# you prefer, you can also configure qutebrowser using the
# :set/:bind/:config-* commands without having to write a config.py
# file.
#
# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

# Carregar o autoconfig.yml
config.load_autoconfig()

# CONFIGURAÇÕES PADRÃO

# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'chrome-devtools://*')
# Valid values:
#   - all: Accept all cookies.
#   - no-3rdparty: Accept cookies from the same origin only. This is known to break some sites, such as GMail.
#   - no-unknown-3rdparty: Accept cookies from the same origin only, unless a cookie is already set for the domain. On QtWebEngine, this is the same as no-3rdparty.
#   - never: Don't accept cookies at all.
config.set('content.cookies.accept', 'all', 'devtools://*')

# Value to send in the `Accept-Language` header. Note that the value
# read from JavaScript is always the global value.
config.set('content.headers.accept_language', '', 'https://matchmaker.krunker.io/*')

# User agent to send.
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {upstream_browser_key}/{upstream_browser_version} Safari/{webkit_version}', 'https://web.whatsapp.com/')
# User agent to send.
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}; rv:90.0) Gecko/20100101 Firefox/90.0', 'https://accounts.google.com/*')
# User agent to send.
config.set('content.headers.user_agent', 'Mozilla/5.0 ({os_info}) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99 Safari/537.36', 'https://*.slack.com/*')

# Load images automatically in web pages.
config.set('content.images', True, 'chrome-devtools://*')
# Load images automatically in web pages.
config.set('content.images', True, 'devtools://*')

# Enable JavaScript.
config.set('content.javascript.enabled', True, 'chrome-devtools://*')
# Enable JavaScript.
config.set('content.javascript.enabled', True, 'devtools://*')
# Enable JavaScript.
config.set('content.javascript.enabled', True, 'chrome://*/*')
# Enable JavaScript.
config.set('content.javascript.enabled', True, 'qute://*/*')

# MINHAS CONFIGURAÇÕES

# Tela cheia limitada a janela do navegador
config.set('content.fullscreen.window', True)

# Mostra a barra de scroll quando procurando uma palavra
config.set('scrolling.bar', 'when-searching')

# Encolhe janela de compleção dependendo das opções
config.set('completion.shrink', True)

# Diminuiu javascript lento nos sites
config.set('content.prefers_reduced_motion', True)

# Vê pdfs no browser usando o pdfjs
config.set('content.pdfjs', True)

# Javascript desativado por padrão
config.set('content.javascript.enabled', False)

# Abre novas abas de fundo
config.set('new_instance_open_target', 'window')

# Não sai do modo de inserção automaticamente
config.set('input.insert_mode.auto_leave', False)
config.set('input.insert_mode.leave_on_load', False)

# Barra escondida
config.set("statusbar.show", "in-mode")
config.set("tabs.show", "switching")

# O que fazer caso a ultima pagina seja fechada
config.set("tabs.last_close", "ignore")

# Abre abas como janelas
config.set("tabs.tabs_are_windows", True)

# Confirma antes de sair
config.set('confirm_quit', ["multiple-tabs"])

# Muda ordem do menu de compleção
config.set("completion.open_categories", ["bookmarks", "history", "filesystem"])

# Formatação dos títulos das abas
config.set("tabs.title.format", "{perc}{private}{current_title}")

# Vídeos não tocam automaticamente
config.set("content.autoplay", False)

# Formatação de horários
config.set('completion.timestamp_format', '%A %d/%m/%Y - %H:%M')

# Corretor ortográfico
config.set('spellcheck.languages', ["pt-BR", "en-US"])

# Conteúdo da barra de status
config.set('statusbar.widgets', ["keypress", "url", "progress"])

# Posição da barra de status
config.set('statusbar.position', 'top')

# Tamanho da barra de compleção
config.set('completion.height', '100%')

# Adblock
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

# Usa o lf para mandar arquivos
config.set("fileselect.handler", "external")
config.set("fileselect.single_file.command", ["st", "-e", "lf", "-selection-path", "{}"])
config.set("fileselect.multiple_files.command", ["st", "-e", "lf", "-selection-path", "{}"])

# Permitir notificações.
# Valid values:
#   - true
#   - false
#   - ask
config.set('content.notifications.enabled', True, 'https://www.youtube.com/*')
config.set('content.notifications.enabled', True, 'https://twitter.com/*')
config.set('content.notifications.enabled', True, 'https://facebook.com/*')

# Editor (and arguments) to use for the `edit-*` commands. The following
# placeholders are defined:  * `{file}`: Filename of the file to be
# edited. * `{line}`: Line in which the caret is found in the text. *
# `{column}`: Column in which the caret is found in the text. *
# `{line0}`: Same as `{line}`, but starting from index 0. * `{column0}`:
# Same as `{column}`, but starting from index 0.
c.editor.command = ['nvim', '{}']

# Search engines which can be used via the address bar.  Maps a search
# engine name (such as `DEFAULT`, or `ddg`) to a URL with a `{}`
# placeholder. The placeholder will be replaced by the search term, use
# `{{` and `}}` for literal `{`/`}` braces.  The following further
# placeholds are defined to configure how special characters in the
# search terms are replaced by safe characters (called 'quoting'):  *
# `{}` and `{semiquoted}` quote everything except slashes; this is the
# most   sensible choice for almost all search engines (for the search
# term   `slash/and&amp` this placeholder expands to `slash/and%26amp`).
# * `{quoted}` quotes all characters (for `slash/and&amp` this
# placeholder   expands to `slash%2Fand%26amp`). * `{unquoted}` quotes
# nothing (for `slash/and&amp` this placeholder   expands to
# `slash/and&amp`). * `{0}` means the same as `{}`, but can be used
# multiple times.  The search engine named `DEFAULT` is used when
# `url.auto_search` is turned on and something else than a URL was
# entered to be opened. Other search engines can be used by prepending
# the search engine name to the search term, e.g. `:open google
# qutebrowser`.
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

# ATALHOS
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
# Atalho para assistir link com mpv
config.bind('zvw', 'hint links spawn mpv {hint-url}')
# Baixar imagem selecionada
config.bind('zid', 'hint images download')
# Baixar como video
config.bind('zvd', 'hint links spawn st -c st_download -e yt {hint-url}')
# Baixar como audio
config.bind('zad', 'hint links spawn st -c st_download -e yta {hint-url}')
# Abre no firefox
config.bind('zf', 'hint links spawn firefox {url}')
# Ativa/Desativa a barra
config.bind('zx', 'config-cycle statusbar.show always in-mode;; config-cycle tabs.show always switching')
# Ativa/Desativa tema escuro
config.bind('zd', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/dark.css ""')
# Ativa/Desativa javascript para um site
config.bind('zj', 'config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload')
# Ativa/Desativa adblocking para um site
config.bind('zb', 'config-cycle -p -u *://*.{url:host}/* content.blocking.enabled ;; reload')
# Modo leitura
config.bind('zr', 'spawn --userscript readability')
# Traduz a pagina
config.bind('ztp', 'spawn --userscript translate')
# Traduz o texto selecionado
config.bind('zts', 'spawn --userscript translate --text')
# Copia links
config.bind('cl', 'hint links yank')
# Copia trechos de código
config.bind('cc', 'hint code userscript code_select.py')
c.hints.selectors["code"] = [
    # Seleciona code tags onde o parente não é uma tag pre
    ":not(pre) > code",
    "pre"
]

# diretório de downloads
c.downloads.location.directory = '~/Downloads'

# pagina inicial e novas abas
# quando usando comandos como :open -t e :open -w .
c.url.default_page = 'https://www.google.com/'
c.url.start_pages = 'https://www.google.com/'

# CORES

# Pedir modo escuro aos sites que o suportam
config.set('colors.webpage.preferred_color_scheme', 'dark')
# Cor do texto da barra de compleção
c.colors.completion.fg = '#ffffff'
# Cor de fundo da barra de compleção.
c.colors.completion.odd.bg = '#000000'
c.colors.completion.even.bg = '#000000'
# Cor do texto das categorias.
c.colors.completion.category.fg = '#ffffff'
# Cor de fundo das categorias.
c.colors.completion.category.bg = '#000000'
# Cor da borda superior de categorias.
c.colors.completion.category.border.top = '#ffffff'
# Cor da borda inferior de categorias.
c.colors.completion.category.border.bottom = '#ffffff'
# Cor de texto selecionado na barra de seleção
c.colors.completion.item.selected.fg = '#000000'
# Cor de fundo de texto selecionado na barra de compleção
c.colors.completion.item.selected.bg = '#ffffff'
# Cor do texto procurado quando selecionado na barra de compleção
c.colors.completion.item.selected.match.fg = '#000000'
# Cor de texto procurado na aba de compleção.
c.colors.completion.match.fg = '#ffff00'
# Cor da barra de scroll na aba de compleção
c.colors.completion.scrollbar.fg = '#000000'
# Cor de fundo da barra de download
c.colors.downloads.bar.bg = '#000000'
# Cor de fundo de downloads com erro
c.colors.downloads.error.bg = '#ff0000'
# Cor da fonte de indicadores de links
c.colors.hints.fg = '#ffffff'
# Cor de fundo de indicadores de links
c.colors.hints.bg = '#000000'
# Borda de indicadores de links
config.set('hints.border', '1px solid #ffffff')
config.set('hints.radius', 0)
# Cor da fonte em partes procuradas
c.colors.hints.match.fg = '#ff0000'
# Cor de fundo de informações importantes
c.colors.messages.info.bg = '#000000'
# Cor de fundo da barra de status
c.colors.statusbar.normal.bg = '#000000'
# Cor do texto da barra de status quando inserindo texto
c.colors.statusbar.insert.fg = '#ffffff'
# Cor da barra de status quando inserindo texto
c.colors.statusbar.insert.bg = '#008800'
# Cor da barra de status no modo passthrough
c.colors.statusbar.passthrough.bg = '#000000'
# Cor de fundo da barra de status quando digitando comandos
c.colors.statusbar.command.bg = '#000000'
# Cor do texto da barra de status quando em alerta
c.colors.statusbar.url.warn.fg = '#ff0000'
# Cor de fundo da barra de abas abertas
c.colors.tabs.bar.bg = '#000000'
# Cor de fundo de abas não selecionadas
c.colors.tabs.odd.bg = '#000000'
c.colors.tabs.even.bg = '#000000'
# Cor de fundo de abas selecionadas
c.colors.tabs.selected.odd.bg = '#333333'
c.colors.tabs.selected.even.bg = '#333333'
# Cor de fundo de abas fixadas não selecionadas
c.colors.tabs.pinned.odd.bg = '#000000'
c.colors.tabs.pinned.even.bg = '#000000'
# Cor de fundo de abas fixadas selecionadas
c.colors.tabs.pinned.selected.odd.bg = '#333333'
c.colors.tabs.pinned.selected.even.bg = '#333333'
# Cor das fontes de abas não selecionadas
c.colors.tabs.even.fg = '#ffffff'
c.colors.tabs.odd.fg = '#ffffff'
c.colors.tabs.pinned.even.fg = '#ffffff'
c.colors.tabs.pinned.odd.fg = '#ffffff'
# Cor das fontes de abas selecionadas
c.colors.tabs.pinned.selected.odd.fg = '#ffffff'
c.colors.tabs.pinned.selected.even.fg = '#ffffff'
c.colors.tabs.selected.even.fg = '#ffffff'
c.colors.tabs.selected.odd.fg = '#ffffff'
# Cor da borda do texto selecionado na barra de compleção
c.colors.completion.item.selected.border.bottom = '#ffffff'
c.colors.completion.item.selected.border.top = '#ffffff'

# FONTES

# Fonte padrão
c.fonts.default_family = '"monospace"'
# Tamanho padrão das fontes
c.fonts.default_size = '14px'
# Fonte usada nas abas de completação de comandos.
c.fonts.completion.entry = '14px "monospace"'
# Fonte used for the debugging console.
c.fonts.debug_console = '14px "monospace"'
# Fonte usada nos prompts.
c.fonts.prompts = 'default_size "monospace"'
# Fonte usada na barra de status.
c.fonts.statusbar = '14px "monospace"'
```

### Tema escuro

-   [dark.css](https://github.com/LucasTavaresA/dotfiles/blob/main/.config/qutebrowser/styles/dark.css)

## Lf

Explorador de arquivos lf

- `~/.config/lf/lfrc`

```sh tangle:~/.config/lf/lfrc
# interpreter for shell commands
set shell sh

# set '-eu' options for shell commands
# These options are used to have safer shell commands. Option '-e' is used to
# exit on error and option '-u' is used to give error for unset variables.
# Option '-f' disables pathname expansion which can be useful when $f, $fs, and
# $fx variables contain names with '*' or '?' characters. However, this option
# is used selectively within individual commands as it can be limiting at
# times.
set shellopts '-eu'

# set internal field separator (IFS) to "\n" for shell commands
# This is useful to automatically split file names in $fs and $fx properly
# since default file separator used in these variables (i.e. 'filesep' option)
# is newline. You need to consider the values of these options and create your
# commands accordingly.
set ifs "\n"

set period 1

# arquivos ocultos
set hidden on

# ícones
set icons on

# informação mostrada do lado do arquivo
set info "size"

# previa de arquivos
set previewer lf-previewer
set cleaner lf-cleaner

# fração das abas
set ratios 1:2

set wrapscroll on

# informação no topo das abas
set promptfmt "\033[32;1m\033[0m\033[34;1m%d\033[0m\033[1m%f\033[0m"

# borda ao redor das abas
set drawbox on

# abre espaço na parte superior e inferior da tela
set scrolloff 0

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

# Atalhos
map gC cd ~/.config
map gcc cd ~/code/c
map gcs cd ~/code/shell
map gcS cd ~/code/csharp
map gcw cd ~/code/webPages
map gcu cd ~/code/unity

map gd cd ~/documentos
map gD cd ~/downloads
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
