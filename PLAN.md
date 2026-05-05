# MPBT Client / Server Compatibility Plan

## Goal

Develop `mpbt-server` and the modern `mpbt-client` simultaneously without breaking compatibility with the original retail **MPBT v1.29 client from 1999**.

## Current Status Snapshot

The compatibility model in this document still holds, but the client is now well past the initial scaffold stage. Current local work already includes:

- Login/registration and character flow
- Solaris world travel shell with presence/chat/travel
- Mech Bay, arena ready room, standings, ComStar, settings, and 3D combat scenes
- Screenshot-driven retail-fidelity passes for extracted UI/combat/world art and retail audio integration
- A fully imported live Ghidra function catalog for `MPBTWIN.EXE` with **1290** named functions and no remaining `FUN_*` entries in the current project

The near-term client-forward path is now retail fidelity, UX polish, and RE-guided behavior closure rather than basic scaffolding. The next highest-confidence step is to keep extending the retail world-shell chrome and navigation system into the remaining bare non-combat scenes, starting with **ComStar** and then **Settings**, before returning to deeper combat posture/animation fidelity work. The completed function/command/helper/subsystem research catalogs now give the project enough behavioral coverage to keep pushing the modern client directly instead of pausing for a speculative full C++ reconstruction.

The modern client will move forward as a **Godot 4** project. This gives the project a first-class 3D engine for the main combat scene while still allowing `mpbt-server` to preserve the retail ARIES protocol path for `MPBTWIN.EXE`.

## Architecture

The server should be shaped like this:

```text
core game/server logic
  -> retail v1.29 ARIES adapter
  -> modern mpbt-client REST/WebSocket adapter
```

`mpbt-server` should own the canonical state for:

- Accounts
- Characters
- Rooms
- Travel
- ComStar messages
- Mech selection and combat loadouts
- Arena staging
- Combat state
- Rankings
- Persistence

The retail v1.29 client receives that state through ARIES frames and v1.29 command builders.

The modern Godot client receives the same state through a clean REST/WebSocket API.

Neither client should define the core model by itself.

## Godot 4 Client Direction

Use Godot 4 as the primary client runtime:

- Godot scenes for world UI, arena ready rooms, cockpit/HUD, and combat.
- C# as the preferred language for newly ported parity-critical client logic, shared model/protocol surfaces, and importer/runtime helpers as the client matures.
- GDScript remains acceptable for existing scene glue and fast iteration, but new behavior ports should bias toward C# when they define durable client contracts.
- GDExtension only where C# is still insufficient for performance-heavy or low-level runtime work.
- Godot importers/tools for local retail assets.
- Native desktop exports first: Windows, Linux, macOS.
- Mobile/tablet feasibility later, after desktop combat is stable.

The modern client should not speak ARIES directly as its main protocol. ARIES stays inside the retail compatibility adapter.

## Reconstruction Stance

A near-retail C++ rebuild may still have value as an internal research harness for especially ambiguous subsystems, but it is no longer the primary implementation path.

The main path remains a modern **Godot 4** client backed by the recovered retail behavior catalog. If a subsystem still cannot be reproduced accurately enough from the mapped functions, recovered helpers, traces, and assets, do a **targeted** source-like reconstruction for that subsystem only.

## Porting Rule

Recovered retail behavior should be ported in **bounded slices**, not as an unfocused whole-project sweep.

For each slice:

1. Audit `mpbt-server` first when the recovered behavior affects canonical state, protocol semantics, validation, ordering, or timing shared by both clients.
2. Patch `mpbt-client` only when the difference is presentation, local UI/input flow, shell transitions, sounds, or other client-local behavior.
3. Patch both repos when the retail behavior spans a server contract plus a client expectation.

This keeps server truth authoritative and prevents UI fidelity work from masking incorrect server semantics.

## Development Rule

The retail v1.29 client remains the compatibility oracle for game semantics:

- Room flow
- Mech selection behavior
- Arena ready-room behavior
- Combat timing and result flow
- SCentEx expectations
- UI-triggered actions
- Retail edge cases

The Godot client can improve presentation and usability, but it should not alter the server’s retail-compatible game model.

Quality-of-life changes should be modeled as optional modern views or commands, not as changes to retail behavior.

## Avoid

Do not make the Godot client depend on low-level ARIES or v1.29 command surfaces.

`mpbt-client` should not need to know about:

- `Cmd43`
- `Cmd57`
- ARIES frames
- Base-85 frame encoding
- Retail menu packet quirks

Those belong in the retail adapter.

Do not use the Godot client as a reason to weaken v1.29 compatibility in `mpbt-server`.

## Modern API Shape

The modern client should use high-level endpoints and messages such as:

```text
GET  /character
GET  /world/rooms
POST /travel
POST /comstar/messages
POST /arena/ready

WS world.presence
WS world.chat
WS combat.input
WS combat.snapshot
WS combat.event
```

The retail adapter translates the same canonical state into the fragile v1.29 protocol.

## Suggested Sequence

1. Keep `mpbt-server` as the canonical game-state owner while preserving the retail v1.29 ARIES adapter.
2. Execute parity work as bounded retail slices, starting with a world/non-combat surface that already exists in both repos (`ComStar` first, then `Settings`).
3. Audit the selected slice against the recovered retail command/helper/subsystem catalogs and patch `mpbt-server` first wherever canonical behavior differs.
4. Port the corresponding client-facing behavior into `mpbt-client` using Godot with a C# bias for new parity-critical logic, while continuing to use the original retail extracted assets locally for shell chrome, sounds, and other retail presentation surfaces.
5. Return to deeper combat posture/animation, HUD, camera, and terrain/model/keyframe fidelity once the surrounding shell/UI work is solid.
6. Only do targeted source-like reconstructions or C#/native helper ports when recovered behavior alone is still insufficient for retail-accurate implementation.

## Feature Discipline

Every new server feature should answer two questions:

1. What is the canonical game-state change?
2. How does each client adapter present or submit that change?

If this boundary is maintained, simultaneous development should help. The Godot client will expose server model gaps faster, while the retail v1.29 client keeps the project honest about authenticity.

If this boundary is skipped, simultaneous development will hinder progress because modern features will become tangled with v1.29 packet quirks.
