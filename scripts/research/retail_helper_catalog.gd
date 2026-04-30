class_name RetailHelperCatalog
extends RefCounted

## Structured metadata for the saved/named retail v1.29 helpers that are not
## direct Cmd* dispatch entries. This turns the imported Ghidra names into a
## queryable RE layer with summaries, candidate Godot surfaces, and a cautious
## implementation-status signal.

const FUNCTION_CATALOG_SCRIPT = preload("res://scripts/research/retail_function_catalog.gd")

const STATUS_METADATA_ONLY := "metadata-only"
const STATUS_PARTIAL_ANALOG := "partial-analog"
const STATUS_EXTERNAL_RUNTIME := "external-runtime"

const OVERRIDES := {
	"Combat_MainLoop_v129": {
		"family": "CombatLoop",
		"summary": "Top-level retail combat loop / scene tick anchor.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SetActorAnimationState_v129": {
		"family": "Animation",
		"summary": "Central combat actor animation-state setter.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3588-3595"],
	},
	"Combat_StartFallDownAnim_SetRecoveryBlock_v129": {
		"family": "Animation",
		"summary": "Starts the fall-down animation path and sets the recovery block.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3589"],
	},
	"Combat_AnimCallback_ClearActorRecoveryBlock_v129": {
		"family": "Animation",
		"summary": "Animation callback that clears the actor recovery block.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3590"],
	},
	"Combat_ArmDeferredCollapseWhileAirborne_v129": {
		"family": "Animation",
		"summary": "Arms deferred collapse while the actor is still airborne.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3591", "RESEARCH.md:3604-3605"],
	},
	"Combat_ProcessLocalMechContact_v129": {
		"family": "Movement",
		"summary": "Processes local mech contact / ground interaction.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3592"],
	},
	"Combat_ProcessMouseUpperBodyAimInput_v129": {
		"family": "UpperBodyControl",
		"summary": "Reads mouse displacement and feeds the local torso-yaw and upper-body pitch accumulators.",
		"notes": [
			"Recent v1.29 decomp shows it recenters the cursor after applying deltas into the same +/-0x1ffe accumulators used for outbound upper-body motion fields.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2692", "RESEARCH.md:3000-3001", "RESEARCH.md:4923-4929"],
	},
	"Combat_UpdateLocalMovementHudAndAnimation_v129": {
		"family": "Movement",
		"summary": "Updates the local movement HUD and ordinary stand/walk animation state.",
		"notes": [
			"Retail only updates this path when the local mech is not airborne, not downed, and not in deferred-collapse handling.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": ["RESEARCH.md:3593", "RESEARCH.md:3606-3608"],
	},
	"Combat_FindAnimationStateDefinitionById_v129": {
		"family": "Animation",
		"summary": "Looks up an animation-state definition by id.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3594"],
	},
	"Combat_BuildActorAnimationPose_v129": {
		"family": "Animation",
		"summary": "Builds the final animation pose for a combat actor.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3595"],
	},
	"Combat_BuildAnimationNodePoseRecursive_v129": {
		"family": "Animation",
		"summary": "Recursively resolves animation-node pose state.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_UpdateAnimationControllerProgress_v129": {
		"family": "Animation",
		"summary": "Advances combat animation-controller progress.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_IntegrateActorMotion_v129": {
		"family": "Movement",
		"summary": "Integrates motion state into actor position / velocity fields.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResolveLandingOrGroundContact_v129": {
		"family": "Movement",
		"summary": "Resolves landing or general ground-contact state.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ProcessLocalMovementAndJumpInput_v129": {
		"family": "Movement",
		"summary": "Local wrapper around the movement and jump-input path.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3624-3626"],
	},
	"Combat_TickLocalActorControlLoop_v129": {
		"family": "Movement",
		"summary": "Ticks the local actor control loop around movement/jump handling.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3624-3626"],
	},
	"Combat_UpdateLocalThrottleTarget_v129": {
		"family": "Movement",
		"summary": "Updates the local throttle target used by movement control.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_JumpJetInputTick_v129": {
		"family": "Movement",
		"summary": "Processes jump-jet input and checks the live jump-jet count gate.",
		"notes": [
			"Current v1.29 research shows the live path checks actual jump-jet count rather than a hardcoded four-jet minimum.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:3627-3629", "RESEARCH.md:6114-6116"],
	},
	"Combat_UpdateLocalHeatAccumulator_v129": {
		"family": "Heat",
		"summary": "Ticks the local heat accumulator from movement, throttle, and jump activity.",
		"notes": [
			"Feeds the shutdown/overheat posture path through Combat_UpdateHeatShutdownState_v129 after adjusting actor heat state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": ["RESEARCH.md:2754-2756", "RESEARCH.md:4050"],
	},
	"Combat_AccumulateTorsoYawOffset_v129": {
		"family": "UpperBodyControl",
		"summary": "Accumulates the local torso-yaw offset with retail +/-0x1ffe clamping.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2692"],
	},
	"Combat_AccumulateUpperBodyPitchOffset_v129": {
		"family": "UpperBodyControl",
		"summary": "Accumulates the local upper-body pitch offset with retail +/-0x1ffe clamping.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2672-2692"],
	},
	"Combat_UpdateWeaponRangeIndicators_v129": {
		"family": "WeaponHud",
		"summary": "Updates the per-weapon range-bracket HUD indicators against the current target distance.",
		"notes": [
			"Uses the active target distance when available and falls back to a large sentinel range when no target is selected.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": ["RESEARCH.md:2063-2066", "RESEARCH.md:2100", "RESEARCH.md:2169-2171"],
	},
	"Combat_UpdateJumpFuelReserve_v129": {
		"family": "Movement",
		"summary": "Recharges or drains the local jump-fuel reserve and updates the jump-ready HUD indicator.",
		"notes": [
			"Retail caps the reserve at 0x78, recharges it continuously on the ground, and uses hysteresis around 0x32/0x3c for the local jump-ready indicator.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": ["RESEARCH.md:4031-4038", "RESEARCH.md:6114-6124", "RESEARCH.md:6138-6144"],
	},
	"Combat_ApplyLocalMovementForces_v129": {
		"family": "Movement",
		"summary": "Builds the local movement-force vector from throttle, jump state, and transient impulses, then integrates it into actor velocity.",
		"notes": [
			"Uses the same globalA/globalB/globalC constants that the retail jump-height follow-up tied to local gravity, ground damping, and jump-active damping behavior.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:4041-4049"],
	},
	"Combat_ProcessChassisTurnInput_v129": {
		"family": "UpperBodyControl",
		"summary": "Processes the local chassis-turn input axis and applies it into the chassis-facing accumulator.",
		"notes": [
			"When no direct turn key is held, it can still route into Combat_ProcessMouseChassisTurnInput_v129 if the retail mouse-turn mode is active and the actor is not blocked.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2673", "RESEARCH.md:2691", "RESEARCH.md:4923-4929"],
	},
	"Combat_ProcessUpperBodyAimInput_v129": {
		"family": "UpperBodyControl",
		"summary": "Processes the local upper-body aim input axes, including keyboard deltas, mouse recentering, and zone-based fallback control.",
		"notes": [
			"Drives the torso-yaw and upper-body pitch accumulators through the v1.29 clamp helpers, then falls back to Combat_RecenterUpperBodyAimOffsets_v129 and Combat_ProcessMouseUpperBodyAimZones_v129 when no direct aim key is held.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2692", "RESEARCH.md:3000-3001", "RESEARCH.md:4923-4929"],
	},
	"Combat_RecenterUpperBodyAimOffsets_v129": {
		"family": "UpperBodyControl",
		"summary": "Decays the live torso-yaw and upper-body pitch offsets back toward neutral when direct aim input is idle.",
		"notes": [
			"Uses the current sign of the two local aim offsets to walk both channels toward zero, then toggles the same actor UI bit that retail uses to reflect active upper-body offset state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2692"],
	},
	"Combat_ProcessMouseChassisTurnInput_v129": {
		"family": "MouseControl",
		"summary": "Reads the configured mouse turn zone and applies the result into the chassis-facing accumulator when keyboard turn input is idle.",
		"notes": [
			"Retail clamps elapsed time to 20 ms for this path, then scales the zone percentage into the same 0x11c6 chassis-turn rate used by direct turn input.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2673", "RESEARCH.md:2691"],
	},
	"Combat_ProcessMouseThrottleZoneInput_v129": {
		"family": "MouseControl",
		"summary": "Processes the retail mouse throttle zone and updates the local throttle target while the actor is grounded and not jump-active.",
		"notes": [
			"Supports both absolute and stepped zone modes, and clears the throttle target back to neutral when the zone is unavailable or local state blocks mouse throttle ownership.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeMouseTurnAxisPercent_v129": {
		"family": "MouseControl",
		"summary": "Converts the configured mouse turn zone into a signed -100..100 turn-axis percentage.",
		"notes": [
			"Shared by chassis turning and jump-jet left/right steering thresholds, so it is broader than a pure chassis-only helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ApplyChassisTurnInputRate_v129": {
		"family": "UpperBodyControl",
		"summary": "Applies a signed chassis-turn input rate over elapsed time into the local turn accumulator.",
		"notes": [
			"Shared by keyboard chassis-turn input and the mouse chassis-turn zone helper, so it represents the common scaled rate applier rather than a device-specific path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2673"],
	},
	"Combat_ApplyTorsoYawInputRate_v129": {
		"family": "UpperBodyControl",
		"summary": "Applies a signed torso-yaw input rate over elapsed time into the clamped upper-body yaw accumulator.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2672", "RESEARCH.md:2692"],
	},
	"Combat_ApplyUpperBodyPitchInputRate_v129": {
		"family": "UpperBodyControl",
		"summary": "Applies a signed upper-body pitch input rate over elapsed time into the clamped pitch accumulator.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2672", "RESEARCH.md:2692"],
	},
	"Combat_ComputeActorForwardSpeedComponent_v129": {
		"family": "Movement",
		"summary": "Computes the signed forward-speed component by projecting actor velocity onto the current facing heading.",
		"notes": [
			"Retail reuses this helper for the local movement HUD, the outbound Cmd8/Cmd9 speed field, and the local throttle feedback/audio path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:4929", "RESEARCH.md:5841-5844"],
	},
	"Combat_UpdateLocalThrottleFeedbackAudio_v129": {
		"family": "CombatAudio",
		"summary": "Updates the local throttle feedback audio, including transient cue playback and the continuous engine/throttle loop pitch.",
		"notes": [
			"Called both from the local control loop and from throttle-target updates; it uses the current forward-speed component to retune the active loop sound while posture-state changes can trigger short cue sounds.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Combat_UpdateUpperBodyAimCueAudio_v129": {
		"family": "CombatAudio",
		"summary": "Updates the local upper-body aim cue audio from the torso-yaw, pitch, and recenter activity timers.",
		"notes": [
			"Uses the torso-yaw/recenter timer for one cue pitch and the upper-body pitch timer for another, then stops the cue once both timers expire.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/audio/audio_manager.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2692"],
	},
	"Combat_PlayAudioCue_v129": {
		"family": "CombatAudio",
		"summary": "Plays a combat audio cue by cue-slot id, applying any stored default volume, pitch, and priority settings.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Combat_StopAudioCue_v129": {
		"family": "CombatAudio",
		"summary": "Stops a combat audio cue by cue-slot id if it is currently active.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Combat_IsAudioCuePlaying_v129": {
		"family": "CombatAudio",
		"summary": "Checks whether a combat audio cue slot is currently active.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Combat_SetAudioCueVolume_v129": {
		"family": "CombatAudio",
		"summary": "Sets the volume for a combat audio cue slot.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Combat_SetAudioCuePitch_v129": {
		"family": "CombatAudio",
		"summary": "Sets the pitch for a combat audio cue slot.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Combat_PlayImpactCue_v129": {
		"family": "CombatAudio",
		"summary": "Selects and plays the retail impact cue based on damage/effect severity and distance.",
		"notes": [
			"Shared by direct damage-pair application and coordinate-only impact effects; it buckets the severity code into a cue family and scales volume from range when the impact is not on the local actor.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/audio/audio_manager.gd",
		],
		"research_refs": ["RESEARCH.md:4739", "RESEARCH.md:4985"],
	},
	"Combat_PlayCollapseImpactCue_v129": {
		"family": "CombatAudio",
		"summary": "Plays the collapse/landing impact cue used when a mech falls into the recoverable down state.",
		"notes": [
			"Called from both the remote `Cmd70` landing-collapse path and the local landing/deferred-collapse resolver, with remote actors using a distance-scaled volume.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/audio/audio_manager.gd",
		],
		"research_refs": ["RESEARCH.md:2739-2741", "RESEARCH.md:2780-2781", "RESEARCH.md:2919-2920"],
	},
	"Combat_RenderActorPreviewPanel_v129": {
		"family": "CombatPreview",
		"summary": "Renders a labeled combat actor preview panel by posing the actor model, drawing it with the preview camera, and centering a truncated caption.",
		"notes": [
			"Called twice from Combat_MainLoop_v129 for the combat self/target preview panes. It builds a fixed preview transform, refreshes the actor pose through Combat_BuildActorAnimationPose_v129, renders the attachment stack via Combat_RenderModelAttachments_v129, truncates the supplied label to 16 characters plus ellipsis, and draws that caption along the panel bottom edge.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SpawnImpactEffectAtAttachmentOrCoord_v129": {
		"family": "CombatEffects",
		"summary": "Spawns the retail impact effect at a target attachment when available, or falls back to explicit world coordinates.",
		"notes": [
			"When the target actor/attachment cannot be resolved, it falls back to the provided impact coordinates and only emits the ordinary impact cue if the caller's effect flags request it.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:4160-4179", "RESEARCH.md:4738-4739"],
	},
	"Combat_ResolveProjectileImpactDamage_v129": {
		"family": "CombatEffects",
		"summary": "Resolves a projectile/effect impact by playing the impact cue and applying any queued damage pairs to the target actor.",
		"notes": [
			"Matches the queued projectile/effect damage model: once the effect reaches its impact point, retail replays the queued code/value pairs through Combat_ApplyDamageCodeValue_v129 and clears the queue state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:4736-4739", "RESEARCH.md:4985"],
	},
	"Combat_UpdateActiveProjectileEffects_v129": {
		"family": "CombatEffects",
		"summary": "Walks the active projectile/effect pool, advances each live entry, resolves completed impacts, and queues visible effects for rendering.",
		"notes": [
			"Called from the retail combat effect/render pass after the camera basis is prepared. Entries that have already impacted are handed off to Combat_ResolveProjectileImpactDamage_v129; entries still in flight are culled into the transient visible-effect list only when they remain plausibly in front of the camera.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:4738", "RESEARCH.md:4985"],
	},
	"Combat_UpdateProjectileEffectState_v129": {
		"family": "CombatEffects",
		"summary": "Advances one active projectile/effect toward its impact point, refreshing target-attachment coordinates until the effect lands.",
		"notes": [
			"When the target attachment is still valid it recomputes the world impact point from that attachment; otherwise it counts down against the last stored destination. The helper also emits periodic in-flight particles and arms the final impact handoff once the remaining travel distance collapses below the retail threshold.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:4738", "RESEARCH.md:4985"],
	},
	"Combat_RenderActiveEffectsPass_v129": {
		"family": "CombatEffects",
		"summary": "Runs the retail combat effect render pass: updates active effects, depth-sorts the visible ones, and dispatches type-specific draw helpers.",
		"notes": [
			"Called from Combat_MainLoop_v129 after the camera basis is prepared. The pass also resets the transient effect hit-test globals before drawing and feeds the visible-effect list through the per-type sprite, trail, and model renderers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:4738", "RESEARCH.md:4985"],
	},
	"Combat_RenderModelAttachments_v129": {
		"family": "CombatEffects",
		"summary": "Transforms, depth-sorts, and renders a model's attachment list while updating the model's projected screen bounds.",
		"notes": [
			"Shared beneath both the combat effect-model path and the main-loop actor preview panels. It walks the model attachment records, sorts them from back to front in camera space, and accumulates the final projected min/max bounds into the owning model struct.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderAttachmentMeshListAndTrackCursorHit_v129": {
		"family": "CombatEffects",
		"summary": "Renders one attachment's active mesh list and updates the retail cursor-hit globals when the attachment is selected.",
		"notes": [
			"Chooses the visible attachment view variant from the current transform, draws each polygon group through the low-level triangle/quad routines, and merges the resulting projected bounds back into the caller's screen-space extents.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderEffectModelAndCheckCursorHit_v129": {
		"family": "CombatEffects",
		"summary": "Renders an effect model, updates its screen-space extents, and reports whether the current cursor hit-test selected it.",
		"notes": [
			"Builds the model's transformed attachment list, renders it through the shared per-attachment model path, caches the on-screen extents used by the effect pass, and marks the effect visible when its projected bounds overlap the active viewport.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderEffectModelHitProxy_v129": {
		"family": "CombatEffects",
		"summary": "Renders the auxiliary effect-model hit proxy used by the retail cursor-selection pass and returns whether it was selected.",
		"notes": [
			"Used from the case-1 effect branch while testing nearby case-6 effects. It renders the stored model pointer at effect offset `0x7a` through the shared hit-test renderer and returns the masked cursor-hit result.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderEffectSprite_v129": {
		"family": "CombatEffects",
		"summary": "Projects and draws a screen-facing retail effect sprite with distance- and lifetime-scaled size.",
		"notes": [
			"Used by one of the combat effect render-pass types. It converts the effect origin into screen space, scales the sprite from depth and elapsed lifetime, then draws the animated sprite frame through the 2D effect atlas.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderEffectTrailStrip_v129": {
		"family": "CombatEffects",
		"summary": "Builds and renders the polygon strip used by retail trail-style combat effects.",
		"notes": [
			"Reconstructs the effect's sampled trail points relative to the current camera, chooses the forward or reverse basis from the stored trail normals, then submits the strip through the generic clipped polygon renderer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderEffectModel_v129": {
		"family": "CombatEffects",
		"summary": "Draws a retail combat effect model resource with the current effect transform.",
		"notes": [
			"Thin wrapper over the shared model/hit-test renderer used by the effect pass for one stored resource pointer and scale preset.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderWeaponEffectModelOrFallback_v129": {
		"family": "CombatEffects",
		"summary": "Draws a retail weapon effect model when present, otherwise falls back to the weapon-specific sprite/quad renderer.",
		"notes": [
			"The fallback path keys off the source actor plus weapon slot stored on the effect object, so this wrapper belongs to the weapon/projectile branch rather than a generic effect-model path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129": {
		"family": "CombatEffects",
		"summary": "Draws the retail fallback visual for weapon effects when no dedicated model resource is present.",
		"notes": [
			"Chooses between a short-lived projectile sprite and a muzzle-to-impact beam/quad based on the source weapon class recovered from the actor's mech record.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_ProcessMouseUpperBodyAimZones_v129": {
		"family": "MouseControl",
		"summary": "Maps configured mouse control zones into torso-yaw and upper-body pitch deltas when direct aim input is idle.",
		"notes": [
			"Evaluates separate horizontal and vertical zone descriptors, applies dead-zone suppression, and then feeds the resulting signed percentages into the same torso-yaw and pitch accumulation wrappers used by keyboard aim.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
		"research_refs": ["RESEARCH.md:2671-2692", "RESEARCH.md:4923-4929"],
	},
	"Combat_GetMouseControlZoneConfig_v129": {
		"family": "MouseControl",
		"summary": "Returns the retail mouse-control zone descriptor for turn, aim, and related control surfaces.",
		"notes": [
			"Each returned descriptor includes bounds, midpoint, half-size, and per-zone dead-zone/scale values; the same helper is shared by the anonymous throttle mouse-zone path as well.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClearExpiredWeaponSlotIndicators_v129": {
		"family": "WeaponHud",
		"summary": "Clears timed-out per-weapon HUD indicators after their transient slot timers expire.",
		"notes": [
			"Walks the local weapon slots and clears the three-cell indicator row for any slot whose local timer has elapsed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": ["RESEARCH.md:2063-2067"],
	},
	"Combat_DampenLocalMotionState_v129": {
		"family": "Movement",
		"summary": "Applies per-tick damping to local velocity, turn state, and airborne drift after the control forces are integrated.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_UpdateHeatShutdownState_v129": {
		"family": "Heat",
		"summary": "Maps local heat thresholds into shutdown posture/state changes and refreshes the movement HUD/animation side effects.",
		"notes": [
			"Writes posture state 2 on high heat and clears it again once the accumulator falls back under the lower recovery threshold.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": ["RESEARCH.md:2754-2756", "RESEARCH.md:3593"],
	},
	"Combat_DrawLocalAirborneHudReadout_v129": {
		"family": "CombatHud",
		"summary": "Draws the local airborne HUD readout from the actor altitude and vertical-response fields.",
		"notes": [
			"Only runs while the local actor is airborne and follows the control-loop path that updates the same vertical response field used by deferred-collapse handling.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
		"research_refs": ["RESEARCH.md:3460-3461", "RESEARCH.md:4787-4790"],
	},
	"Combat_SendCmd12Action_v129": {
		"family": "CombatWire",
		"summary": "Outbound combat action sender for client cmd12 control frames.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/arena_client.gd",
			"res://scripts/net/ws_client.gd",
		],
	},
	"Mech_InitRuntimeStateFromRecord_v129": {
		"family": "MechRuntime",
		"summary": "Initializes actor runtime state from the mech record.",
		"notes": [
			"Copies the mech jump-jet count from mech-data offset +0x38 into the actor runtime field used by jump input.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
		"research_refs": ["RESEARCH.md:3621-3624"],
	},
	"Mech_InitComponentStatusFromRecord_v129": {
		"family": "MechRuntime",
		"summary": "Initializes per-component runtime status from the mech record.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_ClearWorldUiChildren_v129": {
		"family": "WorldUI",
		"summary": "Clears active world UI children before rebuilding a panel/browser surface.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_RegisterShortcutBinding_v129": {
		"family": "WorldUI",
		"summary": "Registers a world shortcut / hotkey binding.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_SendMenuSelection_v129": {
		"family": "WorldSubmit",
		"summary": "Ordinary world list-submit helper that assembles outbound Cmd7 menu selections.",
		"notes": [
			"Retail Enter/hotkey picks route through this helper whenever the latched list id is nonzero.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/world_travel_client.gd",
			"res://scenes/world/world.gd",
		],
		"research_refs": ["RESEARCH.md:6159-6161", "RESEARCH.md:6180-6182", "RESEARCH.md:6390-6394"],
	},
	"World_MenuDialog_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Keyboard input handler for the retail menu-dialog surface.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_MenuDialog_HandleMouse_v129": {
		"family": "WorldUI",
		"summary": "Pointer/mouse handler for the retail menu-dialog surface.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_HotkeySelectionMenu_HandleInput_v129": {
		"family": "WorldSubmit",
		"summary": "Input callback for the hotkey-driven world selection menu.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
		"research_refs": ["RESEARCH.md:6388-6394"],
	},
	"World_MechStatusOptionPage_SubmitSelection_v129": {
		"family": "WorldSubmit",
		"summary": "Submit handler for the mech-status option hub.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
		"research_refs": ["RESEARCH.md:6214-6216"],
	},
	"World_MechComponentActionPage_HandleActionHotkey_v129": {
		"family": "WorldUI",
		"summary": "Hotkey action handler for the mech component-action page.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_MechComponentActionPage_HandleKey_v129": {
		"family": "WorldUI",
		"summary": "Keyboard handler for the mech component-action page.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_MechComponentActionPage_HandlePointer_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the mech component-action page.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_BuyExtraAmmoList_HandleKey_v129": {
		"family": "WorldUI",
		"summary": "Keyboard handler for the buy-extra-ammo selection list.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_BuyExtraAmmoList_HandlePointer_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the buy-extra-ammo selection list.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"Frame_DecodeArg_v129": {
		"family": "FrameProtocol",
		"summary": "Decodes a variable-width retail base-85 frame integer from the active packet cursor.",
		"notes": [
			"Supports the retail type1 through type4 integer widths by consuming 2 to 5 base-85 digits from the current frame pointer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:130-146", "RESEARCH.md:6270-6271", "RESEARCH.md:1128"],
	},
	"Frame_BlitRelativeRect_v129": {
		"family": "FrameBlit",
		"summary": "Normalizes a frame-local rectangle, offsets it by the owning panel origin, and blits that region through the retail surface-present path.",
		"notes": [
			"Shared by the combat actor preview wrapper and many other HUD/UI draw helpers. It wraps the deeper surface blit with the same frame callback toggle used by retail before and after presenting panel-local regions.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_CompositeMaskedSpanRuns_v129": {
		"family": "FrameBlit",
		"summary": "Composites a run-length list of masked pixel spans into a destination frame buffer.",
		"notes": [
			"Each span run either copies source pixels directly, skips fully masked pixels, or bit-composites source and destination pixels with the stored mask word. In combat it is used beneath the preview/radar overlays before the affected rectangle is blitted to the display.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_GetGlyphAdvance_v129": {
		"family": "FrameText",
		"summary": "Returns the horizontal advance for one glyph in the selected retail font table.",
		"notes": [
			"Used beneath both the glyph-measure and wrapped-text writer paths. It reads the per-glyph advance byte directly from the font metrics block.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_MeasureStringWidth_v129": {
		"family": "FrameText",
		"summary": "Measures a retail string width using the active frame font, including tab-stop expansion.",
		"notes": [
			"Used by the combat actor preview panels to center truncated pilot/actor captions. If the frame is marked fixed-width it falls back to eight pixels per character; otherwise it delegates printable glyph measurement to Frame_MeasureGlyphRunWidth_v129 and treats the final tab-delimited segment separately.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_MeasureGlyphRunWidth_v129": {
		"family": "FrameText",
		"summary": "Measures the rendered width of a printable glyph run in the selected retail font.",
		"notes": [
			"Skips non-printable control bytes, honors the retail `[R... ]` inline formatting marker without counting it as visible width, and either returns the summed glyph advances or the visible-character count depending on the mode flag.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_DrawString_v129": {
		"family": "FrameText",
		"summary": "Draws a null-terminated retail string one glyph at a time and advances by each glyph's rendered width.",
		"notes": [
			"Shared widely across HUD and menu surfaces. The combat preview wrapper uses it to draw the bottom caption after measuring and centering the text.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_DrawGlyph_v129": {
		"family": "FrameText",
		"summary": "Draws one retail glyph into the destination frame buffer and returns its horizontal advance.",
		"notes": [
			"Clips the glyph bitmap against the target frame rectangle, optionally remaps palette indices through a supplied color table, and returns the glyph advance so callers can position the next character.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_WriteCharAtCursor_v129": {
		"family": "FrameText",
		"summary": "Writes one character at the frame's current text cursor using the active line and column state.",
		"notes": [
			"Thin wrapper over the lower-level character writer used by wrapped text blocks, selection lists, and other scrolling text surfaces.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_WriteCharAtLineColumn_v129": {
		"family": "FrameText",
		"summary": "Writes one character at an explicit frame text line/column position and advances the logical cursor with wrapping rules.",
		"notes": [
			"Handles newline, carriage return, tab, and printable glyphs. Visible characters are drawn through Frame_DrawGlyph_v129, while the logical line/column state and pixel x-extent are updated using Frame_GetGlyphAdvance_v129 and the active wrap flag.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_ScrollTextViewportUpIfAtBottom_v129": {
		"family": "FrameText",
		"summary": "Scrolls the frame text viewport up by one line when the active text row hits the bottom edge and scrolling is enabled.",
		"notes": [
			"Shared by the explicit line/column writer and related text-state helpers. It shifts the backing surface upward by one line height and rewrites the caller's row index to the last visible line.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_DrawWrappedLine_v129": {
		"family": "FrameText",
		"summary": "Draws one pre-wrapped line into the current frame text surface by streaming characters through the active cursor writer.",
		"notes": [
			"Restores the stored horizontal offset for the current wrapped line before emitting each character via Frame_WriteCharAtCursor_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_DrawInlineAssetRuns_v129": {
		"family": "FrameText",
		"summary": "Processes and draws the inline asset markers embedded in a wrapped retail text block.",
		"notes": [
			"Consumes fixed-width marker records, loads the referenced four-character asset tag, reserves the covered line spans in the wrap metadata, and draws each inline asset into the frame before the surrounding text is emitted.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_DrawWrappedTextBlock_v129": {
		"family": "FrameText",
		"summary": "Lays out a string into wrapped frame lines, honoring explicit breaks and inline asset markers, then draws the resulting text block.",
		"notes": [
			"Shared by message-view and menu/list surfaces. It measures candidate line fragments with Frame_MeasureStringWidth_v129, breaks on whitespace or explicit separators, emits each completed line through Frame_DrawWrappedLine_v129, and applies inline asset runs through Frame_DrawInlineAssetRuns_v129 before text output.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_AppendWrappedInputChar_v129": {
		"family": "FrameText",
		"summary": "Appends one character to an editable wrapped text buffer, enforcing width limits and rerendering when the current line overflows.",
		"notes": [
			"Maintains the backing input string, tracks the special `[` marker location used by inline asset markup, and either draws the character incrementally through Frame_WriteCharAtCursor_v129 or reruns Frame_DrawWrappedTextBlock_v129 when a wrap boundary is crossed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_BackspaceWrappedInputChar_v129": {
		"family": "FrameText",
		"summary": "Removes the last character from an editable wrapped text buffer and refreshes the affected line or rerenders the wrapped block when needed.",
		"notes": [
			"If deleting the trailing character stays within the current wrapped line it erases the old glyph region through Frame_BlitRelativeRect_v129; otherwise it redraws the full wrapped text block and rebuilds the cursor metrics.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_ResetTextLayoutState_v129": {
		"family": "FrameText",
		"summary": "Resets the frame text cursor/layout state for the full text area and clears the backing surface when the frame flags request it.",
		"notes": [
			"Used before rebuilding wrapped text or text-heavy menus. It restores the full frame-local drawing rectangle, zeroes the cursor and width trackers, optionally clears the inner text area, and then refreshes any registered text decorations or inline controls.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_ResetTextLayoutStateWithInsets_v129": {
		"family": "FrameText",
		"summary": "Resets the frame text cursor/layout state against an inset drawing rectangle and applies the requested layout mode.",
		"notes": [
			"Used by wrapped input editors and menu handlers that need inner margins rather than the full text area. It zeroes the cursor state, derives an inset clip rectangle from the supplied left/top/right/bottom offsets, applies the layout mode, and refreshes any registered text decorations.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_SwapPaletteIndicesInRect_v129": {
		"family": "FrameText",
		"summary": "Swaps two palette indices throughout a frame-local rectangle and optionally presents the modified region.",
		"notes": [
			"Used by the text cursor/highlight logic to toggle highlight colors in place without redrawing the underlying text content.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_UpdateTextCursorHighlight_v129": {
		"family": "FrameText",
		"summary": "Computes and toggles the current text cursor highlight rectangle for an editable frame text surface.",
		"notes": [
			"When requested, it recomputes the highlight bounds from the current wrapped line and text width, stores that rectangle in the frame state, and flips the highlight colors over the active cursor box.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawBitmapResourceAt_v129": {
		"family": "FrameBlit",
		"summary": "Draws a bitmap resource into the frame surface at the requested top-left position.",
		"notes": [
			"Shared widely across retail UI surfaces and used beneath Frame_DrawInlineAssetRuns_v129 for embedded art markers. It derives the destination rectangle from the bitmap width/height header and then submits the resource through the low-level bitmap blitter.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawBitmapResourceTransparentAt_v129": {
		"family": "FrameBlit",
		"summary": "Draws a bitmap resource into the frame surface while skipping pixels that match a transparent key value.",
		"notes": [
			"Used by some text decorations and overlay sprites that need to preserve the underlying frame pixels where the bitmap carries its transparency key.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_BlitBitmapWithTransparentKey_v129": {
		"family": "FrameBlit",
		"summary": "Blits a bitmap buffer into the destination frame rectangle while leaving source pixels that match the transparent key untouched.",
		"notes": [
			"Used beneath Frame_DrawBitmapResourceTransparentAt_v129 and several retail overlay painters. If the bitmap resource is stored in the alternate encoded format it first expands it through FUN_0044c1f0 into a temporary buffer, then copies only non-key pixels into the clipped destination rectangle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_BlitBitmapPixels_v129": {
		"family": "FrameBlit",
		"summary": "Blits a bitmap resource's full pixel payload into the clipped destination frame rectangle.",
		"notes": [
			"Used beneath Frame_DrawBitmapResourceAt_v129 and several full-surface retail bitmap painters. If the resource carries the encoded bitmap flag it first expands the payload through Frame_DecodeBitmapRleData_v129 before copying the bitmap rows into the destination frame.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawLine_v129": {
		"family": "FramePrimitive",
		"summary": "Draws one clipped line segment into the frame surface using the requested palette index.",
		"notes": [
			"Shared by bevel/border builders and by the world map connector overlays. It draws directly into the frame's backing surface without presenting the affected region.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawLineAndPresent_v129": {
		"family": "FramePrimitive",
		"summary": "Draws one clipped line segment into the frame surface and then presents the touched rectangle.",
		"notes": [
			"Used by the world connector overlay commands and the immediate bevel helper when retail wants the line update shown right away rather than batched with a later blit.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawBeveledRectAndPresent_v129": {
		"family": "FramePrimitive",
		"summary": "Draws a two-tone beveled rectangle border and presents each affected edge region immediately.",
		"notes": [
			"Builds the retail raised or sunken border by emitting the outer and inner edge lines through Frame_DrawLineAndPresent_v129, swapping the light and dark colors when the bevel direction flag is inverted.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DecodeBitmapRleData_v129": {
		"family": "FrameBlit",
		"summary": "Expands the retail run-length encoded bitmap payload into a flat 8-bit pixel buffer.",
		"notes": [
			"Positive run headers copy literal bytes; negative run headers repeat the following byte for the requested run length. Used by both full and transparent bitmap blitters when a bitmap resource carries the encoded-data flag.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawFilledBoxOrBitmapDecoration_v129": {
		"family": "FrameText",
		"summary": "Draws the simple filled-box decoration variant and the bitmap-backed decoration variant used by registered frame text decorations.",
		"notes": [
			"For type-3 decorations it fills the local decoration box and optionally adds crossing diagonal strokes; for type-8 decorations it chooses one of two bitmap resources and draws it into the decoration bounds.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawBeveledBorderDecoration_v129": {
		"family": "FrameText",
		"summary": "Draws the beveled border decoration variant used by registered frame text decorations.",
		"notes": [
			"Selects one of two border-line implementations depending on whether the caller wants the updated decoration presented immediately, and applies the stored light/dark edge colors to create the retail raised or sunken bevel effect.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawFilledCircleSector_v129": {
		"family": "FramePrimitive",
		"summary": "Draws a filled circular sector into the frame surface using a scratch mask buffer and the requested palette index.",
		"notes": [
			"Builds the sector by tracing the start and end radii plus intermediate angle steps into a temporary square mask, flood-filling each covered scanline span, and then copying non-zero pixels into the destination frame. The formatted-text renderer uses it for the retail `[*...]` inline widget tag.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawFormattedText_v129": {
		"family": "FrameText",
		"summary": "Parses and draws the retail inline-formatted text stream, including tabs, centered runs, embedded bitmaps, and inline widgets.",
		"notes": [
			"Processes the retail control bytes and bracket tags used by world/menu text surfaces, including left/right embedded bitmaps, centered substrings, inline fill-bar widgets, filled sector widgets, and list metadata tags. Printable characters are emitted through Frame_WriteCharAtCursor_v129 while widget tags delegate to the dedicated frame primitive helpers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawBeveledFillBar_v129": {
		"family": "FramePrimitive",
		"summary": "Draws a beveled bar widget with an optional filled span and an optional center marker line.",
		"notes": [
			"Builds the outer bevel through Frame_DrawBeveledRect_v129, then optionally fills a caller-selected sub-span in the requested palette color and can draw a vertical center guide. The formatted-text renderer uses it for the retail `[|...]` inline widget tag.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawBeveledRect_v129": {
		"family": "FramePrimitive",
		"summary": "Draws a two-tone beveled rectangle border into the frame surface without presenting it immediately.",
		"notes": [
			"Used by frame reset and boxed-widget helpers that batch several border and fill updates before blitting. It emits the same raised/sunken double-outline pattern as Frame_DrawBeveledRectAndPresent_v129 but routes each edge through Frame_DrawLine_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_CopyBitmapPixelsToBuffer_v129": {
		"family": "FrameBlit",
		"summary": "Copies a bitmap resource's full pixel payload into a caller-provided destination buffer.",
		"notes": [
			"Used when retail needs the decoded bitmap contents as a standalone buffer instead of drawing directly into a frame surface. Encoded bitmap payloads are expanded through Frame_DecodeBitmapRleData_v129 first.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_GetFontLineHeight_v129": {
		"family": "FrameText",
		"summary": "Returns the retail font line height from the active font descriptor.",
		"notes": [
			"Used by text decorations and cursor highlight logic to center or size text boxes vertically.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_GetCurrentWrappedLineText_v129": {
		"family": "FrameText",
		"summary": "Returns the pointer to the current wrapped-line text buffer in the frame's wrap metadata.",
		"notes": [
			"Used by cursor highlight logic when the frame is operating in wrapped-text mode instead of the raw input buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawTextDecorationByIndex_v129": {
		"family": "FrameText",
		"summary": "Draws one registered text decoration/control entry by index.",
		"notes": [
			"Dispatches by decoration type to bordered boxes, bitmap resources, framed text labels, and related decoration payloads. It temporarily swaps the global text colors while rendering highlight-capable decorations.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_RedrawRegisteredTextDecorations_v129": {
		"family": "FrameText",
		"summary": "Redraws all registered text decorations/controls that are currently enabled on the frame.",
		"notes": [
			"Called after frame text layout resets to restore decoration overlays, labels, and inline controls that live alongside the wrapped text surface.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_BuildLocationBrowserWindow_v129": {
		"family": "WorldUI",
		"summary": "Builds the shared location-browser window used by the Solaris travel/browser commands.",
		"notes": [
			"Cmd40 and Cmd43 both converge here after seeding browser-selection globals and clearing the active world UI children.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
		"research_refs": ["RESEARCH.md:6274-6277"],
	},
	"World_FreeLocationMapData_v129": {
		"family": "WorldMap",
		"summary": "Releases the currently loaded location-map data block before a browser/map rebuild.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_LoadLocationMapDataFile_v129": {
		"family": "WorldMap",
		"summary": "Loads an IS_MAP or SOLARIS_MAP data file into the in-memory location table and bitmap payload.",
		"notes": [
			"Applies different coordinate transforms for the Inner Sphere map and the Solaris local map after the room records are read.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/map_parser.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_EnsureLocationMapIndex_v129": {
		"family": "WorldMap",
		"summary": "Ensures the active location-map data is loaded, then rebuilds the filtered per-district index used by the browser/map overlays.",
		"notes": [
			"Chooses IS_MAP versus SOLARIS_MAP based on the current map mode, filters the room table, sorts it, and records district start/count offsets.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
			"res://scripts/assets/map_parser.gd",
		],
		"research_refs": ["RESEARCH.md:6264-6282"],
	},
	"World_OpenComposeEditor_v129": {
		"family": "ComstarUI",
		"summary": "Opens the local editable ComStar compose editor for one or many target ids.",
		"notes": [
			"Cmd37 forwards here after decoding either a single target id or a counted list of recipient ids.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
		"research_refs": ["RESEARCH.md:1128", "RESEARCH.md:1644-1646", "RESEARCH.md:6753-6757"],
	},
	"World_ResetComposeEditorState_v129": {
		"family": "ComstarUI",
		"summary": "Allocates and resets the per-editor recipient/body state used by the ComStar message surfaces.",
		"notes": [
			"The compose builder calls this directly, and the read-message view also reuses it when reply state is prepared.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
		"research_refs": ["RESEARCH.md:1127-1128", "RESEARCH.md:1645-1646"],
	},
	"KSND_C_init": {
		"family": "AudioRuntime",
		"summary": "Initializes the retail KSND sound runtime.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"KSND_C_play": {
		"family": "AudioRuntime",
		"summary": "Plays a named/parameterized retail sound slot.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"KSND_C_setParamSnd": {
		"family": "AudioRuntime",
		"summary": "Sets the sound payload or identifier for a KSND parameter slot.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"KSND_C_setParamName": {
		"family": "AudioRuntime",
		"summary": "Sets the logical name for a KSND parameter slot.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"KSND_C_stopSnd": {
		"family": "AudioRuntime",
		"summary": "Stops a currently active retail sound slot.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"KSND_C_update": {
		"family": "AudioRuntime",
		"summary": "Per-frame update tick for the retail KSND audio runtime.",
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"init_aries": {
		"family": "AriesRuntime",
		"summary": "Initializes the ARIES communication layer used by the retail client.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scripts/net/ws_client.gd",
		],
	},
	"MakeTCPConnection": {
		"family": "AriesRuntime",
		"summary": "Opens the primary lobby ARIES TCP connection.",
		"notes": [
			"Retail export also copies version/login-block data before opening the socket.",
		],
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/ws_client.gd",
		],
		"research_refs": ["RESEARCH.md:887-889", "RESEARCH.md:2363-2365", "RESEARCH.md:2526-2528"],
	},
	"SendTCPData": {
		"family": "AriesRuntime",
		"summary": "Low-level retail TCP send helper after CRC/frame assembly.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/ws_client.gd",
			"res://scripts/net/server_bridge.gd",
		],
		"research_refs": ["RESEARCH.md:2642", "RESEARCH.md:5123"],
	},
	"SendTCPSound": {
		"family": "AriesRuntime",
		"summary": "Low-level retail TCP sound/voice transport helper.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/ws_client.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"SetInternet": {
		"family": "AriesRuntime",
		"summary": "Stores the 'internet' address/login field from redirect or launch data.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scripts/net/auth_client.gd",
		],
		"research_refs": ["RESEARCH.md:588-589", "RESEARCH.md:630-633", "RESEARCH.md:888-889", "RESEARCH.md:2364-2365", "RESEARCH.md:2528"],
	},
	"SetUserName": {
		"family": "AriesRuntime",
		"summary": "Stores the retail login username field.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/auth_session.gd",
		],
		"research_refs": ["RESEARCH.md:632", "RESEARCH.md:2528"],
	},
	"SetUserPassword": {
		"family": "AriesRuntime",
		"summary": "Stores the retail login password field.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
		],
		"research_refs": ["RESEARCH.md:589", "RESEARCH.md:633", "RESEARCH.md:889", "RESEARCH.md:919", "RESEARCH.md:2365", "RESEARCH.md:2528"],
	},
	"SetUserEmailHandle": {
		"family": "AriesRuntime",
		"summary": "Stores the retail email/handle login field.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/auth_session.gd",
		],
		"research_refs": ["RESEARCH.md:634", "RESEARCH.md:2528"],
	},
	"SetProductCode": {
		"family": "AriesRuntime",
		"summary": "Stores the retail product/server-port code in the login block.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scripts/net/auth_client.gd",
		],
		"research_refs": ["RESEARCH.md:2528"],
	},
	"SetServerIdent": {
		"family": "AriesRuntime",
		"summary": "Stores the retail server-ident field in the login block.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scripts/net/auth_client.gd",
		],
		"research_refs": ["RESEARCH.md:631", "RESEARCH.md:2528"],
	},
	"CEShutDown": {
		"family": "Win32Runtime",
		"summary": "Kesmai communication-engine shutdown/runtime teardown entry.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
	},
	"DirectDrawCreate": {
		"family": "Win32Runtime",
		"summary": "DirectDraw runtime import used by the original Win32 renderer.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
	},
	"RtlUnwind": {
		"family": "Win32Runtime",
		"summary": "Windows runtime unwind support symbol.",
		"implementation_status": STATUS_EXTERNAL_RUNTIME,
	},
}

static var _entries_cache: Array = []
static var _entries_by_name_cache: Dictionary = {}


static func all() -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	return _entries_cache.duplicate(true)


static func by_function_name(name: String) -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	return (_entries_by_name_cache.get(name, {}) as Dictionary).duplicate(true)


static func by_group(group: String) -> Array:
	return _filter_by_field("group", group)


static func by_family(family: String) -> Array:
	return _filter_by_field("family", family)


static func by_status(status: String) -> Array:
	return _filter_by_field("implementation_status", status)


static func by_target(path_fragment: String) -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	var normalized := path_fragment.to_lower()
	var matches: Array = []
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		var targets := entry.get("godot_targets", []) as Array
		for target_v in targets:
			if str(target_v).to_lower().contains(normalized):
				matches.append(entry.duplicate(true))
				break
	return matches


static func metadata() -> Dictionary:
	return {
		"total_helpers": all().size(),
		"statuses": _counts_for_field("implementation_status"),
		"groups": _counts_for_field("group"),
		"families": _counts_for_field("family"),
	}


static func _build_cache() -> void:
	_entries_cache.clear()
	_entries_by_name_cache.clear()

	for function_v in FUNCTION_CATALOG_SCRIPT.all():
		var function_entry := function_v as Dictionary
		var function_name := str(function_entry.get("name", ""))
		if function_name.contains("_Cmd"):
			continue

		var group := str(function_entry.get("group", ""))
		var override := OVERRIDES.get(function_name, {}) as Dictionary
		var entry := {
			"name": function_name,
			"label": str(override.get("label", _humanize_name(function_name))),
			"address": function_entry.get("address", ""),
			"xref_count": function_entry.get("xref_count", 0),
			"group": group,
			"family": str(override.get("family", _default_family(function_name, group))),
			"summary": str(override.get("summary", _default_summary(function_name, group))),
			"implementation_status": str(override.get("implementation_status", _default_status(group))),
			"godot_targets": (override.get("godot_targets", _default_targets(group)) as Array).duplicate(true),
			"notes": (override.get("notes", []) as Array).duplicate(true),
			"research_refs": (override.get("research_refs", []) as Array).duplicate(true),
		}
		_entries_cache.append(entry)
		_entries_by_name_cache[function_name] = entry


static func _filter_by_field(field: String, value: String) -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	var normalized := value.strip_edges().to_lower()
	var matches: Array = []
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		if str(entry.get(field, "")).to_lower() == normalized:
			matches.append(entry.duplicate(true))
	return matches


static func _counts_for_field(field: String) -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	var counts := {}
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		var key := str(entry.get(field, "Unsorted"))
		counts[key] = int(counts.get(key, 0)) + 1
	return counts


static func _default_family(function_name: String, group: String) -> String:
	if group == "Combat":
		if function_name.contains("Anim") or function_name.contains("Animation"):
			return "Animation"
		if function_name.contains("Throttle") or function_name.contains("Jump") or function_name.contains("Motion") or function_name.contains("Landing") or function_name.contains("Contact") or function_name.contains("Movement"):
			return "Movement"
		if function_name.contains("Damage") or function_name.contains("Effect"):
			return "CombatState"
		return "CombatHelper"
	if group == "World":
		if function_name.contains("MenuSelection") or function_name.contains("Submit") or function_name.contains("Shortcut") or function_name.contains("Hotkey"):
			return "WorldSubmit"
		return "WorldUI"
	if group == "Mech":
		return "MechRuntime"
	if group == "Audio":
		return "AudioRuntime"
	if group == "Network":
		return "AriesRuntime"
	return "Win32Runtime"


static func _default_summary(function_name: String, group: String) -> String:
	return "%s helper: %s." % [group, _humanize_name(function_name)]


static func _default_status(group: String) -> String:
	if group in ["Network", "System"]:
		return STATUS_EXTERNAL_RUNTIME
	return STATUS_METADATA_ONLY


static func _default_targets(group: String) -> Array:
	match group:
		"Combat":
			return [
				"res://scenes/combat/combat.gd",
				"res://scripts/net/arena_client.gd",
			]
		"World":
			return [
				"res://scenes/world/world.gd",
				"res://scripts/net/world_client.gd",
				"res://scripts/net/world_travel_client.gd",
			]
		"Mech":
			return [
				"res://scripts/assets/mec_parser.gd",
				"res://scenes/combat/combat.gd",
				"res://scenes/mech/mech_select.gd",
			]
		"Audio":
			return [
				"res://scripts/audio/audio_manager.gd",
			]
		"Network":
			return [
				"res://scripts/net/server_bridge.gd",
				"res://scripts/net/ws_client.gd",
				"res://scripts/net/auth_client.gd",
			]
		_:
			return []


static func _humanize_name(function_name: String) -> String:
	var trimmed := function_name.trim_suffix("_v129")
	var parts := trimmed.split("_")
	var humanized: PackedStringArray = []
	for part_v in parts:
		humanized.append(_humanize_token(str(part_v)))
	return " ".join(humanized)


static func _humanize_token(token: String) -> String:
	if token.is_empty():
		return token
	var out := ""
	for i in token.length():
		var ch := token[i]
		if i > 0 and ch >= "A" and ch <= "Z":
			var prev := token[i - 1]
			if prev != " " and not (prev >= "A" and prev <= "Z"):
				out += " "
		out += ch
	return out
