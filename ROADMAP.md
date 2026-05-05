# MPBT Client Roadmap

## Vision

Build a modern, cross-platform **Godot 4** client for **Multiplayer BattleTech: Solaris** that feels as close as practical to the retail **v1.29 client released in 1999**, while supporting modern resolutions, current operating systems, accessible setup, and quality-of-life improvements.

The client should preserve the game’s identity: Solaris world navigation, ComStar/social surfaces, mech selection, arena ready rooms, indexed-color UI art, cockpit/HUD language, combat pacing, and the late-1990s BattleTech feel. Modernization should improve presentation and usability without turning the project into a different game.

## Primary Recommendation

Use **Godot 4** as the main client engine.

Godot is the best fit for this project because the main gameplay is a 3D combat scene, but the project also needs a small-team-friendly, open, highly hackable engine for reverse-engineered assets and custom networking.

Recommended stack:

- **Godot 4.x** for the application, 3D combat scene, UI scenes, input, audio, packaging, and tooling.
- **C#** as the preferred target for newly ported parity-critical client logic, shared model code, protocol surfaces, and importer/runtime helpers.
- **GDScript** for existing scene glue and fast iteration where it does not become the long-term parity bottleneck.
- **GDExtension** for the rare low-level or performance-sensitive systems that still need native code after C#.
- **REST + WebSocket API** for the modern client.
- `mpbt-server` retains the **retail v1.29 ARIES adapter** for the original 1999 client.

This replaces the earlier TypeScript/PixiJS/Tauri-first plan. Browser-first rendering is no longer the recommended direction for the primary modern client.

## Why Godot 4

Godot gives us:

- A real 3D engine for arena combat.
- Native desktop builds without a browser runtime.
- Good iteration speed for a small project.
- Open-source MIT licensing.
- Enough control to build custom importers for retail MPBT assets.
- A lower operational burden than Unreal Engine.
- A friendlier contributor story than a large Unreal/C++ project.

Unreal Engine remains a reasonable alternative if the project later decides to prioritize highest-end visual fidelity, marketplace assets, cinematic tooling, or a larger production pipeline. For the first modern MPBT client, Godot 4 is the practical choice.

## Fidelity Target

The target is not a literal DirectDraw/Win32 clone. The target is a modern client that:

- Matches retail v1.29 gameplay semantics wherever known.
- Preserves original UI art, iconography, map backgrounds, combat HUD assets, sounds, music, and mech data where legally available.
- Keeps combat pacing and animation timing close to retail behavior, including an explicit fixed-step/60 FPS timing model where appropriate.
- Supports modern resolutions through scaling, layout adaptation, and optional enhanced assets.
- Provides quality-of-life improvements such as better login flow, window management, input remapping, diagnostics, account setup, and clearer error states.

## Current Progress Snapshot

The roadmap below is still directionally correct, but current implementation is already well beyond scaffolding:

- Auth/character flow, Solaris world shell, Mech Bay, arena ready room, standings, ComStar, settings, and a playable 3D combat scene are all in place.
- Recent retail-fidelity work has focused on extracted art/audio integration: world-shell chrome, combat HUD art, non-combat scene artwork, palette-correct UI/combat extraction, and retail PCM-to-WAV SFX conversion with logical aliasing.
- Reverse-engineering coverage is now materially stronger: the live `MPBTWIN.EXE` Ghidra project has no remaining `FUN_*` entries, and the client research layer imports the full **1290-function** custom-name inventory.
- The active roadmap focus is now **M8: Retail Fidelity Pass** rather than M0/M1 setup work.

Near-term highest-confidence work:

1. Execute a bounded **ComStar** retail-parity slice across `mpbt-server` and `mpbt-client`, auditing server semantics first and then tightening the Godot client against the recovered behavior catalogs.
2. Extend the retail shell/chrome pass into the remaining bare non-combat scenes (`ComStar`, then `Settings`) using the original retail extracted assets as the default presentation reference.
3. Tighten screenshot-driven spacing/layout polish across world and standings.
4. Return to deeper combat posture/animation fidelity and Cmd70-aligned presentation work.

## Important Compatibility Notes

Reverse-engineering work indicates the retail v1.29 client is a Win32/x86 C++ program using DirectDraw-era 8-bit surfaces, software blits, palettes, custom image containers, custom terrain/model loaders, and fixed-size 640x480 assumptions.

That does **not** require the new client to be written in C++. It does mean the renderer and asset layer should be designed with enough structure to reproduce old behavior when fidelity matters.

With the named-function map now complete in the live Ghidra project, the highest-ROI path is a behavior-first Godot implementation backed by the research catalogs. A near-retail C++ rebuild is now better framed as optional private/internal tooling for unusually ambiguous subsystems, not as the main roadmap.

Exact behavior for the following assets may become important:

- `3dobj.bin`
- `keyframe.bin`
- `terrain/TER###.BIN`
- `terrain/TER###.DAT`
- `terrain/TER###.PAL`

These may affect authentic arena rendering, mech/object geometry, animation timing, terrain rasterization, collision expectations, visibility, or combat feel. Do not treat current PNG extraction or screenshots as the final word for combat fidelity.

## Architecture

### Client Runtime

- Godot 4 project.
- Desktop-first target: Windows, Linux, macOS.
- Scene-based UI for login, world, ComStar, mech selection, ready rooms, and combat.
- 3D combat scene as a first-class part of the client, not a late add-on.
- Local settings file for server URL, asset path, rendering mode, scaling mode, and diagnostics.

