# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103
# pylint: disable=C0111
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401
config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

# carregar o autoconfig.yml
config.load_autoconfig(False)

# Reinicia as stylesheets
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
config.set('content.fullscreen.window', False)
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
config.set("statusbar.show", "always")
config.set("tabs.show", "never")
# formatação dos títulos das abas
config.set("tabs.title.format", "{perc}{private}{current_title}")
# formatação de horários
config.set('completion.timestamp_format', '%A %d/%m/%Y - %H:%M')
# corretor ortográfico
config.set('spellcheck.languages', ["pt-BR", "en-US"])
# conteúdo da barra de status
config.set('statusbar.widgets', ["keypress", "url", "history", "progress"])
# posição da barra de status
config.set('statusbar.position', 'top')
c.tabs.position = "top"
# tamanho da barra de compleção
config.set('completion.height', '100%')
# editor
c.editor.command = ["term_open", "-a", "nvim", "nvim", "{}"]
# não mostra barra de downloads
config.set("downloads.remove_finished", 200)
# permite copiar/colar
config.set('content.javascript.clipboard', 'access-paste')

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
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2022.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2023.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/filters-2024.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badware.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/privacy.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/badlists.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/annoyances.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/resource-abuse.txt",
        "https://github.com/uBlockOrigin/uAssets/raw/master/filters/unbreak.txt"
        ]

# usa o terminal para mandar arquivos
config.set("fileselect.handler", "external")
config.set("fileselect.single_file.command", ["term_open", "-a", "float", "yazi", "--chooser-file", "{}"])
config.set("fileselect.multiple_files.command", ["term_open", "-a", "float", "yazi", "--chooser-file", "{}"])

# notificações.
config.set('content.notifications.enabled', True, 'https://www.youtube.com/*')
config.set('content.notifications.enabled', True, 'https://twitter.com/*')
config.set('content.notifications.enabled', True, 'https://x.com/*')
config.set('content.notifications.enabled', True, 'https://facebook.com/*')
config.set('content.notifications.enabled', True, 'https://www.reddit.com')
config.set('content.notifications.enabled', True, 'https://old.reddit.com')
config.set('content.notifications.enabled', False, 'https://www.infojobs.com.br')

# geolocalização
config.set('content.geolocation', False, 'https://www.google.com')

# desativa popup no gmail
config.set('content.register_protocol_handler', False, 'https://mail.google.com?extsrc=mailto&url=%25s')

