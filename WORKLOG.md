# MPBT Client Worklog

## 2026-04-29 - Retail v1.29 client clone work

Goal: keep moving `mpbt-client` toward a close functional/art/audio/UI/gameplay clone of the v1.29 retail MPBT client using the local licensed install/extracted assets in `C:\MPBT`, without distributing proprietary assets on GitHub.

Reference source: `C:\MPBT\mpbt-server\RESEARCH.md`, especially the `.MEC` format, combat fire gate, ammo, heat, jump-jet, projectile/effect, radar, and Cmd65/Cmd68/Cmd70 notes.

Local asset policy:
- Do not copy proprietary retail assets into the repo.
- Runtime/local config can point at `C:\MPBT` and `C:\MPBT\assets`.
- `.gitignore` was expanded to ignore accidentally extracted proprietary folders/assets under repo-local `assets/`.

What changed in this work session:
- Added local retail asset lookup support in `scripts/assets/asset_registry.gd` for recursive image/audio lookup.
- Updated `scripts/audio/audio_manager.gd` to load local BGM/SFX from configured extracted retail paths and hook global UI click/hover SFX.
- Updated main menu to load local extracted retail-like title/menu art when available.
- Updated Solaris map rendering to use local extracted map art and better offline marker positions.
- Added `scripts/assets/mec_parser.gd`:
  - MPBT.MSG variant id map.
  - v1.29 `.MEC` XOR decrypt.
  - speed, tonnage, jump jets, heat sinks, armor-like values, weapon ids, mount refs, ammo bins.
  - recovered retail weapon names, short names, ammo, damage, heat, cooldown, range, internal structure table.
- Updated mech select to use local `.MEC` roster when server `/mechs` is unavailable.
- Expanded combat runtime substantially:
  - `.MEC`-based speed, weapon list, mount refs, ammo bins, internal state, heat sinks, jump jets.
  - Selected weapon HUD, mouse-wheel and number-key weapon selection.
  - Per-slot retail-style cooldowns.
  - Ammo consumption/repointing by ammo bin type.
  - Mount/internal-state fire gate with `LOST` / `MNT` HUD states.
  - Heat accumulator, sink-scaled cooling, shutdown blocking, heat metadata in WS messages.
  - Jump-jet gate using actual `.MEC` jump count, fuel `0x78`, fuel > `0x32` gate, action `4` start and action `6` landing metadata.
  - Code-generated Cmd68-like weapon effects: beams, projectiles, missile volleys, impact flashes.
  - Combat radar/target HUD using recovered radar range cycle `50 / 100 / 300 / 800 / 2500`, target range/bearing/HP, and selected-weapon range band.
- Added `scripts/ui/combat_radar.gd`.
- Added `jump_jet` and `radar_range` input actions plus settings rebind rows.
- Added mobile touch `JUMP` button.

Validation last run:
- `godot --headless --quit`
- `godot --headless --editor --quit`
- `godot --headless --scene res://scenes/combat/combat.tscn --quit`
- `godot --headless --scene res://scenes/settings/settings.tscn --quit`
- `git diff --check`

Expected validation note: launching combat scene directly logs `CombatScene: no pending_match - returning to menu`; this is expected.

Known worktree state:
- Many Godot-generated `.uid` files are untracked. Leave them alone unless deciding a repo policy for Godot UID files.
- `scripts/assets/mec_parser.gd` and `scripts/ui/combat_radar.gd` are new untracked source files and should be included if committing this work.
- `scenes/assets/asset_browser.gd` was already dirty from earlier category ordering work; do not revert unrelated user changes.

Next logical steps:
- Add client-side combat animation/posture approximations from `Cmd70` research: remote airborne/jump helper, collapse/fall states, and local target/impact presentation without over-inventing unsupported server semantics.
- Add richer incoming effect handling if/when `mpbt-server` emits Cmd68-like WS fields (`source`, `weaponSlot`, `weaponTypeId`, `target`, `targetAttach`, `impactX/Y/Z`).
- Improve combat cockpit/HUD styling toward retail once more local UI art is identified in `C:\MPBT\assets`, still without committing proprietary assets.
- Consider server compatibility work separately: current simple `combat-ws.ts` ignores `combat_action` and most rich `combat_fire` fields.

## Copilot Handoff Prompt

Continue work in `C:\MPBT\mpbt-client`. The objective is to make the Godot client behave and look as close as possible to the v1.29 retail MPBT client, using local licensed/extracted data in `C:\MPBT` and `C:\MPBT\assets`, but never committing proprietary retail assets.

Start by reading:
- `WORKLOG.md`
- `C:\MPBT\mpbt-server\RESEARCH.md`
- `scripts/assets/mec_parser.gd`
- `scenes/combat/combat.gd`
- `scenes/combat/combat.tscn`
- `scripts/ui/combat_radar.gd`

Current implementation already covers local retail asset lookup, audio fallback, `.MEC` parsing, offline mech roster, combat speed/weapon/ammo/cooldown/mount/heat/jump/radar/effect behavior. Pick the next narrow retail-fidelity slice from `RESEARCH.md`. A good next step is client-side combat animation/posture approximation from Cmd70 research: remote jump/airborne state, collapse/fall presentation, landing/reset state, and matching HUD/status feedback. Keep edits scoped, use existing Godot patterns, do not copy proprietary assets, and validate with:

```powershell
godot --headless --quit
godot --headless --editor --quit
godot --headless --scene res://scenes/combat/combat.tscn --quit
godot --headless --scene res://scenes/settings/settings.tscn --quit
git diff --check
```

The direct combat scene warning about missing `pending_match` is expected.
