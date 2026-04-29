# MPBT Client — Packaging and Distribution

This document covers building distributable artifacts from the Godot 4 project,
platform-specific considerations, and code signing requirements.

---

## Prerequisites

### Godot Export Templates

Distributable exports require Godot's platform export templates. These are **not**
included in this repository.

**Option A — Godot Editor UI**
1. Open the project in Godot Editor.
2. Go to **Editor → Manage Export Templates → Download**.
3. Choose the version matching your installed Godot (4.6.x) and download.

**Option B — Offline .tpz**
1. Download the matching `.tpz` file from https://godotengine.org/download/archive/
2. **Editor → Manage Export Templates → Install from File** and point at the `.tpz`.

### Export Presets

`export_presets.cfg` is already committed in the repository root and configured for:
- Windows Desktop x86_64 → `builds/windows/mpbt-client.exe`
- Linux/X11 x86_64 → `builds/linux/mpbt-client.x86_64`
- macOS Universal → `builds/macos/MPBT Client.zip`

`config/local.json` is excluded from all presets to prevent developer server overrides
leaking into distributed artifacts.

---

## Building

### Create output directories

```powershell
New-Item -ItemType Directory -Force -Path builds/windows, builds/linux, builds/macos
```

### Export (headless / CI)

```bash
# Windows
godot --headless --export-release "Windows Desktop" builds/windows/mpbt-client.exe

# Linux
godot --headless --export-release "Linux/X11" builds/linux/mpbt-client.x86_64

# macOS
godot --headless --export-release "macOS" "builds/macos/MPBT Client.zip"
```

The `builds/` directory is gitignored — do not commit export artifacts.

### Smoke testing an export

After exporting, launch the binary and verify the main menu loads and server
discovery resolves (or shows a meaningful offline state):

```bash
# Windows
./builds/windows/mpbt-client.exe

# Linux
chmod +x builds/linux/mpbt-client.x86_64
./builds/linux/mpbt-client.x86_64

# macOS — unzip first
unzip "builds/macos/MPBT Client.zip" -d builds/macos/app
open "builds/macos/app/MPBT Client.app"
```

---

## User Data Directory

With `application/config/custom_user_dir_name = "mpbt-client"` set in `project.godot`,
`user://` resolves to:

| Platform | Path |
|---|---|
| Windows | `%APPDATA%\mpbt-client\` |
| Linux   | `~/.local/share/mpbt-client/` |
| macOS   | `~/Library/Application Support/mpbt-client/` |

Logs are written to `user://logs/godot.log`.
Settings are stored at `user://mpbt-client.json`.

---

## Code Signing

### Windows (Authenticode)

1. Obtain a code-signing certificate (EV cert preferred for SmartScreen bypass).
2. Sign the exported `.exe` with `signtool.exe`:
   ```bat
   signtool sign /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 ^
     /f your_cert.pfx /p <password> builds\windows\mpbt-client.exe
   ```
3. For CI, store the `.pfx` as an encrypted secret and pass it via environment variable.

### macOS (Gatekeeper + Notarization)

1. Obtain an Apple Developer ID Application certificate.
2. Configure `export_presets.cfg`:
   - `codesign/enable=true`
   - `codesign/identity="Developer ID Application: Your Name (TEAMID)"`
   - `notarization/enable=true` + fill in `api_uuid`, `api_key`, `api_key_id`, `apple_team_id`
3. After export, Godot can optionally run notarization via `xcrun notarytool`.
4. Without notarization, users must right-click → Open to bypass Gatekeeper.

### Linux

Linux does not require code signing for desktop distribution. For AppImage
packaging (optional):

```bash
# Requires appimagetool on PATH
wget https://github.com/AppImage/AppImageKit/releases/latest/download/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage
# Set up AppDir, copy binary + icon + .desktop file, then:
./appimagetool-x86_64.AppImage AppDir builds/linux/mpbt-client-x86_64.AppImage
```

---

## Release Checklist

Before tagging a release:

- [ ] `config/local.json` is absent or blank (will be excluded by presets, but verify)
- [ ] `config/default_client.json` points at production server URL
- [ ] Version strings updated: `project.godot` `config/version`, macOS preset `short_version`/`version`
- [ ] Export templates installed for target Godot version
- [ ] `builds/` directory created and gitignored
- [ ] All three exports complete without errors
- [ ] Smoke-test: main menu loads; server discovery resolves; Settings screen opens; user config saves
- [ ] Windows: signed with Authenticode cert (if available)
- [ ] macOS: code-signed and notarized (if Developer ID cert available)
