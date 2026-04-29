# Audio Architecture

## Overview

`AudioManager` is a Godot autoload (last in the chain, after `DiagOverlay`) that manages
background music and sound effects for the MPBT client.

It creates two programmatic audio buses at startup:
- **Music** — background music (BGM), loops automatically
- **SFX** — one-shot sound effects, played through a small player pool so cues can overlap

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

| Zone   | Track name | Bundled fallback path |
|--------|------------|-----------------------|
| Menus  | `menu`     | `res://assets/audio/bgm/menu.ogg` |
| World  | `world`    | `res://assets/audio/bgm/world.ogg` |
| Arena  | `arena`    | `res://assets/audio/bgm/arena.ogg` |
| Combat | `combat`   | `res://assets/audio/bgm/combat.ogg` |

SFX clips live under `res://assets/audio/sfx/<name>.ogg`.

If a bundled file is absent, the configured `assets.extracted_path` is searched under:

- BGM (`.ogg`, `.wav`, `.mp3`): `audio/bgm/`, `audio/music/`, `music/`, `bgm/`
- SFX (`.ogg`, `.wav`, `.mp3`, `.pcm`): `audio/sfx/`, `audio/sound/`, `audio/sounds/`, `sfx/`, `sound/`, `sounds/`

The resolver prefers files whose base name matches the requested track or clip.
If nothing is found the call is a no-op.

Current SFX hooks:

| Event | Clip name |
|-------|-----------|
| UI button click | `ui_click` |
| UI button hover | `ui_hover` |
| Combat weapon fire | weapon-class-specific retail cue (`lasrfire`, `ppcfire`, `acanfire`, `mislfire`, `mgunfire`, `flamer`) |
| Combat hit | impact-class-specific retail cue (`hit*`, `expld*`, `aexpld`, `collide`, `blwpart`) |
| Jump start | `jump` |
| Jump landing | `landing` |
| Ground movement | speed-scaled `engine*` plus cadence `step` |
| Turn-in-place / torso actuator feel | `actuator`, `torso` |
| Stand up from downed posture | `getup` |
| Radar range step | `radar` |
| Target lock / target cycle | `locked` |
| Remote weapon fire | spatialized fire cue at the attacking mech |
| Remote weapon impact | spatialized impact cue at the target / hit point |
| Match victory | `victory` |
| Match defeat | `defeat` |

When a requested logical SFX name has no exact filename match, the client also tries
common retail-style candidates. Current fallback groups:

| Logical clip | Retail filename candidates |
|--------------|----------------------------|
| `ui_click` | `button`, `button2`, `gclick`, `lever` |
| `ui_hover` | `button2`, `gclick`, `lever`, `radar` |
| `weapon_fire` | `lasrfire`, `mgunfire`, `mislfire`, `ppcfire`, `acanfire`, `flamer` |
| `weapon_hit` | `hit1`, `hit2`, `hit3`, `expld1`, `expld2`, `expld3`, `expld4`, `aexpld`, `collide`, `blwpart` |

## Providing Retail Assets

The client does **not** ship audio assets (they are proprietary Kesmai/EA content).
To hear music and sounds, extract your retail MPBT installation, convert the audio
to OGG/WAV/MP3 where needed, and place it in the configured extracted asset path.
Project-local `assets/audio/bgm/` and `assets/audio/sfx/` remain supported for
open-licensed placeholders or private local testing files.

### Encoding note

BGM files must be OGG Vorbis.  Looping is forced programmatically on load
(`AudioStreamOggVorbis.loop = true`), so a seamlessly looping encode is recommended
but not strictly required.

If you have WAV/MIDI originals, convert with:
```
ffmpeg -i input.wav -c:a libvorbis -q:a 6 output.ogg
```

Retail `.pcm` SFX clips are now loaded directly from extracted assets using the current
best guess for the KSOUND-era format:

- unsigned 8-bit PCM
- mono
- `11025 Hz` mix rate

That guess is good enough for local testing and hook mapping, but it is still based on
reverse-engineering evidence rather than a fully documented retail format spec. If you
convert the clips manually, keep the retail base filename where practical so the same
fallback resolver can find them.

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
