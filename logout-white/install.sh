#!/usr/bin/env bash
#
# Lavanda: user-level white logout screen override.
#
# Plasma 6.x loads the logout QML from the org.kde.plasma.desktop shell, not
# from the theme's Look-and-Feel contents/logout. This script copies that
# shell into the current user's data directory and overlays a white-background
# logout UI. Nothing in /usr/share or KDE global configuration is modified.

set -euo pipefail

SHELL_NAME="org.kde.plasma.desktop"
SYS_SHELL="/usr/share/plasma/shells/${SHELL_NAME}"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
USER_SHELL="${DATA_HOME}/plasma/shells/${SHELL_NAME}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
MARKER="${USER_SHELL}/contents/logout/.lavanda-white-logout"

usage() {
    cat <<EOF
Usage: ./logout-white/install.sh

Installs a user-level copy of the Plasma desktop shell with a white
logout/shutdown background and dark text.

Target: ${USER_SHELL}

No sudo is required. KDE global configuration and /usr/share are not modified.
EOF
}

case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
    "")
        ;;
    *)
        echo "Unknown option: $1" >&2
        usage >&2
        exit 2
        ;;
esac

if [ "$(id -u)" -eq 0 ]; then
    echo "Error: run this script as your regular user, not with sudo/root." >&2
    echo "The override is user-level and installs under \$HOME." >&2
    exit 1
fi

if [ ! -d "${SYS_SHELL}" ]; then
    echo "Error: Plasma shell not found: ${SYS_SHELL}" >&2
    echo "This override is intended for KDE Plasma 6." >&2
    exit 1
fi

for file in Logout.qml LogoutControls.qml LogoutButton.qml; do
    if [ ! -f "${SCRIPT_DIR}/${file}" ]; then
        echo "Error: missing override file: ${SCRIPT_DIR}/${file}" >&2
        exit 1
    fi
done

if [ -e "${USER_SHELL}" ]; then
    backup="${USER_SHELL}.bak-$(date +%Y%m%d-%H%M%S)"
    mv "${USER_SHELL}" "${backup}"
    echo "Backed up existing user shell to: ${backup}"
fi

mkdir -p "$(dirname "${USER_SHELL}")"
cp -a "${SYS_SHELL}" "${USER_SHELL}"

for file in Logout.qml LogoutControls.qml LogoutButton.qml; do
    cp -f "${SCRIPT_DIR}/${file}" "${USER_SHELL}/contents/logout/${file}"
done

touch "${MARKER}"

cat <<EOF

Installed user-level white logout override:
  ${USER_SHELL}

The next logout/shutdown prompt and the next Plasma login will use it.
No system files or KDE global configuration were modified.

This override copies the shell QML present on this system when the script
runs. Re-run this script after Plasma updates, and use
./logout-white/uninstall.sh to revert.
EOF
