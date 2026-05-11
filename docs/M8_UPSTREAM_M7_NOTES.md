# M8 upstream notes: mpbt-legacy M7 -> mpbt-client

This note maps the M7 outputs from `mpbt-legacy` into client-owned M8 follow-ups without asserting speculative full parsers.

## Upstreamed M7 outputs

1. **Deterministic replay suite (M7 evidence source)**
   - Upstream use in `mpbt-client`: keep effect/render investigations deterministic, fixture-driven, and replay-safe.
2. **Retail v1.29 comparison notes**
   - Source: `mpbt-legacy/docs/M7_RETAIL_V129_COMPARISON_NOTES.md`.
   - Upstream use in `mpbt-client`: focus active client-local frontier `cmd68-effect-consumers`.
3. **Repeatable binary probe scaffolds (`3dobj.bin`, `keyframe.bin`, terrain)**
   - Upstream use in `mpbt-client`: lightweight metadata probe utility for renderer/data research surfaces.

## Client-owned M8 follow-up mapping

| M7 finding | Client-owned M8 follow-up |
|---|---|
| `cmd68-effect-consumers` remains active with retail anchors for spawn geometry and impact cue handling. | Instrument effect presentation surfaces: projectile/effect spawn placement, timing, and cue-routing hooks in Godot combat scene/HUD pathways. |
| Cmd68 retention is deterministic in replay evidence but downstream consumers are open. | Keep local consumers hypothesis-scoped: add probe/test surfaces that log stable metadata before adding runtime behavior. |
| 3dobj/keyframe/terrain format confidence is still bounded. | Use binary probes for **metadata only** (headers/sections/record-size hypotheses), explicitly not full decoding. |

## Immediate M8 investigation surfaces (client-local)

- Cmd68 consumer candidates in presentation/effects:
  - effect spawn transform construction
  - impact cue dispatch (visual/audio timing gates)
  - HUD-facing distance/range-band readouts tied to local presentation only
- Data investigation surfaces:
  - `3dobj.bin` section-table/stride hypotheses for mesh import scaffolds
  - `keyframe.bin` section/stride hypotheses for animation timing scaffolds
  - terrain chunk-table vs height-grid structural hypotheses for arena rendering research

## Guardrails

- No speculative full parsers in M8 probe scope.
- Keep hypothesis framing explicit in metadata output.
- Preserve deterministic output formatting so repeated probe runs are comparable in CI/headless smoke runs.
