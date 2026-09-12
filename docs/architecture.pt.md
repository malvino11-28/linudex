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
        ┌───────┴────────┐
        │                │
   Samsung DeX        Termux
                         │
              ┌──────────┴──────────┐
              │                     │
        Termux:X11             PRoot-Distro
                                      │
                                 Debian 13
                                      │
                                    XFCE
```

## Responsabilidade de cada camada

### Android / One UI

Fornece o kernel Linux, drivers Samsung, rede, USB, pilha de áudio, gerenciamento de energia e a infraestrutura de vídeo subjacente.

### Samsung DeX

Fornece o ambiente desktop Android e suporte confiável ao monitor externo via USB-C. O DeX é preservado intencionalmente durante o debloat porque continua fazendo parte do host mesmo quando o desktop Linux está em execução.

### Termux

Fornece o ambiente de linha de comando utilizado para instalar e iniciar PRoot-Distro e Termux:X11.

### PRoot-Distro

Fornece o filesystem raiz e o userspace do Debian sem exigir root no Android. Como o PRoot compartilha o kernel do Android, alguns recursos Linux de baixo nível e métricas de hardware não ficam disponíveis exatamente como ficariam em uma instalação Debian nativa.

### Debian 13 ARM64

Fornece o userspace GNU/Linux, gerenciador de pacotes e aplicativos desktop. A instalação recebe o nome `linudex` no PRoot-Distro.

### Termux:X11

Fornece o servidor X11 que conecta os aplicativos gráficos Linux ao Android.

### XFCE

Fornece o desktop gráfico leve utilizado na prova de conceito da v0.1.

## Por que esta arquitetura

O Galaxy S10+ já possui drivers Android maduros para a plataforma Exynos, saída de vídeo USB-C e periféricos. Manter o Android evita o suporte incompleto de hardware dos ports Linux nativos atualmente disponíveis para esse aparelho, ao mesmo tempo em que permite utilizar um userspace Debian convencional.

## Limitações importantes

- O Debian não controla o kernel; ele compartilha o kernel do Android.
- PRoot não é uma VM e não fornece virtualização de hardware.
- Algumas métricas de `/proc` são restringidas pelo SELinux do Android; por isso a CPU é medida via ADB, e não pelo `htop` dentro do Debian.
- `systemd` tradicional, gerenciamento de módulos do kernel e workloads como Docker padrão estão fora do escopo atual da v0.1.
- Políticas de gerenciamento de processos do Android podem encerrar a árvore de processos do PRoot caso o Phantom Process Killer não seja mitigado.
