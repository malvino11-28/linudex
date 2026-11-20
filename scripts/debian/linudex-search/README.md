# LinuDex Search — XFCE panel plugin

[Português](README.pt.md)

LinuDex Search is an editable input embedded in the bottom XFCE panel. The tested installation searches installed applications by name or executable, displays up to eight results with icons constrained to 24 × 24 px, and launches them by mouse or keyboard. Arrow navigation, Enter, Escape, dismissal, and query clearing were validated on the Galaxy S10+.

## Requirements

Debian 13 ARM64, XFCE 4.20/GTK 3, C compiler, `pkg-config`, `libgtk-3-dev`, `libxfce4panel-2.0-dev`, and `libxfce4ui-2-dev` (needed on systems where the XFCE panel development package does not pull it in). An operational X11 desktop and panel setup are required.

## Build and install

From this directory in Debian:

```bash
sudo apt install build-essential pkg-config libgtk-3-dev libxfce4panel-2.0-dev libxfce4ui-2-dev
chmod +x build.sh install.sh uninstall.sh
./build.sh
./install.sh
xfce4-panel -r
```

Use **Panel → Add New Items → LinuDex Search** only if the plugin is not already present. The installer does not overwrite `~/.config/gtk-3.0/gtk.css`, the panel XML, Docklike, or the previous search launcher. It installs CSS under `~/.config/linudex-search/style.css` and the icon under `~/.local/share/linudex/search-icon.svg`.

The field preserves the approved **280 × 36 px** layout, `#343434` background, `#585858` border, square corners, and light magnifying-glass symbol. The **Pesquisar** prompt is intentional and matches the approved UI.

## Removal

First remove the plugin from the panel, then execute `./uninstall.sh` and `xfce4-panel -r`. Unrelated Linudex settings are untouched.

**Validation:** verified on the development device. Other installations require independent verification. This directory contains only the selected final implementation for v0.5.1, not earlier prototypes.
