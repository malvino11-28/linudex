# LinuDex Search — XFCE panel plugin

[English](README.md)

O LinuDex Search é um campo editável integrado ao painel inferior do XFCE. A instalação testada permite localizar aplicativos por nome ou executável, visualizar até oito resultados com ícones de até 24 × 24 px e abrir aplicativos por clique ou teclado. As teclas `↑`, `↓`, `Enter` e `Esc`, o fechamento da lista e a limpeza do campo foram validados no Galaxy S10+.

## Requisitos

Debian 13 ARM64, XFCE 4.20/GTK 3, compilador C, `pkg-config`, `libgtk-3-dev`, `libxfce4panel-2.0-dev` e `libxfce4ui-2-dev` (necessário em instalações em que a dependência de desenvolvimento não é trazida automaticamente). São necessárias uma sessão X11 funcional e a configuração do painel já instalada.

## Compilação e instalação

No Debian, a partir desta pasta do repositório:

```bash
sudo apt install build-essential pkg-config libgtk-3-dev libxfce4panel-2.0-dev libxfce4ui-2-dev
chmod +x build.sh install.sh uninstall.sh
./build.sh
./install.sh
xfce4-panel -r
```

Adicionar **LinuDex Search** via **Painel → Adicionar novos itens** somente se o plugin ainda não estiver presente. A instalação não modifica `~/.config/gtk-3.0/gtk.css`, o XML do painel, o Docklike ou o lançador antigo. O CSS é instalado em `~/.config/linudex-search/style.css`; o SVG em `~/.local/share/linudex/search-icon.svg`.

A aparência do campo mantém **280 × 36 px**, `#343434`, borda `#585858`, cantos retos e lupa clara. A palavra **Pesquisar** é mantida no campo conforme o layout aprovado.

## Remoção

Primeiro retirar o plugin do painel; depois executar `./uninstall.sh` e `xfce4-panel -r`. O script não remove outras configurações do Linudex.

**Validação:** foi confirmado o funcionamento no dispositivo de desenvolvimento. Outras instalações ainda dependem de teste local. Este diretório contém somente a implementação final selecionada para a v0.5.1, sem os protótipos intermediários.
