#!/bin/sh
#
# Lavanda KDE theme installer for FreeBSD.
# POSIX sh only - no bash extensions (FreeBSD /bin/sh compatible).
#
# Usage:
#   ./install-freebsd.sh               # user-level install (~/.local/share)
#   sudo ./install-freebsd.sh          # system-wide install (/usr/local/share)
#   ./install-freebsd.sh uninstall     # remove user-level install
#   sudo ./install-freebsd.sh uninstall  # remove system-wide install
#
# KDE Plasma data files live under /usr/local on FreeBSD (LOCALBASE).

set -eu

SRC_DIR=$(cd "$(dirname "$0")" && pwd)
THEME_NAME=Lavanda
LOCALBASE=/usr/local

if [ "$(id -u)" -eq 0 ]; then
    SCOPE="system-wide (/usr/local/share)"
    AURORAE_DIR="$LOCALBASE/share/aurorae/themes"
    SCHEMES_DIR="$LOCALBASE/share/color-schemes"
    PLASMA_DIR="$LOCALBASE/share/plasma/desktoptheme"
    LOOKFEEL_DIR="$LOCALBASE/share/plasma/look-and-feel"
    KVANTUM_DIR="$LOCALBASE/share/Kvantum"
    WALLPAPER_DIR="$LOCALBASE/share/wallpapers"
    SDDM_DIR="$LOCALBASE/share/sddm/themes"
else
    DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
    SCOPE="user-level ($DATA_HOME)"
    AURORAE_DIR="$DATA_HOME/aurorae/themes"
    SCHEMES_DIR="$DATA_HOME/color-schemes"
    PLASMA_DIR="$DATA_HOME/plasma/desktoptheme"
    LOOKFEEL_DIR="$DATA_HOME/plasma/look-and-feel"
    KVANTUM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/Kvantum"
    WALLPAPER_DIR="$DATA_HOME/wallpapers"
    SDDM_DIR=""
fi

usage() {
    cat <<EOF
Usage: $0 [install|uninstall]

  install     Install Lavanda themes (default).
  uninstall   Remove previously installed Lavanda themes.

Run as your user for a user-level install ($HOME/.local/share).
Run with sudo for a system-wide install (${LOCALBASE}/share).
The SDDM greeter theme is only installed system-wide.
EOF
}

# Locate an lrelease binary (qt6-tools on FreeBSD).
find_lrelease() {
    for candidate in lrelease6 lrelease lrelease-qt6 "$LOCALBASE/lib/qt6/bin/lrelease"; do
        if command -v "$candidate" >/dev/null 2>&1; then
            echo "$candidate"
            return 0
        fi
    done
    return 1
}

