# Software Setup

[Português](software.pt.md)

This document records the software stack that produced the Linudex v0.1 Linux desktop milestone.

## Final v0.1 stack

```text
Android 12 / One UI 4.1
├── Samsung DeX
└── Termux (F-Droid build)
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian 13 ARM64 (`linudex`)
            └── XFCE
```

## 1. Termux host

Termux was installed from F-Droid. The host environment was updated and the core packages were installed:

```bash
pkg update
pkg upgrade -y
pkg install -y git curl wget nano openssh proot-distro
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

The basic Debian setup included updating packages and installing common core utilities, which are:

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

See [Troubleshooting](troubleshooting.md) for the reason this was necessary.

## 4. XFCE

XFCE and D-Bus X11 support were installed inside Debian:

```bash
sudo apt update
sudo apt install -y xfce4 dbus-x11
```

## 5. Termux:X11

On the Termux side:

```bash
pkg install x11-repo
pkg install termux-x11-nightly
```

The matching Android Termux:X11 application was also installed. Because the main Termux installation came from F-Droid, the non-`sharedUid` Termux:X11 APK variant was used.

## 6. Launching the graphical session

The X11 server is started from Termux:

```bash
termux-x11 :1 &
```

Debian must be entered with a shared temporary directory:

```bash
proot-distro login linudex --user linudex --shared-tmp
```

Inside Debian:

```bash
export DISPLAY=:1
export XDG_RUNTIME_DIR=/tmp/runtime-linudex
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"
dbus-launch --exit-with-session xfce4-session
```

![Linudex running XFCE and Firefox through Termux:X11](../images/screenshots/linudex-xfce-firefox.png)

## 7. Android host tuning

For the v0.1 environment:

- Termux and Termux:X11 were configured without battery restrictions.
- RAM Plus was set to 8 GB. This is storage-backed virtual memory, not physical RAM.
- Charging was capped at 85% to reduce battery wear during stationary use.
- Android 12's phantom-process limit was increased during testing after repeated `signal 9` process termination. See [Troubleshooting](troubleshooting.md).

## 8. Current v0.1 limitations

- Audio integration has not yet been finalized.
- Shared Android/Debian storage workflow has not yet been finalized.
- The current Phantom Process Killer change used for testing may need to be reapplied after reboot depending on how the Android setting is persisted.
- Final daily-use applications and UI/input tuning belong to the next milestone.
