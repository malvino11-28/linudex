# Linudex Scripts

[Português](README.pt.md)

This directory contains helper scripts used to reproduce and operate the Linudex software stack.

The scripts are separated by the environment in which they must be executed. **Do not run every script from the same shell.**

## Structure

```text
scripts/
├── README.md
├── README.pt.md
├── termux/
│   ├── setup-termux.sh
│   ├── install-debian.sh
│   ├── start-linudex.sh
│   └── stop-linudex.sh
├── debian/
│   ├── setup-debian.sh
│   └── install-desktop.sh
└── host/
    └── android12-phantom-process.ps1
```

## Execution map

| Script | Run from | Purpose |
| --- | --- | --- |
| `termux/setup-termux.sh` | Termux | Installs the Termux packages required by Linudex. |
| `termux/install-debian.sh` | Termux | Installs Debian 13 through PRoot-Distro using the local name `linudex`. |
| `debian/setup-debian.sh` | Debian as root | Installs base Debian tools, creates the `linudex` user and configures `sudo`. |
| `debian/install-desktop.sh` | Debian | Installs XFCE, D-Bus X11 support and Firefox ESR. |
| `termux/start-linudex.sh` | Termux | Starts Termux:X11, enters Debian and launches XFCE. |
| `termux/stop-linudex.sh` | Termux | Stops the XFCE session and Termux:X11 server. |
| `host/android12-phantom-process.ps1` | Windows PowerShell with ADB | Applies the Android 12 phantom-process workaround used during v0.1 testing. |

## Recommended installation order

### 1. Prepare Termux

From Termux:

```bash
chmod +x scripts/termux/*.sh
./scripts/termux/setup-termux.sh
```

The Termux:X11 Android APK is a separate component and must still be installed manually.

If Termux was installed from F-Droid, use the Termux:X11 APK variant without `sharedUid`.

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

The script creates the `linudex` user interactively and asks you to set its password.

### 4. Install the desktop

Inside Debian:

```bash
/path/to/install-desktop.sh
```

### 5. Apply the Android 12 workaround when required

On the Windows computer with ADB configured:

```powershell
.\android12-phantom-process.ps1
```

This workaround is intentionally temporary in v0.1 and may need to be reapplied after the phone reboots.

### 6. Start Linudex

From Termux:

```bash
./scripts/termux/start-linudex.sh
```

The script starts:

```text
Termux:X11
    ↓
PRoot-Distro
    ↓
Debian
    ↓
XFCE
```

### 7. Stop Linudex

From a Termux session:

```bash
./scripts/termux/stop-linudex.sh
```

This also helps clear stale Termux:X11 instances that can otherwise produce a `Server already running` error.

## Configuration variables

The Termux scripts accept a few optional environment variables:

```bash
LINUDEX_DISTRO_NAME=linudex
LINUDEX_USER=linudex
LINUDEX_DISPLAY=:1
LINUDEX_DEBIAN_IMAGE=debian:13
```

The defaults reproduce the v0.1 environment, so setting them is normally unnecessary.

## Safety and scope

- No password is stored in the repository.
- The scripts do not root Android.
- The Phantom Process Killer script uses the same temporary `until_reboot` behavior validated during v0.1 testing.
- The installation scripts target the software that was part of the v0.1 milestone; applications planned for later releases are intentionally excluded.
- Review scripts before executing them on a different device or Android version.
