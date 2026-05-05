# MPBT Client Worklog

## 2026-05-03 - Server RESEARCH.md catalog-alignment handoff

Goal: carry the completed `mpbt-client/scripts/research` v1.29 retail findings back into
`mpbt-server/RESEARCH.md` so server-first parity work has the current client-catalog
oracle before the next bounded implementation slice.

## Current cross-repo state

- Client repo: `C:\MPBT\mpbt-client`
- Server repo: `C:\MPBT\mpbt-server`
- It is OK to work on dirty files. Treat the current modified files as intentional
  in-progress work and do not revert them just because the worktree is dirty.
- Do not delete or clean up untracked server log files unless explicitly asked.

Current dirty state observed at handoff:

- `mpbt-client`:
  - `PLAN.md`
  - `README.md`
  - `ROADMAP.md`
  - `WORKLOG.md`
  - `scenes/comstar/comstar.gd`
  - `scripts/net/comstar_client.gd`
- `mpbt-server`:
  - `RESEARCH.md`
  - `src/api.ts`
  - `src/db/messages.ts`
  - untracked `mpbt-server.err.log`
  - untracked `mpbt-server.out.log`

## What changed in the RESEARCH.md pass

- Reconciled the v1.29 world command quick table against the completed client
  function/helper catalogs, including concrete corrections for:
  - `World_Cmd08_MenuClose_v129`
  - `World_Cmd10_ParseCachedNamedEntryList_v129`
  - `World_Cmd11_UpdateCachedNamedEntryText_v129`
  - `World_Cmd12_UpdateCachedNamedEntryState_v129`
  - `World_Cmd27_AlternateMechChooser_v129`
- Added an explicit version-scope warning that older Cmd10/Cmd11/Cmd12 room-presence
  notes are v1.23/M4-scoped and should not be mechanically applied to v1.29 without
  a compatibility bridge or fresh packet proof.
- Added v1.29 shell framing/FIFO notes:
  - `Shell_ResetOutboundCommandBuffer_v129`
  - `Shell_AppendOutboundCommandOpcode_v129`
  - `Shell_FlushOutboundCommandBuffer_v129`
  - `Shell_ResetHeartbeatState_v129`
  - `Shell_SelectInboundCommandTable_v129`
  - `Shell_HandlePreVersionBannerLine_v129`
  - `Shell_HandlePostVersionBannerLine_v129`
  - queued inbound shell-line FIFO helpers and ownership/reset behavior
- Added low-level frame encode/decode helper notes for:
  - `Frame_DecodeArg_v129`
  - `Frame_DecodeType1Arg_v129`
  - `Frame_DecodeByteArg_v129`
  - `Frame_DecodeStringSpanArg_v129`
  - `Frame_DecodeType1StringSpanArg_v129`
  - `Frame_DecodeStringArg_v129`
  - `Frame_DecodeType1StringArg_v129`
  - `Frame_EncodeArg_v129`
  - `Frame_EncodeType1Arg_v129`
  - `Frame_EncodeByteArg_v129`
  - `Frame_EncodeByteCountedStringArg_v129`
  - `Frame_EncodeType1StringArg_v129`
- Added protocol-adjacent helper notes for:
  - `World_QueueTransientNotice_v129` / `World_ResetTransientNoticeQueue_v129`
    as an ordered 12-slot transient notice queue, not last-one-wins toast state
  - `World_RemoveShortcutBindingAtIndex_v129` as local frontend config removal,
    not server-owned state unless a future packet path proves otherwise
  - `World_MessageView_HandleInput_v129` and
    `World_MessageView_DispatchNormalizedKey_v129` in the ComStar read/reply path
  - `Combat_NoOpMissedPacketLog_v129` as a compiled-out diagnostic sink, not an
    active resend/recovery protocol
- Prior passes in the same `RESEARCH.md` dirty file also documented:
  - corrected Cmd36/Cmd37 ComStar read/compose behavior
  - hidden `[p......]` / `[r......]` reply-prefix tags
  - five-character ComStar ID parsing/formatting
  - Settings/options registry and shortcut-binding round trip
  - startup guard/diagnostic surfaces
  - v1.29 outbound client helper crosswalks
  - Cmd72 local actor decode helper details

## Validation used

- `git -C C:\MPBT\mpbt-server diff --check -- RESEARCH.md`
  - passed with only Git's existing LF-to-CRLF warning
- Catalog sweeps from `mpbt-client` confirmed:
  - no missing named `World_Cmd*` entries from `retail_function_catalog.gd`
  - no missing named `Combat_Cmd*` entries from `retail_function_catalog.gd`
  - remaining unmatched helper/function names are mostly local rendering, HUD,
    joystick, modal, registry plumbing, bitmap/frame presentation, or utility
    helpers rather than obvious server-facing protocol updates

## Next logical step

