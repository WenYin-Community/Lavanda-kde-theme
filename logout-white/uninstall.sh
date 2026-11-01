#!/usr/bin/env bash
#
# Lavanda: remove the user-level white logout screen override.

set -euo pipefail

SHELL_NAME="org.kde.plasma.desktop"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
USER_SHELL="${DATA_HOME}/plasma/shells/${SHELL_NAME}"
MARKER="${USER_SHELL}/contents/logout/.lavanda-white-logout"

usage() {
    cat <<EOF
Usage: ./logout-white/uninstall.sh

Removes the user-level shell override and falls back to the system shell:
  ${USER_SHELL}

No sudo is required.
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
    exit 1
fi

if [ ! -d "${USER_SHELL}" ]; then
    echo "White logout override is not installed."
    exit 0
fi

if [ ! -f "${MARKER}" ]; then
    echo "Refusing to remove an unrecognized user shell:" >&2
    echo "  ${USER_SHELL}" >&2
    echo "The Lavanda marker file is missing." >&2
    exit 1
fi

backup="${USER_SHELL}.bak-$(date +%Y%m%d-%H%M%S)"
mv "${USER_SHELL}" "${backup}"

cat <<EOF

Removed the white logout override.
Backup: ${backup}
The system shell will be used again after the next logout/login.
EOF
