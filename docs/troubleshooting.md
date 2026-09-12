# Troubleshooting

Problems encountered during the GalaxyDesk development and their
respective diagnoses and solutions.

---

## Wi-Fi connected but no internet access

### Symptoms

The Galaxy S10+ successfully connected to the Wi-Fi network, but Android
reported that the internet was unavailable.

Other devices connected to the same network were working normally.

### Environment

- Samsung Galaxy S10+
- Android 12
- Samsung DeX
- Wi-Fi connection active

### Diagnosis

The following possibilities were considered:

- Router/network failure
- DNS configuration
- Incorrect Wi-Fi configuration
- Device-specific networking issue

The router was ruled out because other devices had internet access.

### Cause

The system date and time were incorrect.

This caused secure HTTPS connections to fail because TLS certificates
appeared to be outside their valid date range.

### Solution

Automatic date and time were enabled in Android settings.

Path:

Settings → General management → Date and time → Automatic date and time

### Validation

After correcting the system date and time:

- Wi-Fi remained connected
- Internet access started working normally
- HTTPS websites became accessible

### Status

Resolved

---

---

## Abnormal device heating

### Symptoms

The Galaxy S10+ becomes noticeably warm shortly after startup, even
without an intensive workload.

### Environment

- Android 12
- Stock Samsung firmware
- Samsung DeX available
- Active cooling not yet installed

### Diagnosis

Investigation in progress.

Current tests include:

- Battery health diagnostics
- Idle battery temperature
- Temperature without charger
- Temperature under Samsung DeX
- Physical inspection for battery deformation

### Cause

Not yet determined.

Possible causes under investigation include battery degradation,
background processes and thermal dissipation issues.

### Solution

Not yet implemented.

### Status

Investigating

---

---

Termux session terminated unexpectedly
↓
Debian/XFCE stopped
↓
Termux:X11 server remained active (process phantom killing)
↓
subsequent startup returned "Server already running"
↓
resolved by (aumentando limite do phantom killer)

resolved

---
