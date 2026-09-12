# Android Debloat

[Português](debloat.pt.md)

## Goal

Reduce unnecessary Android/OEM software while preserving the services required by Samsung DeX, networking, USB, audio and the Linux host environment.

The goal is a minimal **stable** Android host, not the smallest possible package count.

## Tooling

Debloating was performed from Windows 10 using **[UAD-ng (Universal Android Debloater Next Generation)](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation)** over ADB.

## Procedure used for v0.1

1. Record the stock system baseline and installed package count.
2. Create a UAD-ng snapshot before changing package states.
3. Process the recommended OEM packages first.
4. Review Google, carrier and miscellaneous packages separately.
5. Preserve Samsung DeX and core Android infrastructure.
6. Reboot and validate DeX, network, input and basic Android behavior after each major batch.
7. Remove remaining clearly unnecessary user-facing applications manually when appropriate.

## Components intentionally preserved

The following categories were treated as critical during v0.1:

- Samsung DeX / desktop-mode components.
- Android System UI and Settings.
- Package installer and permission infrastructure.
- Wi-Fi and network stack.
- USB / DisplayPort / HDMI-related services.
- Bluetooth and audio services.
- Storage and document providers.
- Android System WebView.
- Google Play Services / framework components required by the remaining Android environment.

## Samsung DeX packages

At minimum, the following known DeX packages were preserved:

```text
com.sec.android.desktopmode.uiservice
com.samsung.desktopsystemui
com.sec.android.app.desktoplauncher
```

## Validation

After the debloat stage, Android and Samsung DeX booted normally and the Linux installation work proceeded without a regression attributed to debloating.

The original baseline recorded **477 installed Android packages**. The final post-debloat count dropped to **197 packages**. I believe it's possible to reduce this number even further, but I didn't deeply explore the more sensitive packages.

## Related runtime tuning

Settings such as unrestricted battery use for Termux, RAM Plus and the Android phantom-process workaround are runtime/host configuration rather than debloat actions. They are documented in [Software](software.md) and [Troubleshooting](troubleshooting.md).
