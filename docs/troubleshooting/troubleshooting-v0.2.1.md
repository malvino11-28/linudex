## PulseAudio failed during cold boot and interrupted automatic startup

### Symptoms

When the Galaxy S10+ was powered on while already connected to Samsung DeX, Termux:Boot executed normally and started `start-linudex.sh`.

During the startup sequence, PulseAudio failed with:

```text
E: [pulseaudio] main.c: Daemon startup failed.
```

Because `start-linudex.sh` uses:

```bash
set -euo pipefail
```

the PulseAudio failure interrupted the remainder of the script.

In practice, this initially made the automatic startup failure appear to be related to Termux:X11 or Samsung DeX, because the graphical environment did not open correctly on the external display.

### Diagnosis

`start-linudex.sh` already attempted to terminate a previous PulseAudio instance before starting a new one:

```bash
pulseaudio -k 2>/dev/null || true
```

However, stopping the daemon did not necessarily remove temporary runtime state left behind by PulseAudio.

Removing the runtime directory:

```bash
rm -rf "$TMPDIR/pulse"
```

before starting the new daemon was then tested.

After this change, PulseAudio started normally during cold boot and the automatic startup sequence continued through Termux:X11 and Debian/XFCE.

### Cause

Residual PulseAudio runtime state under:

```text
$TMPDIR/pulse
```

could prevent a new daemon instance from starting correctly during boot.

Running only `pulseaudio -k` was not sufficient to guarantee a clean startup.

### Solution

`start-linudex.sh` was changed to remove stale PulseAudio runtime state before starting the audio bridge:

```bash
log 'Clearing stale PulseAudio server...'
pulseaudio -k 2>/dev/null || true
sleep 1

log 'Clearing stale PulseAudio runtime state...'
rm -rf "$TMPDIR/pulse"

log 'Starting PulseAudio bridge...'
pulseaudio \
    --start \
    --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" \
    --exit-idle-time=-1
```

### Validation

After the change, additional cold-boot tests were performed with Samsung DeX connected.

The startup sequence then completed successfully:

```text
Android
    ↓
Termux:Boot
    ↓
PulseAudio
    ↓
Termux:X11
    ↓
Debian / XFCE
```

Termux:X11 also opened automatically on DeX without manual intervention.

The following error:

```text
E: [pulseaudio] main.c: Daemon startup failed.
```

was not reproduced again during the tests performed after the fix.

### Status

**Resolved in v0.2.1.**

The fix was incorporated into `start-linudex.sh`.
