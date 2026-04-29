# Audio Architecture

## Overview

`AudioManager` is a Godot autoload (last in the chain, after `DiagOverlay`) that manages
background music and sound effects for the MPBT client.

It creates two programmatic audio buses at startup:
- **Music** — background music (BGM), loops automatically
- **SFX** — one-shot sound effects

Both buses send to the **Master** bus, so the Master volume slider controls everything.

## Volume Settings

Volumes are stored in dB in `user://mpbt-client.json` (or `config/default_client.json`):

```json
"audio": {
  "master_db": 0,
  "music_db": -10,
  "sfx_db": 0
}
```

Range: `-40` (near-silent) to `0` (full volume).  Adjusted via the **Audio** section
in the in-game Settings screen.  Changes are live-previewed and reverted on Cancel.

## Tracks and Clips

| Zone   | Track name | Path                          |
|--------|------------|-------------------------------|
| Menus  | `menu`     | `res://assets/audio/bgm/menu.ogg` |
| World  | `world`    | `res://assets/audio/bgm/world.ogg` |
| Arena  | `arena`    | `res://assets/audio/bgm/arena.ogg` |
| Combat | `combat`   | `res://assets/audio/bgm/combat.ogg` |

SFX clips live under `res://assets/audio/sfx/<name>.ogg`.

If a file is absent the call is a no-op — silence is the fallback until assets are
provided.

## Providing Retail Assets

The client does **not** ship audio assets (they are proprietary Kesmai/EA content).
To hear music and sounds, extract your retail MPBT installation and place OGG-encoded
files in `assets/audio/bgm/` and `assets/audio/sfx/`.

### Encoding note

BGM files must be OGG Vorbis.  Looping is forced programmatically on load
(`AudioStreamOggVorbis.loop = true`), so a seamlessly looping encode is recommended
but not strictly required.

If you have WAV/MIDI originals, convert with:
```
ffmpeg -i input.wav -c:a libvorbis -q:a 6 output.ogg
```

## API Reference

```gdscript
AudioManager.play_bgm("combat")     # start BGM track (no-op if file absent)
AudioManager.stop_bgm()             # stop current BGM
AudioManager.play_sfx("ui_click")   # one-shot SFX (no-op if file absent)

AudioManager.set_master_db(-6.0)    # live volume control
AudioManager.set_music_db(-10.0)
AudioManager.set_sfx_db(0.0)

AudioManager.apply_from_config()    # re-read volumes from ClientConfig
```

## Adding New Sounds

1. Place `.ogg` file in `assets/audio/sfx/`.
2. Call `AudioManager.play_sfx("your_name")` where needed.
3. For multi-shot or spatial audio (future), extend `AudioManager` with a player pool
   or `AudioStreamPlayer3D` nodes in the relevant scene.
