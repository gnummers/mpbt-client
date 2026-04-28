# MPBT Server — REST API

Base URL: `http://<host>:3002` (default `http://127.0.0.1:3002`)

All endpoints respond with `Content-Type: application/json` and permissive
CORS headers (`Access-Control-Allow-Origin: *`) for local development.

---

## Endpoints

### `GET /health`

Health and version check.

**Response 200**
```json
{
  "ok": true,
  "version": "1.29.1",
  "name": "mpbt-server"
}
```

---

### `GET /world/rooms`

Returns the full room list parsed from the proprietary `SOLARIS.MAP` binary.

When the file is not found on the server (e.g. proprietary assets not
installed), `rooms` is empty and `source_available` is `false`.

**Response 200**
```json
{
  "ok": true,
  "source_available": true,
  "rooms": [
    {
      "roomId": 146,
      "name": "Starport",
      "flags": 0,
      "centreX": 55.0,
      "centreY": 346.0,
      "sceneIndex": 0,
      "description": "The Starport serves as the main transit hub for ..."
    }
  ]
}
```

**Room fields**

| Field | Type | Description |
|---|---|---|
| `roomId` | `number` | Retail room ID (1–6 sector meta-rooms; 146–171 named locations) |
| `name` | `string` | Room display name from SOLARIS.MAP |
| `flags` | `number` | Raw flags word; low byte = district index (0=IZ … 5=Black Hills) |
| `centreX` | `number` | X pixel centre on the Solaris background image |
| `centreY` | `number` | Y pixel centre on the Solaris background image |
| `sceneIndex` | `number` | Parse order index (0-based) |
| `description` | `string` | Room description text from SOLARIS.MAP |

---

## WebSocket  *(deferred — M3)*

A WebSocket endpoint at `/ws` is planned for M3.  When implemented it will
use a simple JSON envelope:

```json
{ "type": "<event>", "payload": {} }
```

### Server → Client events

| `type` | Payload | Notes |
|---|---|---|
| `ping` | `{}` | Keepalive; client must reply with `pong` |
| `world.presence_update` | `{ roomId, players }` | Room population changed |
| `world.chat_message` | `{ roomId, from, text }` | In-room chat |

### Client → Server events

| `type` | Payload | Notes |
|---|---|---|
| `pong` | `{}` | Reply to `ping` |
| `world.travel` | `{ targetRoomId }` | Request room transition |
| `world.chat_send` | `{ text }` | Send chat message to current room |
