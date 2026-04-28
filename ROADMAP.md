# MPBT Client Roadmap

## Vision

Build a modern, cross-platform client for **Multiplayer BattleTech: Solaris** that feels as close as practical to the retail **v1.29 client released in 1999**, while supporting modern resolutions, current operating systems, accessible setup, and quality-of-life improvements.

The client should preserve the game’s identity: Solaris world navigation, ComStar/social surfaces, mech management, arena ready rooms, indexed-color UI art, cockpit/HUD language, combat pacing, and the late-1990s BattleTech feel. Modernization should improve presentation and usability without turning the project into a different game.

## Primary Recommendation

Use a **TypeScript web-first client** with:

- **PixiJS** for 2D GPU rendering, UI composition, map/world screens, HUDs, sprites, and palette-aware asset presentation.
- **Tauri 2** for native packaging on Windows, macOS, Linux, Android, and iOS.
- **Three.js or a native/WASM renderer module** only where combat/3D fidelity needs it.
- A clean **REST + WebSocket API** for the new client, while `mpbt-server` keeps ARIES compatibility for the original retail client.

This aligns with the existing `mpbt-server` codebase, which is TypeScript and already contains protocol, world, combat, map, mech, and asset-parsing knowledge.

## Fidelity Target

The target is not a literal DirectDraw/Win32 clone. The target is a modern client that:

- Matches retail v1.29 gameplay semantics wherever known.
- Preserves original UI art, iconography, map backgrounds, combat HUD assets, sounds, music, and mech data where legally available.
- Keeps combat pacing and animation timing close to retail behavior, including an explicit fixed-step/60 FPS timing model where appropriate.
- Supports modern resolutions through scaling, layout adaptation, and optional enhanced assets.
- Provides quality-of-life improvements such as better login flow, window management, input remapping, diagnostics, account setup, and clearer error states.

## Important Compatibility Notes

Reverse-engineering work indicates the retail v1.29 client is a Win32/x86 C++ program using DirectDraw-era 8-bit surfaces, software blits, palettes, custom image containers, custom terrain/model loaders, and fixed-size 640x480 assumptions.

That does **not** require the new client to be written in C++. It does mean the renderer and asset layer should be designed with enough structure to reproduce old behavior when fidelity matters.

Exact behavior for the following assets may become important:

- `3dobj.bin`
- `keyframe.bin`
- `terrain/TER###.BIN`
- `terrain/TER###.DAT`
- `terrain/TER###.PAL`

These may affect authentic arena rendering, mech/object geometry, animation timing, terrain rasterization, collision expectations, visibility, or combat feel. Do not treat the current PNG extraction as the final word for combat fidelity.

## Architecture

### Client Shell

- TypeScript application.
- PixiJS render surface.
- Tauri wrapper for native distribution.
- Browser-compatible development mode for fast iteration.
- Shared asset manifest and configuration format.

### Server API

The modern client should not speak ARIES directly as its primary protocol.

Use:

- REST/HTTPS for auth, account, launcher metadata, character profile, mech inventory, rankings, articles, and static configuration.
- WebSocket for world presence, chat, room travel, menus, ready-room state, combat input, combat snapshots, and match events.

Keep ARIES in `mpbt-server` as the compatibility protocol for `MPBTWIN.EXE`.

### Shared Logic

Prefer sharing or porting existing TypeScript logic from `mpbt-server` for:

- `.MEC` parsing and derived mech stats.
- `MPBT.MSG` string-table handling.
- `.MAP` room parsing.
- World room data and travel metadata.
- Combat constants, weapon data, heat, ammo, movement, and damage semantics.

Avoid duplicating server truth in a divergent client-only model.

## Rendering Plan

### Phase 1: 2D Retail-Style Shell

Use PixiJS to reproduce:

- Login/account flow.
- Character profile.
- Solaris map and Inner Sphere map.
- World room screens.
- ComStar/social panels.
- Mech selection and mech bay.
- Arena ready room.
- Combat HUD shell using extracted retail assets.

Use the original 640x480 layout as the canonical coordinate space, then scale and adapt it for modern resolutions.

### Phase 2: Combat MVP

Start with a pragmatic combat renderer:

- Fixed-step simulation timing.
- Retail-inspired cockpit/HUD composition.
- Server-authoritative player/actor state.
- Movement, heading, torso/leg orientation, speed, heat, armor/internal state, weapon fire, projectile/effect events.
- Conservative 2D/2.5D representation if exact terrain/model rendering is not ready.

### Phase 3: Fidelity Renderer

If fidelity demands it, introduce a replaceable renderer core:

