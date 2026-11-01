# AGENTS.md — Lavanda KDE Theme

## Project overview

KDE Plasma 6.1+ theme (Qt 6.5+), tested with Plasma 6.8.2 / Qt 6.11.2. Not a code project — no build system, linter, tests, or CI.
All assets are declarative config files (`.colors`, `.svg`, `.qml`, `.desktop`, `theme.conf`).

## Theme variants

Two theme families × two color modes = four combos:

| Variant | Dir suffix | Color scheme file |
|---------|-----------|-------------------|
| Lavanda Light | `Lavanda-Light` | `LavandaLight.colors` |
| Lavanda Dark  | `Lavanda-Dark`  | `LavandaDark.colors` |
| Sea Light     | `Lavanda-Sea-Light` | `LavandaSeaLight.colors` |
| Sea Dark      | `Lavanda-Sea-Dark`  | `LavandaSeaDark.colors` |

**Naming gotcha**: directories use hyphens (`Lavanda-Dark`), color scheme files drop them (`LavandaDark.colors`). Kvantum dirs use variant-only (`Lavanda/`, `LavandaSea/`).

## Directory ownership

| Dir | Content |
|-----|---------|
| `aurorae/` | Window decoration SVGs + rc config (4 variants) |
| `color-schemes/` | KDE `.colors` palette files (4 files) |
| `Kvantum/` | Kvantum engine SVG themes (2 variants, no color split) |
| `plasma/desktoptheme/` | Plasma desktop theme `metadata.json` + `plasmarc` + `opaque/`/`solid/`/`translucent/` + shared `icons/` (all variants; Sea overrides with `icons-Sea/`) |
| `plasma/look-and-feel/` | Global theme `metadata.json` + `contents/{defaults,layouts,splash,logout}` (com.github.vinceliuice.*) |
| `logout-white/` | Optional user-level shell logout override (white background) + install/uninstall scripts |
| `sddm/6.0/` | SDDM login theme (QML + assets + zh_CN translations) |
| `wallpaper/` | Wallpaper images (6 dirs including non-color "base" dirs) |
| `configs/` | Only `Xresources` — **copied to `~/.Xresources` on install** |

## Install scripts

- `./install.sh` — user-level install to `~/.local/share/...`; **Kvantum goes to `~/.config/Kvantum`**; runs as root → `/usr/share/...`
- `sudo ./install.sh` — system-wide install; required for the SDDM greeter (it runs as the `sddm` user and only sees `/usr/share`)
- `sudo ./sddm/6.0/install.sh` — SDDM theme (root only); does **not** restart SDDM
- `./logout-white/install.sh` — user-level shell override for the white logout/shutdown screen (no sudo)
- `./logout-white/uninstall.sh` — removes the override and restores the system shell
- `./uninstall.sh` — removes all Lavanda theme files

**Side effect**: `install.sh:29` unconditionally copies `configs/Xresources` to `$HOME/.Xresources` (overwrites).

## SDDM specifics

- QML-based theme under `sddm/6.0/Lavanda/` and `sddm/6.0/Lavanda-Sea/`
- Targets SDDM 0.21+ / Qt 6; uses `Keyboards.KWinVirtualKeyboard` from `org.kde.plasma.workspace.keyboardlayout` (no legacy `VirtualKeyboardLoader`)
- Translations: `.ts` files in `translations/` compiled to `.qm` via `lrelease` (or `lrelease-qt6`)
- Install script auto-configures `LANG=zh_CN.UTF-8` in `/etc/sysconfig/sddm` on zh_CN systems
- Installer does not restart SDDM; restart manually (`systemctl restart sddm`) only when applying locale/theme changes
- SDDM 0.21 may log `KLocalizedString: Domain is not set` and fall back to English for theme strings

## When editing theme files

- Color scheme changes: edit `color-schemes/*.colors` (INI format, RGB comma-separated values)
- Window decoration: edit SVGs in `aurorae/<variant>/` + `<variant>rc` config
- Desktop theme: edit `metadata.json` + `plasmarc` in `plasma/desktoptheme/<variant>/`; Plasma 6.8 reads `opaque/` (keep `solid/` as fallback)
- Kvantum: edit SVG in `Kvantum/<variant>/` (shared across Light/Dark)
- SDDM QML: edit `Main.qml`, `Login.qml`, `Input.qml` etc. in `sddm/6.0/<variant>/`
- Wallpaper metadata: `wallpaper/<variant>/metadata.json`

## Verification

No CI. Useful local checks:

```sh
kpackagetool6 -t Plasma/Theme -s Lavanda-Light
kpackagetool6 -t Plasma/LookAndFeel -s com.github.vinceliuice.Lavanda-Light
plasma-apply-desktoptheme Lavanda-Light   # live reload
journalctl --user -b | grep -i 'legacy metadata'   # should be empty
QT_QPA_PLATFORM=offscreen sddm-greeter-qt6 --test-mode --theme sddm/6.0/Lavanda
```

Final verification is still visual inspection in KDE System Settings and at the SDDM login screen.
