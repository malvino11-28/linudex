# Configuração do Termux

[English](README.md)

Este diretório contém arquivos opcionais de configuração do Termux utilizados para personalizar o ambiente host do Linudex no Android.

Nenhum dos arquivos desta pasta é necessário para o funcionamento do Linudex.

A pilha principal pode funcionar sem eles:

```text
Android
└── Termux
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian
            └── XFCE
```

Esses arquivos existem apenas para tornar o ambiente Termux mais fácil de utilizar e reproduzir.

## Arquivos

### `.bashrc`

Local de destino:

```text
~/.bashrc
```

Esse arquivo configura o shell Bash utilizado pelo Termux.

Ele pode conter:

- aliases;
- variáveis de ambiente;
- preferências do shell;
- atalhos para comandos do Linudex.

Por exemplo:

```bash
alias start-linudex='$HOME/start-linudex.sh'
alias stop-linudex='$HOME/stop-linudex.sh'
alias update-termux='pkg update && pkg upgrade'
```

Esses aliases são opcionais e servem apenas para reduzir o tamanho dos comandos.

O ambiente Linudex não depende deles.

### `termux.properties`

Local de destino:

```text
~/.termux/termux.properties
```

Esse arquivo configura o próprio aplicativo Termux no Android.

Ele pode controlar recursos como:

- teclas extras do teclado;
- quantidade de linhas mantidas no histórico do terminal;
- comportamento de entrada;
- diretório de trabalho padrão;
- outras preferências da interface do Termux.

Exemplo:

```properties
extra-keys = [['ESC','CTRL','ALT','TAB','LEFT','DOWN','UP','RIGHT']]
terminal-transcript-rows = 5000
enforce-char-based-input = true
default-working-directory = /data/data/com.termux/files/home
```

Essas configurações são apenas preferências de conveniência e não são necessárias para PRoot-Distro, Debian, XFCE ou Termux:X11.

## Instalando as configurações opcionais

Antes de substituir um arquivo existente, é recomendado criar um backup.

### `.bashrc`

Faça backup do arquivo atual, caso exista:

```bash
cp ~/.bashrc ~/.bashrc.backup
```

Depois copie a configuração do Linudex:

```bash
cp .bashrc ~/.bashrc
```

Recarregue a configuração do shell:

```bash
source ~/.bashrc
```

Caso você já mantenha seu próprio `.bashrc`, outra opção é copiar apenas os aliases ou configurações desejadas em vez de substituir o arquivo inteiro.

### `termux.properties`

Crie o diretório de configuração do Termux, caso necessário:

```bash
mkdir -p ~/.termux
```

Copie o arquivo:

```bash
cp termux.properties ~/.termux/termux.properties
```

Recarregue as configurações do Termux:

```bash
termux-reload-settings
```

## Removendo as configurações

Esses arquivos podem ser removidos sem afetar a instalação Debian do Linudex.

Por exemplo:

```bash
rm ~/.termux/termux.properties
```

Depois recarregue as configurações:

```bash
termux-reload-settings
```

Caso exista um backup anterior do `.bashrc`:

```bash
mv ~/.bashrc.backup ~/.bashrc
```

## Importante

Esses arquivos de configuração devem continuar sendo opcionais.

Os scripts de instalação e inicialização não devem depender de aliases, personalizações de interface ou outras configurações de conveniência para que o Linudex funcione.
