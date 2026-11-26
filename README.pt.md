# Linudex

[English](README.md)

Linudex é um projeto de reaproveitamento que transforma um Samsung Galaxy S10+ com a tela danificada em um ambiente desktop ARM compacto. A pilha atual preserva o Samsung DeX e o Android como camada de hardware/drivers, enquanto Termux, PRoot-Distro, Debian e XFCE fornecem o ambiente desktop Linux.

## v0.1.0 — Linux Desktop Boot

A versão `v0.1.0` marca o primeiro estágio gráfico estável do Linux. Neste ponto, o Linudex consegue iniciar o Debian 13 ARM64 com XFCE através do Termux:X11 e permanecer estável nas cargas de desktop testadas.

## v0.2.0 — Ambiente Daily Driver

A versão `v0.2.0` parte do desktop Linux estável estabelecido na v0.1.0 e o transforma em um ambiente mais prático para uso diário. Áudio, armazenamento compartilhado, ajustes do desktop, aplicativos essenciais e automação de inicialização agora fazem parte do fluxo do Linudex.

## v0.2.1 — Correção da Inicialização Automática

A versão `v0.2.1` é uma atualização que corrige um bug da inicialização automática do Linudex causado por um erro ao tentar rodar o PulseAudio durante um cold boot.

## v0.3.0 — Compatibilidade experimental x86/x86-64

A versão `v0.3.0` acrescenta caminhos opcionais para executar programas Linux e Windows x86-64 com Box64, Wine, WineD3D e VirGL/ANGLE. Xonotic e Seraph's Last Stand abriram no ambiente testado, mas cargas 3D exigentes permaneceram lentas e alguns jogos não funcionaram. A camada de compatibilidade é experimental; o desktop Debian/XFCE da v0.2.1 continua sendo a base estável.

## v0.4.0 — Integração física de hardware

A v0.4.0 reúne o Galaxy S10+, um hub USB-C 8 em 1 e dois fans de 80 mm em um gabinete Nano. Foram integrados cabos HDMI, USB-C e P2, além de um kit de teclado e mouse sem fio. A saída HDMI já foi testada com um monitor do PC, sem necessidade de monitor dedicado nesta etapa.

Os dois fans funcionam como **exaustores** e foram testados em conjunto. Durante reproduções de YouTube 1080p, as temperaturas informadas foram **35,2 °C com os fans ligados** e **40,2 °C com eles desligados**, uma diferença observada de 5,0 °C. Os testes são preliminares e não medem temperatura do SoC. A verificação instrumental de tensão e polaridade da alimentação de refrigeração permanece pendente.

![Linudex montado](/images/build/mounted-linudex.png)

## v0.5.0 — Interface inspirada no Windows 10

A v0.5.0 moderniza a experiência do XFCE no Galaxy S10+, com tema e ícones Windows 10, logo LX no Whisker Menu, Docklike, pesquisa por Application Finder, indicadores de bateria/Wi-Fi do Android via Termux:API e botão Mostrar Área de Trabalho. O teclado ABNT2, os atalhos principais e a inicialização/persistência foram validados. A versão também documenta o Chromium ARM64 e WebApps Netflix/YouTube como recursos experimentais; a reprodução de um filme completo na Netflix foi observada no dispositivo testado.

## v0.5.1 — Refinamentos de usabilidade do desktop

A versão **v0.5.1** foca em refinamentos de usabilidade na interface do desktop, sem alterações profundas no sistema ou novos benchmarks. As melhorias incluem a integração da busca **LinuDex Search v3** à barra de tarefas (com ícones e navegação por teclado), a remoção do painel superior, a adição de um **QuickMenu** escuro e de um atalho clicável de Wi-Fi no painel inferior, além de um novo ícone de pasta para o Thunar. O acesso ao `AndroidStorage` também foi restaurado e validado no Galaxy S10+ ao habilitar a permissão de "Acesso a todos os arquivos" no Termux e Termux:API. Por fim, o Chromium sem sandbox segue como uma limitação conhecida e os arquivos-fonte testados localmente ainda precisam ser incluídos no repositório antes da criação da tag da versão.

