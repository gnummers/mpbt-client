# Local Configuration

The client loads configuration in this order:

1. `res://config/default_client.json`
2. `res://config/local.json`
3. `user://mpbt-client.json`

Later files override earlier files by key. `config/local.json` is ignored by git and is intended for development machines. `user://mpbt-client.json` is for installed builds and resolves to Godot's per-user application data directory.

## Minimal Format

```json
{
  "schema": 1,
  "profile": "local-dev",
  "server": {
    "base_url": "http://127.0.0.1:3000",
    "websocket_url": "ws://127.0.0.1:3000/ws"
  },
  "assets": {
    "retail_path": "C:/Games/MPBT",
    "extracted_path": "C:/MPBT/assets"
  },
  "diagnostics": {
    "enabled": true,
    "log_network": false
  }
}
```

- `server.base_url` — mpbt-web Next.js URL; used by `ServerBridge` for `/api/client-config`.
- `assets.retail_path` — path to a licensed retail MPBT installation root (for raw `.MEC`, terrain, and binary parsers).
- `assets.extracted_path` — path to a pre-organized extracted asset directory with `ui/`, `combat/`, `icons/`, `maps/`, `misc/`, and `scenes/` subdirectories (used by the in-game asset browser).
- Both asset paths may be left blank; features that depend on them will show a configuration prompt.
