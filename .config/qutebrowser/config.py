# carregar o autoconfig.yml
config.load_autoconfig()

# Reinicia as stylecheets
import subprocess
subprocess.call(['python3', '.config/qutebrowser/userscripts/rebuild-qutebrowser-grease-styles.py'])

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
# abre abas como janelas
config.set("tabs.tabs_are_windows", True)
# salva a sessão automaticamente
config.set('auto_save.session', True)
# não sai do modo de inserção automaticamente
config.set('input.insert_mode.auto_leave', True)
config.set('input.insert_mode.leave_on_load', True)
# o que fazer caso a ultima pagina seja fechada
config.set("tabs.last_close", "ignore")
# confirma antes de sair
config.set('confirm_quit', ["multiple-tabs"])
# muda ordem do menu de compleção
config.set("completion.open_categories", ["bookmarks", "history", "filesystem"])
# vídeos não tocam automaticamente
config.set("content.autoplay", False)
# mostra a barra de scroll quando procurando uma palavra
config.set('scrolling.bar', 'overlay')
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
c.editor.command = ["emacsclient", "-c", "-a", "'term_open nvim'", "{}"]

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
config.set("fileselect.single_file.command", ["term_open", "-a", "float", "lf", "-selection-path", "{}"])
config.set("fileselect.multiple_files.command", ["term_open", "-a", "float", "lf", "-selection-path", "{}"])

# permitir notificações.
config.set('content.notifications.enabled', True, 'https://www.youtube.com/*')
config.set('content.notifications.enabled', True, 'https://twitter.com/*')
config.set('content.notifications.enabled', True, 'https://facebook.com/*')

