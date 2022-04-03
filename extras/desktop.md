# Desktop

Configurações do Xorg e diversos window managers

# Sumario

- [X11](#x11)
- [Herbstluftwm](#herbstluftwm)
- [Stumpwm](#stumpwm)
- [Bspwm](#bspwm)
- [Spectrwm](#spectrwm)

## X11

Configuração do xorg

- `~/.config/x11/xinitrc`

```sh tangle:~/.config/x11/xinitrc
#!/bin/sh

# mouse
xsetroot -cursor_name left_ptr

# teclado
# troca capslock por escape
setxkbmap -option caps:escape # grep -E "(ctrl|caps):" /usr/share/X11/xkb/rules/base.lst
xset r rate 300 100 # acelera repetição de teclas

# clipmenu
systemctl --user import-environment DISPLAY
export CM_DIR="$HOME/code/shell/dmenuscripts/listas/clipmenu"
clipmenud &

# protetor de tela
xautolock -detectsleep -time 30 -locker "slock" -notify 30 -notifier "notify-send Slock -u critical -t 1800000 'BLOQUEANDO A TELA 30 SEGUNDOS'" &

mpd &
dunst &
nitrogen --restore &
nm-applet &
xbanish &
fluxgui &
megasync &
#picom &

if [ "$WM" = "herbstluftwm" ]; then
    sxhkd -c "$HOME/.config/sxhkd/sxhkd_herbstluftwm" &
    flags=" --locked"
elif [ "$WM" = "dwm" ]; then
    sxhkd -c "$HOME/.config/sxhkd/sxhkd_dwm" &
    dwmblocks &
elif [ "$WM" = "stumpwm" ]; then
    sxhkd -c "$HOME/.config/sxhkd/sxhkd_stumpwm" &
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

# atalhos do mouse
hc mousebind Super-Button1 move
hc mousebind Super-Button2 zoom
hc mousebind Super-Button3 resize

# adiciona tags no primeiro iniciar
if primeira_vez_aberto; then
    tag_names=( {1..4} )
    hc rename default "${tag_names[0]}" || true
    for i in "${!tag_names[@]}"; do
        hc add "${tag_names[$i]}"
    done
    hc detect_monitors
fi
tag_keys=( {1..4} 0 )
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

hc set frame_border_active_color '#ffffff'
hc set frame_border_normal_color '#000000'
hc set frame_bg_active_color '#111111'
hc set frame_bg_normal_color '#000000'
hc set auto_detect_panels false
hc set default_frame_layout max
hc set always_show_frame 0
hc set frame_border_width 1
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

#### Regras ####
hc unrule -F
hc rule focus=on # focar novas janelas
hc rule floatplacement=smart
# programas
hc rule class="qutebrowser" tag=1
hc rule class="firefox" tag=1
hc rule class="Emacs" tag=2
hc rule class="nvim" tag=2
hc rule class="st-256color" tag=2
hc rule class="mpv" tag=3
hc rule class="Gimp" tag=3
hc rule class="Xephyr" tag=3
hc rule class="discord" tag=4
hc rule class="TelegramDesktop" tag=4
# flutuantes
hc rule class="ncmpcpp" floating=on floatplacement=center
hc rule class="pulsemixer" floating=on floatplacement=center
hc rule class="MEGAsync" floating=on floatplacement=center
hc rule class="Transmission-gtk" floating=on floatplacement=center
hc rule class="Galculator" floating=on floatplacement=center
hc rule class="htop" floating=on floatplacement=center
# notificações, pop-ups, etc.
hc rule class="qutebrowser" windowtype='_NET_WM_WINDOW_TYPE_UTILITY' floating=on
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' floating=on floatplacement=center
hc rule windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
hc rule windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off
hc rule class="Pinentry-gtk-2" floating=on floatplacement=center

polybar &
# espera a barra carregar e esconde a barra
sleep 2 && polybar-msg cmd hide
hc unlock

```

## Stumpwm

- `~/.config/stumpwm/config`

```lisp tangle:~/.config/stumpwm/config
;;; -*-  mode: lisp; -*-
;; Módulos ;;
;; chamar módulos stumpwm:
(in-package :stumpwm)

;; módulos da comunidade
;; git clone git@github.com:stumpwm/stumpwm-contrib.git ~/.config/stumpwm/stumpwm-contrib
;; esse comando carrega todos os módulos em pastas e subpastas
(init-load-path #p"~/.config/stumpwm/modules")
;; manipular janelas em todos os grupos
(load-module "globalwindows")

;; quicklisp & sbcl
(load "~/.config/sbcl/sbclrc")
(add-to-load-path "~/.local/share/quicklisp/")

;; arquivos
(defun arquivo-disponivel-p (arquivo)
  "Retorna T, se o arquivo está disponível para leitura"
  (handler-case
      (with-open-file (f arquivo)
        (read-line f))
    (stream-error () nil)))
(defun executavel-p (nome)
  "Diz se NOME é executável"
  (let ((which-out (string-trim '(#\  #\linefeed) (run-shell-command (concat "which " nome) t))))
    (unless (string-equal "" which-out) which-out)))

;; janelas flutuantes sempre visiveis
(defun flutuante-p (janela)
  "Retorna T se JANELA é flutuante e NIL caso contrario"
  (typep janela 'stumpwm::float-window))
(defun desativa-sempre-no-topo (janela) ()
  "Desativa dada JANELA como sempre visível"
  (let ((ontop-wins (group-on-top-windows (current-group))))
    (setf (group-on-top-windows (current-group))
          (remove janela ontop-wins))))
(defun ativa-sempre-no-topo (janela) ()
  "Ativa dada JANELA como sempre visível"
  (let ((j janela)
        (janelas (group-on-top-windows (current-group))))
    (when j
      (unless (find j janelas)
        (push janela (group-on-top-windows (current-group)))))))
(defcommand alterna-flutuante () ()
  "Alterna entre janela fixa/flutuante e coloca sempre no topo"
  (let ((jan    (current-window))
        (grupo  (current-group)))
    (cond
      ((flutuante-p jan)
       (desativa-sempre-no-topo jan)
       (stumpwm::unfloat-window jan grupo))
      (t (ativa-sempre-no-topo jan)
      (stumpwm::float-window jan grupo)))))

;; mostra e esconde janelas
(defun window-menu-format (w)
  (list (format-expand *window-formatters* *window-format* w) w))
(defun window-from-menu (windows)
  (when windows
    (second (select-from-menu
             (group-screen (window-group (car windows)))
             (mapcar 'window-menu-format windows)
             "Selecionar Janela: "))))
(defun windows-in-group (group)
  (group-windows (find group (screen-groups (current-screen))
                       :key 'group-name :test 'equal)))
(defcommand mostra () ()
  (let* ((windows (windows-in-group ".Hidden"))
         (window  (window-from-menu windows)))
    (when window
      (move-window-to-group window (current-group))
      (stumpwm::pull-window window))))
(defcommand esconde () ()
  (stumpwm:run-commands "gmove .Hidden"))

;; Tema ;;
;; cores
(setf *colors*
      '("#ffffff"
        "#ff0000"
        "#00aa00"
        "#ffff00"
        "#0000ff"
        "#ff99ff"
        "#00ffbd"
        "#ffffff"))
(setf *default-bg-color* "#ff00ff")
(update-color-map (current-screen))

;; prompts e caixas de dialogo
(set-font "-xos4-terminus-bold-*-*-*-14-*-*-*-*-*-*-*")
(setf *message-window-gravity* :center
      *window-border-style* :thin
      *message-window-padding* 1
      *maxsize-border-width* 1
      *normal-border-width* 1
      *transient-border-width* 1
      stumpwm::*float-window-border* 1
      stumpwm::*float-window-title-height* 1)
(setf *input-window-gravity* :center
      *message-window-input-gravity* :left)
(setf *input-completion-show-empty* t)

;; Grupos e regras ;;
(grename "Browser")
(gnewbg "Code")
(gnewbg "Fullscreen")
(gnewbg "Message")
(gnewbg ".Hidden")

;; remove todas as regras
(clear-window-placement-rules)
;(frame-number raise lock &key create restore dump-name class instance type role title)
(define-frame-preference "Browser"
    (0 t t :class "qutebrowser")
    (0 t t :class "firefox"))
(define-frame-preference "Code"
    (0 t t :class "nvim")
    (0 t t :class "Emacs")
    (1 t t :class "st-256color"))
(define-frame-preference "Fullscreen"
    (0 t t :class "mpv")
    (0 t t :class "Gimp")
    (0 t t :class "Xephyr"))
(define-frame-preference "Message"
    (0 t t :class "discord")
    (0 t t :class "TelegramDesktop"))

;; Miscelânea ;;
(setf *mouse-focus-policy* :click)
(setf *resize-increment* 25)
(defvar *dynamic-group-master-split-ratio* 1/2)

;; para rodar comandos do shell
;;(run-shell-command "comando")

;; troca de grupos globalmente
(setf *run-or-raise-all-groups* t)

;; integração com o emacs
(defcommand emacs () () ; substitui o comando emacs padrão
  "Inicia o emacs se o client não esta rodando e foca no emacs caso esteja rodando no grupo atual"
  (run-or-raise "emacsclient -c -a 'emacs'" '(:class "Emacs")))
;; trata divisórias do emacs como janelas do xorg
(defun emacs-p (jan)
  "T se JAN é emacs"
  (when jan
    (string-equal (window-class jan) "Emacs")))
(defun eval-elisp (expressao)
  "avalia uma string como emacs-lisp"
  (run-shell-command (concat "emacsclient -e '" expressao "'") t))
(defun emacs-winmove (direcao)
  "executa a função do emacs winmove-DIRECTION onde direcao é uma string"
  (eval-elisp (concat "(windmove-" direcao ")")))
(defun melhor-move-focus (ogdir)
  "Similar ao move-focus porem trata janelas do emacs como janelas Xorg"
  (declare (type (member :up :down :left :right) ogdir))
  (flet ((mv () (move-focus ogdir)))
    (if (emacs-p (current-window))
        (when
            ;; Não tem uma janela emacs nessa direção
            (= (length (emacs-winmove
                        (string-downcase (string ogdir))))
               1)
          (mv))
        (mv))))
(defcommand my-mv (dir) ((:direction "Direção: "))
  (when dir (melhor-move-focus dir)))

(defcommand reload-config () ()
  (load "~/.config/stumpwm/config"))

;; Teclas ;;
(set-prefix-key (kbd "C-space"))
(define-key *groups-map* (kbd "d") "gnew-dynamic")
(define-key *groups-map* (kbd "s") "gselect")
(define-key *root-map* (kbd "C-space") "windowlist")
(define-key *top-map* (kbd "s-ESC") "mostra")
(define-key *top-map* (kbd "M-ESC") "esconde")

;; Final ;;
;(run-shell-command "polybar &")
;; espera a barra carregar e esconde a barra
;(run-shell-command "sleep 2 && polybar-msg cmd hide")
;; remove logs caso existam
(uiop:delete-directory-tree (pathname "~/.stumpwm.d/") :validate t)

```

## Bspwm

Gerenciador de janelas bspwm

- `~/.config/bspwm/bspwmrc`

```sh tangle:~/.config/bspwm/bspwmrc
#!/bin/sh

# monitor
bspc monitor -d 1 2 3 4 5

# configurações
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

# cores
bspc config normal_border_color           "#000000"
bspc config active_border_color           "#ffffff"
bspc config focused_border_color          "#ffffff"
bspc config presel_feedback_color         "#333333"

# regras
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

polybar &
# espera a barra carregar e esconde a barra
sleep 2 && polybar-msg cmd hide

```

## Spectrwm

Gerenciador de janelas spectrwm

- `~/.config/spectrwm/spectrwm.conf`

```conf tangle:~/.config/spectrwm/spectrwm.conf
workspace_limit   = 4
focus_mode        = manual
focus_close       = previous
focus_close_wrap  = 1
focus_default     = last
spawn_position    = next
workspace_clamp   = 1
warp_focus        = 1
warp_pointer      = 1

# decoração de janelas
border_width            = 1
color_focus             = rgb:ff/ff/ff
color_focus_maximized   = rgb:ff/ff/ff
color_unfocus           = rgb:00/00/00
color_unfocus_maximized = rgb:00/00/00
region_padding          = 0
tile_gap                = 0

# região de contenção
boundary_width = 50

# remove bordas quando ha uma janela e a barra é desativada
disable_border = 1

# barra
bar_enabled               = 0
bar_border_width          = 0
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
#bar_action                = baraction.sh
bar_action_expand         = 0
bar_enabled_ws[1]         = 0
bar_border[1]             = rgb:00/00/00
bar_border_unfocus[1]     = rgb:00/00/00
bar_color[1]              = rgb:00/00/00
bar_color_selected[1]     = rgb:ff/ff/ff
bar_font_color[1]         = rgb:ff/ff/ff

dialog_ratio      = 0.6

# nome dos workspaces
name          = ws[1]:Browse
name          = ws[2]:Code
name          = ws[3]:Fullscreen
name          = ws[4]:Message

# tecla mod
modkey = Mod4

# desabilitar programas padrão
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

# teclas
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

#### Regras ####
# remova com: quirk[class:name] = NONE
# programas
quirk[qutebrowser]     = WS[1]
quirk[Firefox]         = WS[1]
quirk[Emacs]           = WS[2]
quirk[nvim]            = WS[2]
quirk[st-256color]     = WS[2]
quirk[mpv]             = WS[3]
quirk[Gimp]            = WS[3]
quirk[Xephyr]          = WS[3]
quirk[discord]         = WS[4]
quirk[TelegramDesktop] = WS[4]
# flutuantes
quirk[ncmpcpp]          = FLOAT
quirk[pulsemixer]       = FLOAT
quirk[MEGAsync]         = FLOAT
quirk[Transmission-gtk] = FLOAT
quirk[Galculator]       = FLOAT
quirk[htop]             = FLOAT
# padrões
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
quirk[polybar:Polybar]                   = FLOAT + ANYWHERE
quirk[Xitk:Xine Window]                  = FLOAT + ANYWHERE
quirk[xine:xine Video Fullscreen Window] = FULLSCREEN + FLOAT
quirk[pcb:pcb]                           = FLOAT
```
