# Meus dotfiles

Esse repositório tem configurações que funcionam em qualquer distro linux, Entretanto é recomendado verificar e modificar como você preferir

## Guia de instalação do meu setup do voidlinux

**Esse guia não é necessariamente feito para te ajudar a fazer uma instalação do voidlinux mais sim para me ajudar a reinstalar o meu setup,
é recomendado você mesmo instalar e configurar o sistema do zero usando a [Documentação do voidlinux](https://docs.voidlinux.org/)**

**Comandos começando com $ podem ser executados com qualquer usuário, Comandos com # necessitam de superusuário**

**Em comandos tudo que é escrito como "\<exemplo\>" deve ser substituído por alguma informação**

### Sumário

- [Preparação](#preparação)
    - [Criar mídia de instalação](#criar-mídia-de-instalação)
    - [Particione o disco](#particione-o-disco)
- [Instalação](#instalação)
- [Pós-instalação](#pós-instalação)
    - [Repositórios](#repositórios)
    - [Clonar esse repositório](#clonar-esse-repositório)
    - [Superusuário](#superusuário)
    - [Hosts](#hosts)
    - [Microcode](#microcode)
    - [Shell](#shell)
    - [Programas](#programas)
    - [Serviços](#serviços)
    - [Drivers](#drivers)
    - [Tema Drácula](#tema-drácula)
    - [Xorg](#xorg)
    - [Compilar](#compilar)

### Preparação

#### Criar mídia de instalação

Verifique qual é o dispositivo para fazer a mídia de instalação usando `lsblk`, Dependendo do sistema use `fdisk -l`
ou verifique por um dispositivo removível usando `dmesg`

**Tenha certeza de que o dispositivo não esta montado**

Apague tudo no dispositivo usando `wipefs`, Tenha certeza de que \<dispositivo\> não é uma partição

```
# wipefs --all <dispositivo>
```

Copie a mídia de instalação para o \<dispositivo\> usando `dd`

```
# dd bs=4M if=<Local/da/iso> of=<dispositivo>
```

Para ter certeza que tudo foi transferido antes de desconectar o "\<dispositivo\>"

```
$ sync
```

#### Particione o disco

Método sempre varia, você pode usar o `cfdisk`, `gparted`, etc.

**Recomendado criar uma partição swap e uma separada para a /home**

**Uma Partição swap deve ter o dobro de tamanho em relação a sua quantidade de memoria, Com no máximo 8GB**

### Instalação

**Caso sua conexão de internet seja wifi a configure usando `wpa_supplicant` antes de prosseguir**

Faça login como `root` usando a senha padrão `voidlinux`, Inicie o instalador usando `void-installer`

- Teclado: `br-abnt2`
- Internet: `dhcp` apenas confirme
- Fonte: instalar usando a iso ou baixar os pacotes mais atualizados
- Hostname: deve ser um nome sem espaços e letras maiúsculas
- Horário: `América` -> `São Paulo`
- Senha do superusuário
- Usuário: Insira um nome, descrição, senha e adicione o usuário ao grupo `storage` para ter acesso a mídias removíveis
- Bootloader: Instalar um bootloader
- Particionar: Particione os discos
- Sistema de arquivos: Formate ou configure partições do sistema
- Verifique as suas escolhas em `Settings` e comece a instalação
- Reinicie o computador

### Pós-instalação

#### Repositórios

**Antes de fazer qualquer coisa atualize os pacotes e repositórios**

```
# xbps-install -Su
```

- Ative o repositório não-livre instalando o pacote `void-repo-nonfree`
- Ative o repositório 32-bits instalando o pacote `void-repo-multilib` **Apenas glibc**
- Ative o repositório não-livre/32-bits instalando o pacote `void-repo-multilib-nonfree`
- Ative o repositório debug instalando o pacote `void-repo-debug`

**Atualize novamente**

#### Clonar esse repositório

```
# xbps-install -S git
$ git clone --recurse-submodules https://github.com/lucastavaresa/dotfiles
```

- Transfira os arquivos para `~`

#### Superusuário

- Instale o `opendoas`

```
# cp ~/extras/doas.conf /etc/doas.conf
```

- `sudo` é uma dependência do sistema, o torne ignorável criando um arquivo `/etc/xbps.d/*.conf`

```
ignorepkg=sudo
```

- Remova o `sudo`

#### Hosts

Copie `~/extras/hosts` para `/etc/hosts` e modifique de acordo com o hostname

#### Microcode

- Para processadores intel instale o pacote `intel-ucode`
**Após instalar esse pacote atualize o initramfs usando `dracut --force`**

- Para processadores amd instale o pacote `linux-firmware-amd`

#### Shell

- Troque o shell do seu usuário `chsh -s /bin/sh`

- Coloque `. $HOME/.config/shell/bashrc` no final de `/etc/bash/bashrc`

#### Programas

Instale todos os programas necessários em `~/extras/voidlinux-pkgs.txt`

```
# xbps-install -S $(cat ~/extras/voidlinux-pkgs.txt)
```

#### Serviços

- Syslog

```
# xbps-install -S socklog-void
# ln -s /etc/sv/socklog-unix /var/service/
# ln -s /etc/sv/nanoklogd /var/service/
```

- Acpid

```
# ln -s /etc/sv/acpid /var/service/
```

- dbus

```
# xbps-install -S dbus
# cp ~/extras/voidservices/dbus /etc/sv/dbus/run
# ln -s /etc/sv/dbus /var/service/
```

- userfolder

Serviço que cria a pasta temporária do usuário

```
# mkdir /etc/sv/userfolder
# cp ~/extras/voidservices/userfolder /etc/sv/userfolder/run
# ln -s /etc/sv/userfolder /var/service/
```

#### Drivers

Instale o pacote `xf86-video-nouveau`

#### Cheatsheets

```
# git clone git@github.com:cheat/cheatsheets.git /usr/share/cheat/cheatsheets/community
```

#### Tema

- Gtk Drácula

```
# xbps-install -S gsettings-desktop-schemas, curl e unzip
# git clone https://github.com/dracula/gtk.git /usr/share/themes/Dracula
# cp -rf /usr/share/themes/Dracula/kde/cursors/Dracula-cursors /usr/share/icons/Dracula-cursors
$ gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
$ gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
$ curl -fLO https://github.com/dracula/gtk/files/5214870/Dracula.zip
$ unzip Dracula.zip
# mv Dracula /usr/share/icons/
$ gsettings set org.gnome.desktop.interface icon-theme "Dracula"
```

- qt5 Drácula

Instale o qt5ct o abra e ajuste o tema

```
# xbps-install -S qt5ct
```

- qt Drácula

```
# xbps-install -S kvantum cmake extra-cmake-modules kdecoration qt5-declarative qt5-x11extras
$ git clone https://github.com/nopain2110/Yet-another-dracula.git
$ cd Yet-another-dracula/Yet-another-dracula
$ cp color-schemes ~/.local/share/color-schemes
$ cp plasma ~/.local/share/plasma
$ cp sddm ~/.local/share/sddm
```

Abra o kvantummanager e o configure

- Emojis ttf-joypixels

```
# xbps-install -S zstd tar
$ curl -fLO https://america.mirror.pkgbuild.com/community/os/x86_64/ttf-joypixels-6.6.0-2-any.pkg.tar.zst
$ unzstd ttf-joypixels-6.6.0-2-any.pkg.tar.zst
$ mkdir ttf-joypixels
$ tar -xf ttf-joypixels-6.6.0-2-any.pkg.tar -C ttf-joypixels
# mv ttf-joypixels/usr/share/fonts/joypixels/ /usr/share/fonts/
```

#### Xorg

- Instale o pacote `xorg-minimal`
- Configure o teclado brasileiro

```
# mkdir /etc/X11/xorg.conf.d/
# cp ~/extras/00-keyboard.conf /etc/X11/xorg.conf.d/
```

#### Compilar

- Baixe o clipmenud

```
# xbps-install clipnotify xsel
$ git clone git@github.com:cdown/clipmenu.git
$ mv clipmenu/clip* .local/bin
```

- compile o devour

```
$ git clone https://github.com/salman-abedin/devour.git
$ cd devour
# make install
```

- compile libxft-bgra

```
# xbps-install xorg-util-macros autoconf automake libtool
$ git clone https://github.com/uditkarode/libxft-bgra
$ cd libxft-bgra
# sh autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
# make install
```

- compile o st

```
# xbps-install -S make pkg-config gcc fontconfig-devel harfbuzz harfbuzz-devel libXft-devel
$ cd code/c/st
# make install
```

- compile o dmenu

```
# xbps-install -S libXinerama-devel
$ cd ../dmenu
# make install
```

- compile o nsxiv

```
# xbps-install -S imLib2-devel libwebp-devel libexif-devel
$ cd ../nsxiv
# make install
```

- compile o slock

```
# xbps-install -S libXrandr-devel
$ cd ../slock
# make install
```

- compile o svkbd

```
# xbps-install -S libXtst-devel
$ cd ../svkbd
# make install
```
