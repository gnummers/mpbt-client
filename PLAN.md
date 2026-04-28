# MPBT Client / Server Compatibility Plan

## Goal

Develop `mpbt-server` and the modern `mpbt-client` simultaneously without breaking compatibility with the original retail **MPBT v1.29 client from 1999**.

This is possible and is likely the right long-term architecture, but only if `mpbt-server` keeps a strict boundary between core game/service state and client-specific protocol adapters.

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
- Mech inventory
- Arena staging
- Combat state
- Rankings
- Persistence

The retail v1.29 client receives that state through ARIES frames and v1.29 command builders.

The modern `mpbt-client` receives the same state through a clean REST/WebSocket API.

Neither client should define the core model by itself.

## Development Rule

The retail v1.29 client remains the compatibility oracle for game semantics:

- Room flow
- Mech bay behavior
- Combat packet timing
- SCentEx expectations
- UI-triggered actions
- Retail edge cases

The modern client can improve presentation and usability, but it should not alter the server’s retail-compatible game model.

Quality-of-life changes should be modeled as optional modern views or commands, not as changes to retail behavior.

## Avoid

Do not make the modern client depend on low-level ARIES or v1.29 command surfaces.

`mpbt-client` should not need to know about:

- `Cmd43`
- `Cmd57`
- ARIES frames
- Base-85 frame encoding
- Retail menu packet quirks

Those belong in the retail adapter.

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
```

The retail adapter translates the same canonical state into the fragile v1.29 protocol.

## Suggested Sequence

1. Keep finishing `mpbt-server` against retail v1.29 until the core game contracts are clearer.
2. Start `mpbt-client` early as a low-risk companion:
   - Login
   - Profile
   - Map
   - Room browser
   - Mech viewer
   - Rankings
3. Add modern WebSocket world presence and chat once the shared state model is stable.
4. Add modern arena and combat after the retail combat model stops moving frequently.

## Feature Discipline

Every new server feature should answer two questions:

1. What is the canonical game-state change?
2. How does each client adapter present or submit that change?

If this boundary is maintained, simultaneous development should help. The modern client will expose server model gaps faster, while the retail v1.29 client keeps the project honest about authenticity.

If this boundary is skipped, simultaneous development will hinder progress because modern features will become tangled with v1.29 packet quirks.

