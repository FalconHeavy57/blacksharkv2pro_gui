#!/bin/bash
# Remove the BlackShark V2 Pro GUI installed by install.sh.
set -e

BIN="${HOME}/.local/bin/blackshark-gui"
DESKTOP="${HOME}/.local/share/applications/dev.blacksharkv2pro.gui.desktop"

for f in "$BIN" "$DESKTOP"; do
    if [ -f "$f" ]; then
        rm "$f"
        echo "Removed: $f"
    else
        echo "Not installed: $f"
    fi
done
update-desktop-database "${HOME}/.local/share/applications" 2>/dev/null || true
echo "Done."
