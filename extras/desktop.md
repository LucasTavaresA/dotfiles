# Desktop

Configurações do Xorg e diversos window managers

# Sumario

- [X11](#x11)
- [Herbstluftwm](#herbstluftwm)
- [Bspwm](#bspwm)
- [Spectrwm](#spectrwm)

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

## Bspwm

Gerenciador de janelas bspwm

- `~/.config/bspwm/bspwmrc`

```sh tangle:~/.config/bspwm/bspwmrc
#!/bin/sh

# Monitor
bspc monitor -d 1 2 3 4 5

# Configurações
bspc config border_width            1
bspc config window_gap              0
bspc config top_padding             0
bspc config bottom_padding          0
bspc config left_padding            0
bspc config right_padding           0
bspc config split_ratio             0.50
bspc config borderless_monocle      true
bspc config gapless_monocle         true
bspc config pointer_modifier        mod4
bspc config pointer_action1         move
bspc config click_to_focus          any
bspc config single_monocle          true

# Cores
bspc config normal_border_color           "#000000"
bspc config active_border_color           "#ffffff"
bspc config focused_border_color          "#ffffff"
bspc config presel_feedback_color         "#333333"

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

## Spectrwm

Gerenciador de janelas spectrwm

- `~/.config/spectrwm/spectrwm.conf`

```conf tangle:~/.config/spectrwm/spectrwm.conf
workspace_limit   = 5
focus_mode        = manual
focus_close       = previous
focus_close_wrap  = 1
focus_default     = last
spawn_position    = next
workspace_clamp   = 1
warp_focus        = 1
warp_pointer      = 1

# Decoração de janelas
border_width            = 1
color_focus             = rgb:ff/ff/ff
color_focus_maximized   = rgb:ff/ff/ff
color_unfocus           = rgb:00/00/00
color_unfocus_maximized = rgb:00/00/00
region_padding          = 0
tile_gap                = 1

# Região de contenção
boundary_width = 50

# Remove bordas quando ha uma janela e a barra é desativada
disable_border = 1

# Barra
bar_enabled               = 0
bar_border_width          = 1
bar_font_color_selected   = rgb:00/00/00
bar_font                  = Fira Code:pixelsize=12:antialias=true
bar_font_pua              = symbols nerd font:pixelsize=14:antialias=true
bar_justify               = center
bar_format                = +N:+I +S <+D>+4< | %a %d/%m/%Y - %H:%M | +8<+A+4<+V
workspace_indicator       = listcurrent,listactive,listurgent,markcurrent,markurgent,printnames
bar_at_bottom             = 1
stack_enabled             = 1
clock_enabled             = 1
clock_format              = %a %d/%m/%Y - %H:%M
iconic_enabled            = 1
maximize_hide_bar         = 1
window_class_enabled      = 1
window_instance_enabled   = 1
window_name_enabled       = 1
verbose_layout            = 1
urgent_enabled            = 1
urgent_collapse           = 1
bar_action                = baraction.sh
bar_action_expand         = 0
bar_enabled_ws[1]         = 1
bar_border[1]             = rgb:00/00/00
bar_border_unfocus[1]     = rgb:00/00/00
bar_color[1]              = rgb:00/00/00
bar_color_selected[1]     = rgb:ff/ff/ff
bar_font_color[1]         = rgb:ff/ff/ff

dialog_ratio      = 0.6

# Nome dos workspaces
name          = ws[1]:Browse
name          = ws[2]:Edit
name          = ws[3]:Watch
name          = ws[4]:Image
name          = ws[5]:Message

# Tecla mod
modkey = Mod4

# Desabilitar programas padrão
bind[] = MOD+Shift+Delete
bind[] = MOD+Shift+Return
bind[] = MOD+p
bind[] = MOD+q
bind[] = MOD+r
bind[] = MOD+f
bind[] = MOD+Escape
bind[] = MOD+Left
bind[] = MOD+Right
bind[] = MOD+w
bind[] = Mod1+Left
bind[] = Mod1+Right
bind[] = Mod1+Shift+Right
bind[] = Mod1+Shift+Left
bind[] = MOD+Mod1+Left
bind[] = MOD+Mod1+Right
bind[] = MOD+Return

# Teclas
bind[wind_del]          = MOD+q
bind[restart]           = MOD+r
bind[fullscreen_toggle] = MOD+f
bind[cycle_layout]      = MOD+Escape
bind[master_shrink]     = MOD+Left
bind[master_grow]       = MOD+Right
bind[float_toggle]      = MOD+w
bind[ws_prev]           = Mod1+Left
bind[ws_next]           = Mod1+Right
bind[ws_next_move]      = Mod1+Shift+Right
bind[ws_prev_move]      = Mod1+Shift+Left
bind[ws_prev_all]       = MOD+Mod1+Left
bind[ws_next_all]       = MOD+Mod1+Right
bind[swap_next]         = MOD+Return

# Regras
# remova com: quirk[class:name] = NONE
# Programas
quirk[qutebrowser]     = WS[1]
quirk[Firefox]         = WS[1]
quirk[Emacs]           = WS[2]
quirk[nvim]            = WS[2]
quirk[mpv]             = WS[3]
quirk[Gimp]            = WS[4]
quirk[discord]         = WS[5]
quirk[TelegramDesktop] = WS[5]
# Flutuantes
quirk[ncmpcpp]          = FLOAT
quirk[pulsemixer]       = FLOAT
quirk[MEGAsync]         = FLOAT
quirk[Transmission-gtk] = FLOAT
quirk[Galculator]       = FLOAT
quirk[htop]             = FLOAT
# Padrões
quirk[MPlayer:xv]                        = FLOAT + FULLSCREEN + FOCUSPREV
quirk[OpenOffice.org 2.4:VCLSalFrame]    = FLOAT
quirk[OpenOffice.org 3.0:VCLSalFrame]    = FLOAT
quirk[OpenOffice.org 3.1:VCLSalFrame]    = FLOAT
quirk[Firefox-bin:firefox-bin]           = TRANSSZ
quirk[Firefox:Dialog]                    = FLOAT
quirk[Gimp:gimp]                         = FLOAT + ANYWHERE
quirk[XTerm:xterm]                       = XTERM_FONTADJ
quirk[xine:Xine Window]                  = FLOAT + ANYWHERE
quirk[Xitk:Xitk Combo]                   = FLOAT + ANYWHERE
quirk[xine:xine Panel]                   = FLOAT + ANYWHERE
quirk[Xitk:Xine Window]                  = FLOAT + ANYWHERE
quirk[xine:xine Video Fullscreen Window] = FULLSCREEN + FLOAT
quirk[pcb:pcb]                           = FLOAT
```
