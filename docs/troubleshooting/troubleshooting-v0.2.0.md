# Troubleshooting — v0.2.0

[Português](troubleshooting-v0.2.0.pt.md)

Problems encountered during the development of Linudex v0.2.0 and their confirmed diagnoses, workarounds or current status.

Problems already documented in v0.1.0 are not repeated here unless they presented new behavior during the development of this version.

## Issue index

- [pt-BR keyboard layout](#pt-br-keyboard-layout-could-not-type-accented-characters-correctly)
- [Automatic startup failure](#termuxboot-could-not-execute-start-linudexsh)
- [Termux:X11 did not open automatically](#termuxx11-did-not-open-automatically-during-boot)

---

## pt-BR keyboard layout could not type accented characters correctly

### Symptoms

While configuring the Debian keyboard for the Brazilian pt-BR layout, some characters worked correctly, including:

```text
ç
```

but accented characters could not be typed normally.

Expected dead-key combinations such as:

```text
´ + a → á
~ + a → ã
^ + e → ê
```

did not produce the expected characters.

### Diagnosis

Keyboard layout changes were tested through the XFCE settings as well as through direct configuration attempts from the Debian terminal.

The accented-character behavior remained incorrect.

At the time, Linudex was being used through Samsung DeX connected to a computer, which introduced several layers into keyboard input processing:

```text
computer physical keyboard
        ↓
computer operating system
        ↓
Samsung DeX
        ↓
Android
        ↓
Termux:X11
        ↓
XFCE / Debian
```

The fact that `ç` worked while dead keys did not suggested that the issue might not be limited to the layout configured inside Debian.

### Cause

**Not yet confirmed.**

The current main hypothesis is an incompatibility or incorrect dead-key handling while using Samsung DeX through a computer.

It has not yet been possible to determine which layer in the input chain introduces the behavior.

### Attempts

The Brazilian keyboard layout was configured through XFCE, and additional configuration attempts were performed directly from the terminal.

These changes did not fix accented-character input in the current test environment.

### Next test

The issue will be tested again when the final hardware is available, using:

```text
Galaxy S10+
    ↓
USB-C hub
    ├── physical keyboard
    ├── mouse
    └── HDMI monitor
```

This setup removes the intermediary computer and will allow direct testing of keyboard behavior through:

```text
USB keyboard
    ↓
Android / DeX
    ↓
Termux:X11
    ↓
Debian / XFCE
```

If accented characters work correctly in this environment, the issue can likely be associated with using DeX through a computer.

If the problem remains, keyboard layout and dead-key handling between Android, Termux:X11 and XKB will require further investigation.

### Status

**Pending.**

The pt-BR keyboard configuration works partially, including the `ç` character, but dead-key and accented-character support still needs to be validated on the final hardware before a definitive fix is implemented.

---

## Termux:Boot could not execute `start-linudex.sh`

### Symptoms

Termux:Boot executed successfully after Android startup and reached:

```text
[Boot] Starting Linudex...
```

but Linudex did not start.

The `~/linudex-boot.log` file contained:

```text
/data/data/com.termux/files/home/.termux/boot/20-start-linudex: line 24:
/data/data/com.termux/files/home/start-linudex.sh#!/data/data/com.termux/files/usr/bin/bash:
No such file or directory
```

### Diagnosis

Termux:Boot had successfully reached the step responsible for executing the main Linudex script.

The path shown in the error contained two strings that should have been separate:

```text
start-linudex.sh
```

and:

```text
#!/data/data/com.termux/files/usr/bin/bash
```

### Cause

While editing `20-start-linudex`, the command:

```bash
exec "$HOME/start-linudex.sh"
```

was accidentally concatenated with the shebang of another script.

The shell therefore attempted to execute the entire string as a file path that did not exist.

### Solution

The file:

```text
~/.termux/boot/20-start-linudex
```

was corrected so that it ended with:

```bash
echo "[Boot] Starting Linudex..."

exec "$HOME/start-linudex.sh"
```

Its contents were checked with:

```bash
nl -ba ~/.termux/boot/20-start-linudex
```

and executable permissions were ensured:

```bash
chmod +x ~/.termux/boot/20-start-linudex
chmod +x ~/start-linudex.sh
```

### Validation

After correcting the script and rebooting the Galaxy S10+ again, Termux:Boot successfully executed `start-linudex.sh` and the Linudex environment started automatically.

### Status

**Resolved.**

---

## Termux:X11 did not open automatically during boot

### Symptoms

After fixing Termux:Boot, the Linudex stack started automatically:

```text
PulseAudio
Termux:X11 server
Debian
XFCE
```

but the Android Termux:X11 interface was not automatically brought to the foreground.

The Linux environment was running, but the Termux:X11 application still had to be opened manually.

### Diagnosis

`start-linudex.sh` already started the X11 server and also used Android's Activity Manager:

```bash
am start \
    --user 0 \
    -n com.termux.x11/com.termux.x11.MainActivity
```

The same command worked when `start-linudex.sh` was launched manually by the user.

The behavior differed when the script was executed automatically by Termux:Boot while Termux was running in the background.

### Cause

Android restricted the Termux:X11 Activity from being opened when the request originated from Termux running in the background during system startup.

The output from `am start` had also originally been discarded, making the issue harder to diagnose:

```bash
>/dev/null 2>&1 || true
```

### Solution

Termux was granted the following permission:

```text
Settings
→ Apps
→ Special access
→ Appear on top
→ Termux
```

The Termux:X11 Activity continued to be explicitly launched from `start-linudex.sh`.

During diagnosis, output suppression was removed so the Activity Manager result could be inspected.

### Validation

After another device reboot:

1. Android started normally;
2. Termux:Boot ran the startup script;
3. Linudex started;
4. Termux:X11 opened automatically;
5. the XFCE session became available without manually opening the application.

### Status

**Resolved.**
