# MPBT Client / Server Compatibility Plan

## Goal

Develop `mpbt-server` and the modern `mpbt-client` simultaneously without breaking compatibility with the original retail **MPBT v1.29 client from 1999**.

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
- GDScript for fast gameplay/client iteration.
- C# or GDExtension only where useful for shared protocol, asset, or performance-heavy code.
- Godot importers/tools for local retail assets.
- Native desktop exports first: Windows, Linux, macOS.
- Mobile/tablet feasibility later, after desktop combat is stable.

The modern client should not speak ARIES directly as its main protocol. ARIES stays inside the retail compatibility adapter.

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

1. Keep finishing `mpbt-server` against retail v1.29 until the core game contracts are clearer.
2. Scaffold `mpbt-client` as a Godot 4 desktop project:
   - project settings
   - directory layout
   - connection config
   - placeholder world scene
   - placeholder combat scene
3. Add the first modern API client layer:
   - REST health/version request
   - WebSocket connection lifecycle
   - local diagnostics logging
   - clear offline/server-unavailable UI state
4. Build early Godot tools as low-risk companions:
   - asset browser
   - `.MEC` viewer
   - room/map viewer
   - local asset import validation
5. Add REST/WebSocket login, world presence, and chat once the shared server API exists.
6. Add arena ready-room flow.
7. Add combat visualization after the retail combat model stops moving frequently.

## Feature Discipline

Every new server feature should answer two questions:

1. What is the canonical game-state change?
2. How does each client adapter present or submit that change?

If this boundary is maintained, simultaneous development should help. The Godot client will expose server model gaps faster, while the retail v1.29 client keeps the project honest about authenticity.

If this boundary is skipped, simultaneous development will hinder progress because modern features will become tangled with v1.29 packet quirks.
