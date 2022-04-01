# Teclas

Teclas usando sxhkd no herbstluftwm, dwm, bspwm e spectrwm

## Sumario

-   [Herbstluftwm](#herbstluftwm)
-   [Dwm](#dwm)
-   [Stumpwm](#stumpwm)
-   [Bspwm](#bspwm)
-   [Nowm](#nowm)

## Herbstluftwm

- `~/.config/sxhkd/sxhkd_herbstluftwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_herbstluftwm
#### HERBSTLUFTWM ####
# fecha janela
super + q
    herbstclient close

# alterna tela cheia
super + f
    herbstclient fullscreen

# alterna janela flutuante
super + w
    herbstclient attr clients.focus.floating toggle

# alterna entre as janelas
super + Tab
    herbstclient cycle_all +1

# troca as janelas de posição
super + shift + {Up,Down,Left,Right}
    herbstclient shift {up,down,left,right}

# muda de tags
super + {Left,Right}
    herbstclient {use_index -1, use_index +1}

# muda janela de tag e a segue
super + alt + {Left,Right}
    herbstclient {move_index -1 && herbstclient use_index -1,move_index +1 && herbstclient use_index +1}

# remove divisória
super + shift + q
    herbstclient remove

# cria uma divisória
ctrl + shift + {Left,Down,Up,Right}
    herbstclient split {left, bottom, top, right}

# muda o tamanho de frames
ctrl + super + {Left,Down,Up,Right}
    herbstclient resize {left +0.05,down +0.05,up +0.05,right +0.05}

# troca entre layouts pulando layouts que não mudam janelas de posição
super + Escape
    herbstclient or , and . compare tags.focus.curframe_wcount = 2                   \
                     . cycle_layout +1 vertical horizontal max vertical grid    \
               , cycle_layout +1

# ativa/desativa a barra enquando super é segurado
Super_L + any
    polybar-msg cmd toggle
~@Super_L + any
    polybar-msg cmd toggle
Super_R + any
    polybar-msg cmd toggle
~@Super_R + any
    polybar-msg cmd toggle

# ativa/desativa a barra
super + b
    polybar-msg cmd toggle

# reinicia a barra
Menu;b
    polybar-msg cmd restart

```

## Stumpwm

- `~/.config/sxhkd/sxhkd_stumpwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_stumpwm
#### STUMPWM ####
# remove frame
super + shift + q
    stumpish remove

# Muda de grupo
super + {Left,Right}
    stumpish g{prev,next}

# Muda a janela de grupo
super + shift + {Left,Right}
    stumpish g{prev-with-window,next-with-window}

# cria frame vertical/horizontal
ctrl + super + {Down,Right}
    stumpish {vsplit,hsplit}

# muda o tamanho de frames
ctrl + shift {Up,Down,Left,Right}
    stumpish resize-direction {up,down,left,right}

# move o foco entre frames e leva o cursor ao frame
super + {Up,Down,Left,Right}
    stumpish my-mv {up,down,left,right}

# move a janela
super + shift {Up,Down,Left,Right}
    stumpish move-window {up,down,left,right}

# Proxima janela
super + Tab
    stumpish pull-hidden-next

# fechar janela
super + q
    stumpish delete-window

# janela flutuante
super + w
    stumpish alterna-flutuante

# tela cheia
super + f
    stumpish fullscreen

# ativa/desativa a barra enquando super é segurado
Super_L + any
    polybar-msg cmd toggle
~@Super_L + any
    polybar-msg cmd toggle
Super_R + any
    polybar-msg cmd toggle
~@Super_R + any
    polybar-msg cmd toggle

# ativa/desativa a barra
super + b
    polybar-msg cmd toggle

# reinicia a barra
Menu;b
    polybar-msg cmd restart

```

## Dwm

- `~/.config/sxhkd/sxhkd_dwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_dwm
#### DWM ####
# ativa/desativa a barra
super + b
    dwmc togglebar

# muda o tamanho da janela
ctrl + super + {Left,Right}
    dwmc setmfact {-,+}0.05

# muda o tamanho da janela
ctrl + super + {Down,Up}
    dwmc setcfact {-,+}0.20

# muda entre as janelas
super + Tab
    dwmc focusstack +1

# muda de tag
super + {Left, Right}
    dwmc {viewprev, viewnext}

# troca a janela de tag
super + shift {Left, Right}
    dwmc {tagtoprev, tagtonext}

# fecha uma janela
super + shift + backslash
    dwmc killclient

# alterna janela flutuante
super + w
    dwmc togglefloating

# troca todas as janelas de posição
super + Return
    dwmc inplacerotate +2

# troca entre layouts
super + Escape
    dwmc layoutscroll +1

# torna a janela fixa em todas as tags
super + s
    dwmc togglesticky

# monocle
super + f
    dwmc setmonocle 0

# ativa/desativa a barra enquando super é segurado
Super_L + any
    dwmc togglebar
~@Super_L + any
    dwmc togglebar
Super_R + any
    dwmc togglebar
~@Super_R + any
    dwmc togglebar

```

## Bspwm

- `~/.config/sxhkd/sxhkd_bspwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_bspwm
#### BSPWM ####
# fecha janela
super + shift + backslash
    bspc node -c

# troca janela selecionada pela maior janela
super + Return
    bspc node -s biggest.window

# troca entre layout monocle e tiled
super + Escape
    bspc desktop -l next

# troca o foco para a janela anterior
super + Left
    bspc node -f prev.local.!hidden.window

# troca o foco para a proxima janela
super + {Right,Tab}
    bspc node -f next.local.!hidden.window

# alterna entre ou muda janela para um desktop
super + {_,shift + }{1-9,0}
    bspc {desktop -f,node -d} '^{1-9,10}'

# move janela para o espaço preselecionado
super + ctrl + Return
    bspc node -n last.!automatic

# preseleciona uma direção
super + ctrl + {Left,Down,Up,Right}
    bspc node -p {west,south,north,east}

# cancela seleção
ctrl + space
    bspc node -p cancel

# muda o tamanho das janelas
ctrl + {Left,Down,Up,Right}
    {bspc node @parent/second -z left -20 0; \
     bspc node @parent/first -z right -20 0, \
     bspc node @parent/second -z top 0 +20; \
     bspc node @parent/first -z bottom 0 +20, \
     bspc node @parent/first -z bottom 0 -20; \
     bspc node @parent/second -z top 0 -20, \
     bspc node @parent/first -z right +20 0; \
     bspc node @parent/second -z left +20 0}

# alterna entre janela flutuante
super + t
    bspc node -t \~floating

# alterna tela cheia
Menu;f
    bspc node -t \~fullscreen

# ajusta proporção da janela selecionada
shift + Tab
    ajustar_tamanho.sh

# ativa/desativa a barra enquando super é segurado
Super_L + any
    polybar-msg cmd toggle
~@Super_L + any
    polybar-msg cmd toggle
Super_R + any
    polybar-msg cmd toggle
~@Super_R + any
    polybar-msg cmd toggle

# ativa/desativa a barra
super + b
    polybar-msg cmd toggle

# reinicia a barra
Menu;b
    polybar-msg cmd restart

```

## Independente

Teclas que funcionarão independente do window manager,

- `~/.config/sxhkd/sxhkd_nowm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_nowm,~/.config/sxhkd/sxhkd_bspwm,~/.config/sxhkd/sxhkd_dwm,~/.config/sxhkd/sxhkd_stumpwm,~/.config/sxhkd/sxhkd_herbstluftwm
#### INDENPENDENTE ####
# Terminal #
# st
super + shift + Return
    st & [ "$WM" = "herbstluftwm" ] && herbstclient use 2
# abre e fecha scratchpads
super + backslash
    st_scratchpad

# Musica #
# pausa/toca musica e atualiza a barra no dwm
super + space
    mpc toggle & [ "$WM" = "dwm" ] && pkill -RTMIN+11 dwmblocks
# anterior/proxima musica e atualiza a barra no dwm
super + shift + {comma, period}
    mpc {prev,next} && musica notificar & [ "$WM" = "dwm" ] && pkill -RTMIN+11 dwmblocks
# abaixar/aumentar o volume e atualiza a barra no dwm
super + {comma, period}
    amixer -q set Master 5%{-,+,-,+} & [ "$WM" = "dwm" ] && pkill -RTMIN+9 dwmblocks
# ncmpcpp/pulsemixer
super + {_,shift} + a
    st -g 120x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# Dmenus #
# dmenu_run
Menu;Menu
    dmenu_run
# dmenu_sys
Menu;Escape
    dmenu_sys
# dmenu_wifi
Menu;w
    dmenu_wifi
# dmenu_edit
Menu;e
    dmenu_edit && [ "$WM" = "herbstluftwm" ] && herbstclient use 2
# dmenu_emoji
Menu;E
    dmenu_emoji
# dmenu_mont
Menu;m
    dmenu_mont
# dmenu_sxhkd
Menu;slash
    dmenu_sxhkd
# dmenu_shhistory
Menu;h
    dmenu_shhistory
# passmenu
Menu;p
    passmenu --type
# dmenu_clip
Menu;c
    dmenu_clip
# dmenu_qutebrowser
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml & [ "$WM" = "herbstluftwm" ] && herbstclient use 1
# dmenu_aliases
Menu;A
    dmenu_aliases
# dmenu_xephyr
Menu;x
    dmenu_xephyr & [ "$WM" = "herbstluftwm" ] && herbstclient use 7
# dmenu_print
Print
    dmenu_print

# Outros #
# htop
Menu;H
    st -g 120x30 -c htop -n htop -e htop
# picom
Menu;P
    killall picom || picom
# fluxgui
Menu;F
    killall fluxgui || fluxgui
# calculadora
Menu;C
    galculator
# transmission
Menu;t
    transmission-gtk
# anotações
Menu;a
    nvim ~/documentos/anotações.md & [ "$WM" = "herbstluftwm" ] && herbstclient use 2

```
