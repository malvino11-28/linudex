# Scripts do Linudex

[English](README.md)

Este diretório contém scripts auxiliares usados para reproduzir e operar a pilha de software do Linudex.

A partir da v0.2.0, os scripts cobrem não apenas a instalação inicial do Debian, mas também o ambiente desktop, áudio, aplicativos essenciais, inicialização automática pelo Android e atalhos manuais de controle.

Os scripts são separados de acordo com o ambiente em que devem ser executados. **Não execute todos os scripts a partir do mesmo shell.**

## Estrutura

```text
scripts/
├── README.md
├── README.pt.md
├── android/
│   └── android12-phantom-process.ps1
├── termux/
│   ├── setup-termux.sh
│   ├── install-debian.sh
│   ├── start-linudex.sh
│   ├── stop-linudex.sh
│   ├── boot/
│   │   └── 20-start-linudex
│   └── widget/
│       ├── Start-Linudex
│       └── Stop-Linudex
└── debian/
    ├── setup-debian.sh
    ├── install-desktop.sh
    └── install-apps.sh
```

## Mapa de execução

| Script                                  | Executar em                | Finalidade                                                                                   |
| --------------------------------------- | -------------------------- | -------------------------------------------------------------------------------------------- |
| `termux/setup-termux.sh`                | Termux                     | Instala os pacotes necessários no Termux, incluindo PRoot-Distro, PulseAudio e Termux:X11.   |
| `termux/install-debian.sh`              | Termux                     | Instala Debian 13 ARM64 através do PRoot-Distro usando o nome local.                         |
| `debian/setup-debian.sh`                | Debian como root           | Atualiza o Debian, instala ferramentas básicas, cria o usuário `linudex` e configura `sudo`. |
| `debian/install-desktop.sh`             | Debian                     | Instala XFCE, suporte D-Bus/X11 e componentes necessários à sessão gráfica e ao áudio.       |
| `debian/install-apps.sh`                | Debian                     | Instala os aplicativos essenciais usados no ambiente Daily Driver da v0.2.0.                 |
| `termux/start-linudex.sh`               | Termux                     | Inicia PulseAudio, Termux:X11, Debian e a sessão XFCE.                                       |
| `termux/stop-linudex.sh`                | Termux                     | Encerra XFCE, Termux:X11 e PulseAudio.                                                       |
| `termux/boot/20-start-linudex`          | Termux:Boot                | Aguarda a inicialização do Android e executa automaticamente o Linudex.                      |
| `termux/widget/Start-Linudex`           | Termux:Widget              | Permite iniciar o Linudex manualmente através de um atalho do Android/DeX.                   |
| `termux/widget/Stop-Linudex`            | Termux:Widget              | Permite encerrar o Linudex manualmente através de um atalho do Android/DeX.                  |
| `android/android12-phantom-process.ps1` | Windows PowerShell com ADB | Aplica o workaround para o Phantom Process Killer do Android 12.                             |

## Ordem recomendada de instalação

### 1. Preparar o Termux

No Termux:

```bash
chmod +x scripts/termux/*.sh
./scripts/termux/setup-termux.sh
```

O APK Android do Termux:X11 é um componente separado e ainda precisa ser instalado manualmente.

Se o Termux foi instalado pelo F-Droid, utilize a variante do APK Termux:X11 sem `sharedUid`.

Termux, Termux:X11, Termux:Boot e Termux:Widget devem utilizar fontes de instalação compatíveis entre si.

### 2. Instalar o Debian

No Termux:

```bash
./scripts/termux/install-debian.sh
```

Depois entre no Debian como root:

```bash
proot-distro login linudex
```

### 3. Configurar o Debian

Dentro do Debian, como root:

```bash
chmod +x /caminho/para/setup-debian.sh
/caminho/para/setup-debian.sh
```

O script:

- atualiza os pacotes do Debian;
- instala ferramentas básicas;
- cria o usuário `linudex`;
- adiciona o usuário ao grupo `sudo`;
- cria uma regra explícita em `/etc/sudoers.d/linudex`.

A regra explícita de `sudo` é necessária porque sessões PRoot podem não carregar os grupos suplementares do usuário da mesma maneira que uma instalação Linux convencional.

### 4. Instalar o desktop

Dentro do Debian:

```bash
/caminho/para/install-desktop.sh
```

Este script instala a base gráfica utilizada pelo Linudex:

```text
XFCE
D-Bus X11
PulseAudio utilities
PulseAudio Volume Control
```

### 5. Instalar os aplicativos essenciais

Ainda dentro do Debian:

```bash
/caminho/para/install-apps.sh
```

A v0.2.0 utiliza um conjunto enxuto de aplicativos para uso cotidiano:

```text
Firefox ESR
LibreOffice Writer
LibreOffice Calc
LibreOffice Impress
Evince
VLC
Ristretto
Mousepad
Galculator
Xarchiver
```

