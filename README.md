# MPBT Client

Modern **Godot 4** client for **Multiplayer BattleTech: Solaris**, designed to work alongside `mpbt-server` while preserving compatibility with the original retail **MPBT v1.29 client from 1999**.

This repository is now in an active **retail-fidelity, RE-backed implementation** phase rather than an early scaffold stage. See [ROADMAP.md](ROADMAP.md) for the product and technical roadmap, and [PLAN.md](PLAN.md) for the client/server compatibility strategy.

## Goals

- Build a modern Godot 4 client for Windows, Linux, macOS, and eventually mobile/tablet feasibility.
- Treat 3D combat as a first-class scene, not a browser-rendered add-on.
- Preserve the feel and semantics of the retail v1.29 client wherever known.
- Support modern resolutions, better setup, improved windowing, input remapping, diagnostics, and other quality-of-life improvements.
- Reuse the original licensed game assets locally without redistributing proprietary Kesmai/EA files.
- Use the same canonical game state as the retail client path in `mpbt-server`.

## Relationship to mpbt-server

`mpbt-server` should remain the source of truth for game and service state:

- Accounts
- Characters
- Solaris rooms and travel
- ComStar messages
- Mech selection and combat loadouts
- Arena ready rooms
- Combat state
- Rankings and persistence

The server should expose that state through two adapters:

```text
core game/server logic
  -> retail v1.29 ARIES adapter
  -> modern mpbt-client REST/WebSocket adapter
```

The original v1.29 client should continue to use ARIES and retail command builders. The modern Godot client should use a clean REST/WebSocket API and should not depend on low-level retail packet details such as `Cmd43`, `Cmd57`, base-85 frames, or ARIES transport quirks.

## Chosen Stack

- **Godot 4.x** for the application, 3D combat, UI scenes, input, audio, packaging, and tooling.
- **GDScript** for most client gameplay and UI code.
- **C# or GDExtension** where useful for performance-sensitive code, binary asset importers, or shared model/protocol tooling.
- **REST + WebSocket** API for communication with `mpbt-server`.
- **Local retail asset importers** for user-provided licensed assets.

This supersedes the earlier TypeScript/PixiJS/Tauri-first recommendation. A browser-first client is no longer the primary path.

## Project Layout

The initial Godot 4 scaffold is organized around a small set of stable folders:

```text
addons/                  Godot editor/runtime plugins.
assets/                  Safe placeholders and ignored local retail asset outputs.
config/                  Default and local client configuration.
docs/                    Implementation notes.
scenes/main/             Startup/menu scene.
scenes/world/            Solaris world shell.
scenes/combat/           3D combat scene.
scripts/config/          Client configuration loader.
scripts/net/             Future REST/WebSocket code.
scripts/ui/              Future shared UI helpers.
tests/                   Future automated tests.
```

See [docs/DIRECTORY_LAYOUT.md](docs/DIRECTORY_LAYOUT.md) for the full layout.

## Local Configuration

The client loads connection settings from:

1. `config/default_client.json`
2. `config/local.json`
3. `user://mpbt-client.json`

`config/local.json` is ignored by git. Start from [config/local.example.json](config/local.example.json) when pointing the client at a local `mpbt-server`.

Minimal connection fields:

```json
{
  "server": {
    "base_url": "http://127.0.0.1:3000",
    "websocket_url": "ws://127.0.0.1:3000/ws"
  }
}
```

See [docs/CONFIG.md](docs/CONFIG.md) for the full current format.

## Headless smoke checks

Run targeted parity/probe smoke scripts from repo root:

```powershell
godot --headless --script tests\m6_parity_slice_smoke.gd
godot --headless --script tests\m8_binary_probe_smoke.gd
```

## Fidelity Strategy

The target is not a literal Win32/DirectDraw clone. The target is a modern 3D client that feels close to the retail v1.29 experience while being practical to maintain.

The retail client remains the compatibility oracle for:

- World flow
- Mech selection behavior
- Arena staging
- Combat pacing
- SCentEx/ranking semantics
- UI-triggered game actions

Modern UI may improve presentation and usability, but it should not redefine the core game model.

## Reverse-Engineering Status

The retail research layer is now materially complete at the named-function level for the live `MPBTWIN.EXE` Ghidra project:

- The current live project has **no remaining `FUN_*` functions**.
- `scripts/research/retail_function_catalog.gd` now imports the full live custom-name inventory: **1290 named functions**.
- The companion command/helper/subsystem catalogs provide a behavior-first reference surface for continuing the Godot client and server work.