#### Ferramentas de pesquisa ####
c.url.searchengines = {'DEFAULT': 'https://searx.be/search?q={}'
                    ,  'g':    'https://www.google.com/search?q={}'
                    ,  'al':   'https://anilist.co/search/anime?search={}&sort=SEARCH_MATCH'
                    ,  'ala':  'https://anilist.co/search/anime?search={}&sort=SEARCH_MATCH'
                    ,  'alm':  'https://anilist.co/search/manga?search={}&sort=SEARCH_MATCH'
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
                    ,  'x':    'https://x.com/search?q={}'
                    ,  'tg':   'https://trends.google.com.br/trends/explore?q={}'
                    ,  'ud':   'https://www.urbandictionary.com/define.php?term={}'
                    ,  'vn':   'https://vndb.org/v?sq={}'
                    ,  'wm':   'https://web.archive.org/web/*/{}'
                    ,  'yt':   'https://www.youtube.com/search?q={}'
                    ,  'ytm':   'https://music.youtube.com/search?q={}'
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
bindings = {
    "<Ctrl-Tab>": "tab-next",
    "<Ctrl-Left>": "tab-prev",
    "<Ctrl-Right>": "tab-next",
    "A": "cmd-set-text -s :back",
    "D": "cmd-set-text -s :forward",
    "<Ctrl-a>": "back",
    "<Ctrl-d>": "forward",
    "<Ctrl-j>": "scroll-page 0 0.5",
    "<Ctrl-k>": "scroll-page 0 -0.5",
    "u": "undo --window",
    # atalho para assistir link
    "qvw": "hint links spawn --detach mpv \
        --ytdl-format='worstvideo*[height=720]+worstaudio/worst[height=720]' \
        --cache=yes --demuxer-max-bytes=2048Kib --wayland-app-id=Picture-in-Picture \
        {hint-url}",
    "qsw": "hint links spawn --detach streamlink \
        -a '--wayland-app-id=Picture-in-Picture' {hint-url}",
    # baixar video
    "qvd": "hint links spawn --detach term_open -a float yt-dlp -P ~/Downloads \
        --write-subs -f 'worstvideo*[height=720]+worstaudio/worst[height=720]' \
        {hint-url}",
    # baixar imagem
    "qid": "hint images download",
    # baixar audio
    "qad": "hint links spawn --detach term_open -a float yt-dlp -x {hint-url}",
    # abre pagina no firefox
    "qf": "spawn --detach firefox {url}",
    # ativa/desativa a barra
    "qq": "config-cycle statusbar.show always never;; config-cycle tabs.show always never",
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
    # Copia url atual para um arquivo
    "yz": "spawn sh -c 'printf %s\\\\n \"$1\" >> ~/copied.txt' _ {url}",
    # ativa/desativa darkmode
    "qd": "config-cycle -p -u *://*.{url:host}/* colors.webpage.darkmode.enabled ;; spawn --userscript darkmode-cycle \"*://*.{url:host}/*\" ;; reload",
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
c.url.default_page = 'https://searx.be/'
c.url.start_pages = 'https://searx.be/'

#### CORES ####
# pedir modo escuro aos sites que o suportam
config.set('colors.webpage.preferred_color_scheme', 'dark')
config.set('colors.webpage.bg', 'black')
# colors.webpage.darkmode.algorithm
# lightness-cielab: Modify colors by converting them to CIELAB color space and inverting the L value. Not available with Qt < 5.14.
# lightness-hsl: Modify colors by converting them to the HSL color space and inverting the lightness (i.e. the "L" in HSL).
# brightness-rgb: Modify colors by subtracting each of r, g, and b from their maximum value.
config.set('colors.webpage.darkmode.algorithm', 'lightness-cielab')
config.set('colors.webpage.darkmode.enabled', False)


#### Fontes ####
# fonte padrão
c.fonts.default_family = '"Iosevka"'
# tamanho padrão das fontes
c.fonts.default_size = '14px'
# fonte usada nas abas de completação de comandos.
c.fonts.completion.entry = '14px "Iosevka"'
# fonte used for the debugging console.
c.fonts.debug_console = '14px "Iosevka"'
# fonte usada nos prompts.
c.fonts.prompts = 'default_size "Iosevka"'
# fonte usada na barra de status.
c.fonts.statusbar = '14px "Iosevka"'

#### Javascript ####
config.set('content.javascript.enabled', True, '*://*.10.0.0.2/*')
config.set('content.javascript.enabled', True, '*://*.127.0.0.1/*')
config.set('content.javascript.enabled', True, '*://*.192.168.0.1/*')
config.set('content.javascript.enabled', True, '*://*.4pda-to.translate.goog/*')
config.set('content.javascript.enabled', True, '*://*.4pda.to/*')
config.set('content.javascript.enabled', True, '*://*.about.gitlab.com/*')
config.set('content.javascript.enabled', True, '*://*.accounts.google.com/*')
config.set('content.javascript.enabled', True, '*://*.gds.google.com/*')
config.set('content.javascript.enabled', True, '*://*.accounts.reddit.com/*')
config.set('content.javascript.enabled', True, '*://*.accounts.spotify.com/*')
config.set('content.javascript.enabled', True, '*://*.anilist.co/*')
config.set('content.javascript.enabled', True, '*://*.anbient.com/*')
config.set('content.javascript.enabled', True, '*://*.anihub.tv/*')
config.set('content.javascript.enabled', True, '*://*.aokp.co/*')
config.set('content.javascript.enabled', True, '*://*.api.soundcloud.com/*')
config.set('content.javascript.enabled', True, '*://*.app.bountysource.com/*')
config.set('content.javascript.enabled', True, '*://*.appimage.github.io/*')
config.set('content.javascript.enabled', True, '*://*.appimage.org/*')
config.set('content.javascript.enabled', True, '*://*.archive.org/*')
config.set('content.javascript.enabled', True, '*://*.asciinema.org/*')
config.set('content.javascript.enabled', True, '*://*.askubuntu.com/*')
config.set('content.javascript.enabled', True, '*://*.atom.io/*')
config.set('content.javascript.enabled', True, '*://*.avaliacaoemonitoramentosaopaulo.caeddigital.net/*')
config.set('content.javascript.enabled', True, '*://*.bitbucket.org/*')
config.set('content.javascript.enabled', True, '*://*.border-radius.com/*')
config.set('content.javascript.enabled', True, '*://*.boyan01.github.io/*')
config.set('content.javascript.enabled', True, '*://*.br.indeed.com/*')
config.set('content.javascript.enabled', True, '*://*.br.pinterest.com/*')
config.set('content.javascript.enabled', True, '*://*.bugs.chromium.org/*')
config.set('content.javascript.enabled', True, '*://*.bugzilla.mozilla.org/*')
config.set('content.javascript.enabled', True, '*://*.camo.githubusercontent.com/*')
config.set('content.javascript.enabled', True, '*://*.careers.microsoft.com/*')
config.set('content.javascript.enabled', True, '*://*.celpa.conao3.com/*')
config.set('content.javascript.enabled', True, '*://*.celspeak.leonardoalves.dev/*')
config.set('content.javascript.enabled', True, '*://*.codeberg.org/*')
config.set('content.javascript.enabled', True, '*://*.codepen.io/*')
config.set('content.javascript.enabled', True, '*://*.codereview.qt-project.org/*')
config.set('content.javascript.enabled', True, '*://*.codevion.github.io/*')
config.set('content.javascript.enabled', True, '*://*.community.e.foundation/*')
config.set('content.javascript.enabled', True, '*://*.console.cloud.google.com/*')
config.set('content.javascript.enabled', True, '*://*.coveryourtracks.eff.org/*')
config.set('content.javascript.enabled', True, '*://*.crates.io/*')
config.set('content.javascript.enabled', True, '*://*.cs.github.com/*')
config.set('content.javascript.enabled', True, '*://*.curiositystream.com/*')
config.set('content.javascript.enabled', True, '*://*.dashboard.twitch.tv/*')
config.set('content.javascript.enabled', True, '*://*.devdrive.cloud/*')
config.set('content.javascript.enabled', True, '*://*.diffy.org/*')
config.set('content.javascript.enabled', True, '*://*.discord.com/*')
config.set('content.javascript.enabled', True, '*://*.discourse.doomemacs.org/*')
config.set('content.javascript.enabled', True, '*://*.distrochooser.de/*')
config.set('content.javascript.enabled', True, '*://*.doc.e.foundation/*')
config.set('content.javascript.enabled', True, '*://*.docplayer.net/*')
config.set('content.javascript.enabled', True, '*://*.docs.microsoft.com/*')
config.set('content.javascript.enabled', True, '*://*.docs.projectile.mx/*')
config.set('content.javascript.enabled', True, '*://*.docs.voidlinux.org/*')
config.set('content.javascript.enabled', True, '*://*.docs.yt-dlp.org/*')
config.set('content.javascript.enabled', True, '*://*.downdetector.com.br/*')
config.set('content.javascript.enabled', True, '*://*.draculatheme.com/*')
config.set('content.javascript.enabled', True, '*://*.drive.google.com/*')
config.set('content.javascript.enabled', False, '*://*.dwm.suckless.org/*')
config.set('content.javascript.enabled', True, '*://*.e.foundation/*')
config.set('content.javascript.enabled', True, '*://*.elite.fansubs.com.br/*')
config.set('content.javascript.enabled', True, '*://*.elpa.gnu.org/*')
config.set('content.javascript.enabled', True, '*://*.emacs-china.org/*')
config.set('content.javascript.enabled', True, '*://*.emacs-lsp.github.io/*')
config.set('content.javascript.enabled', True, '*://*.emacs.stackexchange.com/*')
config.set('content.javascript.enabled', True, '*://*.endeavouros.com/*')
config.set('content.javascript.enabled', True, '*://*.evilmartians.com/*')
config.set('content.javascript.enabled', True, '*://*.explainshell.com/*')
config.set('content.javascript.enabled', True, '*://*.feverdreamjohnny.itch.io/*')
config.set('content.javascript.enabled', True, '*://*.files.catbox.moe/*')
config.set('content.javascript.enabled', True, '*://*.flathub.org/*')
config.set('content.javascript.enabled', True, '*://*.fontawesome.com/*')
config.set('content.javascript.enabled', True, '*://*.fonts.google.com/*')
config.set('content.javascript.enabled', True, '*://*.forums.freebsd.org/*')
config.set('content.javascript.enabled', True, '*://*.frakon98.tumblr.com/*')
config.set('content.javascript.enabled', True, '*://*.framatube.org/*')
config.set('content.javascript.enabled', True, '*://*.gamejolt.com/*')
config.set('content.javascript.enabled', True, '*://*.ghostbsd.org/*')
config.set('content.javascript.enabled', True, '*://*.git.coolaj86.com/*')
config.set('content.javascript.enabled', True, '*://*.git.prolix.live/*')
config.set('content.javascript.enabled', True, '*://*.git.pwmt.org/*')
config.set('content.javascript.enabled', True, '*://*.git.redxen.eu/*')
config.set('content.javascript.enabled', True, '*://*.gitea.petton.fr/*')
config.set('content.javascript.enabled', True, '*://*.githistory.xyz/*')
config.set('content.javascript.enabled', True, '*://*.github.com/*')
config.set('content.javascript.enabled', True, '*://*.gitlab.archlinux.org/*')
config.set('content.javascript.enabled', True, '*://*.gitlab.com/*')
config.set('content.javascript.enabled', True, '*://*.gitlab.common-lisp.net/*')
config.set('content.javascript.enabled', True, '*://*.gitlab.e.foundation/*')
config.set('content.javascript.enabled', True, '*://*.gitlab.freedesktop.org/*')
config.set('content.javascript.enabled', True, '*://*.glot.io/*')
config.set('content.javascript.enabled', True, '*://*.gofile.io/*')
config.set('content.javascript.enabled', True, '*://*.hexchat.readthedocs.io/*')
config.set('content.javascript.enabled', True, '*://*.hikari.acmelabs.space/*')
config.set('content.javascript.enabled', True, '*://*.i3wm.org/*')
config.set('content.javascript.enabled', True, '*://*.imgur.com/*')
config.set('content.javascript.enabled', True, '*://*.informatica.mercadolivre.com.br/*')
config.set('content.javascript.enabled', True, '*://*.itch.io/*')
config.set('content.javascript.enabled', True, '*://*.joinpeertube.org/*')
config.set('content.javascript.enabled', True, '*://*.kakoune.org/*')
config.set('content.javascript.enabled', True, '*://*.kiwiirc.com/*')
config.set('content.javascript.enabled', True, '*://*.knowyourmeme.com/*')
config.set('content.javascript.enabled', True, '*://*.languagetool.org/*')
config.set('content.javascript.enabled', True, '*://*.larbs.xyz/*')
config.set('content.javascript.enabled', True, '*://*.lbrynomics.com/*')
config.set('content.javascript.enabled', True, '*://*.leetcode.com/*')
config.set('content.javascript.enabled', True, '*://*.liberapay.com/*')
config.set('content.javascript.enabled', True, '*://*.librespeed.org/*')
config.set('content.javascript.enabled', True, '*://*.lidarr.audio/*')
config.set('content.javascript.enabled', True, '*://*.ligurio.github.io/*')
config.set('content.javascript.enabled', True, '*://*.linuxcontainers.org/*')
config.set('content.javascript.enabled', True, '*://*.linuxmint.com/*')
config.set('content.javascript.enabled', True, '*://*.lista.mercadolivre.com.br/*')
config.set('content.javascript.enabled', True, '*://*.localhost/*')
config.set('content.javascript.enabled', True, '*://*.login.infojobs.com.br/*')
config.set('content.javascript.enabled', True, '*://*.login.linode.com/*')
config.set('content.javascript.enabled', True, '*://*.lucastavaresa.github.io/*')
config.set('content.javascript.enabled', True, '*://*.lukesmith.xyz/*')
config.set('content.javascript.enabled', True, '*://*.m5.apply.indeed.com/*')
config.set('content.javascript.enabled', True, '*://*.magit.vc/*')
config.set('content.javascript.enabled', True, '*://*.mail.google.com/*')
config.set('content.javascript.enabled', True, '*://*.man.archlinux.org/*')
config.set('content.javascript.enabled', True, '*://*.mangadex.org/*')
config.set('content.javascript.enabled', True, '*://*.manjaro.org/*')
config.set('content.javascript.enabled', True, '*://*.markdown-it.github.io/*')
config.set('content.javascript.enabled', True, '*://*.markdownlivepreview.com/*')
config.set('content.javascript.enabled', True, '*://*.marketplace.visualstudio.com/*')
config.set('content.javascript.enabled', True, '*://*.mathsbot.com/*')
config.set('content.javascript.enabled', True, '*://*.mega.io/*')
config.set('content.javascript.enabled', True, '*://*.mega.nz/*')
config.set('content.javascript.enabled', True, '*://*.melpa.org/*')
config.set('content.javascript.enabled', True, '*://*.messages.indeed.com/*')
config.set('content.javascript.enabled', True, '*://*.mswift42.github.io/*')
config.set('content.javascript.enabled', True, '*://*.murena.io/*')
config.set('content.javascript.enabled', True, '*://*.my-take-on.tech/*')
config.set('content.javascript.enabled', True, '*://*.my.indeed.com/*')
config.set('content.javascript.enabled', True, '*://*.myaccount.google.com/*')
config.set('content.javascript.enabled', True, '*://*.myanimelist.net/*')
config.set('content.javascript.enabled', True, '*://*.myvideogamelist.com/*')
config.set('content.javascript.enabled', True, '*://*.nebula.app/*')
config.set('content.javascript.enabled', True, '*://*.nixos.org/*')
config.set('content.javascript.enabled', True, '*://*.oddgiant.itch.io/*')
config.set('content.javascript.enabled', True, '*://*.odysee.com/*')
config.set('content.javascript.enabled', True, '*://*.omnirom.org/*')
config.set('content.javascript.enabled', True, '*://*.open.spotify.com/*')
config.set('content.javascript.enabled', True, '*://*.osowoso.github.io/*')
config.set('content.javascript.enabled', True, '*://*.pages.linode.com/*')
config.set('content.javascript.enabled', True, '*://*.paranoidandroid.co/*')
config.set('content.javascript.enabled', True, '*://*.pastebin.com/*')
config.set('content.javascript.enabled', True, '*://*.pasteboard.co/*')
config.set('content.javascript.enabled', True, '*://*.pdfjs/*')
config.set('content.javascript.enabled', True, '*://*.pingus.seul.org/*')
config.set('content.javascript.enabled', True, '*://*.pixeldrain.com/*')
config.set('content.javascript.enabled', True, '*://*.pkg.go.dev/*')
config.set('content.javascript.enabled', True, '*://*.pkgs.org/*')
config.set('content.javascript.enabled', True, '*://*.planet.emacsen.org/*')
config.set('content.javascript.enabled', True, '*://*.play.google.com/*')
config.set('content.javascript.enabled', True, '*://*.pop.system76.com/*')
config.set('content.javascript.enabled', True, '*://*.postmarketos.org/*')
config.set('content.javascript.enabled', True, '*://*.primer.style/*')
config.set('content.javascript.enabled', True, '*://*.primerlearning.org/*')
config.set('content.javascript.enabled', True, '*://*.protesilaos.com/*')
config.set('content.javascript.enabled', True, '*://*.raylib.com/*')
config.set('content.javascript.enabled', True, '*://*.archlinux.org/*')
config.set('content.javascript.enabled', True, '*://*.reactos.org/*')
config.set('content.javascript.enabled', True, '*://*.regex101.com/*')
config.set('content.javascript.enabled', True, '*://*.regexr.com/*')
config.set('content.javascript.enabled', True, '*://*.rokfin.com/*')
config.set('content.javascript.enabled', True, '*://*.rust-analyzer.github.io/*')
config.set('content.javascript.enabled', True, '*://*.salsa.debian.org/*')
config.set('content.javascript.enabled', True, '*://*.sanemacs.com/*')
config.set('content.javascript.enabled', True, '*://*.saucenao.com/*')
config.set('content.javascript.enabled', True, '*://*.sawfish.fandom.com/*')
config.set('content.javascript.enabled', True, '*://*.scapub.sbe.sptrans.com.br/*')
config.set('content.javascript.enabled', True, '*://*.secure.indeed.com/*')
config.set('content.javascript.enabled', True, '*://*.secure.rokfin.com/*')
config.set('content.javascript.enabled', True, '*://*.sed.educacao.sp.gov.br/*')
config.set('content.javascript.enabled', True, '*://*.serverfault.com/*')
config.set('content.javascript.enabled', True, '*://*.site.vagas.com.br/*')
config.set('content.javascript.enabled', True, '*://*.sites.google.com/*')
config.set('content.javascript.enabled', True, '*://*.soundcloud.com/*')
config.set('content.javascript.enabled', True, '*://*.stackoverflow.com/*')
config.set('content.javascript.enabled', True, '*://*.store.epicgames.com/*')
config.set('content.javascript.enabled', True, '*://*.store.kde.org/*')
config.set('content.javascript.enabled', True, '*://*.store.steampowered.com/*')
config.set('content.javascript.enabled', True, '*://*.superuser.com/*')
config.set('content.javascript.enabled', True, '*://*.support.google.com/*')
config.set('content.javascript.enabled', True, '*://*.sxmo.org/*')
config.set('content.javascript.enabled', True, '*://*.systemcrafters.cc/*')
config.set('content.javascript.enabled', True, '*://*.systemcrafters.net/*')
config.set('content.javascript.enabled', True, '*://*.szeged.github.io/*')
config.set('content.javascript.enabled', True, '*://*.take.indeedassessments.com/*')
config.set('content.javascript.enabled', True, '*://*.takeout.google.com/*')
config.set('content.javascript.enabled', True, '*://*.temp-mail.org/*')
config.set('content.javascript.enabled', True, '*://*.tiermaker.com/*')
config.set('content.javascript.enabled', True, '*://*.tracker.uniotaku.com/*')
config.set('content.javascript.enabled', True, '*://*.translate.google.com/*')
config.set('content.javascript.enabled', True, '*://*.trends.google.com.br/*')
config.set('content.javascript.enabled', True, '*://*.tsoding.org/*')
config.set('content.javascript.enabled', True, '*://*.twitter.com/*')
config.set('content.javascript.enabled', True, '*://x.com/*')
config.set('content.javascript.enabled', True, '*://*.typeof.net/*')
config.set('content.javascript.enabled', True, '*://*.unix.stackexchange.com/*')
config.set('content.javascript.enabled', True, '*://*.vancedapp.com/*')
config.set('content.javascript.enabled', True, '*://*.vi.stackexchange.com/*')
config.set('content.javascript.enabled', True, '*://*.vim-bootstrap.com/*')
config.set('content.javascript.enabled', True, '*://*.vimawesome.com/*')
config.set('content.javascript.enabled', True, '*://*.vimeo.com/*')
config.set('content.javascript.enabled', True, '*://*.vimvalley.com/*')
config.set('content.javascript.enabled', True, '*://*.vita3k.org/*')
config.set('content.javascript.enabled', True, '*://*.vndb.org/*')
config.set('content.javascript.enabled', True, '*://*.vocaroo.com/*')
config.set('content.javascript.enabled', True, '*://*.vorillaz.github.io/*')
config.set('content.javascript.enabled', True, '*://*.waydro.id/*')
config.set('content.javascript.enabled', True, '*://*.web.archive.org/*')
config.set('content.javascript.enabled', True, '*://*.web.ciee.org.br/*')
config.set('content.javascript.enabled', True, '*://*.web.libera.chat/*')
config.set('content.javascript.enabled', True, '*://*.web.whatsapp.com/*')
config.set('content.javascript.enabled', True, '*://*.www.acer.com/*')
config.set('content.javascript.enabled', True, '*://*.www.animestc.net/*')
config.set('content.javascript.enabled', True, '*://*.www.appimagehub.com/*')
config.set('content.javascript.enabled', True, '*://*.www.cpu-world.com/*')
config.set('content.javascript.enabled', True, '*://*.www.craiyon.com/*')
config.set('content.javascript.enabled', True, '*://*.www.crownengine.org/*')
config.set('content.javascript.enabled', True, '*://*.www.debian.org/*')
config.set('content.javascript.enabled', True, '*://*.www.diffchecker.com/*')
config.set('content.javascript.enabled', True, '*://*.www.dropbox.com/*')
config.set('content.javascript.enabled', True, '*://*.www.efset.org/*')
config.set('content.javascript.enabled', True, '*://*.www.empregos.com.br/*')
config.set('content.javascript.enabled', True, '*://*.www.epicgames.com/*')
config.set('content.javascript.enabled', True, '*://*.www.facebook.com/*')
config.set('content.javascript.enabled', True, '*://godbolt.org/*')
config.set('content.javascript.enabled', True, '*://*.www.flip.pt/*')
config.set('content.javascript.enabled', True, '*://*.www.freebsdsoftware.org/*')
config.set('content.javascript.enabled', True, '*://*.www.gnome-look.org/*')
config.set('content.javascript.enabled', True, '*://*.www.gnu.org/*')
config.set('content.javascript.enabled', True, '*://*.www.google.com.br/*')
config.set('content.javascript.enabled', True, '*://*.www.google.com/*')
config.set('content.javascript.enabled', True, '*://*.squig.link/*')
config.set('content.javascript.enabled', True, '*://*.searx.be/*')
config.set('content.javascript.enabled', True, '*://*.www.gov.br/*')
config.set('content.javascript.enabled', True, '*://*.www.howtogeek.com/*')
config.set('content.javascript.enabled', True, '*://*.www.ibm.com/*')
config.set('content.javascript.enabled', True, '*://*.www.ignboards.com/*')
config.set('content.javascript.enabled', True, '*://*.www.imdb.com/*')
config.set('content.javascript.enabled', True, '*://*.www.imei.info/*')
config.set('content.javascript.enabled', True, '*://*.www.infojobs.com.br/*')
config.set('content.javascript.enabled', True, '*://*.www.instagram.com/*')
config.set('content.javascript.enabled', True, '*://*.www.joypixels.com/*')
config.set('content.javascript.enabled', True, '*://*.www.jreg.co.in/*')
config.set('content.javascript.enabled', True, '*://*.www.linkedin.com/*')
config.set('content.javascript.enabled', True, '*://*.www.mangaupdates.com/*')
config.set('content.javascript.enabled', True, '*://*.www.microsoft.com/*')
config.set('content.javascript.enabled', True, '*://*.learn.microsoft.com/*')
config.set('content.javascript.enabled', True, '*://*.www.midnightbsd.org/*')
config.set('content.javascript.enabled', True, '*://*.www.nerdfonts.com/*')
config.set('content.javascript.enabled', True, '*://*.www.netbsd.se/*')
config.set('content.javascript.enabled', True, '*://*.www.nube.com.br/*')
config.set('content.javascript.enabled', True, '*://*.www.nuget.org/*')
config.set('content.javascript.enabled', True, '*://*.www.nvidia.com.br/*')
config.set('content.javascript.enabled', True, '*://*.www.nvidia.com/*')
config.set('content.javascript.enabled', True, '*://*.www.orgroam.com/*')
config.set('content.javascript.enabled', True, '*://*.www.pcgamer.com/*')
config.set('content.javascript.enabled', True, '*://*.www.pling.com/*')
config.set('content.javascript.enabled', True, '*://*.www.pluralsight.com/*')
config.set('content.javascript.enabled', True, '*://*.www.qt.io/*')
config.set('content.javascript.enabled', True, '*://*.www.quora.com/*')
config.set('content.javascript.enabled', True, '*://*.www.qutebrowser.org/*')
config.set('content.javascript.enabled', True, '*://*.reddit.com/*')
config.set('content.javascript.enabled', True, '*://*.www.rokfin.com/*')
config.set('content.javascript.enabled', True, '*://*.www.shells.com/*')
config.set('content.javascript.enabled', True, '*://*.www.spacemacs.org/*')
config.set('content.javascript.enabled', True, '*://*.www.speedtest.net/*')
config.set('content.javascript.enabled', True, '*://*.www.systemrequirementslab.com/*')
config.set('content.javascript.enabled', True, '*://*.www.twitch.tv/*')
config.set('content.javascript.enabled', True, '*://*.www.vagas.com.br/*')
config.set('content.javascript.enabled', True, '*://*.www.vim.org/*')
config.set('content.javascript.enabled', True, '*://*.www.whonix.org/*')
config.set('content.javascript.enabled', True, '*://*.www.xfce-look.org/*')
config.set('content.javascript.enabled', True, '*://*.youtube.com/*')
config.set('content.javascript.enabled', True, '*://*.xplr.dev/*')
config.set('content.javascript.enabled', True, '*://*.chat.openai.com/*')
config.set('content.javascript.enabled', True, '*://*.chatgpt.com/*')

config.set('colors.webpage.darkmode.enabled', True, '*://*.herbstluftwm.org/*')
config.set('colors.webpage.darkmode.enabled', True, '*://*.searx.be/*')
