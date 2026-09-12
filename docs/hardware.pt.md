# Hardware

[English](hardware.md)

## Dispositivo principal

O Linudex v0.1 roda em um **Samsung Galaxy S10+ (SM-G975F)** com a tela integrada danificada, mas com o restante do hardware principal funcional.

| Componente            | Especificação / estado                        |
| --------------------- | --------------------------------------------- |
| SoC                   | Samsung Exynos 9820                           |
| Arquitetura           | ARM64 / AArch64                               |
| RAM                   | 8 GB nominal                                  |
| Armazenamento interno | 128 GB                                        |
| USB                   | USB-C                                         |
| Saída desktop externa | Samsung DeX através da conexão de vídeo USB-C |
| Tela integrada        | Fisicamente danificada                        |

## Ambiente de teste da v0.1

O marco de software foi validado utilizando monitor externo através do Samsung DeX e periféricos externos conforme necessário. Os modelos exatos dos periféricos não foram registrados nas anotações da v0.1 e, portanto, não são inventados nesta documentação.

## Bateria e energia

- O estado de saúde da bateria reportado pelo Android estava como `GOOD` durante o baseline.
- O carregamento foi limitado a 85% como medida de preservação da bateria para o uso estacionário como PC.
- O RAM Plus foi configurado para 8 GB durante os ajustes do host Android. RAM Plus é memória virtual baseada no armazenamento.

## Resultados térmicos da v0.1

Inicialmente havia suspeita de aquecimento anormal no aparelho. Os benchmarks posteriores de desktop permaneceram estáveis e registraram temperaturas da bateria entre **27.8 °C e 33.0 °C** nos testes documentados.

O ponto quente inicialmente observado estava associado à tela integrada danificada quando ela permanecia acesa; com a tela do telefone desligada durante o uso do DeX, o aparelho esfriou consideravelmente. Portanto, refrigeração ativa e gabinete final continuam como tarefas da fase de hardware, e não como requisitos para o marco de software da v0.1.

## Construção física futura

A montagem final em formato de PC está fora do escopo da v0.1. As áreas planejadas incluem:

- Gabinete compacto.
- Integração do hub USB-C.
- Fluxo de ar ativo/suporte para fan.
- Organização de cabos.
- Acesso conveniente às portas USB, vídeo, rede e alimentação.
- Validação térmica prolongada após a montagem no gabinete.

Os modelos e preços finais dos componentes devem ser registrados na [lista de materiais](../bom/components.pt.md) após compra e validação.