- C++ or Rust module compiled to WASM for web/Tauri.
- Native build option for desktop if needed.
- Exact or near-exact loaders for `3dobj.bin`, `keyframe.bin`, terrain `.BIN/.DAT/.PAL`, animation files, and indexed palettes.
- Software rasterization or GPU translation that preserves retail visual behavior.

The TypeScript client should call this through a narrow interface so the rest of the UI/client code does not depend on renderer internals.

## Asset Strategy

Use the licensed local retail assets; do not redistribute proprietary assets.

Maintain asset variants:

- `original`: direct extraction from retail files.
- `scaled`: nearest-neighbor or clean deterministic scaling.
- `enhanced`: manually cleaned or AI-upscaled variants.

AI upscaling is acceptable for:

- Scene plates.
- Map backgrounds.
- Terrain textures.
- Large UI backdrops.
- Potential mech/object textures after validation.

Be cautious with:

- Fonts.
- Icons.
- HUD marks.
- Thin UI chrome.
- Palette-dependent assets.

Those often need manual cleanup or deterministic scaling rather than AI reinterpretation.

Every enhanced asset should retain a link to its original source asset and a reproducible generation note.

## Quality-of-Life Goals

Modernization should focus on friction reduction without compromising the Solaris feel:

- Native installers/packages.
- Windowed, fullscreen, borderless, and integer-scale display modes.
- Modern resolution support with a faithful 4:3 option.
- Input remapping.
- Controller experiments only after keyboard/mouse parity.
- Better connection/account error messages.
- In-game diagnostics toggle for packet/state debugging.
- Optional modern chat affordances while preserving ComStar flavor.
- Accessibility options for text size, contrast, and audio levels.

## Milestones

### M0: Project Scaffold

- Choose package manager and app framework.
- Add TypeScript, PixiJS, Tauri, linting, formatting, test runner.
- Add asset manifest format.
- Add local config for connecting to `mpbt-server`.

### M1: Asset Browser

- Load extracted PNG assets from local licensed asset directory.
- Render palettes and transparency correctly.
- Browse UI, icons, scenes, maps, combat HUD, sounds, and music metadata.
- Validate scaling modes.

### M2: Modern API Contract

- Define REST/WebSocket protocol between `mpbt-client` and `mpbt-server`.
- Add a compatibility adapter on the server side rather than exposing ARIES directly.
- Document message schemas and version negotiation.

### M3: Account and Character Flow

- Login/register.
- Character creation.
- House/allegiance selection.
- Profile display.
- Returning-player flow.

### M4: Solaris World Shell

- Map navigation.
- Room scene display.
- Presence roster.
- Room chat.
- ComStar message read/send/reply.
- Travel and room transitions.

### M5: Mech Management

- Mech inventory.
- Mech selection.
- Mech status.
- Mech details from `.MEC` and `MPBT.MSG`.
- Ammo/weapon/loadout display as server support allows.

### M6: Arena Ready Room

- Arena entry.
- Side/team selection.
- Status/ready flow.
- Match launch.
- Multi-player staging.

### M7: Combat MVP

- Render cockpit/HUD.
- Consume combat snapshots.
- Send movement/input commands.
- Show remote actors.
- Show weapon fire, damage, heat, ammo, and match end.
- Keep timing fixed and measured against retail-client observations.

### M8: Retail Fidelity Pass

- Investigate exact terrain/model/keyframe behavior.
- Decide whether to implement a native/WASM renderer core.
- Compare side-by-side with retail v1.29 captures.
- Tune camera, movement, weapon effects, fall/recovery timing, and HUD behavior.

### M9: Packaging and Distribution

- Desktop packaging with Tauri.
- App signing strategy.
- Asset-location onboarding.
- Settings migration.
- Crash/log capture.

### M10: Mobile/Tablet Feasibility

- Validate touch layout.
- Validate performance.
- Decide whether mobile is a supported target or experimental.

## Non-Goals

- Do not redistribute proprietary Kesmai/EA assets.
- Do not require the modern client to perfectly emulate Win32, DirectDraw, or ARIES internals.
- Do not replace `mpbt-server` retail-client compatibility.
- Do not make AI-upscaled art the only available presentation.
- Do not hardcode gameplay behavior in the client when the server should own it.

## Open Questions

- How much of `3dobj.bin` and `keyframe.bin` is required for authentic combat visuals?
- Are terrain `.BIN/.DAT/.PAL` files only visual, or do they encode gameplay-relevant collision/height/visibility behavior?
- What is the minimum acceptable combat renderer for an MVP?
- Should the first client release prioritize world/social/mech management before full combat?
- Which v1.29 UI surfaces should be faithfully reproduced, and which can be redesigned?
- What asset enhancement policy preserves the retail look while making modern resolutions attractive?