This means the project does **not** need to pause for a full-source C++ reconstruction to keep moving. A source-like rebuild may still be useful later as a private/internal research tool for ambiguous subsystems, but the primary path remains the modern Godot client with targeted low-level ports only where needed.

## Rendering Strategy

Use the original 640x480 retail layout as a reference coordinate system for UI/HUD composition, then scale and adapt it for modern displays.

Initial Godot scenes should focus on:

- Login/account flow
- Character profile
- Solaris and Inner Sphere maps
- World room screens
- ComStar/social panels
- Mech selection
- Arena ready room
- 3D combat scene with retail-inspired cockpit/HUD

Combat should start with a pragmatic Godot 3D MVP using placeholder or imported meshes and terrain. Exact fidelity can improve as original asset formats are decoded.

Exact behavior for these assets may become important:

- `3dobj.bin`
- `keyframe.bin`
- `terrain/TER###.BIN`
- `terrain/TER###.DAT`
- `terrain/TER###.PAL`

These may affect arena rendering, mech/object geometry, animation timing, collision expectations, visibility, terrain rasterization, or combat feel.

## Asset Policy

This project must not redistribute proprietary game assets.

Use assets from a local licensed retail installation. Asset variants should be tracked as:

- `original`: direct extraction from retail files.
- `scaled`: deterministic scaling.
- `enhanced`: manual cleanup or AI-upscaled variants.

AI upscaling is acceptable for large scenes, map backgrounds, terrain textures, and similar assets. Use caution with fonts, HUD marks, icons, thin chrome, and palette-dependent assets.

## Initial Milestones

1. Godot project scaffold.
2. Local asset browser/import validation.
3. REST/WebSocket API contract with `mpbt-server`.
4. Account and character flow.
5. Solaris world shell: map, rooms, presence, chat, ComStar, travel.
6. Mech selection and viewer.
7. Arena ready room.
8. 3D combat MVP.
9. Retail fidelity pass for original model/terrain/keyframe behavior.
10. Packaging and distribution.

## Non-Goals

- Do not replace `mpbt-server` retail v1.29 compatibility.
- Do not make the modern client speak ARIES directly as its main protocol.
- Do not redistribute proprietary assets.
- Do not make AI-upscaled assets mandatory.
- Do not hardcode gameplay behavior in the client when the server should own it.
- Do not build a browser-first client as the primary implementation path unless Godot is later abandoned.

## Current Status

The client is beyond the initial scaffold and currently includes:

- Login, registration, and character creation flow
- Solaris world shell: room navigation, presence roster, room chat, minimap
- Mech Bay: mech selection from `.MEC` catalogue
- Arena ready room: multi-player staging and match launch
- 3D combat scene: WASD+mouse, live snapshot sync, HUD, match results
- Solaris VII standings leaderboard
- ComStar Terminal: retail-shaped private messaging with a waiting inbox, compose, reply, and ComStar-ID-aware recipient targeting
- In-app Settings screen (server URL, asset paths, display, input rebinding, audio)
- Audio: volume settings (Master/Music/SFX), scene BGM hooks
- Export presets for Windows, Linux, macOS, Android (Experimental), and iOS (Experimental)
- Touch controls for mobile (Virtual Joystick + look zone)
- Diagnostics overlay (F3): FPS, WebSocket/server status, active scene
- Input rebinding with persistent save to `user://mpbt-client.json`
- Display mode and resolution control (windowed/fullscreen, 3 presets)
- Retail extracted-art integration for world/combat/non-combat screens: world shell chrome, district thumbnails, clickable travel map, Mech Bay portraits, ready-room backdrop, and a retail-style standings shell
- Extracted asset pipeline fixes for palette-correct `ui/` and `combat/` output
- Retail SFX extraction pipeline that converts raw PCM clips to Godot-friendly WAV, emits logical aliases such as `ui_click.wav` / `ui_hover.wav`, prefers decoded formats over PCM, and refreshes cached streams when the resolved file changes
- A complete named-function retail research catalog for the live `MPBTWIN.EXE` project, with matching command/helper/subsystem metadata available to guide retail-accurate implementation

## Near-Term Focus

The next highest-confidence step is to keep extending the screenshot-driven retail shell pass into the remaining bare non-combat scenes, starting with **ComStar** and then **Settings**, before returning to deeper combat posture/animation fidelity work. The completed retail research catalogs should now be used as the primary oracle when tightening remaining world/combat behavior, and bounded parity slices should continue to audit `mpbt-server` first wherever canonical retail behavior differs.

See [docs/PACKAGING.md](docs/PACKAGING.md) for export instructions, code signing, and the release checklist.
See [docs/MOBILE.md](docs/MOBILE.md) for Android/iOS feasibility details and known limitations.
