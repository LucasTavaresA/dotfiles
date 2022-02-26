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

# Carregar o autoconfig.yml
config.load_autoconfig(True)

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
config.set("completion.open_categories", ["searchengines", "quickmarks", "bookmarks", "history", "filesystem"])

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
c.editor.command = ['st', '-e','nvim', '{}']

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
config.unbind('<Shift-H>')
config.unbind('<Shift-L>')

config.bind('<Ctrl-Tab>', 'tab-next')
config.bind('<Ctrl-Left>', 'tab-prev')
config.bind('<Ctrl-Right>', 'tab-next')
config.bind('<Ctrl-a>', 'back')
config.bind('<Ctrl-d>', 'forward')
config.bind('u', 'undo --window')
config.bind('zx', 'config-cycle statusbar.show always in-mode;; config-cycle tabs.show always switching')
# Atalho para assistir link com mpv
config.bind('zp', 'hint links spawn mpv {hint-url}')
# Baixar imagem selecionada
config.bind('zi', 'hint images download')
# Baixar como video
config.bind('zv', 'hint links spawn st -c st_download -e yt {hint-url}')
# Baixar como audio
config.bind('za', 'hint links spawn st -c st_download -e yta {hint-url}')
# Abre no firefox
config.bind('zf', 'hint links spawn firefox {url}')
# Ativa/Desativa tema escuro
config.bind('zd', 'config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/dark.css ""')
# Ativa/Desativa javascript para um site
config.bind('zj', 'config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload')
# Ativa/Desativa adblocking para um site
config.bind('zb', 'config-cycle -p -u *://*.{url:host}/* content.blocking.enabled ;; reload')
# Traduz a pagina
config.bind('ztp', 'spawn --userscript translate')
# Traduz o texto selecionado
config.bind('zts', 'spawn --userscript translate --text')
# Modo leitura
config.bind('zl', 'spawn --userscript readability')
# Copia links
config.bind('zc', 'hint links yank')
# Copia trechos de codigo
config.bind('zC', 'hint code userscript code_select.py')
c.hints.selectors["code"] = [
    # Seleciona code tags onde o parente nao é uma tag pre
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
c.colors.completion.item.selected.fg = '#ffffff'
# Cor de fundo de texto selecionado na barra de compleção
c.colors.completion.item.selected.bg = '#555555'
# Cor do texto procurado quando selecionado na barra de compleção
c.colors.completion.item.selected.match.fg = '#ffff00'
# Cor de texto procurado na aba de compleção.
c.colors.completion.match.fg = '#ffff00'
# Cor da barra de scroll na aba de compleção
c.colors.completion.scrollbar.fg = '#555555'
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
c.colors.hints.match.fg = '#ffff00'
# Cor de fundo de informações importantes
c.colors.messages.info.bg = '#222222'
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
c.colors.statusbar.url.warn.fg = '#ffff00'
# Cor de fundo da barra de abas abertas
c.colors.tabs.bar.bg = '#000000'
# Cor de fundo de abas deselecionadas
c.colors.tabs.odd.bg = '#000000'
c.colors.tabs.even.bg = '#000000'
# Cor de fundo de abas selecionadas
c.colors.tabs.selected.odd.bg = '#555555'
c.colors.tabs.selected.even.bg = '#555555'
# Cor de fundo de abas fixadas deselecionadas
c.colors.tabs.pinned.odd.bg = '#000000'
c.colors.tabs.pinned.even.bg = '#000000'
# Cor de fundo de abas fixadas selecionadas
c.colors.tabs.pinned.selected.odd.bg = '#555555'
c.colors.tabs.pinned.selected.even.bg = '#555555'
# Cor da borda do texto selecionado na barra de compleção
c.colors.completion.item.selected.border.bottom = '#555555'
c.colors.completion.item.selected.border.top = '#555555'

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
