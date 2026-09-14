# Linudex Scripts

[Português](https://www.google.com/search?q=README.pt.md)

This directory contains helper scripts used to reproduce and operate the Linudex software stack.

As of v0.2.0, the scripts cover not only the initial Debian installation but also the desktop environment, audio, essential applications, automatic boot via Android, and manual control shortcuts.

The scripts are separated by the environment in which they must be executed. --Do not run every script from the same shell.--

## Structure

```text
scripts/
├── README.md
├── README.pt.md
├── android/
│   └── android12-phantom-process.ps1
├── termux/
│   ├── setup-termux.sh
│   ├── install-debian.sh
│   ├── start-linudex.sh
│   ├── stop-linudex.sh
│   ├── boot/
│   │   └── 20-start-linudex
│   └── widget/
│       ├── Start-Linudex
│       └── Stop-Linudex
└── debian/
    ├── setup-debian.sh
    ├── install-desktop.sh
    └── install-apps.sh

```

## Execution map

| Script                                  | Run from                    | Purpose                                                                                        |
| --------------------------------------- | --------------------------- | ---------------------------------------------------------------------------------------------- |
| `termux/setup-termux.sh`                | Termux                      | Installs the necessary packages in Termux, including PRoot-Distro, PulseAudio and Termux:X11.  |
| `termux/install-debian.sh`              | Termux                      | Installs Debian 13 ARM64 through PRoot-Distro using the local name.                            |
| `debian/setup-debian.sh`                | Debian as root              | Updates Debian, installs basic tools, creates the `linudex` user and configures `sudo`.        |
| `debian/install-desktop.sh`             | Debian                      | Installs XFCE, D-Bus/X11 support and necessary components for the graphical session and audio. |
| `debian/install-apps.sh`                | Debian                      | Installs the essential applications used in the v0.2.0 Daily Driver environment.               |
| `termux/start-linudex.sh`               | Termux                      | Starts PulseAudio, Termux:X11, Debian and the XFCE session.                                    |
| `termux/stop-linudex.sh`                | Termux                      | Stops XFCE, Termux:X11 and PulseAudio.                                                         |
| `termux/boot/20-start-linudex`          | Termux:Boot                 | Waits for Android to boot up and automatically runs Linudex.                                   |
| `termux/widget/Start-Linudex`           | Termux:Widget               | Allows starting Linudex manually through an Android/DeX shortcut.                              |
| `termux/widget/Stop-Linudex`            | Termux:Widget               | Allows stopping Linudex manually through an Android/DeX shortcut.                              |
| `android/android12-phantom-process.ps1` | Windows PowerShell with ADB | Applies the workaround for the Android 12 Phantom Process Killer.                              |

## Recommended installation order

### 1. Prepare Termux

From Termux:

```bash
chmod +x scripts/termux/-.sh
./scripts/termux/setup-termux.sh

```

The Termux:X11 Android APK is a separate component and must still be installed manually.

If Termux was installed from F-Droid, use the Termux:X11 APK variant without `sharedUid`.

Termux, Termux:X11, Termux:Boot, and Termux:Widget must all use compatible installation sources.

### 2. Install Debian

From Termux:

```bash
./scripts/termux/install-debian.sh

```

Then enter Debian as root:

```bash
proot-distro login linudex

```

### 3. Configure Debian

Inside Debian, as root:

```bash
chmod +x /path/to/setup-debian.sh
/path/to/setup-debian.sh

```

The script:

- updates Debian packages;
- installs basic tools;
- creates the `linudex` user;
- adds the user to the `sudo` group;
- creates an explicit rule in `/etc/sudoers.d/linudex`.

The explicit `sudo` rule is necessary because PRoot sessions might not load the user's supplementary groups in the same way a conventional Linux installation does.

### 4. Install the desktop

Inside Debian:

```bash
/path/to/install-desktop.sh

```

This script installs the graphical base used by Linudex:

```text
XFCE
D-Bus X11
PulseAudio utilities
PulseAudio Volume Control

```

### 5. Install essential applications

Still inside Debian:

```bash
/path/to/install-apps.sh

```

v0.2.0 uses a lean set of applications for daily use:

```text
Firefox ESR
LibreOffice Writer
LibreOffice Calc
LibreOffice Impress
Evince
VLC
Ristretto
Mousepad
Galculator
Xarchiver

```

It also installs compression utilities, Thunar integration, pt-BR language packs, spell checking, and fonts with better compatibility for Microsoft Office documents.

## Phantom Process Killer — Android 12

Linudex spawns several child processes. Android 12 may kill this process tree through the Phantom Process Killer, causing:

```text
[Process completed (signal 9) - press Enter]

```

With ADB configured on a Windows computer:

```powershell
.\android12-phantom-process.ps1

```

The script increases the phantom process limit used during Linudex testing.

The current implementation uses a temporary change with:

```text
until_reboot -------------------------------------------------------------------------

```

therefore it might need to be reapplied after restarting the device.

## Start Linudex manually

From Termux:

```bash
./scripts/termux/start-linudex.sh

```

The script:

1. kills old PulseAudio instances;
2. starts the audio bridge;
3. removes residual Termux:X11 instances;
4. starts the X11 server;
5. opens the Termux:X11 Android Activity;
6. enters Debian as the `linudex` user;
7. starts the XFCE session.

The script also runs a cleanup routine when the session ends.

## Stop Linudex

From a Termux session:

```bash
./scripts/termux/stop-linudex.sh

```

The script stops:

```text
XFCE
Termux:X11
PulseAudio

```

## Automatic boot with Termux:Boot

The file:

```text
termux/boot/20-start-linudex

```

must be installed in:

```text
~/.termux/boot/20-start-linudex

```

Example:

```bash
mkdir -p ~/.termux/boot

cp scripts/termux/boot/20-start-linudex \
   ~/.termux/boot/20-start-linudex

chmod +x ~/.termux/boot/20-start-linudex

```

Termux:Boot must be opened manually at least once after installation.

During boot, the script follows this flow:

```text
Android boot
    ↓
stabilization period
    ↓
start-linudex.sh

```

A process log is stored at:

```text
~/linudex-boot.log

```

To view it:

```bash
cat ~/linudex-boot.log

```

### Automatic Termux:X11 opening

`start-linudex.sh` uses the Android Activity Manager to automatically launch the Termux:X11 interface.

On some devices, you may need to grant permission to Termux:

```text
Settings
→ Apps
→ Special app access
→ Display over other apps
→ Termux

```

Without this permission, Android might block launching the Termux:X11 Activity when Linudex is started in the background by Termux:Boot.

## Control via Termux:Widget

The files:

```text
termux/widget/Start-Linudex
termux/widget/Stop-Linudex

```

must be copied to:

```text
~/.shortcuts/

```

Example:

```bash
mkdir -p ~/.shortcuts

cp scripts/termux/widget/Start-Linudex ~/.shortcuts/
cp scripts/termux/widget/Stop-Linudex ~/.shortcuts/

chmod 700 ~/.shortcuts/Start-Linudex
chmod 700 ~/.shortcuts/Stop-Linudex

```

After this, Termux:Widget can be added to Android or Samsung DeX to allow manual control of the environment without typing commands.

## Configuration variables

The scripts accept a few optional environment variables:

```bash
LINUDEX_DISTRO_NAME=linudex
LINUDEX_USER=linudex
LINUDEX_DISPLAY=:1
LINUDEX_DEBIAN_IMAGE=debian:13
LINUDEX_PULSE_SERVER=tcp:127.0.0.1

```

The defaults reproduce the official environment used during v0.2.0 development.

## Safety and scope

- No password is stored in the repository.
- The scripts do not root Android.
- Debian runs through PRoot-Distro.
- The `root` user inside PRoot does not have actual root privileges over Android.
- The PulseAudio server only accepts connections via the local address used by Linudex.
- The Phantom Process Killer workaround modifies an Android setting via ADB.
- Scripts intended for Android 12 should not be applied automatically on other versions without validation.
- Review scripts before executing them on a different device or environment.

## Scope of v0.2.0

v0.2.0 expands upon the v0.1.0 script automation with:

- audio via PulseAudio;
- Daily Driver environment;
- essential applications;
- automatic boot;
- Termux:Boot integration;
- Termux:Widget integration;
- automatic Termux:X11 Activity launching;
- more comprehensive process management during start/stop.

XFCE visual configurations and Termux:X11 specific preferences are kept separately in the `configs/` directory.
