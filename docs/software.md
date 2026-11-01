# Software Setup

[Português](software.pt.md)

This document records the software stack used by the Linudex v0.2.0 daily-driver milestone.

## Final v0.2.0 stack

```text
Android 12 / One UI 4.1
├── Samsung DeX
├── Termux:Boot
├── Termux:Widget
└── Termux (F-Droid build)
    ├── PulseAudio
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian 13 ARM64 (`linudex`)
            └── XFCE
```

## 1. Termux host

Termux was installed from F-Droid. The host environment was updated and the core packages were installed through the project scripts. The v0.2.0 host requirements include:

```text
git
curl
wget
nano
openssh
proot-distro
x11-repo
termux-x11-nightly
pulseaudio
```

The device architecture was confirmed with:

```bash
uname -m
```

Expected architecture:

```text
aarch64
```

## 2. Debian installation

Debian 13 ARM64 was installed through PRoot-Distro with the local installation name `linudex`.

The environment is entered with:

```bash
proot-distro login linudex
```

The basic Debian setup included updating packages and installing common core utilities:

```bash
apt update
apt upgrade
apt install -y sudo git curl wget nano ca-certificates locales procps htop file unzip zip
```

![Debian 13 installed through PRoot-Distro](../images/screenshots/debian-13-installed.png)

## 3. Non-root desktop user

A dedicated user named `linudex` was created for normal desktop use.

Because PRoot-Distro login sessions did not expose the supplementary `sudo` group as expected, an explicit sudoers rule was added with `visudo`:

```text
linudex ALL=(ALL:ALL) ALL
```

The configuration was validated with:

```bash
sudo whoami
```

Expected result:

```text
root
```

See [Troubleshooting](troubleshooting/README.md) for the reason this was necessary.

## 4. XFCE

XFCE and D-Bus X11 support were installed inside Debian:

```bash
sudo apt update
sudo apt install -y xfce4 dbus-x11
```

The v0.2.0 desktop configuration uses:

- 1920×1080 Termux:X11 output.
- 115 DPI.
- XFCE compositor disabled.
- 40 px panel with Whisker Menu.
- Simplified desktop layout.
- `Ctrl+Alt+T` for `xfce4-terminal`.
- `Super+E` for Thunar.
- `Super+B` for Firefox ESR.

The corresponding reproducible configuration is kept under `configs/`.

## 5. Termux:X11

On the Termux side, the X11 repository and Termux:X11 command-line component are installed through the setup script. The matching Android Termux:X11 application is also required.

Because the main Termux installation came from F-Droid, the non-`sharedUid` Termux:X11 APK variant was used.

The v0.2.0 preferences use exact 1920×1080 output and fullscreen mode. The exported Termux:X11 preferences are stored under `configs/termux/`.

## 6. Graphical session startup

The normal v0.2.0 workflow uses `scripts/termux/start-linudex.sh` rather than manually entering each command.

The script starts the stack in this order:

```text
PulseAudio
    ↓
Termux:X11 server
    ↓
Termux:X11 Android Activity
    ↓
PRoot-Distro
    ↓
Debian as user `linudex`
    ↓
D-Bus
    ↓
XFCE
```

The underlying Debian session still uses a shared temporary directory and `DISPLAY=:1`.

![Linudex running XFCE and Firefox through Termux:X11](../images/screenshots/linudex-xfce-firefox.png)

## 7. Shared Android storage

Android shared storage was enabled from Termux and exposed to the Debian user as `~/AndroidStorage`.

This provides a practical file exchange path between Android/DeX and the Debian desktop without copying files through ADB or network services.

## 8. Audio integration

PulseAudio runs on the Termux side and exposes a local TCP server. Debian applications use:

```text
PULSE_SERVER=tcp:127.0.0.1
```

The resulting path is:

```text
Debian application
       ↓
PulseAudio client
       ↓
tcp:127.0.0.1
       ↓
Termux PulseAudio
       ↓
Android / DeX audio
```

Audio was validated with Firefox ESR and the PulseAudio Volume Control interface.

![Firefox ESR audio routed through PulseAudio](../images/screenshots/linudex-v0.2-audio.png)

## 9. Essential applications

The v0.2.0 daily-driver environment includes:

- Firefox ESR.
- Evince.
- VLC.
- Ristretto.
- Mousepad.
- Galculator.
- Xarchiver and Thunar archive integration.
- LibreOffice Writer, Calc and Impress.
- Brazilian Portuguese LibreOffice localization and spell checking.
- Carlito, Caladea, Liberation and Noto fonts for improved document compatibility.

The package list is automated by `scripts/debian/install-apps.sh`.

![LibreOffice Writer running on Linudex](../images/screenshots/linudex-v0.2-libreoffice.png)

## 10. Automatic startup and manual control

Termux:Boot is used to start Linudex automatically after Android boot. The boot script waits for `sys.boot_completed`, allows the graphical environment to settle and then runs `start-linudex.sh`.

