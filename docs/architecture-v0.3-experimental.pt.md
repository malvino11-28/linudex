# Linudex v0.3.0 — Arquitetura de compatibilidade x86/x86-64

[English](architecture-v0.3.md) · [Arquitetura principal](architecture.pt.md)

> **Estado: experimental.** Este documento descreve a implementação testada no Galaxy S10+, sem garantir resultados equiva2lentes em outros aparelhos. O desktop Debian/XFCE da v0.2.1 continua sendo a base estável.

## Ambientes host e de execução

- **Hardware:** Samsung Galaxy S10+ (Exynos 9820; ARM64; Mali-G76 MP12; 8 GB de RAM nominal).
- **Host:** Android 12 / One UI 4.1, Samsung DeX e Termux, **sem root no Android**.
- **Ambiente Linux:** Debian 13 ARM64 via PRoot-Distro, compartilhando o kernel do Android; XFCE via Termux:X11.
- **Áudio:** aplicativos Debian utilizam o PulseAudio do Termux em `tcp:127.0.0.1`.
- **Inicialização:** os scripts de boot e sessão da v0.2.1 continuam controlando o desktop; a camada de compatibilidade é iniciada separadamente, quando necessária.

O PRoot-Distro não é uma máquina virtual com virtualização de hardware nem uma instalação Linux nativa no aparelho. O Box64 traduz instruções de programas x86-64 para ARM64; ele **não** emula um computador completo.

## Aplicativos Linux x86-64

```text
Programa Linux x86-64 (ex.: Xonotic)
           │
           ▼
         Box64
           │  tradução de userspace x86-64 → ARM64
           ▼
       Debian ARM64
           │
           ├── Serviços / bibliotecas Linux
           └── Mesa OpenGL (virpipe)
                    │
                    ▼
                  VirGL
                    │
                    ▼
             ANGLE / Vulkan
                    │
                    ▼
          Vulkan do Android / Mali-G76
```

O caminho Linux testado usa o Box64 0.4.5 compilado manualmente (`/usr/local/bin/box64-0.4.5-manual`) por meio do wrapper local `~/run-x86_64.sh`. No Termux, o auxiliar `~/start-linux-gpu.sh` configura o perfil gráfico Linux (`vgl cfg=gl`, `vgl angle=vulkan`). O conteúdo exato dos wrappers deve ser exportado do aparelho antes de ser versionado.

## Aplicativos Windows x86-64

```text
Executável Windows x86-64
           │
           ▼
      Box64 0.3.4
           │
           ▼
 Wine 9.18-staging (x86-64)
           │
           ▼
      WineD3D 9.2
           │ tradução Direct3D → OpenGL
           ▼
   Mesa / virpipe / VirGL
           │
           ▼
      ANGLE / Vulkan
           │
           ▼
     Android / Mali-G76
```

O caminho Windows validado utiliza `/usr/bin/box64`, o lançador `~/xow64` e o prefixo Wine `~/xow64_prefix/.xow64_test`. A versão selecionada do Wine é `9.18-staging`. No Termux, o auxiliar `~/start-wine-gpu.sh` seleciona o perfil Direct3D (`vgl cfg=d3d`, `vgl angle=vulkan-null`). Isso **descreve a configuração testada**, mas não garante compatibilidade com qualquer aplicativo Direct3D.

`vulkan-null` é o nome do perfil usado na configuração ANGLE testada. Não significa suporte nativo ao Vulkan de Windows nem acesso direto do Debian à GPU Mali.

## Papel da ponte gráfica

O VirGL apresenta uma GPU virtual ao userspace Linux. Assim, programas podem identificar o renderizador como **Red Hat VirtIO GPU**, em vez de **Mali-G76**. Os feature levels e recursos de shader expostos pelo WineD3D podem ser inferiores aos da GPU física. Cada camada de tradução também pode introduzir sobrecarga de CPU/GPU e sincronização.

Por exemplo, o _9 Kings_ inicializou Direct3D 11 em **feature level 10_1**, mas relatou ausência de recursos de shader/compute. Ao forçar OpenGL 4.1, a inicialização gráfica da engine falhou. Isso descreve a limitação do caminho de software testado, e não prova uma limitação física da Mali-G76.

## Componentes e responsabilidades

| Camada                        | Componente testado          | Função                                                        |
| ----------------------------- | --------------------------- | ------------------------------------------------------------- |
| Host ARM64                    | Termux / Debian 13 PRoot    | Ambiente de execução Linux                                    |
| Tradução x86-64 para Windows  | Box64 0.3.4                 | Executar binários x86-64 do Wine                              |
| Tradução x86-64 para Linux    | Box64 manual 0.4.5          | Executar aplicativos Linux x86-64                             |
| Compatibilidade Windows       | Wine 9.18-staging           | APIs e ambiente de processos Windows                          |
| Tradução 3D                   | WineD3D 9.2                 | Direct3D para OpenGL                                          |
| Caminho gráfico virtual       | Mesa virpipe / VirGL        | Encaminhamento dos comandos de renderização                   |
| Tradução gráfica para Android | ANGLE                       | Encaminhamento em direção ao Vulkan do Android                |
| Distribuição de jogos         | DepotDownloader 3.4.0 ARM64 | Obter depots Steam autorizados sem abrir a interface da Steam |

Box64 0.4.4, builds `main` e `linudex` modificadas, experimentos Wine 10.12/11.17 e SteamWebHelper **não são necessários** para a configuração básica testada. São registros de pesquisa histórica quando pertinentes.

## Limitações principais

1. **Desempenho:** a sobrecarga das traduções é significativa. Abrir um programa não significa obter jogabilidade fluida.
2. **Gráficos:** os recursos OpenGL/Direct3D dependem de todas as camadas, não apenas da Mali-G76.
3. **Steam:** o DepotDownloader baixa arquivos acessíveis à conta do usuário. Não contorna exigências de inicialização Steamworks, DRM ou licenciamento.
4. **Memória:** a Steam Windows completa produziu alta pressão de memória pelo SteamWebHelper. O teste bem-sucedido do _Seraph's Last Stand_ usou arquivos baixados e não precisou manter a interface Steam aberta.
5. **Isolamento:** encerrar Wine e servidor gráfico não deve encerrar XFCE ou Termux:X11. **Não** use o comando experimental `~/xow64 q`; utilize `~/stop-xow64-wine.sh`, validado e restrito ao prefixo.
6. **Reprodutibilidade:** o sistema foi montado em vários experimentos manuais; uma instalação integral do zero a partir do repositório ainda não foi validada na v0.3.0.

## Documentos relacionados

- [Configuração e operação da v0.3](compatibility.pt.md)
- [Resultados da v0.3](benchmarks-v0.3.0.pt.md)
- [Troubleshooting da v0.3](troubleshooting/troubleshooting-v0.3.0.pt.md)