## v0.5.2 — Navegação segura e integração Android

A versão **v0.5.2** prioriza o Samsung Internet como navegador principal do Galaxy S10+ no Samsung DeX após investigar as limitações de sandbox de navegadores Linux no Debian PRoot. O navegador Android exibiu sites em 1920×1080 em modo computador e permitiu tela cheia pelo `F11`. Um lançador Debian via TermuxAm possibilita sua abertura pelo menu XFCE e fixação no Docklike. **O navegador roda no Android sobre o desktop Debian, não dentro do XFCE**: clicar em outras janelas Linux pode trazer o Debian para a frente, e acionar o lançador novamente faz o navegador reaparecer. As regras CSS antigas da pesquisa foram removidas para evitar efeitos sobre outros lançadores XFCE. O Chromium continua disponível apenas para usos específicos nos WebApps Netflix/YouTube; o problema do `--no-sandbox` não foi resolvido nesta versão.

## v0.6.0 — Desempenho e manutenção do sistema

A versão **v0.6.0** investiga Android, Termux, Debian, RAM, processos e aceleração gráfica no Galaxy S10+ (Exynos 9820/Mali-G76). A inicialização do Termux:X11 recebeu verificações de disponibilidade; a aceleração VirGL + ANGLE foi disponibilizada **manualmente** pelos comandos `start-linux-gpu.sh` e `linudex-gpu`; o Debian foi atualizado para **13.8**, e caches de navegadores Linux não prioritários foram removidos. Foram investigados overhead do PRoot, memória, políticas de energia e temperaturas, sem comprovação de aumento geral de velocidade. Consulte [Benchmarks](docs/benchmarks.pt.md) e [Configuração de software](docs/software.pt.md).

### Concluído

- Armazenamento compartilhado do Android integrado ao Debian.
- Ponte PulseAudio configurada entre aplicativos Debian, Termux e Android/DeX.
- XFCE ajustado para uso em 1920×1080, com DPI 115 e compositor desativado.
- Painel do desktop, Whisker Menu e atalhos de aplicativos configurados.
- Aplicativos essenciais instalados e validados, incluindo Firefox ESR, LibreOffice, VLC, Evince e utilitários de compactação.
- Fontes compatíveis com documentos Office e suporte a idioma/correção ortográfica em português do Brasil instalados.
- `start-linudex.sh` e `stop-linudex.sh` ampliados para gerenciar áudio, Termux:X11 e a sessão Debian/XFCE.
- Termux:Boot configurado para iniciar o Linudex automaticamente após o boot do Android.
- Termux:Widget configurado para controle manual de start/stop quando necessário.
- Termux:X11 configurado para abrir automaticamente quando o Linudex é iniciado.
- Testada a execução de software Linux x86-64 com Box64 e a ponte gráfica OpenGL.
- Testada a execução de software Windows x86-64 com Wine 9.18-staging e WineD3D 9.2.
- Validado o DepotDownloader 3.4.0 ARM64 como alternativa ao SteamWebHelper para baixar arquivos autorizados pela conta.
- Documentados desempenho gráfico, limitações de memória e testes de compatibilidade malsucedidos.
- Mantidos os launchers de compatibilidade separados da inicialização automática existente do XFCE.
- Integrados gabinete, hub, conexões de vídeo e áudio externo, e dois fans de 80 mm, com teste térmico preliminar da v0.4.0.

## Arquitetura

```text
Samsung Galaxy S10+
└── Android 12 / One UI 4.1
    ├── Samsung DeX
    ├── Termux:Boot / Termux:Widget
    └── Termux
        ├── PulseAudio
        ├── Termux:X11
        └── PRoot-Distro
            └── Debian 13 ARM64
                └── XFCE
```

Esse desenho mantém o Android intencionalmente, pois ele fornece suporte ao hardware do Galaxy S10+, incluindo saída de vídeo USB-C, roteamento de áudio e Samsung DeX. O Debian roda como um ambiente de userspace sobre o kernel do Android, e não como uma máquina virtual.