### Server API

The modern client should not speak ARIES directly as its primary protocol.

Use:

- REST/HTTPS for auth, account, launcher metadata, character profile, mech selection, rankings, articles, and static configuration.
- WebSocket for world presence, chat, room travel, menus, ready-room state, combat input, combat snapshots, and match events.

Keep ARIES in `mpbt-server` as the compatibility protocol for `MPBTWIN.EXE`.

### Porting Workflow

Port recovered retail behavior in bounded slices rather than as a repo-wide audit.

For each slice:

1. Patch `mpbt-server` first if the recovered behavior changes canonical state, protocol semantics, ordering, validation, or timing.
2. Patch `mpbt-client` for the corresponding shell/UI/input/presentation expectations.
3. Use the original retail extracted assets locally whenever that slice depends on retail chrome, map art, HUD art, sounds, or music cues.

### Shared Logic

Prefer sharing, porting, or generating data from existing `mpbt-server` logic for:

- `.MEC` parsing and derived mech stats.
- `MPBT.MSG` string-table handling.
- `.MAP` room parsing.
- World room data and travel metadata.
- Combat constants, weapon data, heat, ammo, movement, and damage semantics.

Avoid duplicating server truth in a divergent client-only model.

## Rendering Plan

### Phase 1: Godot Retail-Style Shell

Use Godot scenes and controls to reproduce:

- Login/account flow.
- Character profile.
- Solaris map and Inner Sphere map.
- World room screens.
- ComStar/social panels.
- Mech selection.
- Arena ready room.
- Combat HUD shell using extracted retail assets.

Use the original 640x480 layout as a canonical reference coordinate space, then scale and adapt it for modern resolutions.

### Phase 2: 3D Combat MVP

Build combat as an actual Godot 3D scene:

- Fixed-step simulation timing.
- Server-authoritative player/actor state.
- Mech placeholders or imported low-fidelity meshes.
- Terrain placeholder or imported arena terrain.
- Movement, heading, torso/leg orientation, speed, heat, armor/internal state, weapon fire, projectile/effect events.
- Retail-inspired cockpit/HUD composition.

This phase should prove playability before perfect asset fidelity.

### Phase 3: Retail Asset Fidelity

Implement replaceable Godot import/runtime layers for:

- `3dobj.bin`
- `keyframe.bin`
- terrain `.BIN/.DAT/.PAL`
- indexed palettes
- animation/keyframe data
- original UI and HUD asset containers

If exact behavior requires native code, use C# or GDExtension behind narrow interfaces.

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

Milestones **M0-M7** are now substantially represented in the client. Current forward progress is concentrated in **M8 Retail Fidelity Pass**, with packaging/mobile still following after fidelity and UX polish.

### M0: Godot Project Scaffold

- Create Godot 4 project. **Done**
- Add directory layout for scenes, scripts, assets, addons, docs, and tests. **Done**
- Add project settings for desktop targets. **Initial version done**
- Add local config for connecting to `mpbt-server`. **Done**
- Add placeholder main menu, world scene, and combat scene. **Done**
- Validate the scaffold in the Godot editor and fix any generated import metadata issues.
- Add the first REST/WebSocket health/version check.

### M1: Local Asset Browser

- Load extracted local retail assets from a user-provided asset directory.
- Render UI art, icons, maps, combat HUD pieces, sounds, and music metadata.
- Validate scaling modes and palette assumptions.
- Do not redistribute proprietary assets.

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

### M5: Mech Selection and Viewer

- Mech selection.
- Mech details from `.MEC` and `MPBT.MSG`.
- Weapon/loadout display as server support allows.
- Avoid blocking on dormant 1999 mech-management economics such as buy-ammo/repair/name-mech unless new evidence shows GameStorm used them.

### M6: Arena Ready Room

- Arena entry.
- Side/team selection.
- Status/ready flow.
- Match launch.
- Multi-player staging.

### M7: 3D Combat MVP

- Render Godot 3D arena scene.
- Consume combat snapshots.
- Send movement/input commands.
- Show local and remote actors.
- Show weapon fire, damage, heat, ammo, and match end.
- Keep timing fixed and measured against retail-client observations.

### M8: Retail Fidelity Pass

- Investigate exact terrain/model/keyframe behavior.
- Implement or improve Godot importers for original binary assets.
- Compare side-by-side with retail v1.29 captures.
- Tune camera, movement, weapon effects, fall/recovery timing, and HUD behavior.
- Use the complete retail function/command/helper/subsystem catalogs to remove remaining behavior ambiguity before introducing custom ports or native helpers.
- Progress one bounded parity slice at a time, with `mpbt-server` audited first when the slice changes canonical retail behavior.

### M9: Packaging and Distribution

- Desktop exports for Windows, Linux, and macOS.
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
- Do not build a browser-first client as the primary path unless Godot is later abandoned.

## Open Questions

- How much of `3dobj.bin` and `keyframe.bin` is required for authentic combat visuals?
- Are terrain `.BIN/.DAT/.PAL` files only visual, or do they encode gameplay-relevant collision/height/visibility behavior?
- Which recovered combat/world data layouts should be formalized next to tighten server and client accuracy?
- Which subsystems, if any, justify targeted C#/GDExtension or source-like reconstruction for accuracy or performance?
- Which v1.29 UI surfaces should be faithfully reproduced, and which can be redesigned?
- What asset enhancement policy preserves the retail look while making modern resolutions attractive?
