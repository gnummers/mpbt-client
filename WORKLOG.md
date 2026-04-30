# MPBT Client Worklog

## 2026-04-29 - Retail fidelity, palette correction, and audio pipeline pass

Goal: keep moving `mpbt-client` toward a close functional/art/audio/UI/gameplay clone of the retail MPBT v1.29 client using the local licensed install/extracted assets in `C:\MPBT`, without distributing proprietary assets on GitHub.

Reference source: `C:\MPBT\mpbt-server\RESEARCH.md`, especially the UI/combat behavior notes, `.MEC` handling, and Cmd68/Cmd70 combat observations.

## Local asset policy

- Do not copy proprietary retail assets into the repo.
- Runtime/local config may point at `C:\MPBT` and `C:\MPBT\assets`.
- Keep committed changes limited to extraction logic, runtime wiring, layout, fallbacks, and docs.

## What changed in this work session

### World / non-combat presentation

- Fixed Mech Bay portrait hint normalization and kept extracted portrait art loading in place.
- Added extracted backdrop art to the arena ready room and fixed scene changes there by deferring `change_scene_to_file(...)`.
- Reworked the Solaris world scene into a much closer retail shell:
  - `FUL*` outer chrome
  - `RAD*` top message console
  - `MOV1` travel shell
  - `MOV2` framed map shell
  - `RECN/RECS/RECE/RECW` room-list framing
  - `DSCN/DSCS/DSCE/DSCW` detail framing
  - `STD0`–`STD4` district thumbnails
  - command bar + quick-action icons (`CSTR`, `OPTN`, `VMEC`, `EXIT`)
- Added coordinate-driven N/E/S/W room browsing and clickable room selection on the Solaris map.
- Wrapped the standings scene in the same retail world-shell chrome/navigation system so it no longer drops back to a bare utility layout.

### Extracted asset pipeline

- Corrected `mw_mpics.dat` palette handling so extracted `C:\MPBT\assets\ui` uses the proper navigation palette.
- Corrected `Combat.dat` palette handling so extracted `C:\MPBT\assets\combat` uses the shared combat palette embedded in `DASH`.
- Regenerated the extracted UI and combat image banks after each fix.

### Audio pipeline

- Stopped relying on raw extracted `.pcm` clips as the primary runtime path.
- Updated `extract_assets.py` to convert the retail PCM sound bank into standard WAV files under `C:\MPBT\assets\sound`.
- Added source fallback so sound extraction uses `C:\MPBT\mpbt-server\sound` in this environment.
- Emitted exact logical WAV aliases for hooked cues:
  - `ui_click.wav`
  - `ui_hover.wav`
  - `weapon_fire.wav`
  - `weapon_hit.wav`
- Updated `AssetRegistry` to prefer decoded formats (`.ogg`/`.wav`/`.mp3`) over raw `.pcm`.
- Updated `AudioManager` so cached streams refresh when the resolved asset path changes.
- Refreshed `docs/AUDIO.md` to describe the WAV-first extracted audio path.

## Current state

- The client now has a solid retail-style world shell, improved standings presentation, palette-correct extracted UI/combat art, and a Godot-friendly extracted SFX pipeline.
- `C:\MPBT\assets\ui` and `C:\MPBT\assets\combat` are confirmed accurate after the palette fixes.
- `C:\MPBT\assets\sound` now contains converted WAV output plus exact logical aliases for the currently hooked UI/combat SFX names.

## Validation slice used during this session

- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --quit-after 2`
- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --scene res://scenes/world/world.tscn --quit-after 2`
- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --scene res://scenes/standings/standings.tscn --quit-after 2`
- direct resolver checks confirming:
  - `ui_click` -> `C:\MPBT\assets\sound\ui_click.wav`
  - `ui_hover` -> `C:\MPBT\assets\sound\ui_hover.wav`
  - `weapon_fire` -> `C:\MPBT\assets\sound\weapon_fire.wav`
  - `weapon_hit` -> `C:\MPBT\assets\sound\weapon_hit.wav`

## Known worktree state

- The current local worktree includes intentional scene/script changes in:
  - `scenes/world/*`
  - `scenes/standings/*`
  - `scenes/arena/*`
  - `scenes/mech/*`
  - `scenes/combat/*`
  - `scripts/world/solaris_map.gd`
  - `scripts/assets/asset_registry.gd`
  - `scripts/audio/audio_manager.gd`
  - `docs/AUDIO.md`
- Do not revert those local changes while continuing fidelity work.

## Next logical step

Apply the same screenshot-driven retail shell pass to the remaining bare non-combat scenes, starting with **ComStar** and then **Settings**. That continues the highest-confidence visual/UI work already established in World and Standings, reuses the known-good extracted shell assets, and keeps momentum on non-combat retail fidelity before returning to deeper combat posture/animation work.