Os caminhos de compatibilidade x86-64 utilizam Box64 e uma ponte gráfica opcional, além da arquitetura desktop apresentada acima. A v0.4.0 adiciona uma organização física para os componentes sem substituir a pilha de software. Consulte [Arquitetura](docs/architecture.pt.md) para os diagramas de conexões, alimentação e fluxo de ar.

## Estado atual

O ambiente para uso diário estabelecido na v0.2.1 permanece como base estável. A v0.3.0 acrescenta uma camada experimental de compatibilidade x86/x86-64; seus resultados de jogos são limitados e estão documentados, sem promessa de desempenho adequado.

A v0.4.0 dispõe de gabinete, hub, vídeo, extensão de áudio e refrigeração ativa em funcionamento na montagem testada. O monitor dedicado ainda não foi adquirido, mas o HDMI foi validado com uma tela existente. A alimentação dos fans funcionou nos testes práticos, porém a confirmação instrumental do perfil de 12 V, polaridade e corrente continua pendente; o carregador apresentou chiado discreto em algumas condições de baixa carga. Os dados térmicos devem ser interpretados como comparações preliminares.

<p align="center">
  <img src="images/screenshots/linudex-v0.2-desktop.png"
       alt="Desktop XFCE do Linudex v0.2.0"
       width="800">
</p>

## Documentação

- [Baseline do sistema](docs/baseline.pt.md)
- [Arquitetura](docs/architecture.pt.md)
- [Debloat do Android](docs/debloat.pt.md)
- [Configuração de software](docs/software.pt.md)
- [Hardware](docs/hardware.pt.md)
- [Benchmarks](docs/benchmarks.pt.md)
- [Troubleshooting](docs/troubleshooting/README.pt.md)
- [Lista de materiais](bom/components.pt.md)

## Estrutura do repositório

```text
linudex/
├── README.md
├── README.pt.md
├── docs/
│   ├── architecture.md
│   ├── baseline.md
│   ├── benchmarks.md
│   ├── debloat.md
│   ├── hardware.md
│   ├── software.md
│   └── troubleshooting/
│       ├── README.md
│       ├── troubleshooting-v0.1.0.md
│       ├── troubleshooting-v0.2.0.md
│       ├── troubleshooting-v0.2.1.md
│       ├── troubleshooting-v0.3.0.md
│       └── troubleshooting-v0.4.0.md
├── images/
│   ├── benchmarks/
│   ├── build/
│   └── screenshots/
├── scripts/
├── configs/
└── bom/
```

Todo documento Markdown possui uma contraparte em português usando o sufixo `*.pt.md`.

## Organização das imagens

Use as pastas de imagens conforme a finalidade:

- `images/build/` — progresso da montagem física, gabinete, hub e refrigeração.
- `images/screenshots/` — capturas do DeX, Termux, Debian e XFCE.
- `images/benchmarks/` — capturas e gráficos dos benchmarks.

Evite colocar capturas diretamente em `docs/`; a documentação deve referenciar o arquivo correspondente dentro de `images/`.

## Escopo do projeto

Linudex é um projeto experimental de reaproveitamento. O objetivo não é substituir um PC x86 convencional em todas as cargas de trabalho, mas avaliar até onde um smartphone flagship danificado, porém funcional, pode ser reaproveitado como desktop ARM de baixo custo.

<p align="center">
  <img src="images/build/v0.1-dex-test-setup.png"
       alt="Linudex v0.1 executando Samsung DeX em um monitor externo"
       width="800">
</p>

## Licença

Este projeto é um software livre: você pode redistribuí-lo e/ou modificá-lo sob os termos da Licença Pública Geral GNU (GNU GPL) conforme publicada pela Free Software Foundation, seja a versão 3 da Licença, ou qualquer versão posterior.

Os diagramas, imagens e documentação textual contidos neste repositório também estão protegidos sob os mesmos termos da GNU GPL v3.
