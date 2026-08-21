# AGENTS.md — Lavanda KDE Theme

## Project overview

KDE Plasma 6.1+ theme (Qt 6.5+). Not a code project — no build system, linter, tests, or CI.
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
| `plasma/desktoptheme/` | Plasma desktop theme metadata + shared `icons/` (all variants; Sea overrides with `icons-Sea/`) |
| `plasma/look-and-feel/` | Global theme metadata (com.github.vinceliuice.*) |
| `sddm/6.0/` | SDDM login theme (QML + assets + zh_CN translations) |
| `wallpaper/` | Wallpaper images (6 dirs including non-color "base" dirs) |
| `configs/` | Only `Xresources` — **copied to `~/.Xresources` on install** |

## Install scripts

- `./install.sh` — user-level install to `~/.local/share/...`; **Kvantum goes to `~/.config/Kvantum`**; runs as root → `/usr/share/...`
- `sudo ./sddm/6.0/install.sh` — SDDM theme (root only)
- `./uninstall.sh` — removes all Lavanda theme files

**Side effect**: `install.sh:29` unconditionally copies `configs/Xresources` to `$HOME/.Xresources` (overwrites).

## SDDM specifics

- QML-based theme under `sddm/6.0/Lavanda/` and `sddm/6.0/Lavanda-Sea/`
- Translations: `.ts` files in `translations/` compiled to `.qm` via `lrelease` (or `lrelease-qt6`)
- Install script auto-configures `LANG=zh_CN.UTF-8` in `/etc/sysconfig/sddm` on zh_CN systems
- Requires `systemctl restart sddm` after install for locale changes

## When editing theme files

- Color scheme changes: edit `color-schemes/*.colors` (INI format, RGB comma-separated values)
- Window decoration: edit SVGs in `aurorae/<variant>/` + `<variant>rc` config
- Desktop theme: edit `metadata.desktop` in `plasma/desktoptheme/<variant>/`
- Kvantum: edit SVG in `Kvantum/<variant>/` (shared across Light/Dark)
- SDDM QML: edit `Main.qml`, `Login.qml`, `Input.qml` etc. in `sddm/6.0/<variant>/`
- Wallpaper metadata: `wallpaper/<variant>/metadata.json`

## No verification commands

There are no automated checks. After changes, the only verification is installing the theme and visually inspecting in KDE System Settings.
