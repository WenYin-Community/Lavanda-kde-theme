Lavanda SDDM theme for KDE Plasma desktop (SDDM 0.21+ / Qt 6).

Variants: `Lavanda` (purple) and `Lavanda-Sea` (sea).

## Installation

```sh
sudo ./install.sh
```

Installs both variants to `/usr/share/sddm/themes` and compiles
`translations/*.ts` to `.qm`. The installer does **not** restart SDDM;
restart manually when ready:

```sh
sudo systemctl restart sddm
```

## Requirements

- SDDM 0.21+ with Qt 6
- `org.kde.breeze.components`, `org.kde.plasma.components`,
  `org.kde.plasma.workspace.keyboardlayout`, `org.kde.kirigami`

## Testing

```sh
QT_QPA_PLATFORM=offscreen sddm-greeter-qt6 --test-mode --theme ./Lavanda
```

The virtual keyboard button uses `Keyboards.KWinVirtualKeyboard`; the legacy
`VirtualKeyboardLoader` component no longer exists in SDDM 0.21.

## Notes

- zh_CN translations are compiled, but SDDM 0.21 may log
  `KLocalizedString: Domain is not set` and display English strings.
- On zh_CN systems the install script appends `LANG=zh_CN.UTF-8` to
  `/etc/sysconfig/sddm` if not already present.
