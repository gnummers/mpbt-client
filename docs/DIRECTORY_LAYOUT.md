# Directory Layout

```text
mpbt-client/
  addons/                  Godot editor/runtime plugins.
  assets/
    icons/                 Redistributable project icons/placeholders.
    original/              Ignored local retail asset extraction output.
    scaled/                Ignored deterministic scaling output.
    enhanced/              Ignored cleaned or AI-upscaled local output.
  config/
    default_client.json    Committed development defaults.
    local.example.json     Template for ignored local overrides.
    local.json             Ignored developer-local override.
  docs/                    Project design and implementation notes.
  scenes/
    combat/                3D combat scene and HUD shell.
    main/                  Startup/menu scene.
    world/                 Solaris/world shell scenes.
  scripts/
    config/                Config loading and settings helpers.
    net/                   REST/WebSocket client code.
    ui/                    Shared UI helpers.
  tests/                   Future automated/unit/integration tests.
```

Keep proprietary retail assets out of git. Commit importers, manifests, generated metadata, and safe placeholders only.
