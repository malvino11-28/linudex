# Benchmarks

[Português](benchmarks.pt.md)

Initial v0.1 validation focused on practical desktop workloads rather than synthetic benchmark scores.

## Method

- Debian 13 ARM64 running through PRoot-Distro.
- XFCE rendered through Termux:X11.
- CPU usage collected from Android through ADB (`dumpsys cpuinfo`) because Android SELinux restrictions prevent reliable global CPU readings from `htop` inside PRoot.
- RAM collected from Debian with `free -h`.
- Battery temperature collected through ADB (`dumpsys battery`).
- Each workload was allowed to settle before values were recorded.

The battery temperature is not the SoC temperature.

## Results

| Test                         | RAM used | RAM available | CPU total | CPU breakdown           | Battery temp. | Stability |
| ---------------------------- | -------: | ------------: | --------: | ----------------------- | ------------: | --------- |
| XFCE idle                    |  3.4 GiB |       3.8 GiB |       10% | 4.9% user + 5.9% kernel |       27.8 °C | Stable    |
| XFCE + Firefox               |  3.4 GiB |       3.9 GiB |       13% | 6.0% user + 7.2% kernel |       29.8 °C | Stable    |
| Firefox + 5 tabs             |  3.4 GiB |       3.8 GiB |       16% | 7.5% user + 8.3% kernel |       30.7 °C | Stable    |
| YouTube 1440p in Firefox ESR |  4.2 GiB |       3.1 GiB |       62% | 40% user + 22% kernel   |       33.0 °C | Stable    |

Total RAM reported during these tests was approximately 7.2 GiB.

## Observations

- All recorded v0.1 workloads remained stable.
- YouTube 1440p was the heaviest tested workload and produced the largest increase in both CPU usage and RAM consumption.
- The battery temperature remained at 33.0 °C during the 1440p test.
- The results validate the software stack as a usable proof of concept, but they do not yet measure SoC temperature, hardware video-decoding efficiency or long-duration thermal throttling.
- After increasing the Android 12 phantom-process limit, the previous random `SIGKILL` (`signal 9`) terminations were no longer observed during these tests.

## Metrics to preserve for future tests

For consistent comparisons, record at minimum:

```text
CPU total: XX%
RAM used: X.X GiB
RAM available: X.X GiB
Battery temperature: XX.X °C
Stability: Stable / Unstable
```

Use the final `XX% TOTAL` line from `adb shell dumpsys cpuinfo` for CPU and the `temperature:` field from `adb shell dumpsys battery`, divided by 10, for battery temperature.

---

Xonotic 0.8.6 — Linux x86_64 via Box64

Architecture:
x86_64 Linux → Box64 → ARM64

GPU path:
OpenGL → virpipe → VirGL → ANGLE → Vulkan → Mali-G76

Box64:
0.4.5 PRoot build (`BAD_SIGNAL=ON`)

---

Resolution:
1280x720

VSync: Disabled

FPS cap: 60

Timedemo: timedemo demos/the-big-keybench.dem

Run: 1 minute

- Average FPS: 14
- 1s min: 14
- 1s avg: 17
- 1s max: 20

Battery (Charging in PC):

- Initial level: 84
- Final level: 84
- Initial temperature: 28.2
- Maximum temperature: 32.3

Android CPU:

- Typical TOTAL: ~16% (7% user + 9% kernel)
- Peak TOTAL: ~33% (17% user + 15% kernel)

RAM (In game):

- Before: 3.1gb ~ 3.2gb
- During: 2.4gb ~ 2.5gb

Stability:

- Crashes: 0
- Rendering issues: 0
- Audio issues: 0

----------------

Resolution:
1920x1080

VSync: Disabled

FPS cap: 60

Timedemo: timedemo demos/the-big-keybench.dem

Run: 1 minute

- Average FPS:
- 1s min: 8
- 1s avg: 11
- 1s max: 15

Battery (Charging in PC):

- Initial level: 84
- Final level: 84
- Initial temperature: 27.9
- Maximum temperature: 28.3

Android CPU:

- Typical TOTAL: 16% (7% user + 9% kernel)
- Peak TOTAL: 29% (15% user + 14% kernel)

RAM (In game):

- Before: ~3.8gb
- During: ~2.4gb

Stability:

- Crashes: 0
- Rendering issues: 0
- Audio issues: 0

---
