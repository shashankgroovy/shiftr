#!/usr/bin/env bash
set -euo pipefail

NATIVE_HOST_NAME="shiftr_host"

case "$(uname -s)" in
    Darwin)
        TARGET_DIR="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
        DATA_DIR="$HOME/Library/Application Support/Shiftr"
        ;;
    Linux)
        TARGET_DIR="$HOME/.mozilla/native-messaging-hosts"
        DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/shiftr"
        ;;
    *)
        echo "Error: Unsupported OS."
        exit 1
        ;;
esac

MANIFEST="$TARGET_DIR/$NATIVE_HOST_NAME.json"

if [ -f "$MANIFEST" ]; then
    rm "$MANIFEST"
    echo "Removed native messaging host manifest:"
    echo "  $MANIFEST"
else
    echo "Nothing to remove — native host manifest not found at:"
    echo "  $MANIFEST"
fi

# Host script downloaded by the standalone installer (absent for checkout installs)
HOST_SCRIPT="$DATA_DIR/$NATIVE_HOST_NAME.py"
if [ -f "$HOST_SCRIPT" ]; then
    rm "$HOST_SCRIPT"
    rmdir "$DATA_DIR" 2>/dev/null || true
    echo "Removed native host script:"
    echo "  $HOST_SCRIPT"
fi

echo ""
echo "To fully uninstall Shiftr, also remove the extension from Firefox:"
echo "  1. Go to about:addons"
echo "  2. Find Shiftr and click Remove"
