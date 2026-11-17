# Arquivos de configuração

[English](README.md)

Este diretório contém arquivos de configuração opcionais para o ambiente Linudex.

Nenhum dos arquivos desta pasta é necessário para o funcionamento da pilha principal do Linudex.

O sistema base necessita apenas de:

```text
Android
└── Termux
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian
            └── XFCE
```

Os arquivos armazenados aqui existem para facilitar a reprodução, personalização ou restauração do ambiente após uma nova instalação.

## Estrutura

```text
configs/
├── debian/
│   └── .bashrc
│
├── termux/
│   ├── .bashrc
│   ├── termux.properties
│   ├── termux-x11-preferences.txt
│   ├── README.md
│   └── README.pt.md
│
└── xfce/
    ├── xfconf/
    │   ├── xfce4-desktop.xml
    │   ├── xfce4-keyboard-shortcuts.xml
    │   ├── xfce4-panel.xml
    │   ├── xfwm4.xml
    └── └── xsettings.xml
```

## Configuração do Debian

Os arquivos dentro de `debian/` são destinados ao ambiente Debian executado através do PRoot-Distro.

Por exemplo:

```text
configs/debian/.bashrc
```

pode ser copiado para:

```text
/home/linudex/.bashrc
```

Ele pode conter aliases do shell, variáveis de ambiente, personalização do prompt e outras preferências do Bash.

## Configuração do Termux

Os arquivos dentro de `termux/` são destinados ao ambiente Termux executado no Android.

Eles podem conter:

- Aliases do Bash
- Preferências do shell
- Configurações da interface do Termux
- Teclas adicionais do teclado
- Configurações de comportamento do terminal
- Preferências do Termux:X11

Consulte [`termux/README.pt.md`](termux/README.pt.md) para mais detalhes.

## Configuração do XFCE

Os arquivos dentro de `xfce/` armazenam as configurações utilizadas pelo ambiente gráfico da v0.2.0.

Eles incluem configurações do desktop, painel, atalhos de teclado, gerenciador de janelas, DPI e Whisker Menu.

## Personalização do XFCE

A v0.5.0 acrescenta a configuração opcional da interface inspirada no Windows 10: arquivos Xfconf (painéis, atalhos, teclado, janela e tema), ajustes GTK CSS, configurações locais de Docklike e Genmon, SVGs e logo LX. Os arquivos locais são instalados normalmente em `~/.config/xfce4/xfconf/xfce-perchannel-xml/`, `~/.config/xfce4/panel/`, `~/.config/gtk-3.0/`, `~/.local/share/linudex/`, `~/.local/share/applications/` e `~/share/icons/linudex/`. Referências absolutas a `/home/linudex` pressupõem esse nome de usuário; devem ser ajustadas se necessário.

Antes de substituir qualquer arquivo, faça backup das configurações atuais e encerre o painel/ a sessão ao aplicar XMLs. Não copie arquivos de sessão, perfis de navegadores ou credenciais. O backup do desenvolvimento antecede ajustes finais do YouTube, Netflix e Chromium; compare o estado final do aparelho antes de publicar tais lançadores. A opção **Prefer scancodes when possible** pertence às preferências Android do Termux:X11 e deve ser ativada manualmente, além de configurar XKB como `br` (variante vazia). O CSS consolidado está sujeito à validação visual; wallpaper e ícones WebApps não fazem parte do backup exportado (os ícones são criados pelo Chromium).

## Importante

Todas essas configurações são opcionais.

O Linudex deve continuar funcionando sem elas, e os scripts de instalação não devem depender de configurações cosméticas ou de conveniência, exceto quando isso estiver explicitamente documentado.
