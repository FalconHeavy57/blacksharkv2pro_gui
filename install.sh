#!/bin/bash
# Install the BlackShark V2 Pro GUI for the current user (no root needed).
set -e
cd "$(dirname "$0")"

BIN_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"
DESKTOP_ID="dev.blacksharkv2pro.gui.desktop"

echo "== checking dependencies =="
if ! command -v python3 >/dev/null; then
    echo "ERROR: python3 not found." >&2
    exit 1
fi
if ! python3 -c "import gi; gi.require_version('Gtk', '4.0'); gi.require_version('Adw', '1')" 2>/dev/null; then
    echo "ERROR: GTK4/libadwaita Python bindings missing." >&2
    echo "  Fedora:        sudo dnf install python3-gobject gtk4 libadwaita" >&2
    echo "  Debian/Ubuntu: sudo apt install python3-gi gir1.2-gtk-4.0 gir1.2-adw-1" >&2
    echo "  Arch:          sudo pacman -S python-gobject gtk4 libadwaita" >&2
    exit 1
fi
if ! python3 -c "import openrazer.client" 2>/dev/null; then
    echo "WARNING: the openrazer Python library is not installed." >&2
    echo "  The app will start but won't find the headset until OpenRazer" >&2
    echo "  (BlackShark V2 Pro full-hardware-support branch) is installed." >&2
    echo "  See README.md." >&2
fi

echo "== installing =="
install -Dm755 blackshark-gui "${BIN_DIR}/blackshark-gui"
mkdir -p "${APP_DIR}"
sed "s|@EXEC@|${BIN_DIR}/blackshark-gui|" "${DESKTOP_ID}" > "${APP_DIR}/${DESKTOP_ID}"
update-desktop-database "${APP_DIR}" 2>/dev/null || true

echo "== done =="
echo "Installed: ${BIN_DIR}/blackshark-gui"
echo "Installed: ${APP_DIR}/${DESKTOP_ID}"
echo "Launch it from your app menu ('BlackShark V2 Pro') or run: blackshark-gui"
