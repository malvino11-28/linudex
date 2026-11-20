# Troubleshooting — v0.5.1

[Português](troubleshooting-v0.5.1.pt.md)

This document records the issues observed while refining usability and the desktop interface in Linudex v0.5.1, running Debian 13 ARM64 through Termux, PRoot-Distro, Termux:X11, and XFCE on the Galaxy S10+. Statuses reflect validation in the development installation and do not guarantee identical behavior on other devices. The Android–Debian architecture was preserved.

## Issue index

- [AndroidStorage inaccessible from Termux and Debian](#androidstorage-inaccessible-from-termux-and-debian)
- [LinuDex Search build failed despite installed dependencies](#linudex-search-build-failed-despite-installed-dependencies)
- [Search field did not accept keyboard input](#search-field-did-not-accept-keyboard-input)
- [Search results were not displayed](#search-results-were-not-displayed)
- [Search contrast differed from the original and LocalSend icon was oversized](#search-contrast-differed-from-the-original-and-localsend-icon-was-oversized)
- [Android Settings did not open from Debian](#android-settings-did-not-open-from-debian)

---

## AndroidStorage inaccessible from Termux and Debian

### Symptoms

The `~/storage/shared` and `~/storage/downloads` links existed in Termux but their contents could not be listed. Direct access to `/storage/emulated/0` also failed. In Debian, `~/AndroidStorage` pointed to `/storage/emulated/0`, but the directory remained inaccessible; `/sdcard` behaved similarly.

### Diagnosis

Android's special **All files access** permission was disabled for both **Termux** and **Termux:API**. The symlinks were present but did not grant access on their own. Since both permissions were enabled at the same time, the tests did not isolate which permission was necessary to restore access.

### Validated fix

**All files access** was enabled for Termux and Termux:API under Android's special app access settings. No `chmod`, `chown`, `--bind`, PRoot configuration, or startup script changes were made.

### Validation

After enabling the permissions, access to the phone's shared internal storage was confirmed directly from Debian through `~/AndroidStorage`.

### Status

**Resolved in the tested installation.** No major Android–Debian integration change was required.

---

## LinuDex Search build failed despite installed dependencies

### Symptoms

Running `./build.sh` reported missing dependencies even though `build-essential`, `pkg-config`, `libgtk-3-dev`, and `libxfce4panel-2.0-dev` were already installed on Debian 13 ARM64.

### Diagnosis

The check `pkg-config --exists libxfce4panel-2.0 gtk+-3.0 gio-2.0` failed without identifying the missing development package. After `libxfce4ui-2-dev` was installed, the same check returned **Dependencies OK**.

### Validated fix

```bash
sudo apt install libxfce4ui-2-dev
pkg-config --print-errors --exists libxfce4panel-2.0 gtk+-3.0 gio-2.0 && echo 'Dependencies OK'
./build.sh
```

The `--print-errors` option was also added to improve subsequent build diagnostics.

### Validation

The dependency check succeeded, and the plugin was built and installed.

### Status

**Resolved.**

---

## Search field did not accept keyboard input

### Symptoms

The LinuDex Search field appeared in the lower panel. The pointer changed to a text cursor, but clicking the field did not allow typing.

### Diagnosis

The `GtkEntry` was present, but the plugin did not explicitly request keyboard focus from the XFCE panel.

### Validated fix

The left-click handler was updated to call `xfce_panel_plugin_focus_widget(plugin, widget)` while returning `FALSE` so GTK could continue normal event handling.

### Validation

Typing directly in the panel and launching an application with Enter were confirmed.

### Status

**Resolved.**

---

## Search results were not displayed

### Symptoms

After fixing focus, application names could be typed and Enter launched the matching application, but no result list or icons appeared.

### Diagnosis

The initial implementation used `GtkPopover` for results. In the tested XFCE/Termux:X11 session, the popover was not visible. The exact underlying rendering or positioning cause was not established.

### Validated fix

The `GtkPopover` was replaced with a separate GTK popup window (`GTK_WINDOW_POPUP`), positioned above the taskbar without taking focus from the search field.

### Validation

Search results displayed application names and icons. Clicking results, arrow-key navigation, Enter to launch, Esc to dismiss, closing on outside click, and clearing the search after launching were all confirmed.

### Status

**Resolved in LinuDex Search v3.**

---

## Search contrast differed from the original and LocalSend icon was oversized

### Symptoms

The new search field displayed darker text and a lower-contrast magnifier than the v0.5.0 launcher. The magnifier was also sized differently. In the result list, the LocalSend icon appeared much larger than other application icons.

### Diagnosis

The GTK theme applied opacity to the `GtkEntry` placeholder, while the magnifier was reduced to an internal entry-icon size. Result icons were not consistently normalized when applications provided larger image assets.

### Validated fix

The magnifier was changed to reuse the original SVG artwork, and **Pesquisar** was rendered with an independent `GtkLabel` using color `#f1f1f1`. Result icons were proportionally constrained to **24 × 24 px** without distortion. The 280 × 36 px field, `#343434` background, `#585858` border, and square corners were retained.

### Validation

The search appearance was confirmed to match the earlier design more closely, typing remained functional, and the LocalSend icon displayed at a consistent size.

### Status

**Resolved in LinuDex Search v3.**

---

## Android Settings did not open from Debian

### Symptoms

Wi-Fi and Bluetooth settings opened from Termux, but running `/system/bin/am` from Debian failed with:

```text
java.lang.SecurityException: Permission Denial:
package=com.android.shell does not belong to uid=10004
```

### Diagnosis

The `/system/bin/am` tool attempted to start an activity using the `com.android.shell` identity, which did not match the process UID of the Debian/PRoot caller. This did not indicate a failure of Android's Wi-Fi or Bluetooth settings.

### Validated fix

The Termux-provided `am` command was invoked from Debian:

```bash
/data/data/com.termux/files/usr/bin/am start --user 0 -a android.settings.WIFI_SETTINGS
/data/data/com.termux/files/usr/bin/am start --user 0 -a android.settings.BLUETOOTH_SETTINGS
```

The `--user 0` argument selects Android's primary user; it does not confer root access.

### Validation

Both settings screens opened correctly from Debian. The working commands were used for the Linudex shortcuts, including the clickable Wi-Fi indicator and the QuickMenu Bluetooth entry.

### Status

**Resolved in the tested installation without root or PRoot changes.**
