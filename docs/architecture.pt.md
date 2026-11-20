# Arquitetura

[English](architecture.md)

## Visão geral

O Linudex usa o Android como camada de compatibilidade com o hardware e executa um userspace Debian ARM64 sobre ele. Não é uma máquina virtual tradicional e não substitui o kernel do Android.

```text
Monitor externo / teclado / mouse
                │
                ▼
        Samsung Galaxy S10+
                │
       Android 12 / One UI
        ┌───────┴──────────────┐
        │                      │
   Samsung DeX              Termux
                               │
              ┌────────────────┼────────────────┐
              │                │                │
         PulseAudio       Termux:X11       PRoot-Distro
              │                                  │
        Áudio Android                          Debian 13
                                                 │
                                               XFCE
```

Termux:Boot e Termux:Widget fornecem controle automático e manual dessa pilha, mas não substituem nenhuma das camadas de execução mostradas acima.

## Responsabilidade de cada camada

### Android / One UI

Fornece o kernel Linux, drivers Samsung, rede, USB, pilha de áudio, gerenciamento de energia e a infraestrutura de vídeo subjacente.

### Samsung DeX

Fornece o ambiente desktop Android e suporte confiável ao monitor externo via USB-C. O DeX é preservado intencionalmente durante o debloat porque continua fazendo parte do host mesmo quando o desktop Linux está em execução.

### Termux

Fornece o ambiente de linha de comando utilizado para instalar e iniciar PRoot-Distro, PulseAudio e Termux:X11.

### PulseAudio

Executa no lado do Termux como ponte de áudio. Os aplicativos Debian se conectam ao servidor PulseAudio local através de `tcp:127.0.0.1`, permitindo que o áudio dos aplicativos Linux chegue ao Android/DeX.

### PRoot-Distro

Fornece o filesystem raiz e o userspace do Debian sem exigir root no Android. Como o PRoot compartilha o kernel do Android, alguns recursos Linux de baixo nível e métricas de hardware não ficam disponíveis exatamente como ficariam em uma instalação Debian nativa.

### Debian 13 ARM64

Fornece o userspace GNU/Linux, gerenciador de pacotes e aplicativos desktop. A instalação recebe o nome `linudex` no PRoot-Distro.

### Termux:X11

Fornece o servidor X11 que conecta os aplicativos gráficos Linux ao Android.

### XFCE

Fornece o desktop gráfico leve utilizado pelo ambiente Daily Driver da v0.2.0.

### Termux:Boot e Termux:Widget

O Termux:Boot executa o script de inicialização do Linudex depois que o Android conclui o boot. O Termux:Widget fornece atalhos manuais de start e stop para situações em que o ambiente Linux precisa ser controlado a partir do Android/DeX.

## Fluxos de dados e controle

O caminho gráfico é:

```text
XFCE / aplicativos Linux
          │
          ▼
      Termux:X11
          │
          ▼
  Pilha gráfica Android
          │
          ▼
     Samsung DeX
```

O caminho de áudio é:

```text
Aplicativo Debian
       │
       ▼
Cliente PulseAudio
       │
       ▼
tcp:127.0.0.1
       │
       ▼
PulseAudio no Termux
       │
       ▼
 Áudio Android / DeX
```

O armazenamento compartilhado do Android também é exposto ao ambiente Debian para permitir troca normal de arquivos entre os dois lados do sistema.

## Por que esta arquitetura

O Galaxy S10+ já possui drivers Android maduros para a plataforma Exynos, saída de vídeo USB-C e periféricos. Manter o Android evita o suporte incompleto de hardware dos ports Linux nativos atualmente disponíveis para esse aparelho, ao mesmo tempo em que permite utilizar um userspace Debian convencional.

## Limitações importantes

- O Debian não controla o kernel; ele compartilha o kernel do Android.
- PRoot não é uma VM e não fornece virtualização de hardware.
- Algumas métricas de `/proc` são restringidas pelo SELinux do Android; por isso a CPU é medida via ADB, e não pelo `htop` dentro do Debian.
- `systemd` tradicional, gerenciamento de módulos do kernel e workloads como Docker padrão estão fora do escopo atual da v0.2.0.
- Políticas de gerenciamento de processos do Android podem encerrar a árvore de processos do PRoot caso o Phantom Process Killer não seja mitigado.
- O workaround atual do projeto para o Phantom Process Killer ainda é temporário entre reinicializações do aparelho.

