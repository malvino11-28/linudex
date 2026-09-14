# Architecture

[Português](architecture.pt.md)

## Overview

Linudex uses Android as the hardware compatibility layer and runs a Debian ARM64 userspace on top of it. It is not a traditional virtual machine and it does not replace the Android kernel.

```text
External display / keyboard / mouse
                │
                ▼
        Samsung Galaxy S10+
                │
       Android 12 / One UI
        ┌───────┴──────────────┐
        │                      │
   Samsung DeX              Termux
                               │
              ┌────────────────┼────────────────┐
              │                │                │
         PulseAudio       Termux:X11       PRoot-Distro
              │                                  │
        Android audio                         Debian 13
                                                 │
                                               XFCE
```

Termux:Boot and Termux:Widget provide automatic and manual control of this stack but do not replace any of the runtime layers shown above.

## Layer responsibilities

### Android / One UI

Provides the Linux kernel, Samsung hardware drivers, networking, USB, audio stack, power management and the underlying display pipeline.

### Samsung DeX

Provides the Android desktop environment and reliable external-display support over USB-C. DeX is intentionally preserved during debloating because it remains part of the host environment even when the Linux desktop is running.

### Termux

Provides the command-line environment used to install and launch PRoot-Distro, PulseAudio and Termux:X11.

### PulseAudio

Runs on the Termux side as an audio bridge. Debian applications connect to the local PulseAudio server through `tcp:127.0.0.1`, allowing Linux application audio to reach Android/DeX.

### PRoot-Distro

Provides the Debian root filesystem and userspace without requiring Android root privileges. Because PRoot shares the Android kernel, some low-level Linux facilities and hardware metrics are not available exactly as they would be on a native Debian installation.

### Debian 13 ARM64

Provides the GNU/Linux userspace, package manager and desktop applications. The installation is named `linudex` in PRoot-Distro.

### Termux:X11

Provides the X11 display server that bridges Linux graphical applications to Android.

### XFCE

Provides the lightweight graphical desktop used by the v0.2.0 daily-driver environment.

### Termux:Boot and Termux:Widget

Termux:Boot launches the Linudex startup script after Android has completed booting. Termux:Widget provides manual start and stop shortcuts for cases where the Linux environment needs to be controlled from Android/DeX.

## Data and control paths

The graphical path is:

```text
XFCE / Linux applications
          │
          ▼
      Termux:X11
          │
          ▼
   Android display stack
          │
          ▼
     Samsung DeX
```

The audio path is:

```text
Debian application
       │
       ▼
PulseAudio client
       │
       ▼
tcp:127.0.0.1
       │
       ▼
Termux PulseAudio
       │
       ▼
 Android / DeX audio
```

Android shared storage is also exposed to the Debian environment for normal file exchange between both sides of the system.

## Why this architecture

The Galaxy S10+ already has mature Android drivers for its Exynos platform, USB-C display output and peripherals. Keeping Android avoids the incomplete hardware support currently associated with native Linux ports for this device while still allowing a conventional Debian userspace.

## Important limitations

- Debian does not own the kernel; it shares Android's kernel.
- PRoot is not a VM and does not provide hardware virtualization.
- Some `/proc` metrics are restricted by Android SELinux, which is why CPU data is collected through ADB rather than `htop` inside Debian.
- Traditional `systemd`, kernel module management and container workloads such as standard Docker are outside the current v0.2.0 scope.
- Android process-management policies can terminate the PRoot process tree unless the Phantom Process Killer behavior is mitigated.
- The current Phantom Process Killer workaround used by the project is still temporary across device reboots.
