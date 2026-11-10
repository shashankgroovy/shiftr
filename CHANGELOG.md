# Changelog

## 1.1.0 — 2026-11-10

- First-run setup screen in the popup when the native host isn't installed, with a one-click copy of the install command
- The install command is pinned to the extension's release tag, so the native host always matches the extension version
- `install.sh` can run standalone (`curl … | bash`) — it downloads the native host instead of requiring a clone
- `uninstall.sh` also removes the downloaded native host script

## 1.0.0 — 2026-04-15

Initial release.

- Switch between Firefox profiles from the toolbar popup
- Keyboard shortcut (`Alt+Shift+P`) to open the popup
- Quick switch by pressing `1`-`9` inside the popup
- Create new profiles directly from the popup
- Rename profiles via the context menu
- Set default profile via the context menu
- Link to `about:profiles` for advanced management
- 6 built-in themes: Ayu (Dark, Mirage, Light) and Tokyo Night (Night, Storm, Light)
- Theme choice persisted via `browser.storage.local`
- Native messaging host for reading/writing `profiles.ini`
- macOS and Linux support