#### Ferramentas de pesquisa ####
c.url.searchengines = {'DEFAULT': 'https://www.google.com/search?q={}'
                    ,  'alm':  'https://anilist.co/search/manga?search={}&sort=SEARCH_MATCH'
                    ,  'al':   'https://anilist.co/search/anime?search={}&sort=SEARCH_MATCH'
                    ,  'aur':  'https://aur.archlinux.org/packages?O=0&SeB=nd&K={}&outdated=&SB=p&SO=d&PP=50&submit=Go'
                    ,  'aw':   'https://wiki.archlinux.org/index.php?search={}'
                    ,  'br':   'https://brainly.com.br/app/ask?q={}'
                    ,  'fp':   'https://www.freshports.org/search.php?query={}&search=go&num=10&stype=name&method=match&deleted=excludedeleted&start=1&casesensitivity=caseinsensitive'
                    ,  'gf':   'https://greasyfork.org/en/scripts?q={}'
                    ,  'gh':   'https://github.com/search?q={}'
                    ,  'gl':   'https://gitlab.com/search?search={}'
                    ,  'gm':   'https://www.google.com.br/maps/search/{}'
                    ,  'gt':   'https://translate.google.com/?sl=auto&tl=en&text={}'
                    ,  'imdb': 'https://www.imdb.com/find?q={}&ref_=nv_sr_sm'
                    ,  'md':   'https://mangadex.org/titles?page=1&q={}&order=relevance.desc'
                    ,  'od':   'https://odysee.com/search?q={}'
                    ,  'r':    'https://www.reddit.com/search/?q={}'
                    ,  'sc':   'https://soundcloud.com/search?q={}'
                    ,  'se':   'https://stackexchange.com/search?q={}'
                    ,  'sf':   'https://sourceforge.net/directory/?q={}'
                    ,  'tw':   'https://twitter.com/search?q={}'
                    ,  'tg':   'https://trends.google.com.br/trends/explore?q={}'
                    ,  'ud':   'https://www.urbandictionary.com/define.php?term={}'
                    ,  'vn':   'https://vndb.org/v?sq={}'
                    ,  'wm':   'https://web.archive.org/web/*/{}'
                    ,  'yt':   'https://www.youtube.com/results?search_query={}'
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

config.bind("<Up>", "move-to-prev-line", mode='caret')
config.bind("<Down>", "move-to-next-line", mode='caret')
config.bind("<Left>", "move-to-prev-char", mode='caret')
config.bind("<Right>", "move-to-next-char", mode='caret')
# previne bug https://github.com/qutebrowser/qutebrowser/issues/2236
config.bind('o', 'set statusbar.show always;; set-cmd-text -s :open')
config.bind('O', 'set statusbar.show always;; set-cmd-text -s :open -t')
config.bind(':', 'set statusbar.show always;; set-cmd-text :')
config.bind('<Escape>', 'mode-enter normal;; set statusbar.show in-mode', mode='command')
config.bind('<Return>', 'command-accept;; set statusbar.show in-mode', mode='command')
config.bind('/', 'set statusbar.show always;; set-cmd-text /')
bindings = {
    "<Ctrl-Tab>": "tab-next",
    "<Ctrl-Left>": "tab-prev",
    "<Ctrl-Right>": "tab-next",
    "<Ctrl-a>": "back",
    "<Ctrl-d>": "forward",
    "u": "undo --window",
    # atalho para assistir link com mpv
    "qvw": "hint links spawn mpv {hint-url}",
    # baixar como video
    "qvd": "hint links spawn term_open -a float yt {hint-url}",
    # baixar imagem selecionada
    "qid": "hint images download",
    # baixar como audio
    "qad": "hint links spawn term_open -a float yta {hint-url}",
    # abre no firefox
    "qf": "hint links spawn firefox {url}",
    # ativa/desativa a barra
    "qq": "config-cycle statusbar.show always in-mode;; config-cycle tabs.show always switching",
    # ativa/desativa tema escuro
    "qd": "config-cycle content.user_stylesheets ~/.config/qutebrowser/styles/dark.css ~/.config/qutebrowser/styles/custom-solarized-dark.css",
    # ativa/desativa javascript para um site
    "qj": "config-cycle -p -u *://*.{url:host}/* content.javascript.enabled ;; reload",
    # ativa/desativa adblocking para um site
    "qb": "config-cycle -p -u *://*.{url:host}/* content.blocking.enabled ;; reload",
    # modo leitura
    "qr": "spawn --userscript readability",
    # traduz a pagina
    "tp": "spawn --userscript translate",
    # traduz o texto selecionado no google translate
    "tt": "spawn --userscript translate --text",
    # traduz o texto selecionado em uma notificação
    # dependencias: translate-shell
    "ts":"spawn --userscript qute_translate",
    # pop-up com tradução do japonês
    # dependencias: pyqt5, python-xlib, wheel, jamdict, jamdict-data
    "tj": "spawn --userscript yomichad --no-kanji",
    # copia links
    "cl": "hint links yank",
    # copia trechos de código
    "cc": "hint code userscript code_select.py",
    # copia links para um arquivo
    "z": "hint links spawn sh -c 'printf %s\\\\n \"$1\" >> ~/copied.txt' _ {hint-url}",
}

for key, bind in bindings.items():
    config.bind(key, bind)

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
c.colors.tabs.selected.odd.bg = '#000000'
c.colors.tabs.selected.even.bg = '#000000'
# cor de fundo de abas fixadas não selecionadas
c.colors.tabs.pinned.odd.bg = '#000000'
c.colors.tabs.pinned.even.bg = '#000000'
# cor de fundo de abas fixadas selecionadas
c.colors.tabs.pinned.selected.odd.bg = '#000000'
c.colors.tabs.pinned.selected.even.bg = '#000000'
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
c.fonts.default_family = '"Terminus"'
# tamanho padrão das fontes
c.fonts.default_size = '16px'
# fonte usada nas abas de completação de comandos.
c.fonts.completion.entry = '16px "Terminus"'
# fonte used for the debugging console.
c.fonts.debug_console = '16px "Terminus"'
# fonte usada nos prompts.
c.fonts.prompts = 'default_size "Terminus"'
# fonte usada na barra de status.
c.fonts.statusbar = '16px "Terminus"'