## Compatibilidade experimental x86/x86-64 — v0.3.0

A versão v0.3.0 adiciona uma camada de compatibilidade ao desktop Debian ARM64 já estabelecido. As camadas Android, Termux, PRoot-Distro, Termux:X11 e XFCE descritas anteriormente permanecem inalteradas. Os componentes de compatibilidade são iniciados sob demanda e não substituem o ambiente ARM64 nativo.

### Aplicativos Linux x86-64

```text
Aplicativo Linux x86-64
          │
          ▼
        Box64
          │
          ▼
    Debian 13 ARM64
          │
          ▼
     Mesa virpipe
          │
          ▼
         VirGL
          │
          ▼
    ANGLE / Vulkan
          │
          ▼
 Vulkan Android / Mali-G76
```

O Box64 traduz instruções de programas x86-64 para ARM64; ele não emula um computador completo. Os testes Linux x86-64 utilizaram o Box64 0.4.5 compilado manualmente, por meio do wrapper local `~/run-x86_64.sh`. No Termux, o auxiliar `~/start-linux-gpu.sh` seleciona o perfil OpenGL (`vgl cfg=gl` e `vgl angle=vulkan`).

### Aplicativos Windows x86-64

```text
Executável Windows x86-64
          │
          ▼
      Box64 0.3.4
          │
          ▼
    Wine 9.18-staging
          │
          ▼
      WineD3D 9.2
          │
          ▼
    Mesa / VirGL
          │
          ▼
    ANGLE / Vulkan
          │
          ▼
 Vulkan Android / Mali-G76
```

O caminho Windows testado usa `/usr/bin/box64`, o lançador local `~/xow64` e o prefixo Wine `.xow64_test`. O WineD3D traduz chamadas Direct3D para OpenGL. No Termux, o auxiliar `~/start-wine-gpu.sh` seleciona `vgl cfg=d3d` e `vgl angle=vulkan-null`; este último é o nome do perfil usado na configuração testada, não uma indicação de suporte direto ao Vulkan de Windows.

### Versões dos componentes

| Componente           | Versão / configuração                 | Função                                                   |
| -------------------- | ------------------------------------- | -------------------------------------------------------- |
| Box64 para Wine      | 0.3.4                                 | Tradução x86-64 da configuração funcional do Wine        |
| Box64 para Linux     | Build manual 0.4.5                    | Testes de execução Linux x86-64                          |
| Wine                 | 9.18-staging                          | Compatibilidade com APIs Windows                         |
| WineD3D              | 9.2                                   | Tradução Direct3D para OpenGL                            |
| Mesa / VirGL / ANGLE | GPU virtual / ponte Vulkan do Android | Tradução gráfica                                         |
| DepotDownloader      | 3.4.0 ARM64                           | Download de depots Steam autorizados sem interface Steam |

### Limitações

- O renderizador virtual pode ser identificado como `Red Hat VirtIO GPU`, em vez da Mali-G76. Os recursos gráficos apresentados aos programas podem ser inferiores aos da GPU física.
- As várias camadas de tradução introduzem sobrecarga significativa. Conseguir abrir um jogo não significa obter desempenho adequado.
- O cliente Steam Windows completo produziu alto consumo de memória pelo SteamWebHelper. O DepotDownloader evita manter essa interface em execução, mas não contorna exigências do Steamworks, DRM ou licenciamento.
- O `9 Kings` inicializou Direct3D 11 com feature level 10_1 e apresentou erros de shaders. Ao forçar OpenGL 4.1, a inicialização gráfica da Unity falhou. Isso não comprova uma limitação física da Mali-G76.
- Não utilize o comando experimental `~/xow64 q` para encerrar o Wine: ele pode finalizar processos não relacionados do desktop. Utilize o auxiliar validado `~/stop-xow64-wine.sh`, restrito ao prefixo.
- Uma instalação completa da camada de compatibilidade v0.3.0 em um aparelho limpo ainda não foi validada. Os scripts utilizados nos testes precisam ser revisados antes da publicação.

Consulte [Configuração de software](software.pt.md), [Benchmarks](benchmarks.pt.md) e [Troubleshooting](troubleshooting/README.pt.md) para instalação, resultados e problemas conhecidos.

