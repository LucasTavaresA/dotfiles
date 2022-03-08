# Extras

Configurações menos importantes

Blocos de código são salvos em seus arquivos usando [md-tangle](https://github.com/joakimmj/md-tangle)

## Sumario

-   [Ncmpcpp](#ncmpcpp)
    -   [Configuração](#configuração)
    -   [Teclas](#teclas)
-   [Mpd](#mpd)
-   [Handlr](#handlr)
-   [Mimetypes](#mimetypes)
-   [.gitignore](#gitignore)
-   [Starship](#starship)
-   [Picom](#picom)
-   [Zathura](#zathura)
-   [Gtk](#gtk)
    -   [Gtk 2](#gtk-2)
    -   [Gtk 3](#gtk-3)
-   [Dunst](#dunst)
-   [Bspwm](#bspwm)
-   [Paru](#paru)
-   [Npm](#npm)

## Ncmpcpp

Player de musica

### Configuração

- `~/.config/ncmpcpp/config`

```conf tangle:~/.config/ncmpcpp/config
# vim: filetype=conf

ncmpcpp_directory = "~/.config/ncmpcpp"
lyrics_directory = "~/.local/share/lyrics"
mpd_music_dir = "~/media/musicas"
message_delay_time = "1"
playlist_display_mode = classic
browser_display_mode = classic
progressbar_look = "━🬋-"
media_library_primary_tag = album_artist
media_library_albums_split_by_date = no
startup_screen = "playlist"
display_volume_level = no
ignore_leading_the = yes
external_editor = nvim
use_console_editor = yes
empty_tag_color = cyan
main_window_color = white
progressbar_color = white
progressbar_elapsed_color = white:b
statusbar_color = white
statusbar_time_color = white:b
cyclic_scrolling = yes
mouse_support = no
song_list_format = {$8%f$9}$R{$3%l$9}
song_status_format = {%f}
song_library_format = {%f}
alternative_header_first_line_format = {%f} $1$atqq$/a$9$/b
alternative_header_second_line_format = {%D}
current_item_prefix = $(white)$r
current_item_suffix = $/r$(end)
current_item_inactive_column_prefix = $(cyan)$r
current_item_inactive_column_suffix = $/r$(end)
now_playing_prefix = $b
now_playing_suffix = $/b
browser_playlist_prefix = "$2playlist$9 "
selected_item_prefix = $6
selected_item_suffix = $9
modified_item_prefix = $3> $9
song_window_title_format = {%f}
browser_sort_mode = none
browser_sort_format = {%f} {%l}
song_columns_list_format = (50)[white]{f:Title} (7f)[white]{l}
```

### Teclas

- `~/.config/ncmpcpp/bindings`

```conf tangle:~/.config/ncmpcpp/bindings
def_key "home"
  move_home
def_key "end"
  move_end
def_key "right"
  enter_directory
def_key "enter"
  toggle_output
def_key "enter"
  run_action
def_key "enter"
  play_item
def_key "delete"
  delete_playlist_items
def_key "delete"
  delete_browser_items
def_key "delete"
  delete_stored_playlist
def_key "right"
  next_column
def_key "left"
  previous_column
def_key ":"
  execute_command
def_key "f1"
  show_help
def_key "p"
  stop
def_key "space"
  pause
def_key ">"
  next
def_key "<"
  previous
def_key "left"
  jump_to_parent_directory
def_key "right"
  seek_forward
def_key "left"
  seek_backward
def_key "e"
  edit_song
def_key "e"
  edit_library_tag
def_key "e"
  edit_library_album
def_key "e"
  edit_directory_name
def_key "e"
  edit_playlist_name
def_key "R"
  remove_selection
def_key "M"
  move_selected_items_to
def_key "A"
  add
def_key "S"
  save_playlist
def_key "z"
  toggle_interface
def_key "!"
  toggle_separators_between_albums
def_key "q"
  quit
def_key "f"
    find
def_key "u"
  update_database
def_key "delete"
  delete_playlist_items
```

## Mpd

Daemon player de musica

- `~/.config/mpd/mpd.conf`

```conf tangle:~/.config/mpd/mpd.conf
music_directory     "~/media/musicas"
playlist_directory  "~/.config/mpd/playlists"
db_file             "~/.config/mpd/database"
pid_file            "~/.config/mpd/pid"
state_file          "~/.config/mpd/state"

auto_update "yes"
bind_to_address "127.0.0.1"
restore_paused "yes"
max_output_buffer_size "16384"

audio_output {
    type "pulse"
    name "pulse"
}
```

## Handlr

Abre arquivos de acordo com o mimetype, substitui o **xdg-open**

- `~/.config/handlr/handlr.toml`

```toml tangle:~/.config/handlr/handlr.toml
enable_selector = true
selector = "dmenu -p 'Abrir com: '"
```

## Mimetypes

Tipos de arquivos e programa chamado para os abrir

- `~/.config/mimeapps.list`

```conf tangle:~/.config/mimeapps.list
[Added Associations]
x-scheme-handler/tg=userapp-Telegram Desktop-EJM1D1.desktop;
x-scheme-handler/magnet=transmission-gtk.desktop;
application/x.bittorrent=transmission-gtk.desktop;
audio/mp4=mpv.desktop;
audio/x-opus+ogg=mpv.desktop;
image/jpeg=nsxiv.desktop;
image/png=nsxiv.desktop;
inode/directory=lf.desktop;

[Default Applications]
application/javascript=nvim.desktop;
application/json=nvim.desktop;
application/ld+json=nvim.desktop;
application/msword=libreoffice-writer.desktop;
application/vnd.openxmlformats-officedocument.wordprocessingml.document=libreoffice-writer.dektop;
application/pdf=firefox.desktop;
application/vnd.ms-excel=libreoffice-calc.desktop;
application/vnd.ms-powerpoint=libreoffice-impress.desktop;
application/x-bittorrent=transmission-gtk.desktop;
audio/*=mpv.desktop;
image/*=nsxiv.desktop;
inode/directory=lf.desktop;
text/*=nvim.desktop;
text/markdown=geany.desktop;
video/*=mpv.desktop;
x-scheme-handler/tg=userapp-Telegram Desktop-EJM1D1.desktop;
x-scheme-handler/http=org.qutebrowser.qutebrowser.desktop;
x-scheme-handler/https=org.qutebrowser.qutebrowser.desktop;
x-scheme-handler/ftp=org.qutebrowser.qutebrowser.desktop;
x-scheme-handler/magnet=transmission-gtk.desktop;
application/x.bittorrent=transmission-gtk.desktop;
```

## .gitignore

Arquivos ignorados pelo git

- `~/.gitignore`

```gitignore tangle:~/.gitignore
.cache/
.config/cabal/
.config/coc/
.config/dconf/
.config/discord/
.config/emacs/
.config/doom/themes/
.config/doom/yasnippet-snippets/
.config/doom/init.el
.config/doom/packages.el
.config/doom/config.el
.config/galculator/
.config/GIMP/
.config/git/config
.config/libreoffice/
.config/mpd/
.config/ncmpcpp/error.log
.config/nitrogen/
.config/npm/
.config/pulse/
.config/qutebrowser/autoconfig.yml
.config/qutebrowser/bookmarks
.config/qutebrowser/quickmarks
.config/stumpwm/*log*
.config/transmission/
.config/VirtualBox/
.config/NuGet/
.config/nvim/plugins/
.config/nvim/plugin/
.config/shell/.zcompdump
.config/shell/history
.config/pam-gnupg
.gnupg/
.dotnet/
.local/
.mozilla/
.nuget/
.pki/
.ssh/
.templateengine/
code/
documentos/
Downloads/
jogos/
media/
mnt/
VirtualBox VMs/
bkp/
```

## Starship

Prompt de comandos

- `~/.config/starship/config.toml`

```toml tangle:~/.config/starship/config.toml
format = """
[┌┤](bold green) $directory$shell$status$git_status$username$hostname$cmd_duration$package$jobs$container[├](bold green)$fill
[└](bold green)$character"""

[character]
format = "$symbol"
success_symbol = "[](green)"
error_symbol = "[X](bold red)"

[shell]
unknown_indicator = "unknown shell"
zsh_indicator = ""
style = "white bold"
disabled = false # Ativa esse modulo

[time]
disabled = false # Ativa o relógio

[line_break]
disabled = true

[directory]
style = "bold #00ccFF"
truncation_length = 4
truncate_to_repo = false

[fill]
symbol = "─"
style = "bold green"
```

## Picom

Compositor

- `~/.config/picom/picom.conf`

```conf tangle:~/.config/picom/picom.conf
#################################
#             Shadows           #
#################################


# Enabled client-side shadows on windows. Note desktop windows
# (windows with '_NET_WM_WINDOW_TYPE_DESKTOP') never get shadow,
# unless explicitly requested using the wintypes option.
#
# shadow = false
shadow = true;

# The blur radius for shadows, in pixels. (defaults to 12)
# shadow-radius = 12
shadow-radius = 7;

# The opacity of shadows. (0.0 - 1.0, defaults to 0.75)
# shadow-opacity = .75

# The left offset for shadows, in pixels. (defaults to -15)
# shadow-offset-x = -15
shadow-offset-x = -7;

# The top offset for shadows, in pixels. (defaults to -15)
# shadow-offset-y = -15
shadow-offset-y = -7;

# Avoid drawing shadows on dock/panel windows. This option is deprecated,
# you should use the *wintypes* option in your config file instead.
#
# no-dock-shadow = false

# Don't draw shadows on drag-and-drop windows. This option is deprecated,
# you should use the *wintypes* option in your config file instead.
#
# no-dnd-shadow = false

# Red color value of shadow (0.0 - 1.0, defaults to 0).
# shadow-red = 0

# Green color value of shadow (0.0 - 1.0, defaults to 0).
# shadow-green = 0

# Blue color value of shadow (0.0 - 1.0, defaults to 0).
# shadow-blue = 0

# Do not paint shadows on shaped windows. Note shaped windows
# here means windows setting its shape through X Shape extension.
# Those using ARGB background is beyond our control.
# Deprecated, use
#   shadow-exclude = 'bounding_shaped'
# or
#   shadow-exclude = 'bounding_shaped && !rounded_corners'
# instead.
#
# shadow-ignore-shaped = ''

# Specify a list of conditions of windows that should have no shadow.
#
# examples:
#   shadow-exclude = "n:e:Notification";
#
# shadow-exclude = []
shadow-exclude = [
  "name = 'Notification'",
  "class_g = 'Conky'",
  "class_g ?= 'Notify-osd'",
  "class_g = 'Cairo-clock'",
  "_GTK_FRAME_EXTENTS@:c"
];

# Specify a X geometry that describes the region in which shadow should not
# be painted in, such as a dock window region. Use
#    shadow-exclude-reg = "x10+0+0"
# for example, if the 10 pixels on the bottom of the screen should not have shadows painted on.
#
# shadow-exclude-reg = ""

# Crop shadow of a window fully on a particular Xinerama screen to the screen.
# xinerama-shadow-crop = false


#################################
#           Fading              #
#################################


# Fade windows in/out when opening/closing and when opacity changes,
#  unless no-fading-openclose is used.
# fading = false
fading = true

# Opacity change between steps while fading in. (0.01 - 1.0, defaults to 0.028)
# fade-in-step = 0.028
fade-in-step = 0.03;

# Opacity change between steps while fading out. (0.01 - 1.0, defaults to 0.03)
# fade-out-step = 0.03
fade-out-step = 0.03;

# The time between steps in fade step, in milliseconds. (> 0, defaults to 10)
# fade-delta = 10

# Specify a list of conditions of windows that should not be faded.
# fade-exclude = []

# Do not fade on window open/close.
# no-fading-openclose = false

# Do not fade destroyed ARGB windows with WM frame. Workaround of bugs in Openbox, Fluxbox, etc.
# no-fading-destroyed-argb = false


#################################
#   Transparency / Opacity      #
#################################


# Opacity of inactive windows. (0.1 - 1.0, defaults to 1.0)
# inactive-opacity = 1
inactive-opacity = 0.8;

# Opacity of window titlebars and borders. (0.1 - 1.0, disabled by default)
# frame-opacity = 1.0
frame-opacity = 0.7;

# Default opacity for dropdown menus and popup menus. (0.0 - 1.0, defaults to 1.0)
# menu-opacity = 1.0

# Let inactive opacity set by -i override the '_NET_WM_OPACITY' values of windows.
# inactive-opacity-override = true
inactive-opacity-override = false;

# Default opacity for active windows. (0.0 - 1.0, defaults to 1.0)
# active-opacity = 1.0

# Dim inactive windows. (0.0 - 1.0, defaults to 0.0)
# inactive-dim = 0.0

# Specify a list of conditions of windows that should always be considered focused.
# focus-exclude = []
focus-exclude = [ "class_g = 'Cairo-clock'" ];

# Use fixed inactive dim value, instead of adjusting according to window opacity.
# inactive-dim-fixed = 1.0

# Specify a list of opacity rules, in the format `PERCENT:PATTERN`,
# like `50:name *= "Firefox"`. picom-trans is recommended over this.
# Note we don't make any guarantee about possible conflicts with other
# programs that set '_NET_WM_WINDOW_OPACITY' on frame or client windows.
# example:
#    opacity-rule = [ "80:class_g = 'URxvt'" ];
#    opacity-rule = [ "80:class_i = 'alacritty'" ]

#################################
#     Background-Blurring       #
#################################


# Parameters for background blurring, see the *BLUR* section for more information.
# blur-method =
# blur-size = 12
#
# blur-deviation = false

# Blur background of semi-transparent / ARGB windows.
# Bad in performance, with driver-dependent behavior.
# The name of the switch may change without prior notifications.
#
# blur-background = false

# Blur background of windows when the window frame is not opaque.
# Implies:
#    blur-background
# Bad in performance, with driver-dependent behavior. The name may change.
#
# blur-background-frame = false


# Use fixed blur strength rather than adjusting according to window opacity.
# blur-background-fixed = false


# Specify the blur convolution kernel, with the following format:
# example:
#   blur-kern = "5,5,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1";
#
# blur-kern = ''
blur-kern = "3x3box";


# Exclude conditions for background blur.
# blur-background-exclude = []
blur-background-exclude = [
  "window_type = 'dock'",
  "window_type = 'desktop'",
  "_GTK_FRAME_EXTENTS@:c"
];

#################################
#       General Settings        #
#################################

# Daemonize process. Fork to background after initialization. Causes issues with certain (badly-written) drivers.
# daemon = false

# Specify the backend to use: `xrender`, `glx`, or `xr_glx_hybrid`.
# `xrender` is the default one.
#
# backend = 'glx'
backend = "xrender";

# Enable/disable VSync.
# vsync = false
vsync = true

# Enable remote control via D-Bus. See the *D-BUS API* section below for more details.
# dbus = false

# Try to detect WM windows (a non-override-redirect window with no
# child that has 'WM_STATE') and mark them as active.
#
# mark-wmwin-focused = false
mark-wmwin-focused = true;

# Mark override-redirect windows that doesn't have a child window with 'WM_STATE' focused.
# mark-ovredir-focused = false
mark-ovredir-focused = true;

# Try to detect windows with rounded corners and don't consider them
# shaped windows. The accuracy is not very high, unfortunately.
#
# detect-rounded-corners = false
detect-rounded-corners = true;

# Detect '_NET_WM_OPACITY' on client windows, useful for window managers
# not passing '_NET_WM_OPACITY' of client windows to frame windows.
#
# detect-client-opacity = false
detect-client-opacity = true;

# Specify refresh rate of the screen. If not specified or 0, picom will
# try detecting this with X RandR extension.
#
# refresh-rate = 60
refresh-rate = 0

# Limit picom to repaint at most once every 1 / 'refresh_rate' second to
# boost performance. This should not be used with
#   vsync drm/opengl/opengl-oml
# as they essentially does sw-opti's job already,
# unless you wish to specify a lower refresh rate than the actual value.
#
# sw-opti =

# Use EWMH '_NET_ACTIVE_WINDOW' to determine currently focused window,
# rather than listening to 'FocusIn'/'FocusOut' event. Might have more accuracy,
# provided that the WM supports it.
#
# use-ewmh-active-win = false

# Unredirect all windows if a full-screen opaque window is detected,
# to maximize performance for full-screen windows. Known to cause flickering
# when redirecting/unredirecting windows.
#
# unredir-if-possible = false

# Delay before unredirecting the window, in milliseconds. Defaults to 0.
# unredir-if-possible-delay = 0

# Conditions of windows that shouldn't be considered full-screen for unredirecting screen.
# unredir-if-possible-exclude = []

# Use 'WM_TRANSIENT_FOR' to group windows, and consider windows
# in the same group focused at the same time.
#
# detect-transient = false
detect-transient = true

# Use 'WM_CLIENT_LEADER' to group windows, and consider windows in the same
# group focused at the same time. 'WM_TRANSIENT_FOR' has higher priority if
# detect-transient is enabled, too.
#
# detect-client-leader = false
detect-client-leader = true

# Resize damaged region by a specific number of pixels.
# A positive value enlarges it while a negative one shrinks it.
# If the value is positive, those additional pixels will not be actually painted
# to screen, only used in blur calculation, and such. (Due to technical limitations,
# with use-damage, those pixels will still be incorrectly painted to screen.)
# Primarily used to fix the line corruption issues of blur,
# in which case you should use the blur radius value here
# (e.g. with a 3x3 kernel, you should use `--resize-damage 1`,
# with a 5x5 one you use `--resize-damage 2`, and so on).
# May or may not work with *--glx-no-stencil*. Shrinking doesn't function correctly.
#
# resize-damage = 1

# Specify a list of conditions of windows that should be painted with inverted color.
# Resource-hogging, and is not well tested.
#
# invert-color-include = []

# GLX backend: Avoid using stencil buffer, useful if you don't have a stencil buffer.
# Might cause incorrect opacity when rendering transparent content (but never
# practically happened) and may not work with blur-background.
# My tests show a 15% performance boost. Recommended.
#
# glx-no-stencil = false

# GLX backend: Avoid rebinding pixmap on window damage.
# Probably could improve performance on rapid window content changes,
# but is known to break things on some drivers (LLVMpipe, xf86-video-intel, etc.).
# Recommended if it works.
#
# glx-no-rebind-pixmap = false

# Disable the use of damage information.
# This cause the whole screen to be redrawn everytime, instead of the part of the screen
# has actually changed. Potentially degrades the performance, but might fix some artifacts.
# The opposing option is use-damage
#
# no-use-damage = false
use-damage = true

# Use X Sync fence to sync clients' draw calls, to make sure all draw
# calls are finished before picom starts drawing. Needed on nvidia-drivers
# with GLX backend for some users.
#
# xrender-sync-fence = false

# GLX backend: Use specified GLSL fragment shader for rendering window contents.
# See `compton-default-fshader-win.glsl` and `compton-fake-transparency-fshader-win.glsl`
# in the source tree for examples.
#
# glx-fshader-win = ''

# Force all windows to be painted with blending. Useful if you
# have a glx-fshader-win that could turn opaque pixels transparent.
#
# force-win-blend = false

# Do not use EWMH to detect fullscreen windows.
# Reverts to checking if a window is fullscreen based only on its size and coordinates.
#
# no-ewmh-fullscreen = false

# Dimming bright windows so their brightness doesn't exceed this set value.
# Brightness of a window is estimated by averaging all pixels in the window,
# so this could comes with a performance hit.
# Setting this to 1.0 disables this behaviour. Requires --use-damage to be disabled. (default: 1.0)
#
# max-brightness = 1.0

# Make transparent windows clip other windows like non-transparent windows do,
# instead of blending on top of them.
#
# transparent-clipping = false

# Set the log level. Possible values are:
#  "trace", "debug", "info", "warn", "error"
# in increasing level of importance. Case doesn't matter.
# If using the "TRACE" log level, it's better to log into a file
# using *--log-file*, since it can generate a huge stream of logs.
#
# log-level = "debug"
log-level = "warn";

# Set the log file.
# If *--log-file* is never specified, logs will be written to stderr.
# Otherwise, logs will to written to the given file, though some of the early
# logs might still be written to the stderr.
# When setting this option from the config file, it is recommended to use an absolute path.
#
# log-file = '/path/to/your/log/file'

# Show all X errors (for debugging)
# show-all-xerrors = false

# Write process ID to a file.
# write-pid-path = '/path/to/your/log/file'

# Window type settings
#
# 'WINDOW_TYPE' is one of the 15 window types defined in EWMH standard:
#     "unknown", "desktop", "dock", "toolbar", "menu", "utility",
#     "splash", "dialog", "normal", "dropdown_menu", "popup_menu",
#     "tooltip", "notification", "combo", and "dnd".
#
# Following per window-type options are available: ::
#
#   fade, shadow:::
#     Controls window-type-specific shadow and fade settings.
#
#   opacity:::
#     Controls default opacity of the window type.
#
#   focus:::
#     Controls whether the window of this type is to be always considered focused.
#     (By default, all window types except "normal" and "dialog" has this on.)
#
#   full-shadow:::
#     Controls whether shadow is drawn under the parts of the window that you
#     normally won't be able to see. Useful when the window has parts of it
#     transparent, and you want shadows in those areas.
#
#   redir-ignore:::
#     Controls whether this type of windows should cause screen to become
#     redirected again after been unredirected. If you have unredir-if-possible
#     set, and doesn't want certain window to cause unnecessary screen redirection,
#     you can set this to `true`.
#
wintypes:
{
  tooltip = { fade = false; shadow = false; opacity = 1; focus = true; full-shadow = false; };
  dock = { shadow = false; }
  dnd = { shadow = false; }
  popup_menu = { opacity = 1; }
  dropdown_menu = { opacity = 1; }
};
```

## Zathura

Leitor de pdf

- `~/.config/zathura/zathurarc`

```conf tangle:~/.config/zathura/zathurarc
set sandbox none
set statusbar-h-padding 0
set statusbar-v-padding 0
set page-padding 1
set selection-clipboard clipboard
map D toggle_page_mode
map R reload
map r rotate
map zd recolor
```

## Gtk

Interface de usuário

### Gtk 2

- `~/.config/gtk-2.0/gtkrc`

```conf tangle:~/.config/gtk-2.0/gtkrc
include "/home/lucas/.gtkrc-2.0.mine"
gtk-theme-name="Adwaita-dark"
gtk-icon-theme-name="Papirus-Dark"
gtk-font-name="Inconsolata 13"
gtk-cursor-theme-name="Bluecurve"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_MENU
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
```

### Gtk 3

- `~/.config/gtk-3.0/settings.ini`

```conf tangle:~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Adwaita-dark
gtk-font-name=Inconsolata 13
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_ICONS
gtk-toolbar-icon-size=GTK_ICON_SIZE_MENU
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-icon-theme-name=Papirus-Dark
gtk-application-prefer-dark-theme=true
```

- `~/.config/settings.ini`

```conf tangle:~/.config/settings.ini
[Settings]
gtk-font-name=Inconsolata 13
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
```

## Dunst

Daemon de notificação

- `~/.config/dunst/dunstrc`

```conf tangle:~/.config/dunst/dunstrc
[global]
    ### Display ###

    # Which monitor should the notifications be displayed on.
    monitor = 0

    # Display notification on focused monitor.  Possible modes are:
    #   mouse: follow mouse pointer
    #   keyboard: follow window with keyboard focus
    #   none: don't follow anything
    #
    # "keyboard" needs a window manager that exports the
    # _NET_ACTIVE_WINDOW property.
    # This should be the case for almost all modern window managers.
    #
    # If this option is set to mouse or keyboard, the monitor option
    # will be ignored.
    follow = mouse

    # The geometry of the window:
    #   [{width}]x{height}[+/-{x}+/-{y}]
    # The geometry of the message window.
    # The height is measured in number of notifications everything else
    # in pixels.  If the width is omitted but the height is given
    # ("-geometry x2"), the message window expands over the whole screen
    # (dmenu-like).  If width is 0, the window expands to the longest
    # message displayed.  A positive x is measured from the left, a
    # negative from the right side of the screen.  Y is measured from
    # the top and down respectively.
    # The width can be negative.  In this case the actual width is the
    # screen width minus the width defined in within the geometry option.
    geometry = "800x5-30+20"

    # Turn on the progess bar
    progress_bar = true

    # Set the progress bar height. This includes the frame, so make sure
    # it's at least twice as big as the frame width.
    progress_bar_height = 10

    # Set the frame width of the progress bar
    progress_bar_frame_width = 1

    # Set the minimum width for the progress bar
    progress_bar_min_width = 150

    # Set the maximum width for the progress bar
    progress_bar_max_width = 300


    # Show how many messages are currently hidden (because of geometry).
    indicate_hidden = yes

    # Shrink window if it's smaller than the width.  Will be ignored if
    # width is 0.
    shrink = no

    # The transparency of the window.  Range: [0; 100].
    # This option will only work if a compositing window manager is
    # present (e.g. xcompmgr, compiz, etc.).
    transparency = 30

    # The height of the entire notification.  If the height is smaller
    # than the font height and padding combined, it will be raised
    # to the font height and padding.
    notification_height = 0

    # Draw a line of "separator_height" pixel height between two
    # notifications.
    # Set to 0 to disable.
    separator_height = 2

    # Padding between text and separator.
    padding = 8

    # Horizontal padding.
    horizontal_padding = 8

    # Padding between text and icon.
    text_icon_padding = 0

    # Defines width in pixels of frame around the notification window.
    # Set to 0 to disable.
    frame_width = 1

    # Defines color of the frame around the notification window.
    frame_color = "#FFFFFF"

    # Define a color for the separator.
    # possible values are:
    #  * auto: dunst tries to find a color fitting to the background;
    #  * foreground: use the same color as the foreground;
    #  * frame: use the same color as the frame;
    #  * anything else will be interpreted as a X color.
    separator_color = auto

    # Sort messages by urgency.
    sort = yes

    # Don't remove messages, if the user is idle (no mouse or keyboard input)
    # for longer than idle_threshold seconds.
    # Set to 0 to disable.
    # A client can set the 'transient' hint to bypass this. See the rules
    # section for how to disable this if necessary
    idle_threshold = 120

    ### Text ###

    font = Inconsolata 13

    # The spacing between lines.  If the height is smaller than the
    # font height, it will get raised to the font height.
    line_height = 1

    # Possible values are:
    # full: Allow a small subset of html markup in notifications:
    #        <b>bold</b>
    #        <i>italic</i>
    #        <s>strikethrough</s>
    #        <u>underline</u>
    #
    #        For a complete reference see
    #        <https://developer.gnome.org/pango/stable/pango-Markup.html>.
    #
    # strip: This setting is provided for compatibility with some broken
    #        clients that send markup even though it's not enabled on the
    #        server. Dunst will try to strip the markup but the parsing is
    #        simplistic so using this option outside of matching rules for
    #        specific applications *IS GREATLY DISCOURAGED*.
    #
    # no:    Disable markup parsing, incoming notifications will be treated as
    #        plain text. Dunst will not advertise that it has the body-markup
    #        capability if this is set as a global setting.
    #
    # It's important to note that markup inside the format option will be parsed
    # regardless of what this is set to.
    markup = full

    # The format of the message.  Possible variables are:
    #   %a  appname
    #   %s  summary
    #   %b  body
    #   %i  iconname (including its path)
    #   %I  iconname (without its path)
    #   %p  progress value if set ([  0%] to [100%]) or nothing
    #   %n  progress value if set without any extra characters
    #   %%  Literal %
    # Markup is allowed
    format = "<b>%s</b>\n%b"

    # Alignment of message text.
    # Possible values are "left", "center" and "right".
    alignment = left

    # Vertical alignment of message text and icon.
    # Possible values are "top", "center" and "bottom".
    vertical_alignment = center

    # Show age of message if message is older than show_age_threshold
    # seconds.
    # Set to -1 to disable.
    show_age_threshold = 60

    # Split notifications into multiple lines if they don't fit into
    # geometry.
    word_wrap = yes

    # When word_wrap is set to no, specify where to make an ellipsis in long lines.
    # Possible values are "start", "middle" and "end".
    ellipsize = middle

    # Ignore newlines '\n' in notifications.
    ignore_newline = no

    # Stack together notifications with the same content
    stack_duplicates = true

    # Hide the count of stacked notifications with the same content
    hide_duplicate_count = false

    # Display indicators for URLs (U) and actions (A).
    show_indicators = yes

    ### Icons ###

    # Align icons left/right/off
    icon_position = left

    # Scale small icons up to this size, set to 0 to disable. Helpful
    # for e.g. small files or high-dpi screens. In case of conflict,
    # max_icon_size takes precedence over this.
    min_icon_size = 0

    # Scale larger icons down to this size, set to 0 to disable
    max_icon_size = 32

    # Paths to default icons.
    icon_path = /usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/

    ### History ###

    # Should a notification popped up from history be sticky or timeout
    # as if it would normally do.
    sticky_history = yes

    # Maximum amount of notifications kept in history
    history_length = 20

    ### Misc/Advanced ###

    # dmenu path.
    dmenu = /usr/local/bin/dmenu -p "dunst:"

    # Browser for opening urls in context menu.
    browser = /usr/bin/qutebrowser

    # Always run rule-defined scripts, even if the notification is suppressed
    always_run_script = true

    # Define the title of the windows spawned by dunst
    title = Dunst

    # Define the class of the windows spawned by dunst
    class = Dunst

    # Print a notification on startup.
    # This is mainly for error detection, since dbus (re-)starts dunst
    # automatically after a crash.
    startup_notification = true

    # Manage dunst's desire for talking
    # Can be one of the following values:
    #  crit: Critical features. Dunst aborts
    #  warn: Only non-fatal warnings
    #  mesg: Important Messages
    #  info: all unimportant stuff
    # debug: all less than unimportant stuff
    verbosity = mesg

    # Define the corner radius of the notification window
    # in pixel size. If the radius is 0, you have no rounded
    # corners.
    # The radius will be automatically lowered if it exceeds half of the
    # notification height to avoid clipping text and/or icons.
    corner_radius = 0

    # Ignore the dbus closeNotification message.
    # Useful to enforce the timeout set by dunst configuration. Without this
    # parameter, an application may close the notification sent before the
    # user defined timeout.
    ignore_dbusclose = false

    ### Wayland ###
    # These settings are Wayland-specific. They have no effect when using X11

    # Uncomment this if you want to let notications appear under fullscreen
    # applications (default: overlay)
    # layer = top

    # Set this to true to use X11 output on Wayland.
    force_xwayland = false

    ### Legacy

    # Use the Xinerama extension instead of RandR for multi-monitor support.
    # This setting is provided for compatibility with older nVidia drivers that
    # do not support RandR and using it on systems that support RandR is highly
    # discouraged.
    #
    # By enabling this setting dunst will not be able to detect when a monitor
    # is connected or disconnected which might break follow mode if the screen
    # layout changes.
    force_xinerama = false

    ### mouse

    # Defines list of actions for each mouse event
    # Possible values are:
    # * none: Don't do anything.
    # * do_action: If the notification has exactly one action, or one is marked as default,
    #              invoke it. If there are multiple and no default, open the context menu.
    # * close_current: Close current notification.
    # * close_all: Close all notifications.
    # These values can be strung together for each mouse event, and
    # will be executed in sequence.
    mouse_left_click = close_current
    mouse_middle_click = do_action, close_current
    mouse_right_click = do_action, close_current

# Experimental features that may or may not work correctly. Do not expect them
# to have a consistent behaviour across releases.
[experimental]
    # Calculate the dpi to use on a per-monitor basis.
    # If this setting is enabled the Xft.dpi value will be ignored and instead
    # dunst will attempt to calculate an appropriate dpi value for each monitor
    # using the resolution and physical size. This might be useful in setups
    # where there are multiple screens with very different dpi values.
    per_monitor_dpi = false

# The internal keyboard shortcut support in dunst is now considered deprecated
# and should be replaced by dunstctl calls. You can use the configuration of your
# WM or DE to bind these to shortcuts of your choice.
# Check the dunstctl manual page for more info.
[shortcuts]

    # Shortcuts are specified as [modifier+][modifier+]...key
    # Available modifiers are "ctrl", "mod1" (the alt-key), "mod2",
    # "mod3" and "mod4" (windows-key).
    # Xev might be helpful to find names for keys.

    # Close notification. Equivalent dunstctl command:
    # dunstctl close
    # close = ctrl+space

    # Close all notifications. Equivalent dunstctl command:
    # dunstctl close-all
    # close_all = ctrl+shift+space

    # Redisplay last message(s). Equivalent dunstctl command:
    # dunstctl history-pop
    # history = ctrl+grave

    # Context menu. Equivalent dunstctl command:
    # dunstctl context
    # context = ctrl+shift+period

[urgency_low]
    # IMPORTANT: colors have to be defined in quotation marks.
    # Otherwise the "#" and following would be interpreted as a comment.
    background = "#000000"
    foreground = "#FFFFFF"
    timeout = 10
    # Icon for notifications with low urgency, uncomment to enable
    #icon = /path/to/icon

[urgency_normal]
    background = "#2f334d"
    foreground = "#FFFFFF"
    timeout = 10
    # Icon for notifications with normal urgency, uncomment to enable
    #icon = /path/to/icon

[urgency_critical]
    background = "#800000"
    foreground = "#ffffff"
    frame_color = "#FF0000"
    timeout = 0
    # Icon for notifications with critical urgency, uncomment to enable
    #icon = /path/to/icon

# Every section that isn't one of the above is interpreted as a rules to
# override settings for certain messages.
#
# Messages can be matched by
#    appname (discouraged, see desktop_entry)
#    body
#    category
#    desktop_entry
#    icon
#    match_transient
#    msg_urgency
#    stack_tag
#    summary
#
# and you can override the
#    background
#    foreground
#    format
#    frame_color
#    fullscreen
#    new_icon
#    set_stack_tag
#    set_transient
#    timeout
#    urgency
#
# Shell-like globbing will get expanded.
#
# Instead of the appname filter, it's recommended to use the desktop_entry filter.
# GLib based applications export their desktop-entry name. In comparison to the appname,
# the desktop-entry won't get localized.
#
# SCRIPTING
# You can specify a script that gets run when the rule matches by
# setting the "script" option.
# The script will be called as follows:
#   script appname summary body icon urgency
# where urgency can be "LOW", "NORMAL" or "CRITICAL".
#
# NOTE: if you don't want a notification to be displayed, set the format
# to "".
# NOTE: It might be helpful to run dunst -print in a terminal in order
# to find fitting options for rules.

# Disable the transient hint so that idle_threshold cannot be bypassed from the
# client
#[transient_disable]
#    match_transient = yes
#    set_transient = no
#
# Make the handling of transient notifications more strict by making them not
# be placed in history.
#[transient_history_ignore]
#    match_transient = yes
#    history_ignore = yes

# fullscreen values
# show: show the notifications, regardless if there is a fullscreen window opened
# delay: displays the new notification, if there is no fullscreen window active
#        If the notification is already drawn, it won't get undrawn.
# pushback: same as delay, but when switching into fullscreen, the notification will get
#           withdrawn from screen again and will get delayed like a new notification
#[fullscreen_delay_everything]
#    fullscreen = delay
#[fullscreen_show_critical]
#    msg_urgency = critical
#    fullscreen = show

#[espeak]
#    summary = "*"
#    script = dunst_espeak.sh

#[script-test]
#    summary = "*script*"
#    script = dunst_test.sh

#[ignore]
#    # This notification will not be displayed
#    summary = "foobar"
#    format = ""

#[history-ignore]
#    # This notification will not be saved in history
#    summary = "foobar"
#    history_ignore = yes

#[skip-display]
#    # This notification will not be displayed, but will be included in the history
#    summary = "foobar"
#    skip_display = yes

#[signed_on]
#    appname = Pidgin
#    summary = "*signed on*"
#    urgency = low
#
#[signed_off]
#    appname = Pidgin
#    summary = *signed off*
#    urgency = low
#
#[says]
#    appname = Pidgin
#    summary = *says*
#    urgency = critical
#
#[twitter]
#    appname = Pidgin
#    summary = *twitter.com*
#    urgency = normal
#
#[stack-volumes]
#    appname = "some_volume_notifiers"
#    set_stack_tag = "volume"
#
# vim: ft=cfg
```

## Bspwm

Gerenciador de janelas bspwm

- `~/.config/bspwm/bspwmrc`

```bash tangle:~/.config/bspwm/bspwmrc
#!/bin/sh

# Monitor
bspc monitor -d 1 2 3

# Configurações
bspc config border_width            1
bspc config window_gap              0
bspc config top_padding             1
bspc config bottom_padding          0
bspc config left_padding            1
bspc config right_padding           0
bspc config split_ratio             0.50
bspc config borderless_monocle      true
bspc config gapless_monocle         true
bspc config pointer_modifier mod4
bspc config pointer_action1 move
bspc config click_to_focus          true
bspc config single_monocle          true

# Cores
bspc config normal_border_color       "#2f334d"
bspc config active_border_color       "#ffffff"
bspc config focused_border_color          "#ffffff"
bspc config presel_feedback_color         "#2f334d"
bspc config urgent_border_color           "#ff0000"

# Regras
bspc rule -a mplayer2 state=floating
bspc rule -a Kupfer.py focus=on
bspc rule -a Screenkey manage=off
bspc rule -a mpv state=fullscreen
bspc rule -a guvcview state=floating rectangle=480x270+0+0 sticky=on layer=above
bspc rule -a Deadbeef state=floating rectangle=1200x600+0+0 sticky=on layer=above center=true
bspc rule -a ncmpcpp state=floating rectangle=1200x600+0+0 sticky=on layer=above center=true
bspc rule -a xev state=floating rectangle=480x270+0+0 sticky=on layer=above center=true
bspc rule -a Gcr-prompter state=floating rectangle=480x270+0+0 sticky=on layer=above center=true
bspc rule -a Transmission-gtk state=floating rectangle=1000x700+0+0 sticky=on layer=above center=true
bspc rule -a firefox:Places state=floating rectangle=480x270+0+0 sticky=off layer=above center=true
bspc rule -a confirm state=floating rectangle=480x270+0+0 sticky=on layer=above center=true
bspc rule -a file_progress state=floating rectangle=480x270+0+0 sticky=off layer=above center=true
bspc rule -a dialog state=floating rectangle=480x270+0+0 sticky=on layer=above center=true
bspc rule -a download state=floating rectangle=480x270+0+0 sticky=off layer=above
bspc rule -a MEGAsync:megasync state=floating rectangle=480x270+0+0 sticky=off layer=above center=true
bspc rule -a firefox:Devtools state=floating rectangle=800x350+0+0 sticky=on layer=above center=true
bspc rule -a Galculator:galculator state=floating rectangle=480x270+0+0 sticky=on layer=above center=true
bspc rule -a toolbar state=floating rectangle=480x270+0+0 sticky=off layer=above
bspc rule -a error state=floating rectangle=480x270+0+0 sticky=off layer=above center=true
bspc rule -a MPlayer state=floating rectangle=480x270+0+0 sticky=off layer=above center=true
bspc rule -a notification state=floating rectangle=480x270+0+0 sticky=off layer=above center=true
bspc rule -a pulsemixer state=floating rectangle=800x300+0+0 center=true
bspc rule -a VirtualBox Manager state=fullscreen
bspc rule -a VirtualBox Machine state=fullscreen
bspc rule -a :Zathura state=tiled
bspc rule -a st_download state=floating rectangle=1000x700+0+0 center=true
```

## Paru

Gerenciador de pacotes da **aur**, Trocado sudo pelo doas

- `~/.config/paru/paru.conf`

```conf tangle:~/.config/paru/paru.conf
[bin]
Sudo = /bin/doas
```

## Npm

Gerenciador de pacotes do node.js, Trocados diretórios para limpar a \~

- `~/.config/npm/npmrc`

```conf tangle:~/.config/npm/npmrc
prefix=${XDG_DATA_HOME}/npm
cache=${XDG_CACHE_HOME}/npm
tmp=${XDG_RUNTIME_DIR}/npm
init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
```
