## Lavanda KDE Theme

Lavanda kde theme is a clean and concise theme for KDE Plasma 6 desktop.

Requires Plasma 6.1+ (Qt 6.5+).

In this repository you'll find:

- Aurorae Theme
- Kvantum Theme
- Wallpaper Theme
- Plasma Color Scheme
- Plasma Desktop Theme
- Plasma Global Theme
- SDDM Theme (with zh_CN localization)
- Optional white logout screen override (user-level)

## Installation

```sh
./install.sh
```

The installer will prompt whether to install the SDDM theme (requires root).

To install SDDM theme manually:

```sh
sudo ./sddm/6.0/install.sh
```

### SDDM Localization

The SDDM theme includes zh_CN translations. On zh_CN systems, the install script automatically configures SDDM locale by adding `LANG=zh_CN.UTF-8` to `/etc/sysconfig/sddm`.

After installation, restart SDDM for translations to take effect:

```sh
sudo systemctl restart sddm
```

If a theme does not have translations for your locale, SDDM will display the original English strings.

### White Logout Screen (optional, user-level)

Plasma 6.x loads its logout/shutdown UI from the `org.kde.plasma.desktop` shell,
not from the theme's Look-and-Feel `contents/logout` file. The optional
`logout-white` helper installs a per-user copy of that shell with a white
translucent background and dark text:

```sh
./logout-white/install.sh
./logout-white/uninstall.sh
```

- No sudo, no system files, no KDE global configuration changes.
- Installs only under `~/.local/share/plasma/shells/org.kde.plasma.desktop`.
- Re-run the installer after Plasma updates; uninstall restores the system shell.
- Tested with Plasma 6.8.2. The background is a 65%-opaque white overlay;
  compositor blur is not added.

The main installer also offers this option when run as a regular user.

## Uninstall

```sh
./uninstall.sh
```

## Recommendations

- For better looking please use this pack with [Kvantum engine](https://github.com/tsujan/Kvantum/blob/master/Kvantum/INSTALL.md#distributions).

  Run `kvantummanager` to choose and apply **Lavanda** (or any other Lavanda) theme.

- Install [Colloid icon theme](https://github.com/vinceliuice/Colloid-icon-theme) for a more consistent and beautiful experience.

- Install [Lavanda gtk theme](https://github.com/vinceliuice/Lavanda-gtk-theme) for a more consistent and beautiful experience.

## License

GNU GPL v3

## Preview

![light](Screenshot_light.png)
![dark](Screenshot_dark.png)


