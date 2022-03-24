# Teclas

Teclas usando sxhkd no herbstluftwm, dwm, bspwm e spectrwm

## Sumario

-   [Herbstluftwm](#herbstluftwm)
-   [Dwm](#dwm)
-   [Bspwm](#bspwm)
-   [Nowm](#nowm)

## Herbstluftwm

- `~/.config/sxhkd/sxhkd_herbstluftwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_herbstluftwm
# abre e fecha scratchpads
super + backslash
    st_scratchpad

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
    herbstclient cycle

# muda entre as janelas
super + {Up,Down,Left,Right}
    herbstclient focus {up,down,left,right}

# troca as janelas de posição
super + shift + {Up,Down,Left,Right}
    herbstclient shift {up,down,left,right}

# muda de tags pulando tags vazias
alt + {Left, Right}
    hlwm-tagswitch {prev, next}

# muda de tags
super + alt + {Left, Right}
    herbstclient {use_index -1, use_index +1}

# muda janela de tag e a segue
alt + shift + {Left, Right}
    herbstclient {move_index -1 && hlwm-tagswitch prev, move_index +1 && hlwm-tagswitch next}

# remove divisória
super + shift + q
    herbstclient remove

# cria uma divisória
ctrl + shift + {Left,Down,Up,Right}
    herbstclient split {left, bottom, top, right}

# muda o tamanho de frames
ctrl + {Left,Down,Up,Right}
    herbstclient resize {left +0.05,down +0.05,up +0.05,right +0.05}

# troca entre layouts pulando layouts que não mudam janelas de posição
super + Escape
    herbstclient or , and . compare tags.focus.curframe_wcount = 2                   \
                     . cycle_layout +1 vertical horizontal max vertical grid    \
               , cycle_layout +1

# ncmpcpp/pulsemixer
super + {_,shift} + a
    st -g 120x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# pausa/toca musica
super + space
    mpc toggle

# anterior/proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar

# abaixar/aumentar o volume e atualizar a barra
super + {comma, period, Down, Up}
    amixer -q set Master 5%{-,+,-,+}

# st
super + shift + Return
    st & herbstclient use 2

# menu
Menu;Menu
    dmenu_run

# menu energia
Menu;Escape
    dmenu_sys

# editar
Menu;e
    dmenu_edit && herbstclient use 2

# emojis
Menu;E
    dmenu_emoji

# montar/desmontar
Menu;m
    dmenu_mont

# atalhos do sxhkd
Menu;slash
    dmenu_sxhkd

# shell History
Menu;h
    dmenu_shhistory

# htop
Menu;H
    st -g 120x30 -c htop -n htop -e htop

# passmenu
Menu;p
    passmenu --type

# picom
Menu;P
    killall picom || picom

# fluxgui
Menu;F
    killall fluxgui || fluxgui

# clipboard
Menu;c
    dmenu_clip

# calculadora
Menu;C
    galculator

# gimp
Menu;g
    gimp & herbstclient use 4

# transmission
Menu;t
    transmission-gtk

# telegram
Menu;T
    telegram-desktop & herbstclient use 5

# discord
Menu;d
    discord & herbstclient use 5

# qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml & herbstclient use 1

# anotações
Menu;a
    nvim ~/documentos/anotações.md & herbstclient use 2

# aliases
Menu;A
    dmenu_aliases

# xephyr
Menu;X
    dmenu_xephyr & herbstclient use 7

# tira print
Print
    dmenu_print
```

## Dwm

- `~/.config/sxhkd/sxhkd_dwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_dwm
# ativa/desativa a barra enquando super é segurado
Super_L + any
    dwmc togglebar
~@Super_L + any
    dwmc togglebar
Super_R + any
    dwmc togglebar
~@Super_R + any
    dwmc togglebar

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

# ncmpcpp/pulsemixer
super + {_,shift} + a
    st -g 100x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# pausa/toca musica
super + space
    mpc toggle && pkill -RTMIN+11 dwmblocks

# anterior/proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar && pkill -RTMIN+11 dwmblocks

# abaixar/aumentar o volume e atualizar a barra
super + {comma, period, Down, Up}
    amixer -q set Master 5%{-,+,-,+} && pkill -RTMIN+9 dwmblocks

# st
super + shift + Return
    st

# aparece/esconde o st
super + backslash
    st_scratchpad

# torna a janela fixa em todas as tags
super + s
    dwmc togglesticky

# monocle
super + f
    dwmc setmonocle 0

# menu
Menu;Menu
    dmenu_run

# menu energia
Menu;Escape
    dmenu_sys

# editar
Menu;e
    dmenu_edit

# emojis
Menu;E
    dmenu_emoji

# montar/desmontar
Menu;m
    dmenu_mont

# atalhos do sxhkd
Menu;slash
    dmenu_sxhkd

# shell history
Menu;h
    dmenu_shhistory

# htop
Menu;H
    st -g 100x30 -c htop -n htop -e htop

# passmenu
Menu;p
    passmenu --type

# picom
Menu;P
    killall picom || picom

# fluxgui
Menu;F
    killall fluxgui || fluxgui

# clipboard
Menu;c
    dmenu_clip

# calculadora
Menu;C
    galculator

# gimp
Menu;g
    gimp

# transmission
Menu;t
    transmission-gtk

# telegram
Menu;T
    telegram-desktop

# discord
Menu;d
    discord

# qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# anotações
Menu;a
    nvim ~/documentos/anotações.md

# aliases
Menu;A
    dmenu_aliases

# xephyr
Menu;X
    dmenu_xephyr

# tira print
Print
    dmenu_print
```

## Bspwm

- `~/.config/sxhkd/sxhkd_bspwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_bspwm
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

# menu
Menu;Menu
    dmenu_menu

# menu energia
Menu;Escape
    dmenu_sys

# editar
Menu;e
    dmenu_edit

# emojis
Menu;E
    dmenu_emoji

# ncmpcpp/pulsemixer
super + {_,shift} + a
    st -g 100x30 -c {'ncmpcpp\,ncmpcpp' -e ncmpcpp,'pulsemixer\,pulsemixer' -e pulsemixer}

# pausa/toca musica
super + space
    mpc toggle

# anterior/proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar

# abaixar/aumentar o volume e atualizar a barra
super + {comma, period}
    amixer -q set Master 5%{-,+}

# st
super + shift + Return
    st

# aparece/esconde o st
super + backslash
    st_scratchpad

# gimp
Menu;g
    gimp

# clipboard
Menu;c
    dmenu_clip

# calculadora
Menu;C
    galculator

# transmission
Menu;t
    transmission-gtk

# telegram
Menu;T
    telegram-desktop

# discord
Menu;d
    discord

# shell history
Menu;h
    dmenu_shhistory

# htop
Menu;H
    st -e htop

# passmenu
Menu;p
    passmenu --type

# picom
Menu;P
    killall picom || picom

# fluxgui
Menu;F
    killall fluxgui || fluxgui

# montar/desmontar
Menu;m
    dmenu_mont

# teclas do sxhkd
Menu;slash
    dmenu_sxhkd

# qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# anotações
Menu;a
    nvim ~/documentos/anotações.md

# aliases
Menu;A
    dmenu_aliases

# xephyr
Menu;X
    dmenu_xephyr

# tira print
Print
    dmenu_print
```

## Nowm

Caso o window manager não execute comandos

- `~/.config/sxhkd/sxhkd_nowm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_nowm
# abre e fecha scratchpads
super + backslash
    st_scratchpad

# ncmpcpp/pulsemixer
super + {_,shift} + a
    st -g 120x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# pausa/toca musica
super + space
    mpc toggle

# anterior/proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar

# abaixar/aumentar o volume e atualizar a barra
super + {comma, period, Down, Up}
    amixer -q set Master 5%{-,+,-,+}

# st
super + shift + Return
    st

# menu
Menu;Menu
    dmenu_run

# menu energia
Menu;Escape
    dmenu_sys

# editar
Menu;e
    dmenu_edit

# emojis
Menu;E
    dmenu_emoji

# montar/desmontar
Menu;m
    dmenu_mont

# atalhos do sxhkd
Menu;slash
    dmenu_sxhkd

# shell history
Menu;h
    dmenu_shhistory

# htop
Menu;H
    st -g 120x30 -c htop -n htop -e htop

# passmenu
Menu;p
    passmenu --type

# picom
Menu;P
    killall picom || picom

# fluxgui
Menu;F
    killall fluxgui || fluxgui

# clipboard
Menu;c
    dmenu_clip

# calculadora
Menu;C
    galculator

# gimp
Menu;g
    gimp

# transmission
Menu;t
    transmission-gtk

# telegram
Menu;T
    telegram-desktop

# discord
Menu;d
    discord

# qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# anotações
Menu;a
    nvim ~/documentos/anotações.md

# aliases
Menu;A
    dmenu_aliases

# xephyr
Menu;X
    dmenu_xephyr

# tira print
Print
    dmenu_print
```
