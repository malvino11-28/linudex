# Linudex v0.3.0 — x86/x86-64 Compatibility Architecture

[Português](architecture-v0.3.pt.md) · [Core architecture](architecture.md)

> **Status: experimental.** This document describes the implementation tested on the Galaxy S10+ rather than promising equivalent results on other hardware. The v0.2.1 Debian/XFCE desktop remains the stable base.

## Host and guest environments

- **Hardware:** Samsung Galaxy S10+ (Exynos 9820; ARM64; Mali-G76 MP12; 8 GB nominal RAM).
- **Host:** Android 12 / One UI 4.1, Samsung DeX and Termux, **without Android root**.
- **Linux environment:** Debian 13 ARM64 under PRoot-Distro, sharing the Android kernel; XFCE through Termux:X11.
- **Audio:** Debian applications connect to PulseAudio in Termux at `tcp:127.0.0.1`.
- **Desktop startup:** the established v0.2.1 boot and session scripts remain responsible for the desktop; the compatibility stack is started separately when needed.

PRoot-Distro is neither a hardware-virtualized machine nor native Linux running directly on the device. Box64 translates x86-64 userspace instructions into ARM64 instructions; it does **not** emulate a complete PC.

## Linux x86-64 applications

```text
Linux x86-64 program (e.g., Xonotic)
           │
           ▼
         Box64
           │  x86-64 → ARM64 userspace translation
           ▼
       Debian ARM64
           │
           ├── Linux services / libraries
           └── Mesa OpenGL (virpipe)
                    │
                    ▼
                  VirGL
                    │
                    ▼
             ANGLE / Vulkan
                    │
                    ▼
          Android Vulkan / Mali-G76
```

The tested Linux path uses a manually built Box64 0.4.5 binary (`/usr/local/bin/box64-0.4.5-manual`) via the local `~/run-x86_64.sh` wrapper. The Termux `~/start-linux-gpu.sh` helper configures the Linux graphics profile (`vgl cfg=gl`, `vgl angle=vulkan`). Exact wrapper contents must be exported from the device before being versioned.

## Windows x86-64 applications

```text
Windows x86-64 executable
           │
           ▼
      Box64 0.3.4
           │
           ▼
 Wine 9.18-staging (x86-64)
           │
           ▼
      WineD3D 9.2
           │ Direct3D → OpenGL translation
           ▼
   Mesa / virpipe / VirGL
           │
           ▼
      ANGLE / Vulkan
           │
           ▼
    Android / Mali-G76
```

The tested Windows path uses `/usr/bin/box64`, the `~/xow64` launcher and Wine prefix `~/xow64_prefix/.xow64_test`. The selected Wine version is recorded as `9.18-staging`. The Termux `~/start-wine-gpu.sh` helper selects the Direct3D graphics profile (`vgl cfg=d3d`, `vgl angle=vulkan-null`). This is a *description of the tested configuration*, not a guarantee that every Direct3D application works.

`vulkan-null` is the profile label used in the tested ANGLE configuration. It should not be interpreted as proof of native Windows Vulkan support or direct access to the Mali GPU from Debian.

## Role of the graphics bridge

VirGL exposes a virtual GPU to the Linux userspace. Applications may see a renderer such as **Red Hat VirtIO GPU** rather than **Mali-G76**. Feature levels and shader capabilities reported through WineD3D can be lower than those of the physical GPU. There are multiple translation boundaries and potential CPU/GPU synchronization costs.

For example, *9 Kings* initialized Direct3D 11 at **feature level 10_1** but reported missing shader/compute capabilities. Forcing OpenGL 4.1 then failed at engine graphics initialization. These failures are observations about this software path, not a conclusive hardware limitation of Mali-G76.

## Tested software and responsibilities

| Layer | Tested component | Responsibility |
| --- | --- | --- |
| ARM64 host | Termux / Debian 13 PRoot | Runtime and Linux userspace |
| x86-64 translation, Windows baseline | Box64 0.3.4 | Run x86-64 Wine binaries |
| x86-64 translation, Linux experiments | Box64 manual 0.4.5 | Run Linux x86-64 binaries |
| Windows compatibility | Wine 9.18-staging | Windows APIs and process environment |
| 3D translation | WineD3D 9.2 | Direct3D-to-OpenGL compatibility |
| Virtual GL path | Mesa virpipe / VirGL | Forward rendering commands |
| Android-facing GL/Vulkan translation | ANGLE | Graphics translation towards Android Vulkan |
| Distribution tool | DepotDownloader 3.4.0 ARM64 | Fetch owned Steam depots without running Steam UI |

The Box64 0.4.4, `main`, and modified `linudex` builds, Wine 10.12/11.17 experiments, and SteamWebHelper experiments are **not required** by the tested baseline. They are retained only as historical research notes when applicable.

## Key constraints

1. **Performance:** software translation overhead is significant. Successful launch does not imply smooth gameplay.
2. **Graphics:** OpenGL/Direct3D feature availability depends on every translation layer, not only Mali-G76 capabilities.
3. **Steam:** DepotDownloader downloads files for accounts with rights to access them. It does not bypass Steamworks launch requirements, DRM, or licensing restrictions.
4. **Memory:** running the full Windows Steam client caused high memory pressure from SteamWebHelper. The successfully tested *Seraph's Last Stand* run used downloaded files and did not require keeping the Steam UI running.
5. **Isolation:** Wine and GPU server shutdown must not terminate the XFCE or Termux:X11 desktop. Do **not** use the experimental `~/xow64 q` command; use the scoped, tested `~/stop-xow64-wine.sh` script.
6. **Reproducibility:** the existing system was configured through several manual experiments; a clean-room installation from this repository has not yet been validated for v0.3.0.

## Related material

- [v0.3 setup and operations](compatibility.md)
- [v0.3 test results](benchmarks-v0.3.0.md)
- [v0.3 troubleshooting](troubleshooting/troubleshooting-v0.3.0.md)