Continue with the server-first rule. The current bounded ComStar slice is mostly
documented and partially implemented, but still needs live/manual verification for:

- reply flow
- dismiss/read consumption
- ComStar-ID targeting
- hidden reply-prefix tag preservation across server REST, Godot display, and reply submit

If ComStar validation exposes a canonical state/protocol bug, patch `mpbt-server`
first, then update `mpbt-client`. After ComStar is solid, the next bounded slice is
Settings, using the new Settings/options section in `mpbt-server/RESEARCH.md` as the
starting oracle.

## Copilot pickup prompt

You are picking up work across two local repos:

- Client repo: `C:\MPBT\mpbt-client`
- Server repo: `C:\MPBT\mpbt-server`

It is OK to work on dirty files. The current modified files are intentional
in-progress work. Do not revert dirty files just because they are dirty. Do not delete
or clean up untracked server log files unless explicitly asked.

Project direction:

- Primary path is the modern Godot client.
- Retail research catalogs are the behavior oracle.
- Parity work should happen in bounded slices.
- Use the server-first rule: audit/patch `mpbt-server` first when recovered retail
  behavior changes canonical state, protocol semantics, validation, ordering, or
  timing; then patch `mpbt-client` for shell/UI/input/presentation expectations.
- Use original retail extracted assets locally for retail-facing presentation work,
  but do not distribute proprietary assets on GitHub.
- C# is preferred for new long-lived parity-critical client logic once client-side
  C# scaffolding exists; this repo currently still has no C# project scaffold, so
  current client work is in GDScript.

Current dirty files:

- `mpbt-client`: `PLAN.md`, `README.md`, `ROADMAP.md`, `WORKLOG.md`,
  `scenes/comstar/comstar.gd`, `scripts/net/comstar_client.gd`
- `mpbt-server`: `RESEARCH.md`, `src/api.ts`, `src/db/messages.ts`,
  untracked `mpbt-server.err.log`, untracked `mpbt-server.out.log`

Recent completed work:

1. `mpbt-server/RESEARCH.md` was updated from `mpbt-client/scripts/research` so the
   v1.29 named client catalogs are reflected in the server research oracle.
2. The v1.29 world command table now includes corrected names/addresses for Cmd8,
   Cmd10, Cmd11, Cmd12, Cmd27, plus earlier corrected ComStar/map/list/no-op rows.
3. The doc now warns that older Cmd10/Cmd11/Cmd12 room-presence semantics are
   v1.23/M4-scoped and should not be applied to v1.29 without a compatibility bridge
   or new packet proof.
4. The doc now includes shell framing/FIFO helpers, frame encode/decode helpers,
   transient notice queue behavior, shortcut local removal behavior, ComStar
   message-view input names, and the compiled-out combat missed-packet diagnostic sink.
5. The existing ComStar REST/Godot slice already moved modern ComStar toward retail:
   REST uses the retail messages table, `{ to, body }`, ComStar ID targeting, saved
   unread semantics, and the Godot scene consumes retail-shaped inbox rows with
   reply-prefix tag handling and paged read-message input.

Validation already run:

- `git -C C:\MPBT\mpbt-server diff --check -- RESEARCH.md`
  passed with only Git's LF-to-CRLF warning.
- Earlier ComStar client validation:
  - `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --scene res://scenes/comstar/comstar.tscn --quit-after 2`
  - `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --quit-after 2`
- Earlier server validation:
  - `npm --prefix C:\MPBT\mpbt-server run build`

Your task:

- Do not restart from scratch.
- Continue from the dirty state.
- First inspect the current ComStar implementation and `mpbt-server/RESEARCH.md`
  notes around Cmd36/Cmd37/message helpers.
- Manually or locally validate the ComStar slice if practical:
  - reply flow
  - dismiss/read consumption
  - ComStar-ID targeting
  - hidden `[p......]` / `[r......]` tag preservation
- If validation finds protocol/canonical-state issues, patch `mpbt-server` first,
  then patch `mpbt-client`.
- If ComStar is solid, move to the next bounded slice: Settings. Start from the
  `Retail Settings / Options Surface` section in `mpbt-server/RESEARCH.md` and
  implement the smallest useful retail-accurate Godot Settings slice.

## 2026-05-02 - Bounded ComStar retail-parity slice across client and server

Goal: start the first bounded retail-parity slice after completing the `MPBTWIN.EXE` function map, using ComStar as the initial server-first behavior audit and Godot client port surface.

## What changed in this work session

### Planning / project direction

- Updated the project strategy docs so parity work now follows a bounded-slice rule:
  - audit `mpbt-server` first when recovered retail behavior changes canonical state, protocol semantics, validation, ordering, or timing
  - patch `mpbt-client` for the corresponding shell/UI/input/presentation expectations
  - keep using the original retail extracted assets locally for retail-facing presentation work
