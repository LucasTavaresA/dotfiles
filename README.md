# Meus dotfiles

Esse repositório tem configurações que funcionam em qualquer distro linux, Entretanto é recomendado verificar e modificar como você preferir

## Guia de instalação do meu setup do voidlinux

**Esse guia não é necessariamente feito para te ajudar a fazer uma instalação do voidlinux mais sim para me ajudar a reinstalar o meu setup,
é recomendado você mesmo instalar e configurar o sistema do zero usando a [Documentação do voidlinux](https://docs.voidlinux.org/)**

**Comandos começando com $ podem ser executados com qualquer usuário, Comandos com # necessitam de superusuário**

**Em comandos tudo que é escrito como "<exemplo>" deve ser substituído por alguma informação**

### Sumário

- [Criar mídia de instalação](#criar-mídia-de-instalação)
- [Particione o disco](#particione-o-disco)
- [Instalação do voidlinux](#instalação-do-voidlinux)
- [Pós-instalação](#pós-instalação)
    - [Repositórios](#repositórios)
    - [Superusuário](#superusuário)
    - [Microcode](#microcode)
    - [Shell](#shell)
- [Serviços](#serviços)
- [Drivers](#drivers)
- [Xorg](#xorg)
- [Tema Dracula](#tema-dracula)
- [Compilar](#compilar)

### Criar mídia de instalação

Verifique qual é o dispositivo para fazer a mídia de instalação usando `lsblk`, Dependendo do sistema use `fdisk -l`
ou verifique por um dispositivo removível usando `dmesg`

**Tenha certeza de que o dispositivo não esta montado**

Apague tudo no dispositivo usando `wipefs`, Tenha certeza de que "<dispositivo>" não é uma partição

```
# wipefs --all <dispositivo>
```

Copie a mídia de instalação para o "<dispositivo>" usando `dd`

```
# dd bs=4M if=<Local/da/iso> of=<dispositivo>
```

Para ter certeza que tudo foi transferido antes de desconectar o "<dispositivo>"

```
$ sync
```

### Particione o disco

Método sempre varia, você pode usar o `cfdisk`, `gparted`, etc.

**Recomendado criar uma partição swap e uma separada para a /home**

**Uma Partição swap deve ter o dobro de tamanho em relação a sua quantidade de memoria, Com no máximo 8GB**

### Instalação do voidlinux

**Caso sua conexão de internet seja wifi a configure usando `wpa_supplicant` antes de prosseguir**

Faça login como `root` usando a senha padrão `voidlinux`, Inicie o instalado usando `void-installer`

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

**Antes de fazer qualquer coisa atualize os repositórios**

```
# xbps-install -Su
```

- Ative o repositório não-livre instalando o pacote `void-repo-nonfree`
- Ative o repositório 32-bits instalando o pacote `void-repo-multilib` **Apenas glibc**
- Ative o repositório não-livre/32-bits instalando o pacote `void-repo-multilib-nonfree`
- Ative o repositório debug instalando o pacote `void-repo-debug`

**Atualize os repositórios novamente**

#### Superusuário

- Instale o `opendoas`
- Configure o doas editando o arquivo `/etc/doas.conf`

```
permit persist keepenv root
permit persist keepenv :wheel
permit nopass lucas cmd xbps-install args -S
```

- `sudo` é uma dependência do sistema, o torne ignorável adicionando essa linha a um arquivo `/etc/xbps.d/*.conf`

```
ignorepkg=sudo
```

- Remova o `sudo`

#### Microcode

- Para processadores intel instale o pacote `intel-ucode`
**Após instalar esse pacote atualize o initramfs usando `dracut --force`**

- Para processadores amd instale o pacote `linux-firmware-amd`

#### Shell

Troque o shell do seu usuário `chsh -s /bin/sh`

#### Clonar esse repositório

- Instale o pacote `git`

```
$ git clone https://github.com/lucastavaresa/dotfiles
```

- Transfira os arquivos para a $HOME

#### Programas

Instale todos os programas necessários em $HOME/extras/voidlinux-pkgs.txt

```
# xbps-install -S $(cat extras/voidlinux-pkgs.txt)
```

#### Serviços

- Syslog

Instale o pacote `socklog-void` e ative os serviços `socklog-unix` e `nanoklogd`

```
# ln -s /etc/sv/socklog-unix /var/service/
# ln -s /etc/sv/nanoklogd /var/service/
```

- Acpid

```
# ln -s /etc/sv/acpid /var/service/
```

- dbus

Instale o pacote `dbus` e ative o serviço `dbus`

```
# cp $HOME/extras/voidservices/dbus /etc/sv/dbus/run
# ln -s /etc/sv/dbus /var/service/
```

- userfolder

Serviço que cria a pasta temporária do usuário

```
# mkdir /etc/sv/userfolder
# cp $HOME/extras/voidservices/userfolder /etc/sv/userfolder/run
# ln -s /etc/sv/userfolder /var/service/
```

#### Drivers

Instale o pacote `xf86-video-nouveau`

### Tema Dracula

- Gtk

Instale os pacotes `gsettings-desktop-schemas`, `curl` e `unzip`

```
# git clone https://github.com/dracula/gtk.git /usr/share/themes/Dracula
# gsettings set org.gnome.desktop.interface gtk-theme "Dracula"
# gsettings set org.gnome.desktop.wm.preferences theme "Dracula"
```

E instale o pacote de icones

```
# curl -fLO https://github.com/dracula/gtk/files/5214870/Dracula.zip
# unzip Dracula.zip
# mv Dracula /usr/share/icons/
# gsettings set org.gnome.desktop.interface icon-theme "Dracula"
```

### Xorg

- Instale o pacote `xorg-minimal`
- Configure o teclado brasileiro

```
# mkdir /etc/X11/xorg.conf.d/
# cp $HOME/extras/00-keyboard.conf /etc/X11/xorg.conf.d/
```

### Compilar

- compile o st
    Dependencias: `make`, `pkg-config`, `gcc`, `fontconfig-devel`, `harfbuzz`, `harfbuzz-devel` e `libXft-devel`

- compile o dmenu
    Dependencias: `libXinerama-devel`

- compile o nsxiv
    Dependencias: `imLib2-devel`, `libwebp-devel`, `libexif-devel`,

- compile o slock
    Dependencias: `libXrandr-devel`

- compile o svkbd
    Dependencias: `libXtst-devel`
