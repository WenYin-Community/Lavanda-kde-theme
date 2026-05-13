# Lavanda-kde-theme Agent Guide

## What This Is

A KDE Plasma 6 theme package (fork of vinceliuice/Lavanda-kde). Contains aurorae decorations, color schemes, desktop themes, global themes (look-and-feel), Kvantum themes, SDDM themes, and wallpapers. No build system, no tests, no CI — pure asset repo.

## Variant Matrix

The theme ships 4 combinations generated from two axes:

| | `-Light` | `-Dark` |
|---|---|---|
| _(empty)_ | Lavanda-Light | Lavanda-Dark |
| `-Sea` | Lavanda-Sea-Light | Lavanda-Sea-Dark |

Naming is **not uniform** across components:
- `aurorae/`, `plasma/desktoptheme/`, `wallpaper/`: `{Name}{theme}{color}` → `Lavanda-Sea-Dark`
- `color-schemes/`: `{Name}{ELSE_THEME}{ELSE_COLOR}` → `LavandaSeaDark.colors`
- `plasma/look-and-feel/`: `com.github.vinceliuice.{Name}{theme}{color}` → `com.github.vinceliuice.Lavanda-Sea-Dark`
- `Kvantum/`: `{Name}{ELSE_THEME}` → `LavandaSea/`

When adding a component, you must replicate it for all 4 variants with the correct naming for each directory.

## Critical: Logout.qml

All 4 variants have `contents/logout/`. Background color differs by variant:
- Light variants: `color: "white"` / `opacity: 0.65`
- Dark variants: `color: "black"` / `opacity: 0.65`

Required files per logout dir: `Logout.qml`, `LogoutButton.qml`, `timer.js`.

## SDDM Themes

Only `sddm/6.0/` is maintained (Plasma 5 support was removed). Has its own `install.sh` that requires **root** (installs to `/usr/share/sddm/themes`).

### zh_CN Localization

SDDM theme includes zh_CN translations in `translations/Lavanda_zh_CN.ts`. The install script:
1. Compiles `.ts` → `.qm` via `lrelease` (requires `qt6-linguist`)
2. On zh_CN systems, adds `LANG=zh_CN.UTF-8` to `/etc/sysconfig/sddm`

SDDM reads locale from `/etc/sysconfig/sddm`, **not** `sddm.conf`'s `Locale=` setting.

Translation files use theme domain `Lavanda` (matching `Theme-Id` in metadata.desktop). QML uses `i18n()` / `i18nc()` (not `i18nd()`).

## Known Issues

None.

## Install Behavior

- `install.sh`: Non-root → `~/.local/share/`, root → `/usr/share/`. **Deletes existing** theme dirs before copying. Also overwrites `~/.Xresources`.
- `uninstall.sh`: Glob-matches `${name}*` — will delete **any** Lavanda-prefixed themes, including manually installed ones.
- `sddm/*/install.sh`: Root only, installs both `Lavanda` and `Lavanda-Sea` SDDM themes.

## QML Conventions

- Plasma 6 QML: use `import QtQuick` (no version number), `import org.kde.plasma.components as PlasmaComponents`, `import org.kde.kirigami as Kirigami`
- Logout screen uses `Kirigami.Theme.Complementary` color set
- Background color for Lavanda-Light logout: `color: "white"` / `opacity: 0.65`

## Directory Map

```
aurorae/           → window decorations (SVG)
color-schemes/     → .colors files (KDE color scheme format)
configs/           → Xresources
Kvantum/           → Kvantum engine themes (.kvconfig + .svg)
plasma/
  desktoptheme/    → Plasma panel/widget themes (SVG/SVGZ)
  look-and-feel/   → Global themes (QML splash, logout, layouts, metadata)
sddm/
  6.0/             → SDDM themes for Plasma 6
wallpaper/         → Wallpaper packages with metadata.json
```