Também são instalados utilitários de compactação, integração com o Thunar, idioma pt-BR, correção ortográfica e fontes com maior compatibilidade com documentos do Microsoft Office.

## Phantom Process Killer — Android 12

O Linudex executa diversos processos filhos. O Android 12 pode encerrar essa árvore de processos através do Phantom Process Killer, causando:

```text
[Process completed (signal 9) - press Enter]
```

Com ADB configurado em um computador Windows:

```powershell
.\android12-phantom-process.ps1
```

O script aumenta o limite de processos phantom utilizado durante os testes do Linudex.

A implementação atual usa uma alteração temporária com:

```text
until_reboot -------------------------------------------------------------------------
```

portanto ela pode precisar ser reaplicada após reiniciar o aparelho.

## Iniciar o Linudex manualmente

No Termux:

```bash
./scripts/termux/start-linudex.sh
```

O script:

1. encerra instâncias antigas do PulseAudio;
2. inicia a ponte de áudio;
3. remove instâncias residuais do Termux:X11;
4. inicia o servidor X11;
5. abre a Activity Android do Termux:X11;
6. entra no Debian como o usuário `linudex`;
7. inicia a sessão XFCE.

O script também executa uma rotina de limpeza quando a sessão termina.

## Encerrar o Linudex

Em uma sessão do Termux:

```bash
./scripts/termux/stop-linudex.sh
```

O script encerra:

```text
XFCE
Termux:X11
PulseAudio
```

## Inicialização automática com Termux:Boot

O arquivo:

```text
termux/boot/20-start-linudex
```

deve ser instalado em:

```text
~/.termux/boot/20-start-linudex
```

Exemplo:

```bash
mkdir -p ~/.termux/boot

cp scripts/termux/boot/20-start-linudex \
   ~/.termux/boot/20-start-linudex

chmod +x ~/.termux/boot/20-start-linudex
```

O Termux:Boot deve ser aberto manualmente pelo menos uma vez após a instalação.

Durante a inicialização, o script:

```text
Android boot
    ↓
período de estabilização
    ↓
start-linudex.sh
```

Um log do processo é armazenado em:

```text
~/linudex-boot.log
```

Para visualizar:

```bash
cat ~/linudex-boot.log
```

### Abertura automática do Termux:X11

O `start-linudex.sh` utiliza o Activity Manager do Android para abrir automaticamente a interface do Termux:X11.

Em alguns dispositivos pode ser necessário permitir ao Termux:

```text
Configurações
→ Aplicativos
→ Acesso especial
→ Aparecer sobre outros apps
→ Termux
```

Sem essa permissão, o Android pode bloquear a abertura da Activity do Termux:X11 quando o Linudex é iniciado em segundo plano pelo Termux:Boot.

## Controle pelo Termux:Widget

Os arquivos:

```text
termux/widget/Start-Linudex
termux/widget/Stop-Linudex
```

devem ser copiados para:

```text
~/.shortcuts/
```

Exemplo:

```bash
mkdir -p ~/.shortcuts

cp scripts/termux/widget/Start-Linudex ~/.shortcuts/
cp scripts/termux/widget/Stop-Linudex ~/.shortcuts/

chmod 700 ~/.shortcuts/Start-Linudex
chmod 700 ~/.shortcuts/Stop-Linudex
```

Depois disso, o Termux:Widget pode ser adicionado ao Android ou Samsung DeX para permitir controle manual do ambiente sem digitar comandos.

## Variáveis de configuração

Os scripts aceitam algumas variáveis de ambiente opcionais:

```bash
LINUDEX_DISTRO_NAME=linudex
LINUDEX_USER=linudex
LINUDEX_DISPLAY=:1
LINUDEX_DEBIAN_IMAGE=debian:13
LINUDEX_PULSE_SERVER=tcp:127.0.0.1
```

Os valores padrão reproduzem o ambiente oficial utilizado no desenvolvimento da v0.2.0.

## Segurança e escopo

- Nenhuma senha é armazenada no repositório.
- Os scripts não fazem root no Android.
- O Debian é executado através do PRoot-Distro.
- O usuário `root` dentro do PRoot não possui privilégios root reais sobre o Android.
- O servidor PulseAudio aceita conexões apenas pelo endereço local utilizado pelo Linudex.
- O workaround do Phantom Process Killer modifica uma configuração do Android através de ADB.
- Scripts destinados ao Android 12 não devem ser aplicados automaticamente em outras versões sem validação.
- Revise os scripts antes de executá-los em outro aparelho ou ambiente.

## Escopo da v0.2.0

A v0.2.0 expande a automação de scripts da v0.1.0 com:

- áudio através do PulseAudio;
- ambiente Daily Driver;
- aplicativos essenciais;
- inicialização automática;
- integração com Termux:Boot;
- integração com Termux:Widget;
- abertura automática do Termux:X11;
- gerenciamento mais completo de processos durante start/stop.

Configurações visuais do XFCE e preferências específicas do Termux:X11 são mantidas separadamente no diretório `configs/`.
