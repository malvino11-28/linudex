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

## Configurações visuais — v0.5.1

O estado final utiliza **somente o painel XFCE inferior**; o painel superior foi removido. Ao exportar `xfce4-panel.xml`, preserve os IDs atuais de plugin e não restaure o painel superior antigo da v0.5.0. A pesquisa original foi substituída pelo **LinuDex Search v3**; seu CSS é independente (`~/.config/linudex-search/style.css`) e utiliza SVG próprio da lupa.

O novo menu de utilitários é exibido por Genmon com ícone de seta em `~/.local/share/linudex/chevron-up.svg`. O estilo escuro reside em `~/.config/linudex-quickmenu/style.css`. O Genmon do Wi-Fi chama `linudex-wifi-click`; seu ícone clicável é estilizado pelo seletor `#genmon-14 .genmon_imagebutton image` com `-gtk-icon-transform: scale(0.75)` no GTK CSS do painel. Esse ID foi validado no ambiente atual e deve ser conferido ao exportar para outro painel.

O ícone do **Thunar** foi alterado pelo editor de lançadores para uma pasta comum; versionar apenas o lançador local pertinente, sem substituir ícones do sistema inteiro. Os ícones da galeria e das configurações continuam vindos do tema instalado. Ao preparar a release, exportar as configurações finais **do aparelho**, não os backups anteriores aos testes da v0.5.1.

## Lançador do Samsung Internet e limpeza do CSS antigo — v0.5.2

O arquivo opcional `xfce/launchers/samsung-browser.desktop` chama o auxiliar Debian `~/.local/bin/linudex-samsung-browser`, que abre o Samsung Internet **no Android** por meio do TermuxAm. A interface é exibida pelo Samsung DeX sobre o Debian/XFCE; não se trata de uma janela nativa do XFCE. O lançador pode ser fixado no Docklike.

A pesquisa antiga da v0.5.0 utilizava seletores abrangentes `#launcher-arrow` no `gtk.css`. Eles também afetaram o lançador do Samsung Internet, dando-lhe indevidamente a aparência da antiga barra de pesquisa. A correção validada removeu apenas esses blocos obsoletos, preservando os demais estilos. O plugin LinuDex Search v3 utiliza CSS próprio e não depende das regras removidas. Exportar o CSS atual do dispositivo, não o snapshot desatualizado do repositório, antes do commit.

## Importante

Todas essas configurações são opcionais.

O Linudex deve continuar funcionando sem elas, e os scripts de instalação não devem depender de configurações cosméticas ou de conveniência, exceto quando isso estiver explicitamente documentado.
