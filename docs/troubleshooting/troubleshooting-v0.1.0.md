# Troubleshooting

[Português](troubleshooting.pt.md)

Problems encountered during Linudex development and their confirmed diagnoses, workarounds or current status.

## Troubleshooting Index

- [Wi-Fi](#wi-fi-connected-but-no-internet-access)
- [Packages not found](#termux-packages-returned-unable-to-locate-package)
- [Sudo permissions](#sudo-rejected-the-linudex-user)
- [XFCE could not open display](#xfce-returned-cannot-open-display)
- [X11 server already running](#server-already-running-with-a-black-termuxx11-window)
- [Phantom Process Killer / Signal 9](#termux-session-terminated-with-signal-9)
- [Thermal concerns](#initial-thermal-concerns)

## Wi-Fi connected but no internet access

### Symptoms

The Galaxy S10+ connected to Wi-Fi, but Android reported that internet access was unavailable. Other devices on the same network worked normally.

### Diagnosis

Router failure, DNS configuration, Wi-Fi settings and device-specific networking issues were considered. The router was ruled out because other devices had working internet access.

### Cause

The system date and time were incorrect. This caused secure HTTPS/TLS connections to fail because certificates appeared to be outside their validity period.

### Solution

Enable automatic date and time:

```text
Settings → General management → Date and time → Automatic date and time
```

### Validation

Wi-Fi remained connected, HTTPS sites became accessible and package repositories worked normally.

### Status

**Resolved.**

---

## Termux packages returned `Unable to locate package`

### Symptoms

Initial attempts to install basic Termux packages such as Git, curl and PRoot-Distro returned:

```text
E: Unable to locate package ...
```

### Cause

The package index had not been successfully loaded from the configured Termux repository.

### Solution

The configured repository was verified and `pkg update` was rerun successfully before attempting package installation again.

### Status

**Resolved.**

---

## `sudo` rejected the `linudex` user

### Symptoms

`id linudex` showed membership in the `sudo` group, but a session entered with PRoot-Distro did not expose that supplementary group and `sudo whoami` returned that `linudex` was not in the sudoers file.

### Cause

The PRoot-Distro login session did not reproduce the supplementary group membership in the way expected by the normal Debian sudo group rule.

### Solution

An explicit rule was created with `visudo -f /etc/sudoers.d/linudex`:

```text
linudex ALL=(ALL:ALL) ALL
```

The file was set to mode `440`, and `visudo -c` was used to validate the configuration.

### Validation

```bash
sudo whoami
```

returned:

```text
root
```

### Status

**Resolved.**

---

## XFCE reported `cannot open display`

### Symptoms

Running `xfce4-session --version` before starting an X server returned:

```text
xfce4-session: cannot open display
```

### Cause

`xfce4-session` expected an X11 display. At that point Termux:X11 had not yet been started and `DISPLAY` was not configured.

### Solution

Termux:X11 was installed and started, Debian was entered with `--shared-tmp`, `DISPLAY=:1` was exported and the XFCE session was launched through D-Bus.

### Status

**Resolved.**

---

## `Server already running` with a black Termux:X11 window

### Symptoms

After the Termux/Debian session was interrupted, the Linux desktop closed. A subsequent launch returned:

```text
Server already running
```

while the Termux:X11 application displayed a black screen.

### Cause

The Debian/XFCE process tree had stopped, but the Termux:X11 server process remained alive in the background.

### Solution

Stop the stale X11 server before relaunching:

```bash
pkill termux-x11
am broadcast -a com.termux.x11.ACTION_STOP -p com.termux.x11
```

If necessary, confirm the process state with `pgrep`/`ps` before using a forced kill.

### Status

**Resolved.**

---

## Termux session terminated with `signal 9`

### Symptoms

While Debian/XFCE was running, Termux occasionally terminated the process tree with:

```text
[Process completed (signal 9) - press Enter]
```

### Diagnosis

The failures stopped after increasing Android 12's phantom-process limit. This strongly associated the termination with Android's Phantom Process Killer rather than Debian instability.

### Workaround used during v0.1 testing

Termux and Termux:X11 were configured without battery restrictions. The phantom-process limit was then increased through ADB for the test session:

```bash
adb shell "/system/bin/device_config set_sync_disabled_for_tests until_reboot"
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
```

The configured value can be checked with:

```bash
adb shell "/system/bin/device_config get activity_manager max_phantom_processes"
```

### Validation

After this adjustment, the benchmark workloads — including Firefox ESR with YouTube 1440p playback — completed without the previous random `signal 9` termination.

### Status

**Workaround confirmed for v0.1.** The current test configuration may need to be reapplied after a reboot because it was intentionally tested with `until_reboot` behavior.

---

## Initial heating concern

### Symptoms

During early testing, a localized hotspot was noticed around the damaged-display area shortly after startup.

### Findings

The hotspot correlated with the damaged built-in display being active. With the phone display off while using DeX, the device cooled substantially. Later v0.1 desktop benchmarks remained stable, with recorded battery temperatures from 27.8 °C to 33.0 °C.

### Status

**No thermal instability reproduced in v0.1 software testing.** Final enclosure and active-cooling validation remain future hardware work.
