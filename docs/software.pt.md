# Configuração de software

[English](software.md)

Este documento registra a pilha de software utilizada pelo marco Daily Driver do Linudex v0.2.0.

## Pilha final da v0.2.0

```text
Android 12 / One UI 4.1
├── Samsung DeX
├── Termux:Boot
├── Termux:Widget
└── Termux (build do F-Droid)
    ├── PulseAudio
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian 13 ARM64 (`linudex`)
            └── XFCE
```

## 1. Host Termux

O Termux foi instalado pelo F-Droid. O ambiente host foi atualizado e os pacotes principais passaram a ser instalados pelos scripts do projeto. Os requisitos do host na v0.2.0 incluem:

```text
git
curl
wget
nano
openssh
proot-distro
x11-repo
termux-x11-nightly
pulseaudio
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

A configuração básica do Debian incluiu atualização dos pacotes e instalação dos utilitários comuns:

```bash
apt update
apt upgrade
apt install -y sudo git curl wget nano ca-certificates locales procps htop file unzip zip
```

![Debian 13 instalado através do PRoot-Distro](../images/screenshots/debian-13-installed.png)

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

A configuração do desktop na v0.2.0 utiliza:

- saída 1920×1080 pelo Termux:X11;
- DPI 115;
- compositor do XFCE desativado;
- painel de 40 px com Whisker Menu;
- layout de desktop simplificado;
- `Ctrl+Alt+T` para `xfce4-terminal`;
- `Super+E` para Thunar;
- `Super+B` para Firefox ESR.

As configurações reproduzíveis correspondentes ficam em `configs/`.

## 5. Termux:X11

No lado do Termux, o repositório X11 e o componente de linha de comando do Termux:X11 são instalados pelo script de setup. O aplicativo Android correspondente do Termux:X11 também é necessário.

Como a instalação principal do Termux veio do F-Droid, foi utilizada a variante do APK Termux:X11 sem `sharedUid`.

As preferências da v0.2.0 utilizam saída exata em 1920×1080 e modo fullscreen. As preferências exportadas do Termux:X11 ficam armazenadas em `configs/termux/`.

## 6. Inicialização da sessão gráfica

O fluxo normal da v0.2.0 utiliza `scripts/termux/start-linudex.sh` em vez de digitar manualmente todos os comandos.

O script inicia a pilha nesta ordem:

```text
PulseAudio
    ↓
Servidor Termux:X11
    ↓
Activity Android do Termux:X11
    ↓
PRoot-Distro
    ↓
Debian como usuário `linudex`
    ↓
D-Bus
    ↓
XFCE
```

A sessão Debian subjacente continua utilizando diretório temporário compartilhado e `DISPLAY=:1`.

![Linudex executando XFCE e Firefox através do Termux:X11](../images/screenshots/linudex-xfce-firefox.png)

## 7. Armazenamento compartilhado do Android

O armazenamento compartilhado do Android foi habilitado pelo Termux e exposto ao usuário Debian como `~/AndroidStorage`.

Isso fornece um caminho prático para troca de arquivos entre Android/DeX e o desktop Debian sem precisar copiar arquivos através de ADB ou serviços de rede.

## 8. Integração de áudio

O PulseAudio executa no lado do Termux e disponibiliza um servidor TCP local. Os aplicativos Debian utilizam:

```text
PULSE_SERVER=tcp:127.0.0.1
```

O fluxo resultante é:

```text
Aplicativo Debian
       ↓
Cliente PulseAudio
       ↓
tcp:127.0.0.1
       ↓
PulseAudio no Termux
       ↓
Áudio Android / DeX
```

O áudio foi validado com Firefox ESR e a interface PulseAudio Volume Control.

![Áudio do Firefox ESR roteado através do PulseAudio](../images/screenshots/linudex-v0.2-audio.png)

## 9. Aplicativos essenciais

O ambiente Daily Driver da v0.2.0 inclui:

- Firefox ESR;
- Evince;
- VLC;
- Ristretto;
- Mousepad;
- Galculator;
- Xarchiver e integração de compactação com o Thunar;
- LibreOffice Writer, Calc e Impress;
- localização do LibreOffice e correção ortográfica em português do Brasil;
- fontes Carlito, Caladea, Liberation e Noto para maior compatibilidade com documentos.

A lista de pacotes é automatizada por `scripts/debian/install-apps.sh`.

![LibreOffice Writer executando no Linudex](../images/screenshots/linudex-v0.2-libreoffice.png)

## 10. Inicialização automática e controle manual

O Termux:Boot é utilizado para iniciar o Linudex automaticamente após o boot do Android. O script de boot aguarda `sys.boot_completed`, reserva um período para estabilização do ambiente gráfico e então executa `start-linudex.sh`.

O processo de boot grava o log em:

```text
~/linudex-boot.log
```

Como o Android pode restringir Activities iniciadas em segundo plano, foi concedida ao Termux a permissão **Aparecer sobre outros apps** para permitir que a Activity do Termux:X11 seja aberta automaticamente durante o boot.

O Termux:Widget fornece atalhos manuais `Start-Linudex` e `Stop-Linudex` para situações em que o ambiente Debian precisa ser iniciado ou encerrado a partir do Android/DeX.

## 11. Ajustes no host Android

Para o ambiente da v0.2.0:

- Termux e Termux:X11 estão configurados sem restrições de bateria.
- RAM Plus está configurado para 8 GB. Trata-se de memória virtual baseada no armazenamento, e não RAM física.
- O carregamento está limitado a 85% para reduzir desgaste da bateria durante uso estacionário.
- Nas Opções do desenvolvedor do Android, **Tamanho de buffer de logger** está definido como **Desativado**.
- Nas Opções do desenvolvedor do Android, **Processamento acelerado** está ativado.
- O limite de processos phantom do Android 12 é aumentado durante os testes após encerramentos repetidos por `signal 9`. Consulte [Troubleshooting](troubleshooting.pt.md).

As opções de buffer do logger e processamento acelerado são documentadas como ajustes do host; não foi realizado um benchmark isolado para atribuir ganho de desempenho quantificado a nenhuma das duas.

## 12. Limitações atuais da v0.2.0

- O workaround atual do Phantom Process Killer utiliza comportamento temporário `until_reboot` e pode precisar ser reaplicado após reiniciar o aparelho.
- A validação final do layout de teclado depende do teclado físico.
- Ajustes finais de mouse e escala de tela devem ser validados novamente com o conjunto definitivo de monitor/hub.
- O cold boot automático diretamente na configuração HDMI final do Samsung DeX ainda depende de validação com o hardware definitivo.
- O gabinete físico e a refrigeração ativa pertencem à fase de hardware.
