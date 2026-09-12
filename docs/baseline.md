# System Baseline

[Português](baseline.pt.md)

Measurements recorded before debloating, Linux installation and hardware modifications.

## Device

| Item         | Value               |
| ------------ | ------------------- |
| Device       | Samsung Galaxy S10+ |
| Model        | SM-G975F            |
| Codename     | `beyond2`           |
| Architecture | ARM64 / AArch64     |
| SoC          | Exynos 9820         |

## Software

| Item           | Value                           |
| -------------- | ------------------------------- |
| Android        | 12                              |
| One UI         | 4.1                             |
| SDK            | 31                              |
| Build          | `SP1A.210812.016.G975FXXSGHWA3` |
| Security patch | 2023-01-01                      |

## Memory

| Item              | Value  |
| ----------------- | ------ |
| Nominal RAM       | 8 GB   |
| RAM visible to OS | 7.3 GB |

## Storage

| Item                       | Value  |
| -------------------------- | ------ |
| Internal storage           | 128 GB |
| Used                       | 31 GB  |
| Available                  | 79 GB  |
| Installed Android packages | 270    |

## Battery

| Item                            | Value      |
| ------------------------------- | ---------- |
| Android health code             | 2 (`GOOD`) |
| Charge level during measurement | 85%        |
| Voltage                         | 4.12 V     |
| Idle battery temperature        | 28.0 °C    |

The reported temperature is the battery sensor value, not the Exynos SoC temperature.

## Connectivity

| Feature         | Status                 |
| --------------- | ---------------------- |
| Wi-Fi           | Working                |
| Internet access | Working                |
| Bluetooth       | Working                |
| Ethernet        | Not tested at baseline |

## Desktop / I/O

| Feature     | Status                 |
| ----------- | ---------------------- |
| Samsung DeX | Working                |
| HDMI output | Working                |
| Keyboard    | Not tested at baseline |
| Mouse       | Not tested at baseline |
| USB storage | Not tested at baseline |
| HDMI audio  | Not tested at baseline |

## Known conditions before modification

- The built-in display is physically damaged.
- Internet initially appeared unavailable even though Wi-Fi was connected; the cause was incorrect system date/time and was resolved by enabling automatic date and time.
- Heating behavior required further validation before the desktop workload was tested.

See [Troubleshooting](troubleshooting.md) and [Benchmarks](benchmarks.md) for the findings obtained after this baseline.
