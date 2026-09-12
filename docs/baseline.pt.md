# Baseline do sistema

[English](baseline.md)

Medições registradas antes do debloat, instalação do Linux e modificações de hardware.

## Dispositivo

| Item        | Valor               |
| ----------- | ------------------- |
| Dispositivo | Samsung Galaxy S10+ |
| Modelo      | SM-G975F            |
| Codename    | `beyond2`           |
| Arquitetura | ARM64 / AArch64     |
| SoC         | Exynos 9820         |

## Software

| Item               | Valor                           |
| ------------------ | ------------------------------- |
| Android            | 12                              |
| One UI             | 4.1                             |
| SDK                | 31                              |
| Build              | `SP1A.210812.016.G975FXXSGHWA3` |
| Patch de segurança | 2023-01-01                      |

## Memória

| Item                   | Valor  |
| ---------------------- | ------ |
| RAM nominal            | 8 GB   |
| RAM visível ao sistema | 7.3 GB |

## Armazenamento

| Item                       | Valor  |
| -------------------------- | ------ |
| Armazenamento interno      | 128 GB |
| Usado                      | 31 GB  |
| Disponível                 | 79 GB  |
| Pacotes Android instalados | 270    |

## Bateria

| Item                           | Valor      |
| ------------------------------ | ---------- |
| Código de saúde do Android     | 2 (`GOOD`) |
| Carga durante a medição        | 85%        |
| Tensão                         | 4.12 V     |
| Temperatura da bateria em idle | 28.0 °C    |

A temperatura informada corresponde ao sensor da bateria, e não à temperatura do SoC Exynos.

## Conectividade

| Recurso           | Estado                  |
| ----------------- | ----------------------- |
| Wi-Fi             | Funcionando             |
| Acesso à internet | Funcionando             |
| Bluetooth         | Funcionando             |
| Ethernet          | Não testado no baseline |

## Desktop / I/O

| Recurso           | Estado                  |
| ----------------- | ----------------------- |
| Samsung DeX       | Funcionando             |
| Saída HDMI        | Funcionando             |
| Teclado           | Não testado no baseline |
| Mouse             | Não testado no baseline |
| Armazenamento USB | Não testado no baseline |
| Áudio via HDMI    | Não testado no baseline |

## Condições conhecidas antes das modificações

- A tela integrada está fisicamente danificada.
- Inicialmente a internet aparecia indisponível mesmo com o Wi-Fi conectado; a causa era data/hora incorretas e foi resolvida ativando data e hora automáticas.
- O comportamento térmico ainda precisava ser validado antes dos testes de carga de desktop.

Consulte [Troubleshooting](troubleshooting.pt.md) e [Benchmarks](benchmarks.pt.md) para os resultados obtidos após este baseline.
