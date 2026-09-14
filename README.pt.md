# Linudex

[English](README.md)

Linudex é um projeto de reaproveitamento que transforma um Samsung Galaxy S10+ com a tela danificada em um ambiente desktop ARM compacto. A pilha atual preserva o Samsung DeX e o Android como camada de hardware/drivers, enquanto Termux, PRoot-Distro, Debian e XFCE fornecem o ambiente desktop Linux.

## v0.1.0 — Linux Desktop Boot

A versão `v0.1` marca o primeiro estágio gráfico estável do Linux. Neste ponto, o Linudex consegue iniciar o Debian 13 ARM64 com XFCE através do Termux:X11 e permanecer estável nas cargas de desktop testadas.

## v0.2.0 — Ambiente Daily Driver

A versão `v0.2.0` parte do desktop Linux estável estabelecido na v0.1.0 e o transforma em um ambiente mais prático para uso diário. Áudio, armazenamento compartilhado, ajustes do desktop, aplicativos essenciais e automação de inicialização agora fazem parte do fluxo do Linudex.

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

## Estado atual

O Linudex `v0.2.0` representa o marco de software para uso diário. O ambiente Linux pode iniciar automaticamente após o boot do Android e agora oferece integração de armazenamento, áudio, aplicativos de escritório, navegação web e os utilitários básicos esperados de um desktop leve.

Ajustes finais de teclado/mouse, validação de cold boot diretamente no Samsung DeX através da configuração HDMI definitiva e a construção física do gabinete/refrigeração continuam dependentes do hardware final.

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
- [Troubleshooting](docs/troubleshooting.pt.md)
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
│   └── troubleshooting.md
├── images/
│   ├── benchmarks/
│   ├── build/
│   ├── diagrams/
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
- `images/diagrams/` — diagramas de arquitetura, fluxo de ar e conexões.

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
