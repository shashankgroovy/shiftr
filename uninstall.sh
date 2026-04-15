#!/usr/bin/env bash
set -euo pipefail

NATIVE_HOST_NAME="shiftr_host"

case "$(uname -s)" in
    Darwin)
        TARGET_DIR="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
        ;;
    Linux)
        TARGET_DIR="$HOME/.mozilla/native-messaging-hosts"
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

echo ""
echo "To fully uninstall Shiftr, also remove the extension from Firefox:"
echo "  1. Go to about:addons"
echo "  2. Find Shiftr and click Remove"
