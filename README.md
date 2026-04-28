# MPBT Client

Modern cross-platform client for **Multiplayer BattleTech: Solaris**, designed to work alongside `mpbt-server` while preserving compatibility with the original retail **MPBT v1.29 client from 1999**.

This repository is currently in the planning/scaffold stage. See [ROADMAP.md](ROADMAP.md) for the product and technical roadmap, and [PLAN.md](PLAN.md) for the client/server compatibility strategy.

## Goals

- Build a modern client for Windows, macOS, Linux, and eventually mobile.
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
- Mech inventory
- Arena ready rooms
- Combat state
- Rankings and persistence

The server should expose that state through two adapters:

```text
core game/server logic
  -> retail v1.29 ARIES adapter
  -> modern mpbt-client REST/WebSocket adapter
```

The original v1.29 client should continue to use ARIES and retail command builders. The modern client should use a clean REST/WebSocket API and should not depend on low-level retail packet details such as `Cmd43`, `Cmd57`, base-85 frames, or ARIES transport quirks.

## Recommended Stack

- **TypeScript** for the application code.
- **PixiJS** for 2D GPU rendering, UI, maps, sprites, and cockpit/HUD surfaces.
- **Tauri 2** for native desktop packaging and future mobile feasibility.
- **REST + WebSocket** API for communication with `mpbt-server`.
- **Three.js or a native/WASM renderer core** only if exact combat/3D fidelity requires it.

This stack aligns with the existing TypeScript `mpbt-server` codebase and keeps asset parsing, game-state schemas, and protocol-adapter work easier to share.

## Fidelity Strategy

The target is not a literal Win32/DirectDraw clone. The target is a modern client that feels close to the retail v1.29 experience while being practical to maintain.

The retail client remains the compatibility oracle for:

- World flow
- Mech bay behavior
- Arena staging
- Combat pacing
- SCentEx/ranking semantics
- UI-triggered game actions

Modern UI may improve presentation and usability, but it should not redefine the core game model.

## Rendering Strategy

Use the original 640x480 retail layout as the canonical coordinate system, then scale and adapt it for modern displays.

Initial rendering should focus on:

- Login/account flow
- Character profile
- Solaris and Inner Sphere maps
- World room screens
- ComStar/social panels
- Mech selection and mech bay
- Arena ready room
- Combat HUD shell

Combat can start with a pragmatic 2D/2.5D renderer. If exact fidelity demands it, introduce a replaceable C++ or Rust renderer module compiled to WASM/native.

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

1. Project scaffold: TypeScript, PixiJS, Tauri, lint/test/build tooling.
2. Asset browser: load extracted local assets and validate scaling/palette behavior.
3. API contract: define REST/WebSocket schemas with `mpbt-server`.
4. Account and character flow.
5. Solaris world shell: map, rooms, presence, chat, ComStar, travel.
6. Mech management.
7. Arena ready room.
8. Combat MVP.
9. Retail fidelity pass.
10. Packaging and distribution.

## Non-Goals

- Do not replace `mpbt-server` retail v1.29 compatibility.
- Do not make the modern client speak ARIES directly as its main protocol.
- Do not redistribute proprietary assets.
- Do not make AI-upscaled assets mandatory.
- Do not hardcode gameplay behavior in the client when the server should own it.

## Current Status

Planning repository. No runnable client scaffold has been created yet.

The next practical step is to scaffold the TypeScript/PixiJS/Tauri application and define a minimal local configuration format for connecting to a development `mpbt-server`.

