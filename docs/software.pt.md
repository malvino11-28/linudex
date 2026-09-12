# Configuração de software

[English](software.md)

Este documento registra a pilha de software utilizada para atingir o marco de desktop Linux do Linudex v0.1.

## Pilha final da v0.1

```text
Android 12 / One UI 4.1
├── Samsung DeX
└── Termux (build do F-Droid)
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian 13 ARM64 (`linudex`)
            └── XFCE
```

## 1. Host Termux

O Termux foi instalado pelo F-Droid. O ambiente host foi atualizado e os pacotes principais foram instalados:

```bash
pkg update
pkg upgrade -y
pkg install -y git curl wget nano openssh proot-distro
```

A arquitetura do aparelho foi confirmada com:

```bash
uname -m
```

Arquitetura esperada:

```text
aarch64
```

## 2. Instalação do Debian

O Debian 13 ARM64 foi instalado através do PRoot-Distro com o nome local `linudex`.

O ambiente pode ser acessado com:

```bash
proot-distro login linudex
```

A configuração básica do Debian incluiu atualização dos pacotes e instalação dos utilitários comuns e básicos, sendo eles:

```bash
apt update
apt upgrade
apt install -y sudo git curl wget nano ca-certificates locales procps htop file unzip zip
```

![Debian 13 installed through PRoot-Distro](../images/screenshots/debian-13-installed.png)

## 3. Usuário desktop sem root

Foi criado um usuário dedicado chamado `linudex` para uso normal do desktop.

Como as sessões iniciadas pelo PRoot-Distro não expuseram o grupo suplementar `sudo` como esperado, foi adicionada uma regra explícita ao sudoers usando `visudo`:

```text
linudex ALL=(ALL:ALL) ALL
```

A configuração foi validada com:

```bash
sudo whoami
```

Resultado esperado:

```text
root
```

Consulte [Troubleshooting](troubleshooting.pt.md) para entender por que isso foi necessário.

## 4. XFCE

XFCE e o suporte D-Bus para X11 foram instalados dentro do Debian:

```bash
sudo apt update
sudo apt install -y xfce4 dbus-x11
```

## 5. Termux:X11

No lado do Termux:

```bash
pkg install x11-repo
pkg install termux-x11-nightly
```

O aplicativo Android correspondente do Termux:X11 também foi instalado. Como a instalação principal do Termux veio do F-Droid, foi utilizada a variante do APK Termux:X11 sem `sharedUid`.

## 6. Iniciando a sessão gráfica

O servidor X11 é iniciado pelo Termux:

```bash
termux-x11 :1 &
```

O Debian deve ser acessado com diretório temporário compartilhado:

```bash
proot-distro login linudex --user linudex --shared-tmp
```

Dentro do Debian:

```bash
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-linudex
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"
dbus-launch --exit-with-session xfce4-session
```

![Linudex running XFCE and Firefox through Termux:X11](../images/screenshots/linudex-xfce-firefox.png)

## 7. Ajustes no host Android

Para o ambiente da v0.1:

- Termux e Termux:X11 foram configurados sem restrições de bateria.
- RAM Plus foi configurado para 8 GB. Trata-se de memória virtual baseada no armazenamento, e não RAM física.
- O carregamento foi limitado a 85% para reduzir desgaste da bateria durante uso estacionário.
- O limite de processos phantom do Android 12 foi aumentado durante os testes após encerramentos repetidos por `signal 9`. Consulte [Troubleshooting](troubleshooting.pt.md).

## 8. Limitações atuais da v0.1

- A integração de áudio ainda não foi finalizada.
- O fluxo de armazenamento compartilhado entre Android e Debian ainda não foi finalizado.
- A alteração atual do Phantom Process Killer usada nos testes pode precisar ser reaplicada após reinicialização, dependendo de como a configuração do Android for persistida.
- Aplicativos finais de uso diário e ajustes de interface/entrada pertencem ao próximo marco.