- Clarified the client direction further:
  - Godot remains the main client runtime
  - C# is the preferred destination for new long-lived parity-critical client logic once client-side C# scaffolding exists
  - this first ComStar slice still landed in the existing GDScript layer because the project does not yet have a C# project scaffold

### Server-side ComStar parity work (`mpbt-server`)

- Stopped treating the modern `/comstar` REST API as a separate mailbox model backed by `comstar_modern`.
- Rewired the modern ComStar REST endpoints onto the retail-oriented `messages` table so the server uses the same canonical ComStar persistence semantics already used by the ARIES/world path.
- Aligned the REST inbox and unread count to **saved unread** terminal messages instead of the newer subject/body mailbox model.
- Added list/query helpers in `src/db/messages.ts` for:
  - saved unread inbox listing
  - sender display-name join for the modern client
  - recipient-owned mark-read by message id
- Updated `src/api.ts` so:
  - `GET /comstar` returns retail-shaped rows with visible body text stripped from the stored retail `"ComStar message from <name>\\..."` payload
  - each row now includes `fromComstarCode`, `replyTargetId`, and a retail-style preview string
  - `GET /comstar/unread` counts saved unread retail messages
  - `POST /comstar` now accepts `{ to, body }` rather than `{ to, subject, body }`
  - the `to` field resolves either case-insensitive display name or the retail five-character ComStar ID code
  - outbound modern ComStar messages are normalized into the retail body-only delivery format through the existing server helper path
  - successful REST sends immediately mark the stored retail message as saved for terminal retrieval
  - `PATCH /comstar/:id/read` and `DELETE /comstar/:id` now both map onto the retail-style consume/dismiss behavior for saved unread messages

### Client-side ComStar parity work (`mpbt-client`)

- Updated `scripts/net/comstar_client.gd` to send retail-style compose payloads (`to` + `body`) instead of the older subject/body payload.
- Updated `scenes/comstar/comstar.gd` to consume the retail-shaped REST inbox:
  - inbox rows now show sender name + retail five-character ComStar code + body preview
  - detail pane now shows sender and ComStar ID instead of a synthetic subject line
  - reply uses the sender ComStar code when available
  - subject-based compose behavior is hidden from the active UX
  - the visible delete action is hidden because the first parity pass treats message consumption as the meaningful retail action
  - reading a message removes it from the waiting inbox once the server marks it read
  - WebSocket `comstar_new_message` now refreshes the waiting inbox when the active player is the recipient
- The ComStar scene continues using the extracted retail shell art already wired into the scene (`FUL*`, `RAD*`, `REC*`, `DSC*`, quick-bar art).

## Current state

- The first bounded retail-parity slice is now in motion, and ComStar is the current proving ground for the server-first workflow.
- `mpbt-server` and `mpbt-client` both have intentional uncommitted work:
  - `mpbt-client`: `PLAN.md`, `README.md`, `ROADMAP.md`, `WORKLOG.md`, `scenes/comstar/comstar.gd`, `scripts/net/comstar_client.gd`
  - `mpbt-server`: `src/api.ts`, `src/db/messages.ts`
- The server repo also has untracked local log files:
  - `mpbt-server.err.log`
  - `mpbt-server.out.log`
- These dirty files are **intentional** and should not be reverted automatically during the next handoff.

## Validation slice used during this session

- `npm --prefix C:\MPBT\mpbt-server run build`
- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --quit-after 2`
- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --scene res://scenes/comstar/comstar.tscn --quit-after 2`
- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --quit-after 2 --script C:\Users\moose\.copilot\session-state\7818ea2e-c745-4cda-9cbf-53e8f36ed4f3\files\retail_combat_helper_expansion_test.gd`

## Next logical step

Finish tightening the ComStar parity slice before moving on:

1. verify the new REST ComStar contract against live/manual client behavior, especially reply, dismiss, and ComStar-ID targeting
2. decide whether the hidden non-retail delete affordance should be removed from the scene entirely or reintroduced later as a retail-accurate dismiss action
3. audit the remaining ComStar UI flow against the recovered retail metadata:
   - `World_Cmd36_MessageView_v129`
   - `World_Cmd37_OpenCompose_v129`
   - `World_MessageView_HandleInput_v129`
   - `World_MessageView_DispatchNormalizedKey_v129`
   - `World_MessageView_ExtractReplyPrefixTags_v129`
   - `World_ComposeEditor_SubmitMessage_v129`
4. once ComStar is solid, do the next bounded slice on **Settings**, then return to deeper combat posture/animation/HUD fidelity

## 2026-05-02 - ComStar reply-prefix and read-view input follow-up

Goal: continue the bounded ComStar slice against the recovered retail metadata instead of restarting the work.

## What changed in this follow-up

- Audited the current client/server ComStar implementation against:
  - `World_Cmd36_MessageView_v129`
  - `World_Cmd37_OpenCompose_v129`
  - `World_MessageView_HandleInput_v129`
  - `World_MessageView_DispatchNormalizedKey_v129`
  - `World_MessageView_ExtractReplyPrefixTags_v129`
  - `World_ComposeEditor_SubmitMessage_v129`
- Confirmed the already-dirty server REST path preserves enough body payload for the client to handle hidden retail reply-prefix tags in the read/compose UI layer for this pass.
- Updated `scenes/comstar/comstar.gd` so received bodies are scanned for inline nine-byte `[p......]` / `[r......]` reply-prefix tags:
  - hidden tags are stripped from inbox preview/detail display
  - captured tags are retained while the read view is active
  - replies prepend the captured hidden prefix string before sending the body back through the existing `{ to, body }` REST contract
- Added a simple paged body model to the ComStar read view:
  - `Space`, `M`, and `PageDown` advance a body page
  - `Shift+Tab` and `PageUp` move backward
  - `R` opens reply when the selected message has a nonzero `replyTargetId`
  - `Escape` / `Enter` close the active read view
  - `Escape` cancels compose

## Validation used in this follow-up

- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --scene res://scenes/comstar/comstar.tscn --quit-after 2`
- `C:\Users\moose\bin\godot.cmd --headless --path C:\MPBT\mpbt-client --quit-after 2`

