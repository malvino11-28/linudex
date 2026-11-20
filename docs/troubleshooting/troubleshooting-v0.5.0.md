# Troubleshooting — v0.5.0

[Português](troubleshooting-v0.5.0.pt.md)

This document records issues and limitations encountered while customizing Linudex v0.5.0 on a Galaxy S10+ running Debian 13 ARM64 through Termux, PRoot-Distro, Termux:X11 and XFCE. Results apply to the tested installation, not necessarily to other devices.

## Issues

- [Brazilian dead keys and keyboard shortcuts](#brazilian-dead-keys-and-keyboard-shortcuts)
- [Firefox ESR froze on complex pages](#firefox-esr-froze-on-complex-pages)
- [Brave crashed on startup](#brave-crashed-on-startup)
- [Chromium requires its sandbox to be disabled in the tested environment](#chromium-requires-its-sandbox-to-be-disabled-in-the-tested-environment)
- [Cloudflare challenges failed in Chromium](#cloudflare-challenges-failed-in-chromium)
- [Netflix needed a custom Chromium ARM64 configuration](#netflix-needed-a-custom-chromium-arm64-configuration)

---

## Brazilian dead keys and keyboard shortcuts

### Symptoms

An incorrect Brazilian keyboard variant caused unexpected `Ctrl+V` and `Super+E` behavior. After restoring the regular keymap, dead accents appeared separately from the following letter across applications, e.g. `´a` instead of `á`, even though X11 registered `dead_acute`.

### Diagnosis

The “Nativo” layout variant was not the standard ABNT2 mapping. Using XKB layout `br` with an empty variant restored shortcuts. Setting the session to `pt_BR.UTF-8` and testing GTK's simple input method did not fix accent composition on their own.

### Validated fix

Use the default Brazilian XKB layout (`br`, empty variant) and enable **Prefer scancodes when possible** in the **Android Termux:X11 app**. Keep a UTF-8 locale.

### Status

**Resolved and persistent after restart on the tested setup.** The Android app preference is not part of the XFCE XML backup.

---

## Firefox ESR froze on complex pages

### Symptoms

Firefox ESR `140.15.0esr-1~deb13u1` intermittently froze when visiting complex pages, including ChatGPT. The problem persisted in Troubleshoot Mode, in a fresh profile and with WebGL disabled. Logs included `org.freedesktop.UPower` and `RenderCompositorSWGL failed mapping default framebuffer, no dt` messages.

### Diagnosis

The causal relationship of these messages to the freezes was not established. Several gigabytes of memory reportedly remained available during earlier failures.

### Subsequent observation

A later session handled heavy pages without freezing when started with `DISPLAY=:1 MOZ_ENABLE_WAYLAND=0 firefox --no-remote`. This does not prove those launch arguments fixed the original issue.

### Status

**Intermittent; root cause unknown.** Chromium was tested as an alternative.

---

## Brave crashed on startup

### Symptoms

Brave `1.98.63` crashed before displaying a window, reporting `Trace/breakpoint trap` and `content/zygote/zygote_linux.cc:662: write: Broken pipe (32)`, including when using a fresh temporary profile.

### Diagnosis

A Chromium/PRoot compatibility issue was considered, but the Brave logs did not expose a definitive root cause.

### Status

**Unresolved; deferred to a future release.**

---

## Chromium requires its sandbox to be disabled in the tested environment

### Symptoms

Chromium `156.0.8078.79` on Debian 13 would not start under PRoot without `--no-sandbox`. The zygote reported a broken pipe. Disabling only the setuid sandbox did not help.

### Diagnosis

The device was running PRoot `5.1.107.102`. Inside Debian, namespace creation could not be verified because `/proc/self/ns` was not available. In the original Termux environment, `unshare --user --map-root-user` failed with `Invalid argument` (exit status `1`). This indicates a namespace/isolation limitation in the tested environment but does not fully explain every Chromium initialization failure.

### Working but insecure configuration

The browser launched with `--no-sandbox`, in some tests combined with `--disable-gpu-sandbox`, `GALLIUM_DRIVER=virpipe`, `--use-gl=egl`, and `--ignore-gpu-blocklist`.

**Security warning:** `--no-sandbox` disables a critical Chromium protection. This should not be presented as equivalent to normal secure browsing. Avoid sensitive activity; do not provide this configuration as a safe default.

### Status

**Operational with a known security limitation; sandbox isolation not validated.**

---

## Cloudflare challenges failed in Chromium

### Symptoms

Cloudflare-protected sites failed to complete verification. A User-Agent switcher extension did not fix the issue.

### Diagnosis and solution

The normal Chromium launcher impersonated ChromeOS to support Netflix. Removing this global User-Agent override allowed the tested Cloudflare challenges to pass. Any ChromeOS User-Agent override should be confined to the Netflix launcher if required.

### Status

**Resolved.**

---

## Netflix needed a custom Chromium ARM64 configuration

### Symptoms

Netflix did not work with the initial Debian ARM64 Chromium setup.

### Experimental configuration

The external installer `AsahiLinux/widevine-installer` and a ChromeOS-compatible browser identification were used. Netflix was installed as a WebApp via Chromium's `Cast, save and share` menu, and its `.desktop` launcher was customized, including `--app`, `--class`, and `StartupWMClass` for individual integration into Docklike.

### Validation and limitations

One full movie played on the tested device; occasional brief player reloads were observed, without a confirmed cause.

### Status

**Works on the tested installation.**
