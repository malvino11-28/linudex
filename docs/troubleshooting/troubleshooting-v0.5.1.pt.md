# Troubleshooting — v0.5.1

[English](troubleshooting-v0.5.1.md)

Este documento reúne os problemas observados durante os refinamentos de usabilidade e interface do Linudex v0.5.1, executado em Debian 13 ARM64 via Termux, PRoot-Distro, Termux:X11 e XFCE no Galaxy S10+. Os estados refletem as validações realizadas na instalação de desenvolvimento; não representam garantias para outros dispositivos. A arquitetura Android–Debian foi preservada.

## Índice de problemas

- [AndroidStorage inacessível no Termux e no Debian](#androidstorage-inacessível-no-termux-e-no-debian)
- [Compilação do LinuDex Search falhava apesar das dependências instaladas](#compilação-do-linudex-search-falhava-apesar-das-dependências-instaladas)
- [Campo de pesquisa não recebia digitação](#campo-de-pesquisa-não-recebia-digitação)
- [Resultados da pesquisa não apareciam](#resultados-da-pesquisa-não-apareciam)
- [Pesquisa apresentava contraste incorreto e ícone do LocalSend ampliado](#pesquisa-apresentava-contraste-incorreto-e-ícone-do-localsend-ampliado)
- [Configurações Android não abriam a partir do Debian](#configurações-android-não-abriam-a-partir-do-debian)

---

## AndroidStorage inacessível no Termux e no Debian

### Sintomas

Os links `~/storage/shared` e `~/storage/downloads` existiam no Termux, mas não permitiam listar os arquivos. O acesso direto a `/storage/emulated/0` também falhava. No Debian, `~/AndroidStorage` apontava para `/storage/emulated/0`, porém o diretório permanecia inacessível; `/sdcard` apresentava comportamento semelhante.

### Diagnóstico

Foi identificado que a permissão especial **Acesso a todos os arquivos** estava desativada para **Termux** e **Termux:API** no Android. Os links simbólicos estavam presentes, mas não substituíam a autorização do sistema. Como as duas permissões foram habilitadas na mesma etapa, não foi isolado qual delas era indispensável para restabelecer o acesso.

### Solução validada

Nas configurações de acesso especial do Android, foi habilitado **Acesso a todos os arquivos** para Termux e Termux:API. Não foram realizadas alterações de `chmod`, `chown`, `--bind`, configurações do PRoot ou scripts de inicialização.

### Validação

Após conceder as permissões, foi confirmado o acesso aos arquivos do armazenamento interno diretamente pelo Debian, por meio de `~/AndroidStorage`.

### Estado

**Resolvido na instalação testada.** Não foi necessária uma alteração profunda na integração Android–Debian.

---

## Compilação do LinuDex Search falhava apesar das dependências instaladas

### Sintomas

O comando `./build.sh` informava que as dependências estavam indisponíveis, apesar de `build-essential`, `pkg-config`, `libgtk-3-dev` e `libxfce4panel-2.0-dev` já estarem instalados no Debian 13 ARM64.

### Diagnóstico

A verificação `pkg-config --exists libxfce4panel-2.0 gtk+-3.0 gio-2.0` falhava sem indicar o pacote responsável. Após instalar `libxfce4ui-2-dev`, o mesmo teste retornou **Dependencies OK**.

### Solução validada

```bash
sudo apt install libxfce4ui-2-dev
pkg-config --print-errors --exists libxfce4panel-2.0 gtk+-3.0 gio-2.0 && echo 'Dependencies OK'
./build.sh
```

A opção `--print-errors` também foi incorporada à verificação para tornar eventuais falhas posteriores mais fáceis de diagnosticar.

### Validação

As dependências passaram na verificação e o plugin foi compilado e instalado.

### Estado

**Resolvido.**

---

## Campo de pesquisa não recebia digitação

### Sintomas

O campo do LinuDex Search era exibido na barra inferior. O cursor mudava para o formato de texto, porém clicar no campo não permitia digitar.

### Diagnóstico

O `GtkEntry` estava presente, mas o plugin não solicitava explicitamente ao painel XFCE que transferisse o foco do teclado para esse componente.

### Solução validada

Foi adicionada a chamada `xfce_panel_plugin_focus_widget(plugin, widget)` ao tratamento do clique esquerdo no campo, mantendo `return FALSE` para preservar o processamento normal do evento GTK.

### Validação

Foi confirmada a digitação diretamente no painel e a execução de aplicativos com Enter.

### Estado

**Resolvido.**

---

## Resultados da pesquisa não apareciam

### Sintomas

Após corrigir o foco, os nomes dos aplicativos podiam ser digitados e Enter iniciava o aplicativo correspondente, mas nenhuma lista de resultados ou ícones era apresentada.

### Diagnóstico

O protótipo utilizava `GtkPopover` para apresentar os resultados. Na sessão XFCE/Termux:X11 testada, esse componente não ficou visível. A causa exata da falha de apresentação não foi determinada.

### Solução validada

O `GtkPopover` foi substituído por uma janela GTK separada (`GTK_WINDOW_POPUP`), posicionada acima da barra de tarefas e configurada para não retirar o foco do campo de pesquisa.

### Validação

A lista passou a apresentar aplicativos com nomes e ícones. Foram confirmados clique nos resultados, navegação com as setas, abertura com Enter, fechamento com Esc, fechamento ao clicar fora e limpeza do texto após executar um aplicativo.

### Estado

**Resolvido no LinuDex Search v3.**

---

## Pesquisa apresentava contraste incorreto e ícone do LocalSend ampliado

### Sintomas

A nova pesquisa apresentava texto e lupa com contraste inferior ao botão utilizado na v0.5.0. A lupa também tinha dimensões diferentes. Na lista de resultados, o ícone do LocalSend aparecia desproporcionalmente maior do que os demais.

### Diagnóstico

O texto de placeholder do `GtkEntry` recebia transparência do tema GTK, enquanto a lupa era reduzida ao tamanho de um ícone interno. Os ícones dos resultados também não eram normalizados de maneira consistente quando fornecidos em resoluções maiores.

### Solução validada

A lupa passou a utilizar a arte vetorial original e o texto **Pesquisar** foi implementado como `GtkLabel` independente, com cor `#f1f1f1`. Os ícones dos resultados foram redimensionados proporcionalmente para uma área máxima de **24 × 24 px**, sem distorção. Foram preservadas as dimensões de 280 × 36 px, o fundo `#343434`, a borda `#585858` e os cantos retos.

### Validação

Foi confirmada a equivalência visual da pesquisa com a referência original, a continuidade da digitação e o tamanho adequado do ícone do LocalSend.

### Estado

**Resolvido no LinuDex Search v3.**

---

## Configurações Android não abriam a partir do Debian

### Sintomas

Os comandos de abertura de Wi-Fi e Bluetooth funcionavam no Termux, mas falhavam quando executados no Debian pelo `/system/bin/am`. O erro apresentado era:

```text
java.lang.SecurityException: Permission Denial:
package=com.android.shell does not belong to uid=10004
```

### Diagnóstico

A ferramenta `/system/bin/am` tentava iniciar a atividade usando a identidade `com.android.shell`, que não correspondia ao UID da chamada realizada no ambiente Debian/PRoot. O problema não indicava falha no gerenciador de Wi-Fi ou Bluetooth do Android.

### Solução validada

Foi utilizada a implementação `am` fornecida pelo Termux, acessível a partir do Debian:

```bash
/data/data/com.termux/files/usr/bin/am start --user 0 -a android.settings.WIFI_SETTINGS
/data/data/com.termux/files/usr/bin/am start --user 0 -a android.settings.BLUETOOTH_SETTINGS
```

O parâmetro `--user 0` identifica o usuário Android principal; não significa execução como root.

### Validação

Ambas as telas de configurações foram abertas corretamente a partir do Debian. Os comandos passaram a ser utilizados pelos atalhos do Linudex, inclusive pelo indicador de Wi-Fi clicável e pelo QuickMenu para Bluetooth.

### Estado

**Resolvido na instalação testada, sem root ou modificações no PRoot.**