## Integração física — v0.4.0

A v0.4.0 acrescenta um gabinete compacto, um hub USB-C e refrigeração ativa à configuração existente. A pilha de software descrita acima não é substituída. O objetivo do diagrama é representar as **conexões físicas**, não os caminhos lógicos entre Android e Debian.

### Conexões do conjunto

```mermaid
flowchart LR
    subgraph Gabinete["Gabinete Linudex"]
        S["Galaxy S10+"]
        E["Extensor USB-C macho/fêmea"]
        H["Hub USB-C 8 em 1"]
        P["Extensor P2 3,5 mm"]
        J["Saída de áudio traseira"]
        S -->|"USB-C"| E
        E -->|"USB-C host"| H
        S -->|"P2"| P
        P --> J
    end
    C["Carregador multiportas"] -->|"PD-IN do hub"| H
    H -->|"HDMI, cabo 2 m"| M["Monitor externo do PC"]
    H -->|"USB-A"| R["Receptor USB do kit sem fio"]
```

A porta PD-IN do hub recebe alimentação do carregador. O HDMI já foi testado com um monitor do PC, sem que seja necessário adquirir um monitor exclusivo para fechar a v0.4.0. As demais portas do hub, como Ethernet, SD, TF/microSD e USB-C de dados, permanecem acessíveis, mas não devem ser confundidas com conexões em uso no diagrama.

![Linudex montado](../images/build/mounted-linudex.png)

### Alimentação dos fans

O caminho efetivamente utilizado conecta o cabo USB-C/12 V ao adaptador DC5521 e, em seguida, ao **conector pequeno de fan** do conjunto de coolers. O anúncio do adaptador descreve uma saída de 4 pinos PWM; os conectores Molex periféricos grandes dos fans não foram usados nesse caminho.

```mermaid
flowchart TD
    C["Carregador — porta USB-C PD"]
    T["Cabo USB-C PD → DC5521, nominal 12 V"]
    A["Adaptador DC5521 → conector fan 4 pinos"]
    F["Conector pequeno do conjunto de fans"]
    F1["Fan 80 mm — 1"]
    F2["Fan 80 mm — 2"]
    C --> T --> A --> F
    F --> F1
    F --> F2
```

**Observação de validação:** O perfil de 12 V do carregador e do cabo trigger ainda precisa ser verificado com instrumento apropriado. Não se deve ligar o conector Molex grande e o conector pequeno à alimentação simultaneamente.

### Fluxo de ar

```mermaid
flowchart TB
    A["Aberturas passivas superiores, frontais e laterais"] -.->|"Entrada de ar presumida"| I["Interior do gabinete / Galaxy S10+"]
    I -->|"Exaustão confirmada pelo teste do papel"| F1["Fan 1 — 80 mm"]
    I -->|"Exaustão confirmada pelo teste do papel"| F2["Fan 2 — 80 mm"]
    F1 --> E["Ar externo"]
    F2 --> E
```

Os dois fans expulsam ar para fora do gabinete, conforme teste com papel realizado pelos lados interno e externo. A presença de múltiplas grades torna plausível a entrada passiva de ar, mas o caminho exato não foi medido: o papel não apresentou deslocamento perceptível nessas grades. Ver [Hardware](hardware.pt.md) e [Benchmarks](benchmarks.pt.md) para detalhes dos testes.

## Integração de interface e estado Android

A personalização da v0.5.0 mantém as camadas Android → Termux → PRoot-Distro → Debian ARM64 → XFCE já descritas. A novidade é uma ponte **somente de leitura** de indicadores do Android para o painel XFCE. Não há comunicação direta do Genmon com as APIs do Android: o monitor executa no Termux e publica JSONs no diretório compartilhado.

```mermaid
flowchart TD
    A["Android / Termux:API"] --> B["Monitor do Termux: battery e wifi"]
    B --> C["$HOME/.linudex/status/*.json"]
    C --> D["Debian PRoot: linudex-status"]
    D --> E["XFCE Genmon: ícone e tooltip"]
    F["Start/Stop Linudex"] -->|"start/stop"| B
    G["Termux:X11 :1"] --> H["XFCE / Docklike / Whisker / Genmon"]
    E --> H
```

