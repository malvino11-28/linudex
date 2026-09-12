# Scripts do Linudex

[English](README.md)

Este diretório contém scripts auxiliares usados para reproduzir e operar a pilha de software do Linudex.

Os scripts são separados de acordo com o ambiente em que devem ser executados. **Não execute todos os scripts a partir do mesmo shell.**

## Estrutura

```text
scripts/
├── README.md
├── README.pt.md
├── termux/
│   ├── setup-termux.sh
│   ├── install-debian.sh
│   ├── start-linudex.sh
│   └── stop-linudex.sh
├── debian/
│   ├── setup-debian.sh
│   └── install-desktop.sh
└── host/
    └── android12-phantom-process.ps1
```

## Mapa de execução

| Script                               | Executar em                | Finalidade                                                                             |
| ------------------------------------ | -------------------------- | -------------------------------------------------------------------------------------- |
| `termux/setup-termux.sh`             | Termux                     | Instala os pacotes do Termux necessários para o Linudex.                               |
| `termux/install-debian.sh`           | Termux                     | Instala Debian 13 através do PRoot-Distro usando o nome local `linudex`.               |
| `debian/setup-debian.sh`             | Debian como root           | Instala ferramentas básicas, cria o usuário `linudex` e configura o `sudo`.            |
| `debian/install-desktop.sh`          | Debian                     | Instala XFCE, suporte D-Bus X11 e Firefox ESR.                                         |
| `termux/start-linudex.sh`            | Termux                     | Inicia Termux:X11, entra no Debian e abre o XFCE.                                      |
| `termux/stop-linudex.sh`             | Termux                     | Encerra a sessão XFCE e o servidor Termux:X11.                                         |
| `host/android12-phantom-process.ps1` | Windows PowerShell com ADB | Aplica o workaround do Android 12 para processos phantom utilizado nos testes da v0.1. |

## Ordem recomendada de instalação

### 1. Preparar o Termux

No Termux:

```bash
chmod +x scripts/termux/*.sh
./scripts/termux/setup-termux.sh
```

O APK Android do Termux:X11 é um componente separado e ainda precisa ser instalado manualmente.

Se o Termux foi instalado pelo F-Droid, utilize a variante do APK Termux:X11 sem `sharedUid`.

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

O script cria o usuário `linudex` de forma interativa e pede que você defina sua senha.

### 4. Instalar o desktop

Dentro do Debian:

```bash
/caminho/para/install-desktop.sh
```

### 5. Aplicar o workaround do Android 12 quando necessário

No computador Windows com ADB configurado:

```powershell
.\android12-phantom-process.ps1
```

Na v0.1 esse workaround é intencionalmente temporário e pode precisar ser reaplicado depois que o telefone for reiniciado.

### 6. Iniciar o Linudex

No Termux:

```bash
./scripts/termux/start-linudex.sh
```

O script inicia:

```text
Termux:X11
    ↓
PRoot-Distro
    ↓
Debian
    ↓
XFCE
```

### 7. Encerrar o Linudex

Em uma sessão do Termux:

```bash
./scripts/termux/stop-linudex.sh
```

Isso também ajuda a limpar instâncias residuais do Termux:X11 que poderiam gerar o erro `Server already running`.

## Variáveis de configuração

Os scripts do Termux aceitam algumas variáveis de ambiente opcionais:

```bash
LINUDEX_DISTRO_NAME=linudex
LINUDEX_USER=linudex
LINUDEX_DISPLAY=:1
LINUDEX_DEBIAN_IMAGE=debian:13
```

Os valores padrão reproduzem o ambiente da v0.1, portanto normalmente não é necessário defini-los manualmente.

## Segurança e escopo

- Nenhuma senha é armazenada no repositório.
- Os scripts não fazem root no Android.
- O script do Phantom Process Killer utiliza o mesmo comportamento temporário `until_reboot` validado durante os testes da v0.1.
- Os scripts de instalação incluem apenas o software pertencente ao marco v0.1; aplicativos planejados para versões futuras foram deixados de fora intencionalmente.
- Revise os scripts antes de executá-los em outro aparelho ou versão do Android.