The boot process writes to:

```text
~/linudex-boot.log
```

Because Android can restrict Activities started from the background, Termux was granted the **Appear on top** permission so the Termux:X11 Activity can open automatically during boot.

Termux:Widget provides manual `Start-Linudex` and `Stop-Linudex` shortcuts for cases where the Debian environment needs to be started or stopped from Android/DeX.

## 11. Android host tuning

For the v0.2.0 environment:

- Termux and Termux:X11 are configured without battery restrictions.
- RAM Plus is set to 8 GB. This is storage-backed virtual memory, not physical RAM.
- Charging is capped at 85% to reduce battery wear during stationary use.
- Android Developer Options **Logger buffer size** is set to **Disabled**.
- Android Developer Options **Accelerated processing** is enabled.
- Android 12's phantom-process limit is increased during testing after repeated `signal 9` process termination. See [Troubleshooting](troubleshooting/README.md).

The logger-buffer and accelerated-processing options are documented as host tuning choices; no isolated benchmark was performed to attribute a quantified performance gain to either option.

## 12. Current v0.2.0 limitations

- The current Phantom Process Killer workaround uses temporary `until_reboot` behavior and may need to be reapplied after a device reboot.
- Final keyboard layout validation depends on the physical keyboard.
- Final mouse tuning and display scaling should be validated again with the definitive monitor/hub setup.
- Automatic cold boot directly into the final Samsung DeX HDMI setup still requires hardware validation.
- The physical enclosure and active-cooling build belong to the hardware phase.

## 13. Experimental x86/x86-64 compatibility (v0.3.0)

The v0.2.1 desktop remains the stable base. Version v0.3.0 adds optional compatibility components for Linux and Windows x86-64 software, without changing the normal XFCE boot sequence.

### Tested software

| Component | Tested version | Notes |
| --- | --- | --- |
| Box64, Wine baseline | 0.3.4 (`/usr/bin/box64`) | Working baseline for Windows applications |
| Box64, Linux programs | Manually compiled 0.4.5 | Local wrapper `~/run-x86_64.sh` |
| Wine | 9.18-staging | Selected prefix `.xow64_test` |
| WineD3D | 9.2 | Direct3D compatibility |
| VirGL / ANGLE | OpenGL and Direct3D profiles | Android-facing Vulkan bridge |
| DepotDownloader | 3.4.0 Linux ARM64 | Steam depot downloader, without SteamWebHelper |

These are versions used during development, not an automated clean-install recipe. The locally tested GPU and compatibility wrappers are not yet all published in the repository.

### Linux x86-64 graphics profile

Run in **Termux** when the desktop is already active:

```bash
~/start-linux-gpu.sh
```

The helper selects the `gl` profile and `vulkan` ANGLE mode. Inside **Debian**, Linux x86-64 applications are launched through the locally configured Box64 wrapper. Xonotic was tested with this route.

### Windows x86-64 graphics profile

Run in **Termux**:

```bash
~/start-wine-gpu.sh
```

Enter Debian with the shared X11 temporary directory when necessary:

```bash
proot-distro login linudex --user linudex --shared-tmp --env DISPLAY=:1 --env PULSE_SERVER=tcp:127.0.0.1
```

Run in **Debian**, using the already configured Wine prefix:

```bash
cd "$HOME/xow64_prefix/.xow64_test/drive_c/Games/Seraph-Depot"
~/xow64 r "Seraph's Last Stand.exe"
```

For shutdown, use `~/stop-xow64-wine.sh` from Debian. Avoid the experimental `~/xow64 q` command because it may also terminate unrelated X11/desktop processes. Do not restart the whole desktop just to switch the compatibility profile unless needed.

### DepotDownloader

The native ARM64 DepotDownloader 3.4.0 release was installed in `~/opt/depotdownloader-3.4.0`. Under the tested Android/PRoot environment, its .NET runtime required the following environment setting to start:

```bash
DOTNET_GCHeapHardLimit=1C0000000
```

This value is a .NET GC heap limit, not a requirement for 7 GiB of physically available RAM. The local `~/depotdownloader.sh` helper exports it before launching the application. User credentials and Steam Guard codes must be entered interactively and must not be committed to the repository.

DepotDownloader can download files for owned games without running the full Steam UI. It does not ensure a game works without the Steam client or bypass DRM/Steamworks requirements.

### Compatibility status

- Linux x86-64: Xonotic ran with the Box64/OpenGL graphics route.
- Windows x86-64: Seraph's Last Stand ran without keeping Steam open, with low observed performance.
- Windows x86-64: 9 Kings initialized Unity but did not reach gameplay; graphics feature limitations and Steam launch behavior were observed.
- Linux x86-64: Terraria started its binary through Box64 but requested launching through the Steam client.

Measured performance and reproducibility limitations are documented in [Benchmarks](benchmarks.md), with diagnostic details in [Troubleshooting](troubleshooting/README.md).
