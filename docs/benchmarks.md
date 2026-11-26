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

![YouTube workload and RAM monitoring](../images/benchmarks/youtube-1440p-ram.png)

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

## v0.3.0 — x86-64 compatibility and graphics tests

Version v0.3.0 introduced Box64, WineD3D and VirGL/ANGLE graphics experiments. Results were measured on the Galaxy S10+ with Debian ARM64 through PRoot-Distro. These figures describe the specific tested configuration; they are not general performance claims for the physical Mali-G76 GPU.

### OpenGL benchmark — GLMark2

| Renderer / resolution    | Score | Notes                         |
| ------------------------ | ----: | ----------------------------- |
| VirGL/ANGLE at 1280×720  |    67 | OpenGL accelerated bridge     |
| VirGL/ANGLE at 1920×1080 |    40 | Higher output resolution      |
| llvmpipe at 1280×720     |    51 | Software rendering comparison |

The VirGL/ANGLE path improved the 720p score over the llvmpipe comparison but remained slow for demanding 3D workloads. Testing `vulkan-null` instead of `vulkan` did not improve the observed 720p score.

### Xonotic — Linux x86-64

Xonotic 0.8.6 ran through the manually compiled Box64 0.4.5 and the Linux OpenGL graphics profile. The timedemo used `demos/the-big-keybench.dem`, with VSync disabled and a 60 FPS cap.

| Metric                       | 1280×720 |    1920×1080 |
| ---------------------------- | -------: | -----------: |
| Timedemo overall average FPS |       14 | Not recorded |
| One-second minimum FPS       |       14 |            8 |
| One-second average FPS       |       17 |           11 |
| One-second maximum FPS       |       20 |           15 |
| Maximum battery temperature  |  32.3 °C |      28.3 °C |
| Typical Android total CPU    |     ~16% |         ~16% |
| Observed crashes             |        0 |            0 |

### Additional Xonotic test conditions

| Metric                      |                     1280×720 |                    1920×1080 |
| --------------------------- | ---------------------------: | ---------------------------: |
| Run duration                |                     1 minute |                     1 minute |
| Initial battery level       |                          84% |                          84% |
| Final battery level         |                          84% |                          84% |
| Initial battery temperature |                      28.2 °C |                      27.9 °C |
| Peak Android total CPU      | ~33% (17% user + 15% kernel) | ~29% (15% user + 14% kernel) |
| Typical CPU breakdown       |         ~7% user + 9% kernel |         ~7% user + 9% kernel |
| Available RAM before test   |                 ~3.1–3.2 GiB |                     ~3.8 GiB |
| Available RAM during test   |                 ~2.4–2.5 GiB |                     ~2.4 GiB |
| Rendering issues            |                            0 |                            0 |
| Audio issues                |                            0 |                            0 |

The one-second average is not interchangeable with the overall timedemo average. Approximately 2.4–2.5 GiB of available RAM was observed during the 720p run. No rendering or audio failures were reported in these runs. The battery readings are not SoC temperatures.

### Windows x86-64 games and Steam

| Test                    | Result                                                | Limitation                                                                     |
| ----------------------- | ----------------------------------------------------- | ------------------------------------------------------------------------------ |
| Seraph's Last Stand     | Started and played without Steam UI                   | Approximately 10 FPS by visual observation, not an instrumented benchmark      |
| 9 Kings                 | Unity 6 launched and initialized a Direct3D 11 device | Feature level 10_1, unsupported shaders and Steam launch behavior; no gameplay |
| Terraria (Linux x86-64) | Box64 launched the executable                         | Game required launch through the Steam client                                  |
| Windows Steam client    | Installed, updated and logged in                      | SteamWebHelper caused substantial memory pressure and very slow startup        |

For Seraph, the earlier Unity resolution parameters did not preserve the lower resolution during gameplay. The `GALLIUM_HUD=fps` attempt triggered a shader compilation failure and was therefore excluded from FPS measurements. The approximate gameplay FPS must not be presented as a measured average.

During a test without Steam running, available RAM decreased from approximately 3.7 GiB to 2.2 GiB while Seraph was running with Firefox open. Steam caused a substantially larger memory impact, so the full client was excluded from further game tests.

### Interpretation

- Application startup and playable performance are different criteria.
- The primary limitation observed in these tests was the multi-layer graphics path rather than a confirmed thermal bottleneck.
- Compatibility is experimental; no general claim of smooth Windows gaming is supported.
- The hardware enclosure, fans and final peripheral setup remain outside the v0.3.0 benchmark scope.

## Active cooling and thermal tests

The v0.4.0 build uses two 80 mm fans as **exhaust fans** at the bottom of the enclosure. Test durations were reported as approximately **20 minutes per configuration**, with fans on or off. Values below are individual reported readings, not time averages or CPU temperatures.

### Recorded temperatures

| Condition           | Fans on | Fans off | Observed difference |
| ------------------- | ------: | -------: | ------------------: |
| Initial state       | 32.1 °C |  33.6 °C |             −1.5 °C |
| Firefox open        | 32.4 °C |  34.2 °C |             −1.8 °C |
| Firefox with 8 tabs | 32.9 °C |  36,7 °C |             -3,8 °C |
| YouTube 1080p       | 35.2 °C |  40.2 °C |         **−5.0 °C** |

### Interpretation and limitations