- Host Termux: `android-monitor.sh` consulta os comandos `termux-battery-status` e `termux-wifi-connectioninfo`, com limite de 15 segundos por consulta, troca atômica do JSON temporário e espera de 45 segundos após cada ciclo; `android-monitor-control.sh` gerencia `start`, `stop`, `status` e arquivo PID.
- Convidado Debian: `~/.local/bin/linudex-status` lê `/data/data/com.termux/files/home/.linudex/status/{battery,wifi}.json`, valida idade máxima de 180 segundos e imprime tags `<icon>`, `<txt>` e `<tool>` para o Genmon.
- Os dois plugins Genmon atualizam a exibição a cada 15 segundos; os scripts do painel não consultam a API Android diretamente. Em caso de leitura ausente ou antiga, exibem indicador indisponível.
- Um terceiro Genmon chama `linudex-desktop-button`, cuja ação `linudex-toggle-desktop` utiliza a propriedade X11 `_NET_SHOWING_DESKTOP` e `wmctrl`.
- A sessão usa `DISPLAY=:1`, PulseAudio via `tcp:127.0.0.1` e D-Bus de sessão iniciado com `dbus-launch`. A preferência física de scancodes pertence ao aplicativo Android Termux:X11, fora dos XML do Debian.

A correção do nome do monitor na rotina `cleanup()` do script de inicialização deve ser publicada e validada; o backup exportado ainda contém `adnroid-monitor-control.sh`. Os WebApps Chromium/Netflix/YouTube rodam no Debian e são identificados no Docklike pelas classes das janelas. Executar Chromium com `--no-sandbox` não cria isolamento de segurança no PRoot, mesmo quando aparece como uma janela independente no XFCE.

## Ações de interface entre Debian e Android

A v0.5.1 adiciona uma rota de **abertura de configurações Android** a partir de componentes do XFCE, sem alterar a arquitetura de inicialização nem o monitor de bateria/Wi-Fi da v0.5.0:

```mermaid
flowchart LR
    A["XFCE: Wi-Fi clicável / QuickMenu"] --> B["Debian: linudex-android-settings"]
    B --> C["TermuxAm: /data/data/com.termux/files/usr/bin/am"]
    C --> D["Android: Settings Wi-Fi / Bluetooth"]
    A --> E["Debian: gThumb / XFCE Settings"]
```

O `linudex-wifi-click` adiciona `<iconclick>` à saída existente de `linudex-status wifi`, preservando a leitura passiva de JSON descrita na v0.5.0. O `linudex-quickmenu-indicator` produz a seta e sua ação de clique; o menu GTK é criado sob demanda. A chamada direta pelo `/system/bin/am` falhou com `SecurityException` por divergência entre pacote e UID, enquanto o executável do Termux funcionou dentro do Debian. Não foram necessários mudanças de permissões de sistema ou um serviço residente adicional.

## Navegador Android acionado pelo desktop Debian — v0.5.2

O lançador do Samsung Internet adiciona um **fluxo de controle**, não uma nova instalação de navegador Linux:

```mermaid
flowchart LR
    A["Menu XFCE / Docklike"] --> B["Script no Debian"]
    B --> C["TermuxAm: am start"]
    C --> D["Android: Samsung Internet"]
    D --> E["Samsung DeX: janela do aplicativo"]
    F["Debian / Termux:X11 / XFCE"] --> G["Superfície de desktop no DeX"]
    E --> G
```

O Samsung Internet executa como **aplicativo Android**. Sua janela é gerenciada pelo Samsung DeX e pode ficar à frente ou atrás da superfície do Debian conforme o foco muda. Assim, clicar em um aplicativo XFCE pode fazer o navegador desaparecer atrás do Debian, embora ele continue aberto. Clicar novamente no lançador traz o navegador de volta à frente no ambiente testado. Trata-se de um comportamento de foco/empilhamento de janelas, não de travamento do navegador e nem de uma tarefa XFCE dentro da sessão X11 do Debian.

O launcher validado chama `/data/data/com.termux/files/usr/bin/am start --user 0 com.sec.android.app.sbrowser`. O parâmetro `--user 0` seleciona o usuário Android principal, sem conceder root. `F11` ativou a tela cheia e ocultou a barra superior da janela DeX nos testes com Galaxy S10+. O comportamento pode variar conforme a versão do Android/DeX.
