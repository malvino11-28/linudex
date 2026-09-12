# Termux Configuration

[Português](README.pt.md)

This directory contains optional Termux configuration files used to customize the Android-side host environment of Linudex.

None of the files in this directory are required for Linudex to work.

The core stack can run without them:

```text
Android
└── Termux
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian
            └── XFCE
```

These files exist only to make the Termux environment easier to use and reproduce.

## Files

### `.bashrc`

Target location:

```text
~/.bashrc
```

This file configures the Bash shell used by Termux.

It may contain:

- aliases;
- environment variables;
- shell preferences;
- shortcuts for Linudex commands.

For example:

```bash
alias start-linudex='$HOME/start-linudex.sh'
alias stop-linudex='$HOME/stop-linudex.sh'
alias update-termux='pkg update && pkg upgrade'
```

These aliases are optional and only provide shorter commands.

The Linudex environment does not depend on them.

### `termux.properties`

Target location:

```text
~/.termux/termux.properties
```

This file configures the Termux Android application itself.

It can control features such as:

- extra keyboard keys;
- terminal scrollback history;
- input behavior;
- default working directory;
- other Termux interface preferences.

Example:

```properties
extra-keys = [['ESC','CTRL','ALT','TAB','LEFT','DOWN','UP','RIGHT']]
terminal-transcript-rows = 5000
enforce-char-based-input = true
default-working-directory = /data/data/com.termux/files/home
```

These settings are convenience preferences and are not required by PRoot-Distro, Debian, XFCE or Termux:X11.

## Installing the optional configuration

Before replacing an existing file, creating a backup is recommended.

### `.bashrc`

Backup the current file if it exists:

```bash
cp ~/.bashrc ~/.bashrc.backup
```

Then copy the Linudex configuration:

```bash
cp .bashrc ~/.bashrc
```

Reload the shell configuration:

```bash
source ~/.bashrc
```

Alternatively, if you already maintain your own `.bashrc`, copy only the aliases or settings you want instead of replacing the whole file.

### `termux.properties`

Create the Termux configuration directory if necessary:

```bash
mkdir -p ~/.termux
```

Copy the file:

```bash
cp termux.properties ~/.termux/termux.properties
```

Reload Termux settings:

```bash
termux-reload-settings
```

## Removing the configuration

These files can be removed without affecting the Linudex Debian installation.

For example:

```bash
rm ~/.termux/termux.properties
```

Then reload the Termux settings:

```bash
termux-reload-settings
```

If a previous `.bashrc` backup exists:

```bash
mv ~/.bashrc.backup ~/.bashrc
```

## Important

These configuration files should remain optional.

Installation and startup scripts should not require aliases, interface customization or other convenience settings in order for Linudex to function.