## Remaining ComStar handoff notes

- Manual/live validation is still needed for reply flow, dismiss/read consumption, and ComStar-ID targeting against a running server.
- The hidden delete button still exists in the scene file but remains disabled/hidden in the runtime UI; decide later whether to remove it or bring it back only as a retail-accurate dismiss affordance.
- If live testing shows server-generated previews should also be sanitized at the API boundary, patch `mpbt-server/src/api.ts` next under the server-first rule.
- After that, move to the next bounded slice: **Settings**.

## 2026-05-02 - Retail function-map completion and full catalog import

Goal: finish the retail v1.29 named-function burn-down in Ghidra, mirror the result into the Godot research layer, and use that milestone to clarify the project’s forward implementation strategy.

## What changed in this work session

### Retail reverse-engineering/catalog layer

- Exhausted the remaining `FUN_*` list in the live `MPBTWIN.EXE` Ghidra project.
- Promoted the final low-level software-rasterizer and stub helpers needed to close the last unnamed gaps, including:
  - `Combat_SoftwareRasterizerPaletteMapped16BitTexturedSpan_v129`
  - `Combat_SoftwareRasterizerPaletteMapped16BitDoubleWideTexturedSpan_v129`
  - `Combat_SoftwareRasterizerClippedTexturedSpan_v129`
  - `Combat_SoftwareRasterizerClippedPaletteMapped16BitTexturedSpan_v129`
  - `Combat_SoftwareRasterizerClippedPaletteMapped16BitDoubleWideTexturedSpan_v129`
  - `Combat_SoftwareRasterizerSpanCodeDeadLoop_v129`
  - `Shell_StackCleanupReturnStub_v129`
  - `Frame_NoOpSingleByteNormalizedKeyHook_v129`
  - `Frame_ZeroCountScratchCopyStub_v129`
- Expanded `scripts/research/retail_function_catalog.gd` from a curated subset to the full live Ghidra custom-name inventory.
- Imported the remaining missing named functions, including CRT/FID/runtime helpers and duplicate-address wrappers that were previously omitted from the research catalog.
- The research layer now tracks **1290** named retail functions and the current live project has **no remaining `FUN_*` placeholders**.
- `retail_command_catalog.gd`, `retail_helper_catalog.gd`, and `retail_subsystem_catalog.gd` remain the higher-level semantic views over that completed function map.

### Project-direction clarification

- The completed function map materially improves the project’s ability to build a retail-accurate modern client directly in Godot.
- A near-retail C++ rebuild may still be useful as a private/internal research harness for ambiguous subsystems, but it is no longer the primary path.
- The main path remains a behavior-first modern clone: keep using Godot as the client runtime, consult the retail research catalogs as the oracle, and only do targeted low-level reconstructions or native ports where they meaningfully improve accuracy.

## Current state

- `mpbt-client` now has a complete named-function research baseline for the live `MPBTWIN.EXE` project.
- The project’s remaining uncertainty is less about “what function is this?” and more about deeper data layout recovery, asset semantics, and last-mile world/combat fidelity tuning.
- The documentation and planning direction now reflect that the retail research milestone supports continued direct progress in the modern client rather than a wholesale pause for full-source reconstruction.

## Next logical step

Continue the screenshot-driven retail shell/chrome pass in the remaining bare non-combat scenes, starting with **ComStar** and then **Settings**, and then spend the next fidelity cycle on deeper combat posture/animation/HUD work using the completed research catalogs as the reference oracle.

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
