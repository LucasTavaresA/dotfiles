# Teclas

Teclas usando sxhkd no spectrwm, herbstluftwm, dwm e bspwm

## Sumario

-   [Herbstluftwm](#herbstluftwm)
-   [Dwm](#dwm)
-   [Bspwm](#bspwm)
-   [Spectrwm](#spectrwm)

## Herbstluftwm

- `~/.config/sxhkd/sxhkd_herbstluftwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_herbstluftwm
# Abre e fecha scratchpads
super + backslash
    st_scratchpad

# Fecha janela
super + q
    herbstclient close

# Alterna tela cheia
super + f
    herbstclient fullscreen

# Alterna janela flutuante
super + w
    herbstclient attr clients.focus.floating toggle

# Alterna entre as janelas
super + Tab
    herbstclient cycle

# Muda entre as janelas
super + {Up,Down,Left,Right}
    herbstclient focus {up,down,left,right}

# Troca as janelas de posição
super + shift + {Up,Down,Left,Right}
    herbstclient shift {up,down,left,right}

# Muda de tags pulando tags vazias
alt + {Left, Right}
    hlwm-tagswitch {prev, next}

# Muda de tags
super + alt + {Left, Right}
    herbstclient {use_index -1, use_index +1}

# Muda janela de tag e a segue
alt + shift + {Left, Right}
    herbstclient {move_index -1 && hlwm-tagswitch prev, move_index +1 && hlwm-tagswitch next}

# Remove divisória
super + shift + q
    herbstclient remove

# Cria uma divisória
ctrl + super + {Left,Down,Up,Right}
    herbstclient split {left, bottom, top, right}

# Muda o tamanho de frames
ctrl + {Left,Down,Up,Right}
    herbstclient resize {left +0.05,down +0.05,up +0.05,right +0.05}

# Troca entre layouts pulando layouts que não mudam janelas de posição
super + Escape
    herbstclient or , and . compare tags.focus.curframe_wcount = 2                   \
                     . cycle_layout +1 vertical horizontal max vertical grid    \
               , cycle_layout +1

# Ncmpcpp/Pulsemixer
super + {_,shift} + a
    st -g 120x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# Pausa/Toca musica
super + space
    mpc toggle

# Anterior/Proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar

# Abaixar/Aumentar o volume e atualizar a barra
super + {comma, period, Down, Up}
    amixer -q set Master 5%{-,+,-,+}

# St
super + shift + Return
    st

# Menu
Menu;Menu
    dmenu_run

# Menu energia
Menu;Escape
    dmenu_sys

# Editar
Menu;e
    dmenu_edit

# Emojis
Menu;E
    dmenu_emoji

# Montar/Desmontar
Menu;m
    dmenu_mont

# Atalhos do sxhkd
Menu;slash
    dmenu_sxhkd

# Shell History
Menu;h
    dmenu_shhistory

# Htop
Menu;H
    st -g 120x30 -c htop -n htop -e htop

# Passmenu
Menu;p
    passmenu --type

# Picom
Menu;P
    killall picom || picom

# Fluxgui
Menu;F
    killall fluxgui || fluxgui

# Clipboard
Menu;c
    dmenu_clip

# Calculadora
Menu;C
    galculator

# Gimp
Menu;g
    gimp

# Transmission
Menu;t
    transmission-gtk

# Telegram
Menu;T
    telegram-desktop

# Discord
Menu;d
    discord

# Qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# Anotações
Menu;a
    nvim ~/documentos/anotações.md

# Aliases
Menu;A
    dmenu_aliases

# Tira print
Print
    dmenu_print
```

## Dwm

- `~/.config/sxhkd/sxhkd_dwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_dwm
# Ativa/Desativa a barra enquando super é segurado
Super_L + any
    dwmc togglebar
~@Super_L + any
    dwmc togglebar
Super_R + any
    dwmc togglebar
~@Super_R + any
    dwmc togglebar

# Ativa/Desativa a barra
super + b
    dwmc togglebar

# Muda o tamanho da janela
ctrl + super + {Left,Right}
    dwmc setmfact {-,+}0.05

# Muda o tamanho da janela
ctrl + super + {Down,Up}
    dwmc setcfact {-,+}0.20

# Muda entre as janelas
super + Tab
    dwmc focusstack +1

# Muda de tag
super + {Left, Right}
    dwmc {viewprev, viewnext}

# Troca a janela de tag
super + shift {Left, Right}
  dwmc {tagtoprev, tagtonext}

# Fecha uma janela
super + shift + backslash
    dwmc killclient

# Alterna janela flutuante
super + w
    dwmc togglefloating

# troca todas as janelas de posição
super + Return
    dwmc inplacerotate +2

# Troca entre layouts
super + Escape
    dwmc layoutscroll +1

# Ncmpcpp/Pulsemixer
super + {_,shift} + a
    st -g 100x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# Pausa/Toca musica
super + space
    mpc toggle && pkill -RTMIN+11 dwmblocks

# Anterior/Proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar && pkill -RTMIN+11 dwmblocks

# Abaixar/Aumentar o volume e atualizar a barra
super + {comma, period, Down, Up}
    amixer -q set Master 5%{-,+,-,+} && pkill -RTMIN+9 dwmblocks

# St
super + shift + Return
    st

# Aparece/Esconde o st
super + backslash
    st_scratchpad

# Torna a janela fixa em todas as tags
super + s
    dwmc togglesticky

# Monocle
super + f
    dwmc setmonocle 0

# Menu
Menu;Menu
    dmenu_run

# Menu energia
Menu;Escape
    dmenu_sys

# Editar
Menu;e
    dmenu_edit

# Emojis
Menu;E
    dmenu_emoji

# Montar/Desmontar
Menu;m
    dmenu_mont

# Atalhos do sxhkd
Menu;slash
    dmenu_sxhkd

# Shell History
Menu;h
    dmenu_shhistory

# Htop
Menu;H
    st -g 100x30 -c htop -n htop -e htop

# Passmenu
Menu;p
    passmenu --type

# Picom
Menu;P
    killall picom || picom

# Fluxgui
Menu;F
    killall fluxgui || fluxgui

# Clipboard
Menu;c
    dmenu_clip

# Calculadora
Menu;C
    galculator

# Gimp
Menu;g
    gimp

# Transmission
Menu;t
    transmission-gtk

# Telegram
Menu;T
    telegram-desktop

# Discord
Menu;d
    discord

# Qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# Anotações
Menu;a
    nvim ~/documentos/anotações.md

# Aliases
Menu;A
    dmenu_aliases

# Tira print
Print
    dmenu_print
```

## Bspwm

- `~/.config/sxhkd/sxhkd_bspwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_bspwm
# Fecha janela
super + shift + backslash
    bspc node -c

# Troca janela selecionada pela maior janela
super + Return
    bspc node -s biggest.window

# Troca entre layout monocle e tiled
super + Escape
    bspc desktop -l next

# Troca o foco para a janela anterior
super + Left
    bspc node -f prev.local.!hidden.window

# Troca o foco para a proxima janela
super + {Right,Tab}
    bspc node -f next.local.!hidden.window

# Alterna entre ou muda janela para um desktop
super + {_,shift + }{1-9,0}
    bspc {desktop -f,node -d} '^{1-9,10}'

# Move janela para o espaço preselecionado
super + ctrl + Return
    bspc node -n last.!automatic

# Preseleciona uma direção
super + ctrl + {Left,Down,Up,Right}
    bspc node -p {west,south,north,east}

# Cancela seleção
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

# Alterna entre janela flutuante
super + t
    bspc node -t \~floating

# Alterna tela cheia
Menu;f
    bspc node -t \~fullscreen

# Ajusta proporção da janela selecionada
shift + Tab
    ajustar_tamanho.sh

# Menu
Menu;Menu
    dmenu_menu

# Menu energia
Menu;Escape
    dmenu_sys

# Editar
Menu;e
    dmenu_edit

# Emojis
Menu;E
    dmenu_emoji

# Ncmpcpp/Pulsemixer
super + {_,shift} + a
    st -g 100x30 -c {'ncmpcpp\,ncmpcpp' -e ncmpcpp,'pulsemixer\,pulsemixer' -e pulsemixer}

# Pausa/Toca musica
super + space
    mpc toggle

# Anterior/Proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar

# Abaixar/Aumentar o volume e atualizar a barra
super + {comma, period}
    amixer -q set Master 5%{-,+}

# St
super + shift + Return
    st

# Aparece/Esconde o st
super + backslash
    st_scratchpad

# Gimp
Menu;g
    gimp

# Clipboard
Menu;c
    dmenu_clip

# Calculadora
Menu;C
    galculator

# Transmission
Menu;t
    transmission-gtk

# Telegram
Menu;T
    telegram-desktop

# Discord
Menu;d
    discord

# Shell History
Menu;h
    dmenu_shhistory

# Htop
Menu;H
    st -e htop

# Passmenu
Menu;p
    passmenu --type

# Picom
Menu;P
    killall picom || picom

# Fluxgui
Menu;F
    killall fluxgui || fluxgui

# Montar/Desmontar
Menu;m
    dmenu_mont

# Teclas do sxhkd
Menu;slash
    dmenu_sxhkd

# Qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# Anotações
Menu;a
    nvim ~/documentos/anotações.md

# Aliases
Menu;A
    dmenu_aliases

# Tira print
Print
    dmenu_print
```

## Spectrwm

- `~/.config/sxhkd/sxhkd_spectrwm`

```sxhkdrc tangle:~/.config/sxhkd/sxhkd_spectrwm
# Abre e fecha scratchpads
super + backslash
    st_scratchpad

# Ncmpcpp/Pulsemixer
super + {_,shift} + a
    st -g 120x30 -c {ncmpcpp -n ncmpcpp -e ncmpcpp,pulsemixer -n pulsemixer -e pulsemixer}

# Pausa/Toca musica
super + space
    mpc toggle

# Anterior/Proxima musica
super + shift + {comma, period}
    mpc {prev,next} && musica notificar

# Abaixar/Aumentar o volume e atualizar a barra
super + {comma, period, Down, Up}
    amixer -q set Master 5%{-,+,-,+}

# St
super + shift + Return
    st

# Menu
Menu;Menu
    dmenu_run

# Menu energia
Menu;Escape
    dmenu_sys

# Editar
Menu;e
    dmenu_edit

# Emojis
Menu;E
    dmenu_emoji

# Montar/Desmontar
Menu;m
    dmenu_mont

# Atalhos do sxhkd
Menu;slash
    dmenu_sxhkd

# Shell History
Menu;h
    dmenu_shhistory

# Htop
Menu;H
    st -g 120x30 -c htop -n htop -e htop

# Passmenu
Menu;p
    passmenu --type

# Picom
Menu;P
    killall picom || picom

# Fluxgui
Menu;F
    killall fluxgui || fluxgui

# Clipboard
Menu;c
    dmenu_clip

# Calculadora
Menu;C
    galculator

# Gimp
Menu;g
    gimp

# Transmission
Menu;t
    transmission-gtk

# Telegram
Menu;T
    telegram-desktop

# Discord
Menu;d
    discord

# Qutebrowser, pesquisa e favoritos
Menu;q
    dmenu_qutebrowser ~/code/shell/dmenuscripts/listas/favoritos.yaml

# Anotações
Menu;a
    nvim ~/documentos/anotações.md

# Aliases
Menu;A
    dmenu_aliases

# Tira print
Print
    dmenu_print
```
