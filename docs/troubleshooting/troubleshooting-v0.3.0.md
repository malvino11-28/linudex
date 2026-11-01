# Troubleshooting — v0.3.0

[Português](troubleshooting-v0.3.0.pt.md)

Problems observed during development of the experimental x86/x86-64 compatibility layer. These records describe results on the tested Galaxy S10+ configuration and do not imply that every application will work.

## Issue index

- [DepotDownloader .NET initialization](#depotdownloader-failed-to-create-coreclr)
- [Steam client memory consumption](#steamwebhelper-exhausted-available-memory)
- [Seraph shader failure with FPS HUD](#seraph-failed-with-gallium_hudfps)
- [9 Kings graphics initialization](#9-kings-graphics-initialization-failed)
- [Terraria requested the Steam client](#terraria-requested-launching-from-steam)
- [Unsafe Wine shutdown](#experimental-wine-shutdown-terminated-unrelated-processes)

---

## DepotDownloader failed to create CoreCLR

### Symptoms

The native ARM64 DepotDownloader initially failed under Android/PRoot with:

```text
GC heap initialization failed with error 0x8007000E
Failed to create CoreCLR, HRESULT: 0x8007000E
```

### Diagnosis and workaround

The .NET runtime could not initialize its expected memory reservation in this environment. The application launched after setting:

```bash
export DOTNET_GCHeapHardLimit=1C0000000
```

This hexadecimal value limits the managed GC heap; it is not a claim of available physical RAM. DepotDownloader 3.4.0 subsequently downloaded the owned Seraph's Last Stand depot successfully.

### Status

**Workaround confirmed in the tested environment.**

---

## SteamWebHelper exhausted available memory

### Symptoms

The Windows Steam client installed and authenticated but started multiple `steamwebhelper.exe` processes, consumed substantial RAM and swap, and made startup very slow.

### Diagnosis and workaround

Steam UI options, Box64 experiments and CEF configuration changes did not sufficiently reduce memory consumption. DepotDownloader provided an ARM64 alternative for obtaining files the account was authorized to download. Some titles still require Steam at launch.

### Status

**Steam UI remains unsuitable for the tested gaming workflow.**

---

## Seraph failed with `GALLIUM_HUD=fps`

### Symptoms

Seraph's Last Stand had previously worked but failed to open after enabling the FPS HUD. VirGL logged shader compilation errors, including:

```text
Shader failed to compile
ERROR: 0:4: 'in' : cannot declare arrays of this qualifier
Dropping rendering due to missing shaders
```

### Diagnosis and solution

Removing `GALLIUM_HUD=fps` allowed the game to start again. No Wine, Box64 or GPU driver replacement was needed.

```bash
env -u GALLIUM_HUD -u LIBGL_SHOW_FPS ~/xow64 r "Seraph's Last Stand.exe"
```

Run this command from the game's directory under the active Wine prefix.

### Status

**Resolved by disabling the incompatible HUD.**

---

## 9 Kings graphics initialization failed

### Symptoms

The game started briefly, closed and opened Steam. The Unity 6000.3.8f1 log reported:

```text
Direct3D 11.0 [level 10.1]
ERROR: Shader Hidden/CoreSRP/CoreCopy shader is not supported
No SRP present, no compute shader support
```

Forcing OpenGL 4.1 produced `InitializeEngineGraphics failed`.

### Diagnosis

The WineD3D/VirGL path exposed insufficient graphics features for some shaders used by the game. Starting Steam may be related to a separate Steamworks launch requirement, but the provided log did not establish that as the definitive reason for closing.

### Status

**Not running on the v0.3.0 configuration.** No gameplay benchmark was obtained.

---

## Terraria requested launching from Steam

### Symptoms

The Linux x86-64 binary started after fixing executable permissions, but displayed:

```text
Please launch the game from your Steam client
```

### Diagnosis

The distributed executable did not accept the standalone launch. This message is not evidence that the GPU or Box64 failed.

### Status

**Blocked by the Steam launch requirement in the tested distribution.**

---

## Experimental Wine shutdown terminated unrelated processes

### Symptoms

The experimental `~/xow64 q` command could terminate unrelated XFCE/Termux:X11 processes while trying to stop Wine.

### Solution

Do not use `~/xow64 q` or broad process-killing commands as a routine Wine shutdown. The tested environment uses `~/stop-xow64-wine.sh` to stop the selected Wine prefix without taking down the desktop. Review the script before publishing it.

### Status

**Safe, prefix-scoped shutdown tested locally; script not yet published in the repository.**