compile_translations() {
    target_dir=$1
    if ! lrelease_bin=$(find_lrelease); then
        return 0
    fi
    for ts_file in "$target_dir"/translations/*.ts; do
        [ -e "$ts_file" ] || continue
        "$lrelease_bin" "$ts_file" >/dev/null 2>&1 || true
    done
}

install_sddm() {
    [ -n "$SDDM_DIR" ] || return 0
    mkdir -p "$SDDM_DIR"
    rm -rf "$SDDM_DIR/$THEME_NAME" "$SDDM_DIR/$THEME_NAME-Sea"
    cp -R "$SRC_DIR/sddm/6.0/$THEME_NAME" "$SDDM_DIR/"
    cp -R "$SRC_DIR/sddm/6.0/$THEME_NAME-Sea" "$SDDM_DIR/"
    compile_translations "$SDDM_DIR/$THEME_NAME"
    compile_translations "$SDDM_DIR/$THEME_NAME-Sea"
}

do_install() {
    mkdir -p "$AURORAE_DIR" "$SCHEMES_DIR" "$PLASMA_DIR" "$LOOKFEEL_DIR" \
             "$KVANTUM_DIR" "$WALLPAPER_DIR"

    for theme in '' '-Sea'; do
        for color in '-Light' '-Dark'; do
            variant="${THEME_NAME}${theme}${color}"
            if [ -n "$theme" ]; then else_theme='Sea'; else else_theme=''; fi
            if [ "$color" = '-Dark' ]; then else_color='Dark'; else else_color='Light'; fi
            scheme="${THEME_NAME}${else_theme}${else_color}.colors"
            plasma_theme="$PLASMA_DIR/$variant"

            rm -rf "$AURORAE_DIR/$variant"
            rm -f "$SCHEMES_DIR/$scheme"
            rm -rf "$plasma_theme"
            rm -rf "$LOOKFEEL_DIR/com.github.vinceliuice.$variant"
            rm -rf "$WALLPAPER_DIR/$variant"
            rm -rf "$KVANTUM_DIR/$THEME_NAME$else_theme"

            cp -R "$SRC_DIR/aurorae/$variant" "$AURORAE_DIR/"
            cp "$SRC_DIR/color-schemes/$scheme" "$SCHEMES_DIR/"
            cp -R "$SRC_DIR/Kvantum/$THEME_NAME$else_theme" "$KVANTUM_DIR/"

            cp -R "$SRC_DIR/plasma/desktoptheme/$variant" "$PLASMA_DIR/"
            cp -R "$SRC_DIR/plasma/desktoptheme/icons" "$plasma_theme/icons"
            if [ -n "$theme" ]; then
                cp -R "$SRC_DIR/plasma/desktoptheme/icons-Sea/"* "$plasma_theme/icons/"
            fi
            cp "$SRC_DIR/color-schemes/$scheme" "$plasma_theme/colors"
            mkdir -p "$plasma_theme/wallpapers"
            cp -R "$SRC_DIR/wallpaper/$variant" "$plasma_theme/wallpapers/"

            cp -R "$SRC_DIR/plasma/look-and-feel/com.github.vinceliuice.$variant" "$LOOKFEEL_DIR/"
            cp -R "$SRC_DIR/wallpaper/$variant" "$WALLPAPER_DIR/"
            cp -R "$SRC_DIR/wallpaper/$THEME_NAME$theme" "$WALLPAPER_DIR/"
        done
    done

    if [ -n "$SDDM_DIR" ]; then
        printf 'Install SDDM greeter theme? [y/N] '
        read -r answer || answer=''
        case "$answer" in
            [Yy]*) install_sddm ;;
        esac
    fi

    echo ""
    echo "Installed Lavanda themes ($SCOPE)."
    echo ""
    echo "Apply them via:"
    echo "  System Settings -> Appearance -> Global Theme -> Lavanda"
    echo "  (window decoration and color scheme are set by the global theme)"
    if [ -n "$SDDM_DIR" ]; then
        echo ""
        echo "SDDM theme installed. Set it in $LOCALBASE/etc/sddm.conf:"
        echo "  [Theme]"
        echo "  Current=Lavanda"
    else
        echo ""
        echo "For the SDDM greeter theme, run: sudo $0"
    fi
}

do_uninstall() {
    for theme in '' '-Sea'; do
        for color in '-Light' '-Dark'; do
            variant="${THEME_NAME}${theme}${color}"
            if [ -n "$theme" ]; then else_theme='Sea'; else else_theme=''; fi
            if [ "$color" = '-Dark' ]; then else_color='Dark'; else else_color='Light'; fi
            scheme="${THEME_NAME}${else_theme}${else_color}.colors"

            rm -rf "$AURORAE_DIR/$variant"
            rm -f "$SCHEMES_DIR/$scheme"
            rm -rf "$PLASMA_DIR/$variant"
            rm -rf "$LOOKFEEL_DIR/com.github.vinceliuice.$variant"
            rm -rf "$WALLPAPER_DIR/$variant"
        done
    done

    # Kvantum dirs drop the hyphen: Lavanda, LavandaSea.
    rm -rf "$KVANTUM_DIR/$THEME_NAME" "$KVANTUM_DIR/${THEME_NAME}Sea"
    # Wallpaper base dirs keep the hyphen: Lavanda, Lavanda-Sea.
    rm -rf "$WALLPAPER_DIR/$THEME_NAME" "$WALLPAPER_DIR/$THEME_NAME-Sea"

    if [ -n "$SDDM_DIR" ]; then
        rm -rf "$SDDM_DIR/$THEME_NAME" "$SDDM_DIR/$THEME_NAME-Sea"
    fi

    echo "Removed Lavanda themes ($SCOPE)."
}

case "${1:-install}" in
    install)
        do_install
        ;;
    uninstall|--uninstall|-u)
        do_uninstall
        ;;
    -h|--help)
        usage
        ;;
    *)
        usage >&2
        exit 2
        ;;
esac
