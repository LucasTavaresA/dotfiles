# Extras

Configurações menos importantes

## Sumario

-   [Alacritty](#alacritty)
-   [Tmux](#tmux)
-   [Ncmpcpp](#ncmpcpp)
    -   [Configuração](#configuração)
    -   [Teclas](#teclas)
-   [Mpd](#mpd)
-   [Mimetypes](#mimetypes)
-   [.gitignore](#gitignore)
-   [Picom](#picom)
-   [Zathura](#zathura)
-   [Dunst](#dunst)

## Alacritty

Emulador de terminal alacritty

- `~/.config/alacritty/alacritty.yml`

```yaml tangle:~/.config/alacritty/alacritty.yml
#import:
#  - /path/to/alacritty.yml

env:
  TERM: alacritty

window:
  dimensions:
    columns: 150
    lines: 50

  #position:
    #x: 0
    #y: 0

  #padding:
  #  x: 0
  #  y: 0

  # Spread additional padding evenly around the terminal content.
  #dynamic_padding: false

  decorations: none

  # Background opacity
  opacity: 0.7

  startup_mode: Maximized

  title: Alacritty

  dynamic_title: true

  class:
    instance: Alacritty
    general: Alacritty

  # gtk_theme_variant: None

#scrolling:
  #history: 10000

  #multiplier: 3

font:
  normal:
    family: Fira Code
    style: Regular
  bold:
    family: Fira Code
    style: Bold
  italic:
    family: Fira Code
    style: Italic
  bold_italic:
    family: Inconsolata
    style: Bold Italic
  size: 12.0
  #offset:
  #  x: 0
  #  y: 0
  #glyph_offset:
  #  x: 0
  #  y: 0
  #use_thin_strokes: true
#draw_bold_text_with_bright_colors: false

# Blood_Moon Theme START -----------------------------------------------

# Colors (Blood Moon)
colors:
  # Default colors
  primary:
    background: '#000000'
    foreground: '#FFFFFF'

  # Normal colors
  normal:
    black:   '#222222'
    red:     '#FF0000'
    green:   '#00FF00'
    yellow:  '#FFFF00'
    blue:    '#0052FF'
    magenta: '#9A4EAE'
    cyan:    '#20B2AA'
    white:   '#CCCCCC'

  # Bright colors
  bright:
    black:   '#696969'
    red:     '#FF2400'
    green:   '#03C03C'
    yellow:  '#FDFF00'
    blue:    '#007FFF'
    magenta: '#FF1493'
    cyan:    '#00CCCC'
    white:   '#FFFAFA'

  #search:
    #matches:
    #  foreground: '#000000'
    #  background: '#ffffff'
    #focused_match:
    #  foreground: '#ffffff'
    #  background: '#000000'
    #bar:
    #  background: '#c5c8c6'
    #  foreground: '#1d1f21'

# Blood_Moon Theme END --------------------------------------------------

selection:
  # This string contains all characters that are used as separators for
  # "semantic words" in Alacritty.
  semantic_escape_chars: ",│`|:\"' ()[]{}<>\t"
  # When set to `true`, selected text will be copied to the primary clipboard.
  #save_to_clipboard: false

cursor:
  style:
    # Cursor shape
    # Values for `shape`:
    #   - ▇ Block
    #   - _ Underline
    #   - | Beam
    shape: Beam
    # Cursor blinking state
    blinking: On
  vi_mode_style: Block

  #blink_interval: 750

  # If this is `true`, the cursor will be rendered as a hollow box when the
  # window is not focused.
  unfocused_hollow: true

  # Thickness of the cursor relative to the cell width as floating point number
  #thickness: 0.15

# Live config reload (changes require restart)
live_config_reload: true

# Shell
shell:
   program: /bin/zsh
#  args:
#    - --login

# Startup directory
#working_directory: None

# Send ESC (\x1b) before characters when alt is pressed.
#alt_send_esc: true

# Offer IPC using `alacritty msg` (unix only)
#ipc_socket: true

# Key bindings
#
# Key bindings are specified as a list of objects. For example, this is the
# default paste binding:
#
# `- { key: V, mods: Control|Shift, action: Paste }`
#
# Each key binding will specify a:
#
# - `key`: Identifier of the key pressed
#
#    - A-Z
#    - F1-F24
#    - Key0-Key9
#
#    A full list with available key codes can be found here:
#    https://docs.rs/glutin/*/glutin/event/enum.VirtualKeyCode.html#variants
#
#    Instead of using the name of the keys, the `key` field also supports using
#    the scancode of the desired key. Scancodes have to be speceified as a
#    decimal number. This command will allow you to display the hex scancodes
#    for certain keys:
#
#       `showkey --scancodes`.
#
# Then exactly one of:
#
# - `chars`: Send a byte sequence to the running application
#
#    Th `chars` field writes the specified string to the terminal. This makes
#    it possible to pass escape sequences. To find escape codes for bindings
#    like `PageUp` (`"\x1b[5~"`), you can run the command `showkey -a` outside
#    of tmux. Note that applications use terminfo to map escape sequences back
#    to keys. It is therefore required to update the terminfo when changing an
#    escape sequence.
#
# - `action`: Execute a predefined action
#
#   - ToggleViMode
#   - SearchForward
#       Start searching toward the right of the search origin.
#   - SearchBackward
#       Start searching toward the left of the search origin.
#   - Copy
#   - Paste
#   - IncreaseFontSize
#   - DecreaseFontSize
#   - ResetFontSize
#   - ScrollPageUp
#   - ScrollPageDown
#   - ScrollHalfPageUp
#   - ScrollHalfPageDown
#   - ScrollLineUp
#   - ScrollLineDown
#   - ScrollToTop
#   - ScrollToBottom
#   - ClearHistory
#       Remove the terminal's scrollback history.
#   - Hide
#       Hide the Alacritty window.
#   - Minimize
#       Minimize the Alacritty window.
#   - Quit
#       Quit Alacritty.
#   - ToggleFullscreen
#   - SpawnNewInstance
#       Spawn a new instance of Alacritty.
#   - CreateNewWindow
#       Create a new Alacritty window from the current process.
#   - ClearLogNotice
#       Clear Alacritty's UI warning and error notice.
#   - ClearSelection
#       Remove the active selection.
#   - ReceiveChar
#   - None
#
# - Vi mode exclusive actions:
#
#   - Open
#       Perform the action of the first matching hint under the vi mode cursor
#       with `mouse.enabled` set to `true`.
#   - ToggleNormalSelection
#   - ToggleLineSelection
#   - ToggleBlockSelection
#   - ToggleSemanticSelection
#       Toggle semantic selection based on `selection.semantic_escape_chars`.
#
# - Vi mode exclusive cursor motion actions:
#
#   - Up
#       One line up.
#   - Down
#       One line down.
#   - Left
#       One character left.
#   - Right
#       One character right.
#   - First
#       First column, or beginning of the line when already at the first column.
#   - Last
#       Last column, or beginning of the line when already at the last column.
#   - FirstOccupied
#       First non-empty cell in this terminal row, or first non-empty cell of
#       the line when already at the first cell of the row.
#   - High
#       Top of the screen.
#   - Middle
#       Center of the screen.
#   - Low
#       Bottom of the screen.
#   - SemanticLeft
#       Start of the previous semantically separated word.
#   - SemanticRight
#       Start of the next semantically separated word.
#   - SemanticLeftEnd
#       End of the previous semantically separated word.
#   - SemanticRightEnd
#       End of the next semantically separated word.
#   - WordLeft
#       Start of the previous whitespace separated word.
#   - WordRight
#       Start of the next whitespace separated word.
#   - WordLeftEnd
#       End of the previous whitespace separated word.
#   - WordRightEnd
#       End of the next whitespace separated word.
#   - Bracket
#       Character matching the bracket at the cursor's location.
#   - SearchNext
#       Beginning of the next match.
#   - SearchPrevious
#       Beginning of the previous match.
#   - SearchStart
#       Start of the match to the left of the vi mode cursor.
#   - SearchEnd
#       End of the match to the right of the vi mode cursor.
#
# - Search mode exclusive actions:
#   - SearchFocusNext
#       Move the focus to the next search match.
#   - SearchFocusPrevious
#       Move the focus to the previous search match.
#   - SearchConfirm
#   - SearchCancel
#   - SearchClear
#       Reset the search regex.
#   - SearchDeleteWord
#       Delete the last word in the search regex.
#   - SearchHisetoryPrevious
#       Go to the previous regex in the search history.
#   - SearchHistoryNext
#       Go to the next regex in the search history.
#
# - macOS exclusive actions:
#   - ToggleSimpleFullscreen
#       Enter fullscreen without occupying another space.
#
# - Linux/BSD exclusive actions:
#
#   - CopySelection
#      Copy from the selection buffer.
#   - PasteSelection
#       Paste from the selection buffer.
#
# - `command`: Fork and execute a specified command plus arguments
#
#    The `command` field must be a map containing a `program` string and an
#    `args` array of command line parameter strings. For example:
#       `{ program: "alacritty", args: ["-e", "vttest"] }`
#
# And optionally:
#
# - `mods`: Key modifiers to filter binding actions
#
#    - Command
#    - Control
#    - Option
#    - Super
#    - Shift
#    - Alt
#
#    Multiple `mods` can be combined using `|` like this:
#       `mods: Control|Shift`.
#    Whitespace and capitalization are relevant and must match the example.
#
# - `mode`: Indicate a binding for only specific terminal reported modes
#
#    This is mainly used to send applications the correct escape sequences
#    when in different modes.
#
#    - AppCursor
#    - AppKeypad
#    - Search
#    - Alt
#    - Vi
#
#    A `~` operator can be used before a mode to apply the binding whenever
#    the mode is *not* active, e.g. `~Alt`.
#
# Bindings are always filled by default, but will be replaced when a new
# binding with the same triggers is defined. To unset a default binding, it can
# be mapped to the `ReceiveChar` action. Alternatively, you can use `None` for
# a no-op if you do not wish to receive input characters for that binding.
#
# If the same trigger is assigned to multiple actions, all of them are executed
# in the order they were defined in.
#key_bindings:
  #- { key: Paste,                                       action: Paste          }
  #- { key: Copy,                                        action: Copy           }
  #- { key: L,         mods: Control,                    action: ClearLogNotice }
  #- { key: L,         mods: Control, mode: ~Vi|~Search, chars: "\x0c"          }
  #- { key: PageUp,    mods: Shift,   mode: ~Alt,        action: ScrollPageUp,  }
  #- { key: PageDown,  mods: Shift,   mode: ~Alt,        action: ScrollPageDown }
  #- { key: Home,      mods: Shift,   mode: ~Alt,        action: ScrollToTop,   }
  #- { key: End,       mods: Shift,   mode: ~Alt,        action: ScrollToBottom }

  # Vi Mode
  #- { key: Space,  mods: Shift|Control, mode: ~Search,    action: ToggleViMode            }
  #- { key: Space,  mods: Shift|Control, mode: Vi|~Search, action: ScrollToBottom          }
  #- { key: Escape,                      mode: Vi|~Search, action: ClearSelection          }
  #- { key: I,                           mode: Vi|~Search, action: ToggleViMode            }
  #- { key: I,                           mode: Vi|~Search, action: ScrollToBottom          }
  #- { key: C,      mods: Control,       mode: Vi|~Search, action: ToggleViMode            }
  #- { key: Y,      mods: Control,       mode: Vi|~Search, action: ScrollLineUp            }
  #- { key: E,      mods: Control,       mode: Vi|~Search, action: ScrollLineDown          }
  #- { key: G,                           mode: Vi|~Search, action: ScrollToTop             }
  #- { key: G,      mods: Shift,         mode: Vi|~Search, action: ScrollToBottom          }
  #- { key: B,      mods: Control,       mode: Vi|~Search, action: ScrollPageUp            }
  #- { key: F,      mods: Control,       mode: Vi|~Search, action: ScrollPageDown          }
  #- { key: U,      mods: Control,       mode: Vi|~Search, action: ScrollHalfPageUp        }
  #- { key: D,      mods: Control,       mode: Vi|~Search, action: ScrollHalfPageDown      }
  #- { key: Y,                           mode: Vi|~Search, action: Copy                    }
  #- { key: Y,                           mode: Vi|~Search, action: ClearSelection          }
  #- {  key: Copy,                        mode: Vi|~Search, action: ClearSelection          }
  #- { key: V,                           mode: Vi|~Search, action: ToggleNormalSelection   }
  #- { key: V,      mods: Shift,         mode: Vi|~Search, action: ToggleLineSelection     }
  #- { key: V,      mods: Control,       mode: Vi|~Search, action: ToggleBlockSelection    }
  #- { key: V,      mods: Alt,           moe: Vi|~Search, action: ToggleSemanticSelection }
  #- { key: Return,                      mode: Vi|~Search, action: Open                    }
  #- { key: K,                           mode: Vi|~Search, action: Up                      }
  #- { key: J,                           mode: Vi|~Search, action: Down                    }
  #- { key: H,                           mode: Vi|~Search, action: Left                    }
  #- { key: L,                           mode: Vi|~Search, action: Right                   }
  #- { key: Up,                          mode: Vi|~Search, action: Up                      }
  #- { key: Down,                        mode: Vi|~Search, action: Down                    }
  #- { key: Left,                        mode: Vi|~Search, action: Left                    }
  #- { key: Right,                       mode: Vi|~Search, action: Right                   }
  #- { key: Key0,                        mode: Vi|~Search, action: First                   }
  #- { key: Key4,   mods: Shift,         mode: Vi|~Search, action: Last                    }
  #- { key: Key6,   mods: Shift,         mode: Vi|~Search, action: FirstOccupied           }
  #- { key: H,      mods: Shift,         mode: Vi|~Search, action: High                    }
  #- { key: M,      mods: Shift,         mode: Vi|~Search, action: Middle                  }
  #- { key: L,      mods: Shift,         mode: Vi|~Search, action: Low                     }
  #- { key: B,                           mode: Vi|~Search, action: SemanticLeft            }
  #- { key: W,                           mode: Vi|~Search, action: SemanticRight           }
  #- { key: E,                           mode: Vi|~Search, action: SemanticRightEnd        }
  #- { key: B,      mods: Shift,         mode: Vi|~Search, action: WordLeft                }
  #- { key: W,      mods: Shift,         mode: Vi|~Search, action: WordRight               }
  #- { key: E,      mods: Shift,         mode: Vi|~Search, action: WordRightEnd            }
  #- { key: Key5,   mods: Shift,         mode: Vi|~Search, action: Bracket                 }
  #- { key: Slash,                       mode: Vi|~Search, action: SearchForward           }
  #- { key: Slash,  mods: Shift,         mode: Vi|~Search, action: SearchBackward          }
  #- { key: N,                           mode: Vi|~Search, action: SearchNext              }
  #- { key: N,      mods: Shift,         mode: Vi|~Search, action: SearchPrevious          }

  # Search Mode
  #- { key: Return,                mode: Search|Vi,  action: SearchConfirm         }
  #- { key: Escape,                mode: Search,     action: SearchCancel          }
  #- { key: C,      mods: Control, mode: Search,     action: SearchCancel          }
  #- { key: U,      mods: Control, mode: Search,     action: SearchClear           }
  #- { key: W,      mods: Control, mode: Search,     action: SearchDeleteWord      }
  #- { key: P,      mods: Control, mode: Search,     action: SearchHistoryPrevious }
  #- { key: N,      mods: Control, mode: Search,     action: SearchHistoryNext     }
  #- { key: Up,                    mode: Search,     action: SearchHistoryPrevious }
  #- { key: Down,                  mode: Search,     action: SearchHistoryNext     }
  #- { key: Return,                mode: Search|~Vi, action: SearchFocusNext       }
  #- { key: Return, mods: Shift,   mode: Search|~Vi, action: SearchFocusPrevious   }

  # (Windows, Linux, and BSD only)
  #- { key: V,              mods: Control|Shift, mode: ~Vi,        action: Paste            }
  #- { key: C,              mods: Control|dShift,                   action: Copy             }
  #- { key: F,              mods: Control|Shift, mode: ~Search,    action: SearchForward    }
  #- { key: B,              mods: Control|Shift, mode: ~Search,    action: SearchBackward   }
  #- { key: C,              mods: Control|Shift, mode: Vi|~Search, action: ClearSelection   }
  #- { key: Insert,         mods: Shift,                           action: PasteSelection   }
  #- { key: Key0,           mods: Control,                        action: ResetFontSize    }
  #- { key: Equals,         mods: Control,                         action: IncreaseFontSize }
  #- { key: Plus,           mods: Control,                         action: IncreaseFontSize }
  #- { key: NumpadAdd,      mods: Control,                         action: IncreaseFontSize }
  #- { key: Minus,          mods: Control,                         action: DecreaseFontSize }
  #- { key: NumpadSubtract, mods: Control,                         action: DecreaseFontSize }
```

## Tmux

- `~/.config/tmux/tmux.conf`

```conf tangle:~/.config/tmux/tmux.conf
set -g default-terminal "screen-256color"
set-option -ga update-environment ' PAGER VISUAL EDITOR W3M_DIR NNN_OPENER NNN_COLORS NNN_PLUG NNN_FIFO NNN_TMPFILE MANPAGER SHELL'
set -g status off
set -g status-fg white
set -g pane-active-border-style bg=default,fg=white
```

## Ncmpcpp

Player de musica

### Configuração

- `~/.config/ncmpcpp/config`

```conf tangle:~/.config/ncmpcpp/config
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

## Mimetypes

Tipos de arquivos e programa chamado para os abrir

- `~/.config/mimeapps.list`

```conf tangle:~/.config/mimeapps.list
[Added Associations]
x-scheme-handler/tg=userapp-Telegram Desktop-EJM1D1.desktop;
x-scheme-handler/magnet=transmission-gtk.desktop;
x-scheme-handler/terminal=st.desktop;
application/x.bittorrent=transmission-gtk.desktop;
application/x-troff-man=nvim.desktop;
application/x-executable=nvim.desktop;
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

## Picom

Compositor

- `~/.config/picom/picom.conf`

```conf tangle:~/.config/picom/picom.conf
shadow = false
shadow-radius = 7;
# shadow-opacity = .75
shadow-offset-x = -7;
shadow-offset-y = -7;
# no-dock-shadow = false
# shadow-red = 0
# shadow-green = 0
# shadow-blue = 0
# Do not paint shadows on shaped windows.
# Deprecated, use
#   shadow-exclude = 'bounding_shaped'
# or
#   shadow-exclude = 'bounding_shaped && !rounded_corners'
# instead.
# shadow-ignore-shaped = ''

# Specify a list of conditions of windows that should have no shadow.
# examples:
#   shadow-exclude = "n:e:Notification";
# shadow-exclude = []
shadow-exclude = [
  "name = 'Notification'",
  "class_g = 'Conky'",
  "class_g ?= 'Notify-osd'",
  "class_g = 'Cairo-clock'",
  "_GTK_FRAME_EXTENTS@:c"
];
#    shadow-exclude-reg = "x10+0+0"
# shadow-exclude-reg = ""
# xinerama-shadow-crop = false

#################################
#           Fading              #
#################################

fading = false
fade-in-step = 0.03;
# fade-out-step = 0.03
fade-out-step = 0.03;
# fade-delta = 10
# fade-exclude = []
# no-fading-openclose = false
# no-fading-destroyed-argb = false

#################################
#   Transparency / Opacity      #
#################################

inactive-opacity = 1.0;
frame-opacity = 1.0;
menu-opacity = 1.0
inactive-opacity-override = false;
active-opacity = 1.0
inactive-dim = 0.0
focus-exclude = [ "class_g = 'Cairo-clock'" ];
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

# blur-method =
# blur-size = 12
# blur-deviation = false
# blur-background = false
# blur-background-frame = false
# blur-background-fixed = false
# blur-kern = ''
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
backend = "xrender";

# Enable/disable VSync.
vsync = true

# Enable remote control via D-Bus. See the *D-BUS API* section below for more details.
# dbus = false

# Try to detect WM windows (a non-override-redirect window with no
# child that has 'WM_STATE') and mark them as active.
mark-wmwin-focused = true;

# Mark override-redirect windows that doesn't have a child window with 'WM_STATE' focused.
mark-ovredir-focused = true;

# Try to detect windows with rounded corners and don't consider them
# shaped windows. The accuracy is not very high, unfortunately.
detect-rounded-corners = false;

# Detect '_NET_WM_OPACITY' on client windows, useful for window managers
# not passing '_NET_WM_OPACITY' of client windows to frame windows.
detect-client-opacity = true;

# Specify refresh rate of the screen. If not specified or 0, picom will
# try detecting this with X RandR extension.
refresh-rate = 0

# Use 'WM_TRANSIENT_FOR' to group windows, and consider windows
# in the same group focused at the same time.
detect-transient = true

# Use 'WM_CLIENT_LEADER' to group windows, and consider windows in the same
# group focused at the same time. 'WM_TRANSIENT_FOR' has higher priority if
# detect-transient is enabled, too.
detect-client-leader = true

# Disable the use of damage information.
# This cause the whole screen to be redrawn everytime, instead of the part of the screen
# has actually changed. Potentially degrades the performance, but might fix some artifacts.
# The opposing option is use-damage
use-damage = true

# Use X Sync fence to sync clients' draw calls, to make sure all draw
# calls are finished before picom starts drawing. Needed on nvidia-drivers
# with GLX backend for some users.
# xrender-sync-fence = false

# Force all windows to be painted with blending. Useful if you
# have a glx-fshader-win that could turn opaque pixels transparent.
# force-win-blend = false

# Dimming bright windows so their brightness doesn't exceed this set value.
# Brightness of a window is estimated by averaging all pixels in the window,
# so this could comes with a performance hit.
# Setting this to 1.0 disables this behaviour. Requires --use-damage to be disabled. (default: 1.0)
# max-brightness = 1.0

# Make transparent windows clip other windows like non-transparent windows do,
# instead of blending on top of them.
# transparent-clipping = false

log-level = "warn";

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
    follow = mouse

    # The geometry of the window:
    #   [{width}]x{height}[+/-{x}+/-{y}]
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
    # Set to 0 to disable.
    idle_threshold = 120

    font = Inconsolata 13
    line_height = 1
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
    alignment = left

    # Vertical alignment of message text and icon.
    vertical_alignment = center

    # Show age of message if message is older than show_age_threshold
    # Set to -1 to disable.
    show_age_threshold = 60

    # Split notifications into multiple lines if they don't fit
    word_wrap = yes

    # When word_wrap is set to no, specify where to make an ellipsis in long lines.
    ellipsize = middle

    # Ignore newlines '\n' in notifications.
    ignore_newline = no

    # Stack together notifications with the same content
    stack_duplicates = true

    # Hide the count of stacked notifications with the same content
    hide_duplicate_count = false

    # Display indicators for URLs (U) and actions (A).
    show_indicators = yes

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

# Experimental features that may or may not work correctly.
[experimental]
    per_monitor_dpi = false

# The internal keyboard shortcut support in dunst is now considered deprecated
[shortcuts]

[urgency_low]
    background = "#000000"
    foreground = "#FFFFFF"
    timeout = 10
    # Icon for notifications with low urgency, uncomment to enable
    #icon = /path/to/icon

[urgency_normal]
    background = "#333333"
    foreground = "#FFFFFF"
    timeout = 10
    # Icon for notifications with normal urgency, uncomment to enable
    #icon = /path/to/icon

[urgency_critical]
    background = "#ff0000"
    foreground = "#ffffff"
    frame_color = "#ff0000"
    timeout = 0
    # Icon for notifications with critical urgency, uncomment to enable
    #icon = /path/to/icon
```
