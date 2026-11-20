# Troubleshooting — v0.5.2

[Português](troubleshooting-v0.5.2.pt.md)

This document records the browsing security and Android browser integration experiments of LinuDex v0.5.2 on a Galaxy S10+ with Samsung DeX, Debian 13 ARM64 through Termux/PRoot and XFCE. Statuses describe the **tested device**, not universal behavior.

## Issue index

- [Linux browsers require an unsafe sandbox workaround](#linux-browsers-require-an-unsafe-sandbox-workaround)
- [Bubblewrap isolation experiment failed](#bubblewrap-isolation-experiment-failed)
- [LibreWolf performance was inadequate](#librewolf-performance-was-inadequate)
- [Samsung Internet cannot remain in front of Debian](#samsung-internet-cannot-remain-in-front-of-debian)
- [Samsung Internet DeX title bar remained visible](#samsung-internet-dex-title-bar-remained-visible)
- [XFCE launcher inherited the old search bar appearance](#xfce-launcher-inherited-the-old-search-bar-appearance)

---

## Linux browsers require an unsafe sandbox workaround

### Symptoms

Chromium and Brave needed `--no-sandbox` or failed to run reliably with normal sandbox requirements in the tested PRoot environment.

### Diagnosis

PRoot does not provide the same isolation primitives as a conventional Debian kernel/userspace. Using `--no-sandbox` bypasses important browser protections. Firefox ESR was also investigated, but the evidence was mixed: some processes showed `NoNewPrivs: 1` and `Seccomp: 2`, while user namespaces were unavailable; full sandbox operation was not established.

### Adopted approach

Use the Android-native Samsung Internet app as the primary browser. Keep Chromium only for the specific previously tested Netflix/YouTube WebApps, explicitly acknowledging its sandbox limitation. Do not treat process flags alone as a complete security audit.

### Status

**Browser strategy defined and Samsung Internet validated. Linux browser sandboxing not validated as secure.**

---

## Bubblewrap isolation experiment failed

### Symptoms

A GNOME Web / Bubblewrap isolation experiment failed with:

```text
execvp /usr/bin/true: No such file or directory
```

### Diagnosis

Bubblewrap 0.12.0 did not complete the tested operation under PRoot. The precise failure cause was not conclusively isolated.

### Adopted approach

Do not claim a working Bubblewrap sandbox; prioritize the Android-native browser.

### Status

**Unresolved experiment; not used in the final browsing route.**

---

## LibreWolf performance was inadequate

### Symptoms

LibreWolf launched, but heavy websites including ChatGPT, YouTube and GitHub performed poorly.

### Diagnosis

The application was functional, but practical browsing experience on the tested phone was not adequate. No reproducible benchmark isolating a single cause was recorded.

### Adopted approach

Prioritize Samsung Internet under DeX. Uninstallation of LibreWolf and Firefox ESR has not been confirmed.

### Status

**Alternative rejected for daily browsing on the tested device.**

---

## Samsung Internet cannot remain in front of Debian

### Symptoms

Samsung Internet appears when its XFCE launcher is activated, but can disappear after clicking a Debian/XFCE application.

### Diagnosis

Samsung Internet is an Android application displayed and managed by Samsung DeX **above the Debian/Termux:X11 desktop**, not an X11 application running in the Debian guest. Focus changes can put Debian in front of the Android browser.

### Validated workaround

Click the Samsung Internet launcher in XFCE/Docklike again. The browser returns to the foreground in the tested configuration. The helper script uses:

```bash
/data/data/com.termux/files/usr/bin/am start --user 0 com.sec.android.app.sbrowser
```

### Status

**Expected window-focus limitation; launcher workaround validated.**

---

## Samsung Internet DeX title bar remained visible

### Symptoms

Maximizing Samsung Internet did not initially remove the upper DeX title bar.

### Validated fix

Press `F11` with the browser active. This enabled full-screen mode and hid the bar on the Galaxy S10+ test setup. The same shortcut did not work for Chrome Android in the user's test.

### Status

**Resolved for Samsung Internet in the tested DeX installation.**

---

## XFCE launcher inherited the old search bar appearance

### Symptoms

The new Samsung Internet launcher displayed the old Windows-style search bar graphic, even though its launcher properties listed only Samsung Internet.

### Diagnosis

Legacy CSS in `~/.config/gtk-3.0/gtk.css` used broad `#launcher-arrow` selectors plus a `search.svg` background. The user found repeated rules from the v0.5.0 search launcher, which affected other XFCE launchers.

### Validated fix

Back up `gtk.css`; remove only the old search launcher selector blocks, leaving other panel rules intact. On the tested device these blocks occupied lines 111–213, but line numbers must not be reused blindly on other CSS versions. Then execute:

```bash
xfce4-panel -r
```

The newer LinuDex Search plugin uses its own stylesheet and remains independent of the removed selector.

### Status

**Resolved; Samsung Internet launcher appearance normalized.**
