# Hardware

[Português](hardware.pt.md)

## Core device

Linudex v0.1 runs on a **Samsung Galaxy S10+ (SM-G975F)** with a damaged built-in display but otherwise functional core hardware.

| Component               | Specification / state                     |
| ----------------------- | ----------------------------------------- |
| SoC                     | Samsung Exynos 9820                       |
| Architecture            | ARM64 / AArch64                           |
| RAM                     | 8 GB nominal                              |
| Internal storage        | 128 GB                                    |
| USB                     | USB-C                                     |
| External desktop output | Samsung DeX over USB-C display connection |
| Built-in display        | Physically damaged                        |

## v0.1 test setup

The software milestone was validated using an external display through Samsung DeX and external input devices as needed. Exact peripheral models were not documented in the v0.1 notes, so they are intentionally not invented here.

## Battery and power

- Android battery health status reported `GOOD` during the baseline.
- Charging was limited to 85% as a battery-longevity measure for the stationary-PC use case.
- RAM Plus was configured to 8 GB during Android host tuning. RAM Plus is storage-backed virtual memory.

## Thermal findings in v0.1

The project initially suspected abnormal device heating. Subsequent desktop benchmarks remained stable and recorded battery temperatures between **27.8 °C and 33.0 °C** across the documented tests.

The initially observed hotspot was associated with the damaged built-in display being active; with the phone display off while using DeX, the device cooled substantially. Active cooling and the final enclosure therefore remain hardware-development tasks rather than requirements for the v0.1 software milestone.

## Future physical build

The final PC-style build is outside v0.1. Planned areas include:

- Compact enclosure.
- USB-C hub integration.
- Active airflow/fan mounting.
- Cable management.
- Convenient access to USB, video, network and power ports.
- Long-duration thermal validation after enclosure assembly.

Final component models and prices belong in [the bill of materials](../bom/components.md) once purchased and validated.