- The largest observed gap was during YouTube 1080p playback: **5.0 °C lower with the fans on**.
- Initial temperatures differed, and ambient temperature, complete time series and tightly controlled test order were not recorded. The entire 5.0 °C difference therefore cannot be assigned to the fans alone.
- The test duration was 20 minutes per test. The available observations do not establish full thermal equilibrium in every run.
- Both fans operated and their exhaust direction was confirmed by a paper-strip test.
- FPS, SoC frequency, internal SoC temperature and instrumented thermal-throttling evidence were not collected in this set of tests.

These results provide **preliminary evidence of a thermal benefit in the current enclosure**, not a certification of cooling efficiency. Instrumented measurement of the USB-C PD trigger's nominal 12 V output and polarity remains pending.

![Fans working](../images/build/fans-working.png)

## v0.5.0 — Long-running desktop and video validation

The v0.5.0 interface was exercised on the Galaxy S10+ running Debian 13 ARM64, XFCE/Termux:X11, and Chromium `156.0.8078.79`. The observed session lasted approximately **one hour** and included playing an entire Netflix movie with Widevine installed and a ChromeOS User-Agent confined to the WebApp.

| Measurement / workload  | Observed result                                                   |
| ----------------------- | ----------------------------------------------------------------- |
| Device memory available | 2.8–4.5 GB across the observation                                 |
| CPU: `proot` process    | 7.3% in one `ps` sample                                           |
| CPU: `main` process     | 3.2% in one `ps` sample                                           |
| CPU: `ps` process       | Transient 66.6% while measuring itself; not sustained utilization |
| Other sampled processes | 0.1% CPU or less, as reported                                     |
| Netflix (Chromium)      | One full movie played; no complete browser freeze reported        |
| Video playback          | Occasional brief player reloads; cause undetermined               |
| Startup / persistence   | Validated after restarting Linudex                                |

**Limitations:** the memory range denotes **available memory**, not XFCE memory usage or average RAM consumption. CPU values were snapshots, not one-hour averages; the `main` process was not identified by executable path. FPS, SoC temperature, Wi-Fi quality, CPU frequency, and isolated GPU acceleration effects were not measured.

## v0.6.0 — Graphics, PRoot and Android resource measurements

**Test device:** Galaxy S10+ `SM-G975F`, Exynos 9820 / Mali-G76, Android 12, Debian 13 ARM64 under PRoot and Termux:X11 (`DISPLAY=:1`). These are observations of one device, not a general-purpose performance rating.

### Software OpenGL versus manual VirGL + ANGLE

| Measurement | Mesa llvmpipe (CPU) | VirGL/ANGLE (Mali-G76) |
| --- | ---: | ---: |
| `glxgears`, isolated observed range | 59–92 FPS | 109–150 FPS |
| `glxgears`, typical observed value | ~70 FPS | ~140 FPS |
| `glmark2`, identical three-scene run | 58 points | 75 points |

The typical `glxgears` observations suggest about **2× FPS**, while `glmark2` scored **29.3% higher** with VirGL. Neither figure is an overall system gain. With both `glxgears` instances running together, Mali was about 6–14 FPS ahead; shared-resource contention makes simultaneous tests less suitable for comparison. Approximately ten minutes of earlier graphics tests showed no observed artifacts, freezes or perceptible warming. `glxinfo` with `virpipe` returned X11 `BadMatch (X_GetImage)`, while `glxgears -info` successfully identified `virgl (ANGLE (ARM, Mali-G76, ...))`. Full real-application performance validation remains pending.

### PRoot microbenchmarks

| Operation (average, three runs) | Termux native | Debian/PRoot |
| --- | ---: | ---: |
| Launch 100 `true` processes | 1,337 ms | 614 ms |
| Create 250 small files + check 250 paths | 54.7 ms | 340.3 ms |

These runs use different binaries and runtimes; the differences cannot be attributed solely to PRoot. A follow-up inside Debian separated file creation from existence checks:

| Location | 250 creates, average | 250 checks, average | Combined |
| --- | ---: | ---: | ---: |
| Shared `/tmp` | 324.3 ms | 54.0 ms | 378.3 ms |
| Debian `$HOME` | 310.7 ms | 69.7 ms | 380.3 ms |

The similar combined times do not support changing the current `/tmp` binding. Five fresh `proot-distro login linudex --user linudex --shared-tmp -- /usr/bin/true` runs took **382, 362, 367, 359 and 372 ms** (average **368.4 ms**), without errors.

### Android memory, CPU and thermals

An Android memory snapshot with Chromium open showed **3.4 GiB available RAM** and approximately **978 MiB used swap**, while a later mostly idle measurement showed **3.8 GiB available** and **1.3 GiB swap in use**. Swap occupancy alone is not evidence of active swapping. PSS estimates were smaller than individual process RSS values because of shared pages.

| Sample | Initial | After 10 minutes of video/multitab use |
| --- | ---: | ---: |
| Android total CPU (snapshot) | 6.6% | 11% |
| PRoot process CPU (snapshot) | 10% | 14% |
| Termux:X11 process CPU (snapshot) | 2.4% | 6.5% |
| AP thermal sensor | 33.2 °C | 35.6 °C |
| Battery sensor | 30.2 °C | 32.1 °C |
| Skin sensor | 30.1 °C | 32.0 °C |
| Android thermal status | 0 | 0 |

These are two CPU snapshots, **not ten-minute averages**; thermal status 0 does not rule out every form of frequency management. The device used an enabled 85% battery charge limit. No new kernel, GPU-frequency or thermal-threshold modification was required.
