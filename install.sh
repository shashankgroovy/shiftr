#!/usr/bin/env bash
#
# Registers the Shiftr native messaging host with Firefox.
#
# Works two ways:
#   - From a checkout:  ./install.sh   (uses native-host/shiftr_host.py in place)
#   - Standalone:       curl -fsSL https://raw.githubusercontent.com/shashankgroovy/shiftr/v<version>/install.sh | bash
#                       (downloads shiftr_host.py into a per-user data directory)
set -euo pipefail

NATIVE_HOST_NAME="shiftr_host"
# Release tag the standalone install downloads the host from.
# Keep in step with "version" in extension/manifest.json.
SHIFTR_VERSION="1.1.0"
HOST_URL="https://raw.githubusercontent.com/shashankgroovy/shiftr/v$SHIFTR_VERSION/native-host/$NATIVE_HOST_NAME.py"

# Everything lives in main() so a partially downloaded script never runs half-way.
main() {
    local target_dir data_dir
    case "$(uname -s)" in
        Darwin)
            target_dir="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts"
            data_dir="$HOME/Library/Application Support/Shiftr"
            ;;
        Linux)
            target_dir="$HOME/.mozilla/native-messaging-hosts"
            data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/shiftr"
            ;;
        *)
            echo "Error: Unsupported OS. This script supports macOS and Linux." >&2
            exit 1
            ;;
    esac

    echo "=== Shiftr - Native Host Installer ==="
    echo ""

    if ! command -v python3 >/dev/null 2>&1; then
        echo "Warning: python3 was not found on your PATH. Shiftr needs Python 3.6+ to work."
        echo ""
    fi

    # When piped into bash there is no script file, so BASH_SOURCE is empty.
    local script_dir="" local_host="" from_checkout=0
    if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
        script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        local_host="$script_dir/native-host/$NATIVE_HOST_NAME.py"
    fi

    local host_script
    if [ -n "$local_host" ] && [ -f "$local_host" ]; then
        from_checkout=1
        host_script="$local_host"
    else
        host_script="$data_dir/$NATIVE_HOST_NAME.py"
        echo "Downloading native host script..."
        mkdir -p "$data_dir"
        local tmp="$host_script.tmp"
        if command -v curl >/dev/null 2>&1; then
            curl -fsSL "$HOST_URL" -o "$tmp"
        elif command -v wget >/dev/null 2>&1; then
            wget -qO "$tmp" "$HOST_URL"
        else
            echo "Error: neither curl nor wget is available to download the host script." >&2
            exit 1
        fi
        if [ ! -s "$tmp" ]; then
            rm -f "$tmp"
            echo "Error: downloaded host script is empty." >&2
            exit 1
        fi
        mv "$tmp" "$host_script"
    fi

    chmod +x "$host_script"
    mkdir -p "$target_dir"

    # Generate the manifest with the correct absolute path
    cat > "$target_dir/$NATIVE_HOST_NAME.json" <<EOF
{
  "name": "$NATIVE_HOST_NAME",
  "description": "Native messaging host for Shiftr",
  "path": "$host_script",
  "type": "stdio",
  "allowed_extensions": ["shiftr@local"]
}
EOF

    echo "Native host script: $host_script"
    echo "Manifest:           $target_dir/$NATIVE_HOST_NAME.json"
    echo ""

    if [ "$from_checkout" -eq 1 ]; then
        echo "Next steps (if the extension isn't installed yet):"
        echo "  1. Open Firefox"
        echo "  2. Go to about:debugging#/runtime/this-firefox"
        echo "  3. Click 'Load Temporary Add-on...'"
        echo "  4. Select: $script_dir/extension/manifest.json"
    else
        echo "Next step: open the Shiftr popup in Firefox again — your profiles should appear."
    fi
    echo ""
    echo "Done!"
}

main "$@"
