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
	"Combat_SetJumpJetAnimationState_v129": {
		"family": "Animation",
		"summary": "Switches an actor animation controller into the jump-jet / airborne start state.",
		"notes": [
			"Thin wrapper over Combat_SetActorAnimationState_v129 with retail state id `4`.",
			"Combat_JumpJetInputTick_v129 uses it for the local actor, and Combat_Cmd70_ActorAnimState_v129 reuses the same wrapper for remote actor state updates.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClearAirborneFlagsAndSetIdleAnimation_v129": {
		"family": "Animation",
		"summary": "Clears the retail airborne state bits on an actor record and returns its animation controller to idle.",
		"notes": [
			"Clears the actor runtime flags at bit `0x80` and bit `0x01` on the owning mech record before delegating to Combat_SetActorAnimationState_v129 with state id `0`.",
			"Used when landing / ground-contact handling or the remote cmd70 state machine needs to exit the airborne path without starting the collapse animation branch.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetGroundedIdleAnimation_v129": {
		"family": "Animation",
		"summary": "Marks the actor grounded in the runtime record and switches the animation controller to idle.",
		"notes": [
			"Refreshes the keyed ground-contact field at actor offset `0x35e`, then delegates to Combat_SetActorAnimationState_v129 with retail state id `0`.",
			"Retail uses it as the callback target after several remote cmd70 stop-transition wrappers complete their intermediate settle animations.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetGroundedMovementAnimation_v129": {
		"family": "Animation",
		"summary": "Marks the actor grounded in the runtime record and switches the animation controller into the ordinary movement loop.",
		"notes": [
			"Refreshes the keyed ground-contact field at actor offset `0x35e`, then delegates to Combat_SetActorAnimationState_v129 with retail state id `1`.",
			"Combat_Cmd70_ActorAnimState_v129 uses it for remote state updates, while Combat_UpdateLocalMovementHudAndAnimation_v129 drives the same state id directly for the local actor when forward speed is non-zero.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetAnimationNodeStatePoseDisabledByTag_v129": {
		"family": "Animation",
		"summary": "Sets or clears the per-node flag that suppresses state-pose interpolation for the tagged animation node.",
		"notes": [
			"Looks up the node index from the controller's tag table and toggles the bit in controller mask `+0x58` for that node.",
			"Combat_BuildAnimationNodePoseRecursive_v129 checks that mask before calling Combat_FindAnimationStateDefinitionById_v129; when the bit is set, the node skips the state's interpolated Euler/translation triplets and uses only its baked local transform plus any enabled runtime rotation offset.",
			"Combat_UpdateLocalMovementHudAndAnimation_v129 and Combat_CollectVisibleActorRenderEntries_v129 use it to suppress selected node-state poses while live movement / presentation overrides are active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetAnimationNodeRotationOffsetEnabledByTag_v129": {
		"family": "Animation",
		"summary": "Sets or clears the per-node flag that applies the controller's additive rotation-offset triplet to the tagged animation node.",
		"notes": [
			"Looks up the node index from the controller's tag table and toggles the bit in controller mask `+0x5c` for that node.",
			"Combat_BuildAnimationNodePoseRecursive_v129 checks that mask before applying the node matrix; when enabled, it adds the node's runtime Euler offset from the controller table at `+0x30` onto the interpolated state-pose angles.",
			"Combat_AccumulateTorsoYawOffset_v129, Combat_AccumulateUpperBodyPitchOffset_v129, Combat_RecenterUpperBodyAimOffsets_v129, Combat_ProcessWeaponBankFilterInput_v129, and Combat_CollectVisibleActorRenderEntries_v129 use it to gate live torso / upper-body orientation overrides per node tag.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
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
	"Combat_SendLocalMechContactUpdate_v129": {
		"family": "CombatWire",
		"summary": "Sends the retail local-mech contact update for the remote actor hit by the local collision response.",
		"notes": [
			"Only called from Combat_ProcessLocalMechContact_v129 after a local collision against another active mech is confirmed. Encodes the contacted actor through the shared slot-to-network lookup table at `DAT_0047e138`, then writes three local motion components from the active contact/rebound vector fields into the outbound combat stream.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SendLocalMotionUpdate_v129": {
		"family": "CombatWire",
		"summary": "Packages the periodic retail local-motion update after the local actor pose has been integrated for the current combat tick.",
		"notes": [
			"Called from Combat_MainLoop_v129 immediately after Combat_IntegrateActorMotion_v129 finishes updating the local actor state for the tick.",
			"Rate-limits outbound movement frames, computes the current forward-speed component, and then appends either opcode `0x08` or opcode `0x09` depending on whether the encoded pose needs the extra attitude fields.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/net/ws_client.gd",
		],
	},
	"Combat_ComputeActorBearingToActor_v129": {
		"family": "Movement",
		"summary": "Computes the retail planar bearing from one actor to another in the engine's signed heading units.",
		"notes": [
			"Builds the target-minus-source planar delta from the actor world positions, handles the vertical-axis special case, and otherwise converts the slope through the retail arctangent helper into the same heading scale used by local chassis facing. Combat_ProcessLocalMechContact_v129 uses it to align the local actor's rebound orientation against the contacted mech.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeVelocityMagnitude3_v129": {
		"family": "Movement",
		"summary": "Returns the magnitude of a 3-axis retail velocity vector.",
		"notes": [
			"Computes `sqrt(x*x + y*y + z*z)` for the supplied fixed-point motion components. Combat_ProcessLocalMechContact_v129 uses it for both the local actor and the contacted mech when scaling the rebound impulse after a collision.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeArcTanDegreesFromScaledRatio_v129": {
		"family": "CombatMath",
		"summary": "Converts a signed slope ratio scaled by 1000 into a signed degree angle with the retail arctangent lookup table.",
		"notes": [
			"Uses the monotonic word table at `DAT_00480540` to approximate arctangent and returns a signed degree value in the `[-90, 90]` range, saturating when the absolute scaled ratio exceeds the table domain.",
			"Combat_ComputeActorBearingToActor_v129 uses it for planar bearing recovery, and Combat_ComputeEffectAimAnglesToPoint_v129 uses it for both pitch and yaw before scaling the result into the engine's `0xb6` angle units.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_TickRemoteActorPresentationState_v129": {
		"family": "CombatOverlay",
		"summary": "Advances one remote actor's presentation state and rebuilds the render matrices used by the combat overlay passes.",
		"notes": [
			"Only called for remote actors before world-marker rendering and before the active-actor pose collection pass. Applies the pending turn and pitch deltas against the elapsed time since the last actor update, integrates motion, updates the primary model matrix, and refreshes the secondary facing matrix used by later overlay draws.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ProcessMouseUpperBodyAimInput_v129": {
		"family": "UpperBodyControl",
		"summary": "Reads mouse displacement and feeds the local torso-yaw and upper-body pitch accumulators.",
		"notes": [
			"Recent v1.29 decomp shows it hides the active cursor, reads the raw screen-space displacement, applies those deltas into the same +/-0x1ffe accumulators used for outbound upper-body motion fields, and then warps the pointer back to the fixed `(0x140, 0x0f0)` aim origin through Frame_SetCursorScreenPos_v129.",
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
	"Combat_MultiplyFixedMatrix4x4_v129": {
		"family": "CombatMath",
		"summary": "Multiplies two retail 4x4 fixed-point transform matrices into an output matrix.",
		"notes": [
			"Uses the retail 16.16 fixed-point matrix convention, accumulating each row/column dot product with a right shift by 16 before writing the 16 output cells. Shared by animation-pose recursion, attachment rendering, projectile/effect transforms, and other combat-space transform paths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CopyFixedMatrix4x4_v129": {
		"family": "CombatMath",
		"summary": "Copies one retail 4x4 fixed-point transform matrix into another buffer.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildInverseAffineMatrix4x4_v129": {
		"family": "CombatMath",
		"summary": "Builds the retail inverse-affine 4x4 transform used to move points from world space into local combat space.",
		"notes": [
			"Transposes the upper-left 3x3 basis block and negates the translation vector while preserving the affine tail terms, matching the transform form expected by the retail point-transform helpers. Used by preview/camera-space callers before projecting or testing attachment points.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SetFixedMatrix4x4Identity_v129": {
		"family": "CombatMath",
		"summary": "Initializes a retail 4x4 fixed-point matrix to the identity transform.",
		"notes": [
			"Sets the diagonal to `0x10000` and all other cells to zero, which is the retail 16.16 fixed-point identity matrix. Shared by combat startup, preview-panel setup, pose builders, and projectile/effect state resets.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ComputeFixedSinCos_v129": {
		"family": "CombatMath",
		"summary": "Computes retail 16.16 fixed-point sine and cosine values for one combat angle.",
		"notes": [
			"Interpolates between adjacent entries in the retail trigonometric lookup tables at `DAT_0047ff98`/`DAT_0047ff9c` using the 14-bit angle remainder, writing the sine to the first output pointer and the cosine to the second.",
			"Shared by the matrix rotation helpers, tactical radar heading markers, effect trail spawning, and frame circle-sector fills that need the same fixed-angle basis vectors.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_TransformPointListByMatrix4x4_v129": {
		"family": "CombatMath",
		"summary": "Transforms a strided list of retail combat points through a 4x4 fixed-point matrix.",
		"notes": [
			"Treats each source element as a 6-int record, rotating and translating the leading xyz triplet through the supplied matrix while copying the trailing three metadata ints unchanged into the destination record.",
			"Terrain-scenery projection, sky/ground backdrop, effect-strip, and other projected point-list paths reuse it when whole batches of combat-space points must be transformed together.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_TransformVectorByMatrix3x3_v129": {
		"family": "CombatMath",
		"summary": "Transforms one retail xyz vector by the rotational 3x3 basis of a fixed-point matrix.",
		"notes": [
			"Ignores the translation row and multiplies the input vector only by the matrix axes, making it suitable for direction, offset, and already-origin-relative point transforms.",
			"Used by tactical radar, actor preview/rendering, projectile/effect state, and cursor-hit helpers that need basis-only transforms without adding a world-space translation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ApplyEulerRotationTripletToMatrix4x4_v129": {
		"family": "CombatMath",
		"summary": "Applies a three-angle Euler rotation triplet onto an existing retail 4x4 transform matrix.",
		"notes": [
			"Consumes a `short[3]` rotation triplet and applies the non-zero angles in sequence to the destination matrix, matching the pose-builder path used for actor-root and per-node animation rotations.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RotateMatrix4x4AroundX_v129": {
		"family": "CombatMath",
		"summary": "Rotates a retail 4x4 transform matrix around the X axis by one fixed-point angle.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RotateMatrix4x4AroundY_v129": {
		"family": "CombatMath",
		"summary": "Rotates a retail 4x4 transform matrix around the Y axis by one fixed-point angle.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RotateMatrix4x4AroundZ_v129": {
		"family": "CombatMath",
		"summary": "Rotates a retail 4x4 transform matrix around the Z axis by one fixed-point angle.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ScaleMatrix4x4Axes_v129": {
		"family": "CombatMath",
		"summary": "Applies per-axis fixed-point scale factors to the X, Y, and Z columns of a retail 4x4 transform matrix.",
		"notes": [
			"Used after pose generation to apply actor, attachment, and effect scale vectors without disturbing the homogeneous tail column.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_TranslateMatrix4x4Local_v129": {
		"family": "CombatMath",
		"summary": "Applies a local-space translation onto a retail 4x4 transform matrix.",
		"notes": [
			"Adds the weighted homogeneous column into the X/Y/Z rows, matching a right-multiplied affine translation in the matrix's current local basis. Used by animation poses, actor previews, and effect rendering before parent/world composition.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InterpolateAnimationTranslationTriplet_v129": {
		"family": "Animation",
		"summary": "Samples one animation state's translation track at the requested frame and writes the interpolated X/Y/Z triplet.",
		"notes": [
			"Walks the translation keyframe times in the transform-animation state block, selects the surrounding samples, and linearly interpolates each axis when the requested frame falls between keys.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InterpolateAnimationEulerAngles_v129": {
		"family": "Animation",
		"summary": "Samples one animation state's rotation track, resolves angle wraparound, and converts the result into the retail fixed-angle triplet.",
		"notes": [
			"Interpolates the three stored rotation channels with wraparound across the `-180/180` boundary and multiplies the result by the retail degrees-to-angle scaling factor before pose composition.",
		],
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
	"Combat_AllocateTransformAnimation_v129": {
		"family": "Animation",
		"summary": "Allocates the retail transform-animation state table and per-state translation/rotation track buffers.",
		"notes": [
			"The allocator error strings explicitly identify this routine as `AllocTransAnim`. It sizes the shared transform-animation container from the incoming state descriptor list, allocates zeroed per-state translation and rotation key arrays, and records the highest referenced state id so later loaders can populate the track table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetActorAnimationCache_v129": {
		"family": "Animation",
		"summary": "Clears the shared retail actor-animation cache table used to reuse loaded animation assets across actor instances.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateActorAnimationInstance_v129": {
		"family": "Animation",
		"summary": "Allocates one retail actor animation instance, reusing cached animation object/state resources when available.",
		"notes": [
			"Used by both combat actor-add and local-actor init paths. Allocates the per-instance matrices and pose buffers, seeds default scale to `0x20000`, loads or reuses the shared animation object/state pair for the requested actor animation id, and attaches a freshly allocated transform-animation table through Combat_AllocateTransformAnimation_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FindActorAnimationTrackByStateTag_v129": {
		"family": "Animation",
		"summary": "Returns one actor-animation track record from a retail animation instance by state tag.",
		"notes": [
			"Walks the instance's state-tag table and returns the matching 10-byte track record from the instance-local track array. The local and remote actor init paths use it to cache the special state-tag records for tags `0x1f` and `0x01` immediately after Combat_AllocateActorAnimationInstance_v129 succeeds.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeActorAnimationInstance_v129": {
		"family": "Animation",
		"summary": "Releases one retail actor animation instance and decrements the shared animation-cache reference count.",
		"notes": [
			"When the cached animation object/state pair's refcount reaches zero, frees both cached resources before releasing the instance-local pose tables and transform-animation structure.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadCached3dObjectRecord_v129": {
		"family": "AnimationIO",
		"summary": "Returns one cached parsed 3d object record by id, loading it from the shared archive path on first use.",
		"notes": [
			"Maintains a 10-entry cache of parsed object records and reuses an existing entry when the requested id is already loaded. On cache miss it opens the shared combat archive path, loads the indexed record through Combat_LoadIndexed3dObjectRecord_v129, and stores the parsed result in the cache.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Free3dObjectRecordCache_v129": {
		"family": "AnimationIO",
		"summary": "Frees the cached 3d object record table and every parsed record it owns.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Free3dObjectRecord_v129": {
		"family": "AnimationIO",
		"summary": "Frees one parsed 3d object record and all of its nested arrays.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadAnimationKeyframeSet_v129": {
		"family": "Animation",
		"summary": "Loads one retail animation keyframe-set asset from `keyframe.bin` or an `anim\\%04d_.bin` archive entry.",
		"notes": [
			"Uses the shared indexed-directory helper to seek the requested entry, then parses the per-state keyframe tracks through Combat_ParseAnimationKeyframeSet_v129. On parse failure it drops the cached directory and frees any partially built keyframe-set structure.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ParseAnimationKeyframeSet_v129": {
		"family": "Animation",
		"summary": "Parses one retail animation keyframe-set record and allocates its per-state transform-animation blocks.",
		"notes": [
			"Reads the state count, allocates one 10-byte descriptor per state, and fills each descriptor through the nested keyframe-set record parser before returning the assembled table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ParseAnimationStateTrackSet_v129": {
		"family": "Animation",
		"summary": "Parses one animation state's track-set header and allocates the nested transform track records for that state.",
		"notes": [
			"Reads the state id/flags/count header, allocates one 0x16-byte nested track record per entry, and normalizes the stored frame-duration field into the fixed-point units expected by later pose sampling.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ParseAnimationTransformTrackPair_v129": {
		"family": "Animation",
		"summary": "Parses one nested animation transform-track pair consisting of vector samples plus frame-time arrays.",
		"notes": [
			"Loads the first vector/time stream, then the second vector/time stream, and converts each stored frame time into the fixed-point units later used by animation interpolation. The two streams match the translation/rotation pair consumed by the retail pose builders.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeTransformAnimation_v129": {
		"family": "Animation",
		"summary": "Frees a retail transform-animation table and all nested translation/rotation track buffers.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeAnimationKeyframeSet_v129": {
		"family": "Animation",
		"summary": "Frees a parsed retail animation keyframe-set and all nested translation/rotation track buffers.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Load3dObjectDefinition_v129": {
		"family": "Animation",
		"summary": "Loads one retail 3d object definition from `3dobj.bin` or an `anim\\%04d_.bin` archive entry.",
		"notes": [
			"Uses the shared indexed-directory helper to seek the requested object id, then parses the object header, node tables, and attachment sections through Combat_Parse3dObjectDefinition_v129. The loader keeps a cached directory per source archive and drops that cache when parsing fails.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Parse3dObjectDefinition_v129": {
		"family": "Animation",
		"summary": "Parses one retail 3d object definition into the in-memory node, attachment, and mesh-reference tables used by combat rendering.",
		"notes": [
			"Reads the fixed 0x4ba-byte object header/body, then expands the variable sections with the downstream object-table parsers before returning the assembled object definition.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Parse3dObjectRecordTable_v129": {
		"family": "AnimationIO",
		"summary": "Parses the variable-length table of 3d object records embedded in a retail 3d object definition.",
		"notes": [
			"Allocates one 100-byte parsed record per entry, fills each record through the standalone record-table parsers, and resolves the definition's label-based cross-record references into direct pointers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Free3dObjectDefinition_v129": {
		"family": "Animation",
		"summary": "Frees a parsed retail 3d object definition and all nested attachment/model buffers.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SeekIndexedAssetById_v129": {
		"family": "AnimationIO",
		"summary": "Looks up an asset id in a cached retail indexed-directory table and seeks the archive handle to that entry.",
		"notes": [
			"Walks the cached `(id, offset)` table, seeks the archive to the matching payload offset, and consumes the 4-byte record header so the caller lands on the entry body.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ReadAssetBytesExact_v129": {
		"family": "AnimationIO",
		"summary": "Reads an exact byte count from the current retail asset stream and reports failure on short reads.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateAssetBuffer_v129": {
		"family": "AnimationIO",
		"summary": "Allocates an asset buffer when the requested size is non-zero.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeAssetBuffer_v129": {
		"family": "AnimationIO",
		"summary": "Frees an asset buffer when the supplied pointer is non-null.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_WriteClampedSpriteScaleTableRow_v129": {
		"family": "AnimationIO",
		"summary": "Quantizes one generated sprite-scale table row to bytes, clamps it to the requested scale bound, and writes it to the open `.scl` file.",
		"notes": [
			"Converts each generated sample through `__ftol`, stores the byte in the caller-provided row buffer, clamps values above `scale_id - 1`, and writes the final byte stream one element at a time.",
			"Combat_GenerateSpriteScaleTableFile_v129 uses it for every generated row before the sprite-scale cache is reused by the combat effect-animation loader.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_GenerateSpriteScaleTableFile_v129": {
		"family": "AnimationIO",
		"summary": "Builds one sprite-scale table in memory and serializes it as `spr_%d.scl` when the cache file is missing.",
		"notes": [
			"Opens the requested `.scl` file for write, chooses the generated row count from the scale id, writes the 6-byte table header, builds the in-memory triangular scale table, and streams each row through Combat_WriteClampedSpriteScaleTableRow_v129.",
			"Combat_GetOrCreateSpriteScaleTable_v129 falls back to this helper when the cached scale file is absent or unreadable.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateSpriteScaleTableBuffers_v129": {
		"family": "AnimationIO",
		"summary": "Allocates the triangular byte buffer and per-row pointer table for one sprite-scale table.",
		"notes": [
			"Allocates `(rows + 1) * rows / 2` bytes for the triangular table payload, then allocates the row-pointer array and seeds each row pointer to the correct offset inside the packed payload buffer.",
			"Both Combat_LoadSpriteScaleTableFile_v129 and Combat_GenerateSpriteScaleTableFile_v129 rely on it before they fill or persist the table contents.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadSpriteScaleTableFile_v129": {
		"family": "AnimationIO",
		"summary": "Loads one cached sprite-scale table from an open `.scl` file into the packed runtime buffers.",
		"notes": [
			"Reads the 6-byte header, validates the version field, allocates the packed table buffers through Combat_AllocateSpriteScaleTableBuffers_v129, and then reads the triangular byte payload into the allocated row storage.",
			"Combat_GetOrCreateSpriteScaleTable_v129 uses it on the hot path when a previously generated `spr_%d.scl` file is already present on disk.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_GetOrCreateSpriteScaleTable_v129": {
		"family": "AnimationIO",
		"summary": "Returns the cached sprite-scale table for one scale id, loading `spr_%d.scl` or generating it on first use.",
		"notes": [
			"Searches the small in-memory sprite-scale cache first, then opens the `spr_%d.scl` file for the requested scale id and loads it through Combat_LoadSpriteScaleTableFile_v129 when available.",
			"If the file is missing or invalid it regenerates the table through Combat_GenerateSpriteScaleTableFile_v129, caches the finished table, and returns the new record to the combat effect-animation loader.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClearSpriteScaleTableCache_v129": {
		"family": "AnimationIO",
		"summary": "Frees every cached sprite-scale table and resets the small in-memory `.scl` cache.",
		"notes": [
			"Walks the compact sprite-scale cache rooted at `DAT_004e82d0`, frees both the triangular payload buffer and the row-pointer array for each populated entry, clears the entry fields, and then resets the active cache count.",
			"Combat_FreeDefaultEffectAnimations_v129 calls it during result-scene teardown after the default combat effect animations are released.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitializeEffectAnimationCaches_v129": {
		"family": "AnimationIO",
		"summary": "Allocates and zeroes the retail combat effect-animation caches before default effect assets are loaded.",
		"notes": [
			"Allocates the global effect-frame, effect-slot, and active-instance tables, zeroes the newly allocated buffers, and reports the retail allocation failures through the shared BTERR path when any buffer cannot be created.",
			"Combat_Cmd72_InitLocalActor_v129 calls it immediately before Combat_LoadDefaultEffectAnimations_v129 during local combat scene bootstrap.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeEffectAnimationCaches_v129": {
		"family": "AnimationIO",
		"summary": "Frees the three global combat effect-animation cache buffers and clears their pointers.",
		"notes": [
			"Releases the global effect-frame, effect-slot, and active-instance buffers allocated by Combat_InitializeEffectAnimationCaches_v129 when they are present, then nulls each shared pointer.",
			"Combat_Cmd63_ResultSceneInit_v129 calls it during result-scene teardown after the default effect animations themselves have been released.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeDefaultEffectAnimations_v129": {
		"family": "AnimationIO",
		"summary": "Releases the cached default combat effect animations and clears the shared sprite-scale cache.",
		"notes": [
			"Frees effect-animation slots `0`, `1`, and `3`, which are the default explosion, smoke, and acknowledgement-burst animations loaded during combat init, then drops the cached sprite-scale tables through Combat_ClearSpriteScaleTableCache_v129.",
			"Combat_Cmd63_ResultSceneInit_v129 uses it while tearing down the previous combat presentation state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadDefaultEffectAnimations_v129": {
		"family": "AnimationIO",
		"summary": "Loads the default combat explosion, smoke, and acknowledgement-burst effect animations into the retail effect-animation slots.",
		"notes": [
			"Builds the three fixed animation paths for `boom64.anm`, `smoke64.anm`, and `ack64.anm`, loads them into slots `0`, `1`, and `3` through Combat_LoadEffectAnimationSlot_v129, and clears their optional slot-link pointers afterward.",
			"Combat_Cmd72_InitLocalActor_v129 calls it after Combat_InitializeEffectAnimationCaches_v129 so the baseline combat effect assets are ready before the battle scene starts.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadEffectAnimationSlot_v129": {
		"family": "AnimationIO",
		"summary": "Loads one `.anm` effect animation file into the requested retail effect-animation slot.",
		"notes": [
			"Reads the fixed-size animation header into the chosen slot record, allocates the palette/pixel payload buffers sized by the file header, reads both payload blocks from disk, and resolves the referenced sprite-scale table through Combat_GetOrCreateSpriteScaleTable_v129.",
			"Combat_LoadDefaultEffectAnimations_v129 uses it for the three baseline combat effect animations seeded during local-actor initialization.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeEffectAnimationSlot_v129": {
		"family": "AnimationIO",
		"summary": "Frees the palette and pixel payload buffers owned by one retail effect-animation slot.",
		"notes": [
			"Checks the slot index against the ten-entry effect-animation cache, frees the slot's two owned payload buffers when present, and clears the stored pointers afterward.",
			"Combat_FreeDefaultEffectAnimations_v129 uses it on slots `0`, `1`, and `3` during result-scene teardown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetEffectAnimationSlotScaleLinks_v129": {
		"family": "AnimationIO",
		"summary": "Sets the smaller/larger scale-neighbor links used when an effect animation slot needs to swap to a better size variant.",
		"notes": [
			"Stores optional neighbor pointers on one effect-animation slot record so the renderer can walk toward a smaller-scale variant when the projected size is tiny or toward a larger-scale variant when the projected size outgrows the current frames.",
			"Combat_LoadDefaultEffectAnimations_v129 currently clears both links for the default explosion, smoke, and acknowledgement-burst slots.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitializeTerrainSceneryField_v129": {
		"family": "TerrainScenery",
		"summary": "Builds the retail terrain-scenery field for the current combat map and clears the shared indexed-directory cache afterward.",
		"notes": [
			"Called during combat visual bootstrap after terrain assets are selected. Wraps Combat_BuildTerrainSceneryField_v129, logs the retail allocation/load failure string on error, and always drops the shared indexed-directory caches before returning.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildTerrainSceneryField_v129": {
		"family": "TerrainScenery",
		"summary": "Allocates the temporary placement inputs, loads the indexed terrain object table, and assembles the current combat map's terrain-scenery field.",
		"notes": [
			"Builds the placement-band table, ensures the shared indexed directory is loaded for the selected terrain archive, groups candidate object records by scenery-class bitmasks, and passes the assembled inputs to Combat_PopulateTerrainSceneryField_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateTerrainSceneryPlacementBands_v129": {
		"family": "TerrainScenery",
		"summary": "Allocates and seeds the default terrain-scenery placement-band table for the active terrain type.",
		"notes": [
			"Creates two 0x20-byte band records with per-terrain count and size ranges derived from the terrain id selected through Combat_SetTerrainAssetSet_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeTerrainSceneryPlacementBands_v129": {
		"family": "TerrainScenery",
		"summary": "Frees the temporary terrain-scenery placement-band table.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildTerrainSceneryObjectGroups_v129": {
		"family": "TerrainScenery",
		"summary": "Groups indexed terrain object records into scenery-class buckets based on their retail flag bits.",
		"notes": [
			"Walks the shared `(id, offset)` directory table, rejects records with the `0x80` flag bit, and stores matching ids into four buckets keyed by the class mask table rooted at `DAT_0047f76c`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateTerrainSceneryObjectGroups_v129": {
		"family": "TerrainScenery",
		"summary": "Allocates the four-bucket terrain-scenery object-group table used during placement.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeTerrainSceneryObjectGroups_v129": {
		"family": "TerrainScenery",
		"summary": "Frees the temporary terrain-scenery object-group table and any per-bucket id arrays it owns.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_PopulateTerrainSceneryField_v129": {
		"family": "TerrainScenery",
		"summary": "Allocates the final terrain-scenery instance table, chooses random candidates from the grouped records, and seeds each instance's transform and scale.",
		"notes": [
			"Computes the total object count from the placement bands, allocates the shared `0xbe`-byte instance table, chooses a random candidate group per band, places each object through Combat_PlaceTerrainSceneryInstanceWithoutOverlap_v129, loads the chosen 3d object record, then derives planar extent and uniform scale before composing the final transform matrix.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateTerrainSceneryInstances_v129": {
		"family": "TerrainScenery",
		"summary": "Allocates the shared terrain-scenery instance array at `DAT_0047f728`.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_PlaceTerrainSceneryInstanceWithoutOverlap_v129": {
		"family": "TerrainScenery",
		"summary": "Chooses a random non-overlapping position and radius for one terrain-scenery instance.",
		"notes": [
			"Samples random planar coordinates, rejects placements that overlap previously placed scenery or the blocker list decoded by Combat_DecodeTerrainSceneryConfig_v129, and stores the accepted position/radius back into the instance entry.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Compute3dObjectPlanarRadius_v129": {
		"family": "TerrainScenery",
		"summary": "Computes the maximum planar radius of a parsed 3d object record from its vertex table.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeTerrainSceneryScaleForRadius_v129": {
		"family": "TerrainScenery",
		"summary": "Converts a target scenery radius and raw object extent into the fixed-point uniform scale used by retail terrain object placement.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetTerrainAssetSet_v129": {
		"family": "TerrainScenery",
		"summary": "Selects the active retail terrain asset set and formats the matching `terrain\\ter_%03d.*` filenames.",
		"notes": [
			"Stores the normalized terrain id and formats the archive, metadata, and palette paths later consumed by the terrain scenery and palette loaders.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadTerrainPaletteOverrides_v129": {
		"family": "TerrainScenery",
		"summary": "Loads the selected terrain palette file and seeds missing RGB triples into the shared terrain-scenery color table.",
		"notes": [
			"Reads `terrain\\ter_%03d.pal`, then only fills color entries whose current RGB triple is still zero so earlier explicit colors are preserved.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetActiveTerrainPaletteTable_v129": {
		"family": "TerrainScenery",
		"summary": "Installs the active terrain palette table for the combat scene, copying it into the runtime palette buffer and marking every entry dirty.",
		"notes": [
			"Stores the selected palette-table pointer in the shared terrain palette global, bulk-copies the 0x201 dword table into the combat runtime buffer at `DAT_00489c80`, and writes `0xff` into each entry's dirty byte so later palette-apply and palette-fade helpers rebuild from the new terrain palette state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ApplyActiveTerrainPaletteForDuration_v129": {
		"family": "TerrainScenery",
		"summary": "Applies the active combat terrain palette working copy immediately and arms a short restore deadline.",
		"notes": [
			"Only runs while the retail combat presentation mode byte `DAT_0047c8d4` is `4`. It applies the runtime terrain palette buffer at `DAT_00489c80` through Frame_ApplyBitmapPalette_v129 and stores `DAT_0047cbb0 + param_1` into `DAT_0048a490` so the main loop can restore `DAT_0047cbbc` after the timeout expires.",
			"Combat_ApplyDamagePairOrQueueEffect_v129 and Combat_ResolveProjectileImpactDamage_v129 both call it with a duration of `7` ticks when the local actor takes immediate impact damage.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_DecodeTerrainSceneryConfig_v129": {
		"family": "TerrainScenery",
		"summary": "Decodes the local-actor terrain-scenery config payload, including scenery class masks and no-place blocker circles.",
		"notes": [
			"Called from Combat_Cmd72_InitLocalActor_v129. Stores the incoming scenery class mask table pointer, decodes a count of blocker circles, and fills the shared `(x, y, radius)` blocker list later consulted by Combat_PlaceTerrainSceneryInstanceWithoutOverlap_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeTerrainSceneryPlacementBlockerTable_v129": {
		"family": "TerrainScenery",
		"summary": "Frees the decoded terrain-scenery placement blocker table and clears its shared pointer.",
		"notes": [
			"Releases the heap buffer rooted at `DAT_0047f764`, which Combat_DecodeTerrainSceneryConfig_v129 allocates as the decoded `(x, y, radius)` blocker-circle table used by Combat_PlaceTerrainSceneryInstanceWithoutOverlap_v129.",
			"Combat_Cmd63_ResultSceneInit_v129 calls it during combat/result teardown before the next terrain-scenery config is decoded.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_DecodeTerrainProjectionOutlinePoints_v129": {
		"family": "TerrainScenery",
		"summary": "Decodes the capped local-actor terrain projection outline point list used by the retail tactical projection overlay.",
		"notes": [
			"Called from Combat_Cmd72_InitLocalActor_v129. Reads a point-count byte into `DAT_004f578c`, decodes each `(x, y)` pair as two 3-byte arguments, subtracts the shared world-origin bias `0x018e4258`, and stores the resulting points into the outline table rooted at `DAT_004f69e0`.",
			"When more than ten points arrive it still consumes the extra encoded pairs from the inbound stream, but only the first ten survive and `DAT_004f578c` is clamped back to `10`. Combat_RenderTerrainSceneryProjection_v129 later injects the Z plane and projects those stored points into the radar/world-marker overlay.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_DecodeLocalActorMechState_v129": {
		"family": "MechRuntime",
		"summary": "Decodes the cmd72 local-actor mech state block, including the backing mech record, component state tables, and trailing label string.",
		"notes": [
			"Starts by decoding the mech id, loading the decoded mech record through Mech_AllocateAndLoadRecordById_v129, caching that pointer into the local actor block at `+0x21e`, and then seeding the runtime and component-status regions through Mech_InitRuntimeStateFromRecord_v129 and Mech_InitComponentStatusFromRecord_v129.",
			"After the mech record is in place it decodes several XOR-protected byte and type-1 argument tables into the local actor arrays at `+0x18c`, `+0x164`, `+0x14e`, `+0x20e`, and `+0x1e6`, then copies a capped `0x1f`-byte string span into the actor block at `+0x2da`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"Combat_QueryTerrainScenerySupportAtCoord_v129": {
		"family": "TerrainScenery",
		"summary": "Queries the active terrain-scenery field for a supporting face under a world-space coordinate and fills the retail ground-contact record.",
		"notes": [
			"Resets the output contact flags, finds the containing scenery instance through Combat_FindTerrainSceneryInstanceAtCoord_v129, transforms that object's face vertices into world space, checks whether the query point lies inside any candidate polygon, and records the supporting plane height through Combat_ComputeTerrainSceneryFaceHeightAtCoord_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FindTerrainSceneryInstanceAtCoord_v129": {
		"family": "TerrainScenery",
		"summary": "Finds the active terrain-scenery instance whose placement radius contains the given world-space X/Y coordinate.",
		"notes": [
			"Can either scan the full instance array or probe one specific scenery index when the caller already narrowed the candidate. Only instances with the active-placement flag bit set are considered.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeTerrainSceneryFaceHeightAtCoord_v129": {
		"family": "TerrainScenery",
		"summary": "Evaluates the height of a terrain-scenery support face at the given world-space X/Y coordinate.",
		"notes": [
			"When the candidate face is not already flat, solves the face plane equation from the transformed vertex basis vectors and returns the corresponding Z height. Returns `-1` when the face has no usable vertical span.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FindContactMechAtCoord_v129": {
		"family": "Movement",
		"summary": "Finds another active mech whose collision cylinder overlaps the supplied world-space contact point.",
		"notes": [
			"Scans actors `1..7`, checks the planar radius test against each active mech, then verifies the point's Z coordinate falls within that mech's current vertical span before returning the owning actor record.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitializeActiveProjectileEffectSlots_v129": {
		"family": "CombatEffects",
		"summary": "Allocates and zeroes the retail active projectile/effect slot pool used by the combat effect update loop.",
		"notes": [
			"Called during combat visual bootstrap with a fixed slot count of `0x20`. The helper only allocates once, then clears every `0x1ff`-byte slot record before later spawn paths populate them.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_IntersectSegmentWithTerrainSceneryFace_v129": {
		"family": "TerrainScenery",
		"summary": "Intersects a world-space segment against the currently selected terrain-scenery face and returns the hit point when the segment crosses that polygon.",
		"notes": [
			"Rebuilds the candidate face plane from the owning scenery instance's transformed vertex table, normalizes the segment direction through Combat_NormalizeVector3InPlace_v129, and solves the segment/plane intersection through Combat_IntersectRayWithPlane_v129 only when the current face index resolves to a polygonal face.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_NormalizeVector3InPlace_v129": {
		"family": "TerrainScenery",
		"summary": "Normalizes a 3D vector in place and reports failure when the input vector is effectively zero-length.",
		"notes": [
			"Computes the vector magnitude from the three double-precision components, rejects vectors shorter than the retail epsilon in `DAT_00479068`, and otherwise divides each component by the magnitude. Combat_IntersectSegmentWithTerrainSceneryFace_v129 uses it to normalize the candidate segment direction before solving the face-plane hit.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_IntersectRayWithPlane_v129": {
		"family": "TerrainScenery",
		"summary": "Intersects a ray with a plane equation and returns both the hit point and the parametric distance when the ray faces the plane.",
		"notes": [
			"Treats the final parameter as a plane normal plus plane-distance term, computes the ray/plane denominator, and rejects parallel or back-facing hits through the status flag output. Combat_IntersectSegmentWithTerrainSceneryFace_v129 uses it after rebuilding a candidate terrain-scenery face plane.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_IsActorSegmentClearOfTerrainScenery_v129": {
		"family": "TerrainScenery",
		"summary": "Tests whether the 3D segment between two actor positions stays clear of solid terrain-scenery support geometry.",
		"notes": [
			"Projects the actor-to-actor segment against each active scenery instance's bounding radius and top height, then samples the candidate crossing point through Combat_QueryTerrainScenerySupportAtCoord_v129 to confirm whether that same instance blocks the segment.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderTerrainSceneryProjection_v129": {
		"family": "CombatOverlay",
		"summary": "Projects and draws the active terrain-scenery field into either the main combat camera or the tactical radar view.",
		"notes": [
			"The second parameter selects between the world camera surface (`DAT_004e6f20`) and the player-centered radar surface (`DAT_004e5fc0`). In both modes the helper rotates a shared basis, fills the destination panel, rasterizes the projected terrain outline list, and then renders each active scenery instance through Combat_RenderTerrainSceneryObjectRecord_v129.",
			"Combat_InitializeSharedRenderProjectionContexts_v129 seeds both projection-surface descriptors during combat presentation reset so the world-marker and tactical-radar paths can share the same fixed retail panel bounds and projection constants.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawTerrainProjectionOutline_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the closed outline for the already-projected terrain projection polygon on the target overlay surface.",
		"notes": [
			"Consumes the projected `(x, y)` point list built by Combat_RenderTerrainSceneryProjection_v129, wraps the last point back to the first, and emits one edge segment per pair by building a thin screen-space quad and submitting it to Combat_RasterizeFlatPolygon_v129.",
			"Combat_RenderTerrainSceneryProjection_v129 calls it with palette index `0x26` after projecting the stored terrain outline points so both the radar view and main combat overlay share the same closed boundary rendering.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RasterizeFlatPolygon_v129": {
		"family": "CombatRender3d",
		"summary": "Fills one screen-space polygon with a uniform palette index through the retail flat-polygon rasterizer.",
		"notes": [
			"Consumes the six-word-per-vertex screen-space polygon payload, clips the polygon bounds to the destination surface, walks the upper and lower scanline edges, and writes the constant palette byte stored in vertex field `2` across each covered span.",
			"Combat_DrawTerrainProjectionOutline_v129 uses it directly for the thin projected outline quads, and the same primitive matches the retail uniform-color polygon fill path referenced by the higher-level flat-shaded combat render helpers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RasterizeGouraudPolygon_v129": {
		"family": "CombatRender3d",
		"summary": "Fills one screen-space polygon while linearly interpolating an 8-bit shade value across each span.",
		"notes": [
			"Consumes the same six-word-per-vertex screen-space polygon payload as Combat_RasterizeFlatPolygon_v129, but treats vertex field `2` as the per-vertex shade term and linearly interpolates that byte across both polygon edges and horizontal spans before writing to the destination surface.",
			"No direct callers remain in the current xref graph, but the routine forms the companion interpolated-shade raster path beside the uniform-color filler and matches the same clipped scanline setup structure.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderActorWorldMarkers_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the retail world-screen actor marker overlays for the local actor and every active remote mech.",
		"notes": [
			"Called from Combat_MainLoop_v129. Reuses Combat_RenderTerrainSceneryProjection_v129 for the camera basis, projects a small marker mesh around each active actor, stores the resulting screen bounds into `DAT_0048a4a0`, and flashes the selected actor's world marker when the retail blink timer is armed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_DrawCombatHelpOverlay_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the retail combat help overlay bitmap onto the main combat frame when the help latch is active.",
		"notes": [
			"Blits the `CHLP` bitmap resource loaded by Combat_LoadVisualResourceTables_v129 at the fixed top-left combat overlay origin `(0x50, 0x00)`. Combat_MainLoop_v129 only calls it while the movement-input path keeps the combat help latch `DAT_004e4f60` active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawFrameRateOverlay_v129": {
		"family": "CombatOverlay",
		"summary": "Updates the rolling retail framerate sample and draws the FPS overlay string on the combat frame.",
		"notes": [
			"Accumulates a 30-frame timing window, converts the elapsed tick delta into a localized `XX.XX` fps string, and draws that debug readout at `(0x14, 0x55)` on the main combat surface. Combat_MainLoop_v129 calls it while the Ctrl+Shift debug-toggle latch keeps the framerate bit armed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawHeadingTapeHud_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the stacked retail heading-tape HUD for the local chassis and upper-body headings.",
		"notes": [
			"Called from Combat_MainLoop_v129 in the steady-state overlay path when the presentation mode is using the normal HUD instead of world markers. Draws the shared baseline and tick marks across the top of the combat frame, centers the lower heading tape on the local mech heading field, and centers the upper tape on the combined upper-body heading offset used by the aim/torso presentation state.",
			"Reuses the fixed `10`-through-`350` heading label strip with the cardinal markers `N`, `E`, `S`, and `W`, and applies the active zoom-state byte `DAT_004f6c38` to scale the tape spacing before forwarding each visible label through Combat_DrawOverlayTextLine_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawOffscreenActorEdgeMarkers_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the retail off-screen actor edge markers around the combat frame for active remote contacts.",
		"notes": [
			"Called from Combat_MainLoop_v129 only while the standard HUD overlay path is active instead of the full world-marker mode. Walks the active remote actors, checks their projected screen position fields, and places stacked markers along the left edge, right edge, or top edge whenever a contact falls outside the visible combat frame.",
			"Uses Combat_MapActorColorCodeToPaletteIndex_v129 to derive each contact color from the actor color code field, triggers the shared LASR cue auto-select path the first time a nonlocal contact enters the forward in-frame zone, and delegates the tiny arrow rasterization to Combat_DrawOffscreenActorEdgeMarker_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawOffscreenActorEdgeMarker_v129": {
		"family": "CombatOverlay",
		"summary": "Draws one small directional off-screen actor marker glyph on the combat frame edge.",
		"notes": [
			"Builds a clipped five-scanline arrow shape inside the main combat frame using the supplied palette index. The direction parameter selects the left-edge, right-edge, or downward top-edge glyph variant used by Combat_DrawOffscreenActorEdgeMarkers_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_MapActorColorCodeToPaletteIndex_v129": {
		"family": "CombatOverlay",
		"summary": "Maps a retail actor color code to the fixed palette index used by combat markers, radar blips, and status text.",
		"notes": [
			"Translates the eight retail actor color-code values into the hard-coded palette entries reused by Combat_RenderActorWorldMarkers_v129, Combat_RenderTacticalRadarPanel_v129, Combat_DrawOffscreenActorEdgeMarkers_v129, and the target-side header color in Combat_DrawActorStatusPanel_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawActorStatusPanel_v129": {
		"family": "CombatHud",
		"summary": "Draws the retail actor status side panel for the local mech or the currently selected target.",
		"notes": [
			"Returns unless the panel-mode byte `DAT_0047d2c4` selects either the local actor (`1`) or the current tracked target (`2`); in target mode it also requires the selected contact to remain active and visible before any rows are emitted.",
			"Builds the colored status rows for the torso, arm, leg, and detail sections, formats the header as either `MY %s` or `TARGET: %s`, appends the `Jets: %d Sinks: %d` summary plus the active weapon/detail rows, and forwards the resulting text layout through Combat_DrawOverlayTextLine_v129 on the fixed combat side-panel coordinates.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_GetActorPanelInterferenceLevel_v129": {
		"family": "CombatPreview",
		"summary": "Returns the current actor-panel interference level from the encoded local-actor combat state.",
		"notes": [
			"Called only by Combat_MainLoop_v129 immediately after Combat_DrawActorStatusPanel_v129. It XOR-decodes the local actor word at offset `0x1ae` using the current presentation-state seed `DAT_004f6c14`, then uses the resulting small integer as the interference level for the actor status and preview panels.",
			"Combat_MainLoop_v129 treats value `0` as the clean path, value `1` as the rolling partial-static path driven by Combat_FillRectWithRandomInterferenceRuns_v129, and values `>= 2` as the full static replacement path for the status / preview surfaces.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawOverlayTextLine_v129": {
		"family": "CombatOverlay",
		"summary": "Draws one clipped text line onto the main combat overlay surface.",
		"notes": [
			"Rejects coordinates outside the `320x240` combat frame, offsets the supplied x position by the retail combat-panel origin `0x50`, clamps the draw rectangle to a single 15-pixel text row, and forwards the string into Frame_DrawString_v129 using the active combat window font.",
			"Shared by the framerate overlay, tracked-target labels, compact voice status HUD, countdown timer, and several other combat overlay panels.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawTrackedActorScreenBracket_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the retail screen-space bracket around the currently tracked actor and, when enabled, its adjacent info label.",
		"notes": [
			"Uses the selected actor's projected world-marker bounds to draw a colored rectangle on the main combat surface, expands to a double frame for the locked presentation state, and calls Combat_DrawTrackedActorInfoLabel_v129 when the label toggle is enabled.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SelectNextTrackedActor_v129": {
		"family": "CombatOverlay",
		"summary": "Cycles the tracked-actor selection to the next eligible retail contact for the current presentation mode.",
		"notes": [
			"Called from Combat_HandlePresentationHotkey_v129 for the tracked-target hotkeys. Advances the shared tracked-actor index `DAT_004f6a58` through the eight actor slots, keeps only entries with the required active/visible flag set, and marks the chosen actor's presentation state so the bracket and label HUD redraw against the new tracked target.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawTrackedActorInfoLabel_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the tracked actor's three-line retail info label beside a world marker or screen bracket.",
		"notes": [
			"Formats the localized prefix string from message id `0xf8`, then prints the tracked actor's callsign, pilot/name line, and trailing status line at the supplied screen position when the label toggle flag is enabled.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"System_GetCentisecondTickCount_v129": {
		"family": "SystemRuntime",
		"summary": "Returns the retail monotonic tick count in centiseconds.",
		"notes": [
			"Wraps `timeGetTime()` and divides the millisecond result by ten, giving the 10 ms units used by the retail framerate sampler, countdown HUD, animation timers, and other combat overlay clocks.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"System_RoundFloatToNearestInt_v129": {
		"family": "SystemRuntime",
		"summary": "Rounds a float to the nearest integer using the retail `__ftol` helper plus a fractional-threshold check.",
		"notes": [
			"Converts the incoming float through `__ftol()`, then increments the truncated integer when the remaining fractional part exceeds the comparison constant at `DAT_00479010`.",
			"Combat_UpdateJumpFuelReserve_v129 uses it for the scaled airborne jump-fuel drain terms before the helper subtracts those deltas from the encrypted local reserve.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"System_IntegerSquareRoot_v129": {
		"family": "SystemRuntime",
		"summary": "Computes the integer square root of a non-negative retail fixed/range accumulator.",
		"notes": [
			"Uses a coarse repeated-quartering seed and then refines it with a Newton-style midpoint step until the candidate changes by at most one.",
			"Combat distance, speed, planar-radius, and tactical-radar callers reuse it to avoid floating-point square roots in the live simulation path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"System_UpdateCrc32_v129": {
		"family": "SystemRuntime",
		"summary": "Updates a running CRC32 accumulator over one byte buffer using the retail non-reflected polynomial stepper.",
		"notes": [
			"Shifts the accumulator left once per input bit and xors polynomial `0x04C11DB7` whenever the previous high bit was set, folding each byte from MSB to LSB.",
			"Combat_SendLocalActorStateChecksum_v129 reuses it to derive the outbound combat checksum reply from the selected local-actor and mech-record bytes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/arena_client.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_InitializeExecutableChecksumTable_v129": {
		"family": "SystemRuntime",
		"summary": "Builds the 256-entry reflected checksum table used by the retail executable self-check.",
		"notes": [
			"Generates the lookup table at `DAT_00498e00` one byte value at a time using the reflected CRC32 polynomial step that the nearby executable verifier reuses for each file chunk.",
			"System_VerifyExecutableChecksum_v129 calls it once before scanning the live `mpbtwin.exe` image on disk.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_VerifyExecutableChecksum_v129": {
		"family": "SystemRuntime",
		"summary": "Verifies the retail executable checksum before the frontend continues through startup.",
		"notes": [
			"Initializes the dedicated executable-checksum table and then delegates the actual on-disk scan to System_VerifyExecutableChecksumFromDisk_v129 while keeping the startup callsite narrow.",
			"It compares the computed value against the stored checksum dword at `DAT_0047febc`; Shell_RunFrontendMain_v129 aborts startup and reports the localized frontend error when this verifier returns false.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_VerifyExecutableChecksumFromDisk_v129": {
		"family": "SystemRuntime",
		"summary": "Opens the running retail executable from disk, skips the embedded checksum block, and verifies the remaining bytes against the stored checksum word.",
		"notes": [
			"Loads the current module path, opens that file through System_OpenFileDescriptor_v129, and rejects obviously short images before allocating the 16KB scratch buffer used for chunked reads.",
			"It hashes the protected prefix `[0, DAT_0047feb8)`, seeks past the embedded 16-byte checksum block at `DAT_0047feb8 + 0x10` through System_SeekFileDescriptor_v129, continues hashing the remainder of the file through System_UpdateExecutableChecksumSegment_v129, and finally compares the accumulator against `DAT_0047febc`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_UpdateExecutableChecksumSegment_v129": {
		"family": "SystemRuntime",
		"summary": "Updates the executable self-check accumulator over one caller-selected byte segment.",
		"notes": [
			"Starts from the caller-supplied accumulator, advances into `buffer + offset`, and folds the requested byte count through the dedicated reflected checksum table at `DAT_00498e00`.",
			"System_VerifyExecutableChecksumFromDisk_v129 uses it repeatedly on the 16KB scratch buffer so the retail verifier can hash the prefix and post-checksum tail in chunks without loading the whole executable at once.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_GetFileLengthByPath_v129": {
		"family": "SystemRuntime",
		"summary": "Opens one file path in binary mode, returns its byte length, and closes it immediately.",
		"notes": [
			"Thin helper over System_OpenFileStream_v129, the retail file-length query, and System_CloseFileStream_v129. System_LoadFileIntoBuffer_v129 uses it first so callers can either allocate the exact file-sized buffer or validate a caller-supplied one.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_LoadFileIntoBuffer_v129": {
		"family": "SystemRuntime",
		"summary": "Loads an entire file into a caller-supplied buffer or allocates a new one sized to the file.",
		"notes": [
			"Queries the file length through System_GetFileLengthByPath_v129, optionally allocates an exact-fit heap buffer through System_AllocateHeapBlock_v129 when the caller passes `NULL`, then reopens the file through System_OpenFileStream_v129, reads the full payload in one pass, and closes the stream through System_CloseFileStream_v129.",
			"Combat_LoadLasrSequenceData_v129 uses it for raw LASR sequence bytes, while Frame_LoadBitmapFontDescriptor_v129 uses it to pull TFONT descriptor blobs from disk before caching glyph advances.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawWeaponAimCursor_v129": {
		"family": "CombatOverlay",
		"summary": "Updates the live combat aim-cursor screen position and draws the retail cursor bitmap when the current weapon filter leaves a local slot enabled.",
		"notes": [
			"Centers the cursor around the live shake-adjusted HUD point, stores that screen coordinate into the shared cursor-hit globals reused by Combat_RenderAttachmentMeshListAndTrackCursorHit_v129, and suppresses the bitmap entirely when Combat_HasAnyWeaponSlotEnabledByBankFilter_v129 reports that the active bank filter would disable every local slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateCombatStartCountdownHud_v129": {
		"family": "CombatHud",
		"summary": "Updates the retail combat-start countdown HUD readout and releases the local actor when the countdown expires.",
		"notes": [
			"Called from Combat_MainLoop_v129 while the combat-start countdown flag is armed. Formats the absolute start time seeded by Combat_Cmd62_StartCombat_v129 into an `MM:SS` string at `(0x14, 0x19)` and, once the timer reaches zero, calls Combat_ResetLocalMotionAndRefreshAnimation_v129 unless the pre-start hold bit is still set.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RenderTacticalRadarPanel_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the fixed-size retail tactical radar panel, including terrain projection, contact blips, range readout, and facing cues.",
		"notes": [
			"Renders into the panel rectangle `(0xdc,0x114)-(0x1a3,0x1db)`, centers the view on the local actor, reuses Combat_RenderTerrainSceneryProjection_v129 in player-relative mode, and then plots each in-range remote mech through Combat_BuildTacticalRadarContactMarker_v129 before drawing the current radar range string.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawTacticalRadarRangeRings_v129": {
		"family": "CombatOverlay",
		"summary": "Draws the concentric tactical-radar range rings for the current retail radar range step.",
		"notes": [
			"Converts the selected radar range into the panel's fixed 90-pixel radius scale, then draws the matching 50, 100, 300, 800, and 2500 range circles with Frame_DrawEllipseOutline_v129 around the radar center `(99,100)` as applicable.",
			"Combat_RenderTacticalRadarPanel_v129 calls it after projecting contact markers so the active range ladder is visible on top of the terrain and blip overlay.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_BuildTacticalRadarContactMarker_v129": {
		"family": "CombatOverlay",
		"summary": "Builds the small normalized contact-marker polygon used by the retail tactical radar panel.",
		"notes": [
			"Seeds a fixed 3D marker mesh, then scales its translation terms from the target's relative `(x,y)` offset against the current radar range stored in `DAT_004f5128`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ResetEnvironmentRuntimeState_v129": {
		"family": "TerrainScenery",
		"summary": "Releases the retail terrain/environment runtime pools, including placed scenery instances, active projectile-effect slots, and the cached terrain object records.",
		"notes": [
			"Called both from result-scene teardown and before reallocating the terrain-scenery instance array. Clears the shared terrain instance table, the `0x1ff`-byte projectile/effect slot pool, and the cached 3d object record table rooted at `DAT_0047f770`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CollectVisibleTerrainSceneryInstances_v129": {
		"family": "TerrainScenery",
		"summary": "Transforms the active terrain-scenery instances into camera space and queues the ones that are plausibly visible for the retail effect/render pass.",
		"notes": [
			"Called from Combat_RenderActiveEffectsPass_v129 after the camera basis is prepared. Rebuilds each active instance's camera-space transform, updates its projected offsets, and appends only sufficiently in-front instances into the transient visible-object list at `DAT_004f5130`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitializeSkyBackdrop_v129": {
		"family": "CombatBackdrop",
		"summary": "Loads the `SKY0` bitmap and seeds the fixed transform used by the retail sky-backdrop pass.",
		"notes": [
			"Stores the cached bitmap buffer in `DAT_0047f740` and initializes the shared backdrop basis matrix at `DAT_004e7500` with a fixed Z rotation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitializeAmbientGroundDetail_v129": {
		"family": "CombatBackdrop",
		"summary": "Initializes the retail ambient ground-detail runtime state, including random anchor points, GRD bitmaps, and the special cached support mesh.",
		"notes": [
			"Loads the special cached 3d object record `0x10000`, allocates 800 random `(x, y, variant)` anchor triplets, and caches the `GRD0` / `GRD1` bitmaps later used by the ambient ground-detail renderer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeAmbientGroundDetailSeeds_v129": {
		"family": "CombatBackdrop",
		"summary": "Frees the randomized ambient ground-detail anchor table.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderAmbientGroundDetail_v129": {
		"family": "CombatBackdrop",
		"summary": "Renders the retail ambient ground-detail sprites at their randomized world anchors using the cached `GRD0` / `GRD1` bitmaps.",
		"notes": [
			"Uses the detail level selected through `DAT_0047a048` to choose how many anchors to sample, expands the indexed support mesh through Combat_ExpandIndexedPolygonVertexList_v129, clips it with Combat_ClipPolygonToViewVolume_v129, projects the surviving textured vertices through Combat_ProjectClippedPolygonToTexturedRenderVertices_v129, and draws the selected GRD bitmap only for anchors that remain near enough to the active view.",
			"The surviving linked render vertices are handed directly to Combat_RasterizeTexturedPolygon_v129 together with the caller-specific textured-span state block for the chosen ground-detail bitmap.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderSkyAndGroundBackdrop_v129": {
		"family": "CombatBackdrop",
		"summary": "Draws the retail `SKY0` backdrop, the main ground plane quads, and any enabled ambient ground-detail sprites behind the active combat effects.",
		"notes": [
			"Called from Combat_RenderActiveEffectsPass_v129 when the main 3d scene is being drawn. The pass conditionally renders the `SKY0` backdrop when the matching visual toggle is enabled, clips the transformed ground quads through Combat_ClipPolygonToViewVolume_v129, projects their textured vertices through Combat_ProjectClippedPolygonToTexturedRenderVertices_v129, and then dispatches those linked render vertices through Combat_RasterizeTexturedPolygon_v129 before delegating the optional GRD sprite layer to Combat_RenderAmbientGroundDetail_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InterpolateClippedPolygonVertexAttributes_v129": {
		"family": "CombatRender3d",
		"summary": "Interpolates the payload fields for one newly clipped polygon vertex after the clip-plane intersection coordinates are solved.",
		"notes": [
			"Called only from Combat_ClipPolygonToViewVolume_v129 after Combat_ComputeClipPlaneIntersectionCoords_v129 finds the surviving coordinates. It linearly interpolates vertex slots `3..5`, preserving the per-vertex shading or texture payload attached to the homogeneous clip vertex.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeClipPlaneIntersectionCoords_v129": {
		"family": "CombatRender3d",
		"summary": "Solves the two varying coordinates where a polygon edge intersects one homogeneous combat view-volume clip plane.",
		"notes": [
			"Used by Combat_ClipPolygonToViewVolume_v129 for each sign-change edge while clipping against the retail left/right and top/bottom frustum boundaries. The helper returns failure only when the edge is parallel to the active clip plane.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClipPolygonToViewVolume_v129": {
		"family": "CombatRender3d",
		"summary": "Clips a homogeneous polygon vertex list against the retail combat view volume and emits the surviving scratch vertex list.",
		"notes": [
			"Used directly by Combat_RenderAmbientGroundDetail_v129 and Combat_RenderSkyAndGroundBackdrop_v129, and indirectly by the shared world-marker and effect-strip render wrappers. The helper walks the polygon through four frustum boundaries with the scratch buffers at `DAT_0048a520` and `DAT_0048a508`, inserting new vertices through Combat_ComputeClipPlaneIntersectionCoords_v129 and Combat_InterpolateClippedPolygonVertexAttributes_v129 whenever an edge crosses a clip plane.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ProjectClippedPolygonToScreen_v129": {
		"family": "CombatRender3d",
		"summary": "Projects one already clipped polygon vertex list into integer screen coordinates and tracks its screen-space bounds.",
		"notes": [
			"Converts each surviving homogeneous vertex into `(x, y)` pixels using the active viewport fields at `+0x68` and `+0x6c`, preserves either the caller-supplied depth slot or the vertex payload slot `5`, and updates the shared min/max bounds globals used by the follow-up raster path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ExpandIndexedPolygonVertexList_v129": {
		"family": "CombatRender3d",
		"summary": "Expands a retail indexed polygon face record into the six-word-per-vertex scratch list consumed by the clip/project helpers.",
		"notes": [
			"Reads the face vertex count plus its vertex-index list, copies the referenced entries from the source vertex table into a dense local buffer, and feeds that expanded list into Combat_ClipPolygonToViewVolume_v129. Combat_RenderAmbientGroundDetail_v129 is the current direct named caller.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ProjectWorldPointToScreenVertex_v129": {
		"family": "CombatRender3d",
		"summary": "Projects one transformed combat world point into the shared six-word screen-vertex record used by overlays and effect renderers.",
		"notes": [
			"Called by Combat_RenderActorWorldMarkers_v129, Combat_RenderTerrainSceneryProjection_v129, Combat_RenderEffectModelAndCheckCursorHit_v129, Combat_RenderEffectSprite_v129, and Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129. It applies the active viewport scaling and copies the point payload fields into the destination record layout consumed by the retail sprite and polygon paths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClipLineSegmentToViewVolume_v129": {
		"family": "CombatRender3d",
		"summary": "Clips a two-point line segment against the retail combat view volume and writes the surviving endpoints back in place.",
		"notes": [
			"Thin wrapper over Combat_ClipPolygonToViewVolume_v129 that seeds a two-vertex scratch polygon, runs the shared clipper, and rewrites the caller's endpoints from the surviving segment. Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129 uses it for the beam-style fallback branch before projecting the clipped muzzle-to-impact line.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ProjectClippedPolygonToTexturedRenderVertices_v129": {
		"family": "CombatRender3d",
		"summary": "Projects a clipped polygon into the linked textured-render vertex buffer used by the retail textured polygon rasterizer.",
		"notes": [
			"Used directly by Combat_RenderSkyAndGroundBackdrop_v129 and Combat_RenderAmbientGroundDetail_v129, and by Combat_RenderTexturedPolygonGroup_v129 after the source polygon group is clipped. The helper emits the doubly linked render-vertex records expected by Combat_RasterizeTexturedPolygon_v129 while scaling the stored UV payload by the source bitmap dimensions and reciprocal depth.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeVisibleAttachmentViewVariantIndex_v129": {
		"family": "CombatRender3d",
		"summary": "Computes the visible attachment view-variant index from the current transformed attachment basis.",
		"notes": [
			"Used only by Combat_RenderAttachmentMeshListAndTrackCursorHit_v129. It evaluates three sign tests from the current transformed attachment basis and packs them into the 0..7 index used to select one pre-sorted attachment polygon-group variant.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderLitClippedPolygon_v129": {
		"family": "CombatRender3d",
		"summary": "Clips, lights, projects, and rasterizes one uniformly shaded polygon through the retail flat-polygon path.",
		"notes": [
			"Called by Combat_RenderEffectTrailStrip_v129 after the trail strip chooses its active normal basis. The helper clips the polygon, applies Combat_ComputeClampedLightDotShadeOffset_v129 to the supplied base shade, projects the result through Combat_ProjectClippedPolygonToScreen_v129, and submits the screen-space polygon to the retail flat rasterizer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderTexturedPolygonGroup_v129": {
		"family": "CombatRender3d",
		"summary": "Expands, clips, projects, and rasterizes one textured polygon group from a retail mesh record.",
		"notes": [
			"Used by Combat_RenderAttachmentMeshListAndTrackCursorHit_v129 and the terrain-scenery projection wrapper. It expands the indexed polygon group through Combat_ExpandIndexedPolygonVertexList_v129, clips it, projects the surviving textured vertices through Combat_ProjectClippedPolygonToTexturedRenderVertices_v129, and then hands the linked render vertices to Combat_RasterizeTexturedPolygon_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RasterizeTexturedPolygonToSurface_v129": {
		"family": "CombatRender3d",
		"summary": "Thin wrapper that extracts a destination surface's pitch and pixel pointer before invoking the retail textured polygon rasterizer.",
		"notes": [
			"Reads the destination surface descriptor fields from the caller-supplied frame/surface record and forwards them to Combat_RasterizeTexturedPolygon_v129 together with the linked textured-render vertex list, raster state block, callback count, and raster flags.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RasterizeTexturedPolygon_v129": {
		"family": "CombatRender3d",
		"summary": "Rasterizes one linked textured polygon into the destination surface using the retail software span-walker path.",
		"notes": [
			"Consumes the linked render-vertex list emitted by Combat_ProjectClippedPolygonToTexturedRenderVertices_v129, walks the polygon from top to bottom, computes the left/right edge slopes plus reciprocal-depth-adjusted UV increments, and dispatches the caller-supplied raster state block across each scanline span.",
			"Combat_RenderTexturedPolygonGroup_v129, Combat_RenderSkyAndGroundBackdrop_v129, and Combat_RenderAmbientGroundDetail_v129 all call it directly with state blocks that point at the active texture bitmap and the self-patching span routine rooted at `FUN_0046a764`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderFlatShadedPolygonGroup_v129": {
		"family": "CombatRender3d",
		"summary": "Expands, clips, projects, and rasterizes one flat-shaded polygon group from a retail mesh record.",
		"notes": [
			"Used by Combat_RenderAttachmentMeshListAndTrackCursorHit_v129 and the terrain-scenery projection wrapper for polygon groups without a textured-face payload. When the face flag requests lighting, it applies Combat_ComputeClampedLightDotShadeOffset_v129 to the polygon normal before projecting the group through Combat_ProjectClippedPolygonToScreen_v129 and submitting it to the flat rasterizer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeClampedLightDotShadeOffset_v129": {
		"family": "CombatRender3d",
		"summary": "Computes a clamped lighting shade offset from the dot product of two fixed-point render vectors.",
		"notes": [
			"Used by Combat_RenderLitClippedPolygon_v129 and Combat_RenderFlatShadedPolygonGroup_v129. It scales the fixed-point dot product into the retail shade domain and clamps the result to the signed `+/-0x60000` range before the caller adds it to the polygon's base shade.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderTerrainSceneryObjectRecord_v129": {
		"family": "CombatRender3d",
		"summary": "Transforms and renders one cached terrain-scenery object record through the retail polygon-group render path.",
		"notes": [
			"Called only by Combat_RenderTerrainSceneryProjection_v129 after each active scenery instance's transform is rebuilt into camera space. It transforms the record's cached vertex list into the shared scratch buffer and then dispatches each polygon group through Combat_RenderTexturedPolygonGroup_v129 or Combat_RenderFlatShadedPolygonGroup_v129 based on the group's face flags.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetEnvironmentLightDirectionAngles_v129": {
		"family": "CombatRender3d",
		"summary": "Stores the shared combat light-direction angles and rebuilds the derived lighting vector used by the retail shading helpers.",
		"notes": [
			"Called by Combat_InitializeBattlefieldVisualState_v129 with the default battlefield light angles. It caches the supplied heading/elevation pair and recomputes the fixed-point direction vector later consumed by Combat_ComputeClampedLightDotShadeOffset_v129 and the terrain/effect shading paths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeIndexedAssetDirectory_v129": {
		"family": "AnimationIO",
		"summary": "Frees one cached retail indexed-directory table and its `(id, offset)` rows.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadIndexedAssetDirectory_v129": {
		"family": "AnimationIO",
		"summary": "Loads the header and `(id, offset)` rows for a retail indexed asset archive after verifying the expected format id.",
		"notes": [
			"Used by the 3d object loader, keyframe-set loader, and a third combat asset loader that shares the same indexed archive layout.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Parse3dObjectVertexTable_v129": {
		"family": "AnimationIO",
		"summary": "Parses the vertex table for one retail 3d object record.",
		"notes": [
			"Allocates `count * 0x18` bytes and reads the raw 24-byte vertex entries directly from the asset stream. Later record consumers use this table to derive record radius and render geometry.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Parse3dObjectFaceTable_v129": {
		"family": "AnimationIO",
		"summary": "Parses the face table for one retail 3d object record, including per-face index lists and optional bitmap references.",
		"notes": [
			"Each parsed face entry stores its vertex-index list, flags, vector data, and optional cached bitmap handle when the textured-face bit is present.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Parse3dObjectFaceGroups_v129": {
		"family": "AnimationIO",
		"summary": "Parses the eight per-record face groups that remap face indices to direct face pointers.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Parse3dObjectRecordGroups_v129": {
		"family": "AnimationIO",
		"summary": "Parses the eight top-level record groups in a retail 3d object definition and resolves them to direct record pointers.",
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadIndexed3dObjectRecord_v129": {
		"family": "AnimationIO",
		"summary": "Loads one 3d object record from a retail indexed archive using the shared cached directory table.",
		"notes": [
			"Reuses the shared indexed-directory cache in `DAT_00481bf0`, seeks the requested object id, and parses the resulting 100-byte record plus its variable sections through Combat_Parse3dObjectRecord_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_Parse3dObjectRecord_v129": {
		"family": "AnimationIO",
		"summary": "Parses one standalone 3d object record and its variable sections from the current archive position.",
		"notes": [
			"The fixed record layout matches the per-object entries parsed inside Combat_Parse3dObjectDefinition_v129, but this helper loads a single indexed record directly from the shared archive cache.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetIndexedAssetDirectoryCaches_v129": {
		"family": "AnimationIO",
		"summary": "Clears the cached indexed-directory tables used by the combat animation and 3d object asset loaders.",
		"notes": [
			"Releases the keyframe, 3d object, and third shared indexed-directory caches and nulls their global pointers so later loads reopen fresh directory tables.",
		],
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
	"Combat_RecomputeWalkRunSpeedCaps_v129": {
		"family": "Movement",
		"summary": "Recomputes the actor's current walk and run speed caps from the damaged movement rating and any caller-supplied penalty.",
		"notes": [
			"Stores the current walk cap as `(walk_mp - penalty) * 300` and the run cap as the rounded retail `ceil(walk_mp * 1.5) * 300` value, except when the matching leg/hip damage state forces the run cap to collapse to the walk cap.",
			"Combat_ApplyDamageCodeValue_v129 and Combat_ApplyDetailRowDamageCode_v129 call it after movement-affecting damage updates and when shutdown forces the local actor's movement budget to zero, then refresh the local movement HUD through Combat_UpdateLocalMovementHudAndAnimation_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ToggleStickyViewMode_v129": {
		"family": "UpperBodyControl",
		"summary": "Toggles the retail sticky-view mode latch used by the local aim and weapon-filter controls.",
		"notes": [
			"Flips the same `DAT_0048a484` flag that the main loop advertises through the `Sticky View Mode` overlay. Combat_ProcessWeaponBankFilterInput_v129 reads this latch to preserve the neutral selector state when directional bank-filter input is released.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
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
	"Combat_UpdateHeatGaugeAndPaletteTint_v129": {
		"family": "Heat",
		"summary": "Redraws the local heat gauge and drives the staged combat palette tint from the current displayed heat level.",
		"notes": [
			"Called from Combat_UpdateLocalHeatAccumulator_v129, the combat HUD bootstrap, and the local weapon-selection refresh path. Tracks the last displayed heat value in `DAT_0048b0f8`, repaints the segmented heat column on the combat HUD surface, and then forwards the current tint stage / bar delta into Combat_UpdateHeatPaletteTintStage_v129 before latching the new displayed heat.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateHeatPaletteTintStage_v129": {
		"family": "Heat",
		"summary": "Evaluates the current heat-tint stage thresholds and applies the matching palette-tint amount when the local heat bar crosses into a new band.",
		"notes": [
			"Uses the two threshold ranges stored in `DAT_0047d2c8` / `DAT_0047d2cc` together with the last applied stage in `DAT_0047d2c0`. When the heat bar enters or extends past a new band it computes the tint amount from the remaining band height and forwards that amount to Combat_ApplyHeatPaletteTint_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ApplyHeatPaletteTint_v129": {
		"family": "Heat",
		"summary": "Builds and applies the working combat heat-tint palette from the active terrain palette table.",
		"notes": [
			"Starts from `DAT_0047cbb8`, the active terrain palette table installed during combat bootstrap. Positive tint first raises one palette channel across the working copy and, once the amount exceeds `0xff`, subtracts the remaining overflow from the two other channels before publishing the tinted working buffer through `DAT_0047cbbc` and Frame_ApplyBitmapPalette_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AdjustPaletteChannelClamped_v129": {
		"family": "Heat",
		"summary": "Adjusts one byte channel across a palette table with 0..255 saturation.",
		"notes": [
			"Walks the palette-entry records shared by the heat-tint working buffer and offsets the selected channel by the requested signed amount. Negative adjustments clamp to `0`, positive adjustments clamp to `0xff`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetHeatPaletteWorkingCopy_v129": {
		"family": "Heat",
		"summary": "Resets the combat heat-tint working palette buffer from the active terrain palette table.",
		"notes": [
			"Copies `DAT_0047cbb8` into the mutable working buffer at `DAT_0048b110` and resets the current heat-tint stage tracker in `DAT_0047d2c0`. Combat_InitializeBattlefieldVisualState_v129 calls this before any live heat-driven palette adjustments run.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
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
	"Combat_SetJumpFuelReadyIndicator_v129": {
		"family": "CombatHud",
		"summary": "Toggles the jump-fuel ready indicator artwork between the active and inactive palette ramps.",
		"notes": [
			"Called from Combat_UpdateJumpFuelReserve_v129 only when the jump-fuel reserve crosses the retail ready hysteresis threshold. Replaces one eight-entry palette ramp inside the fixed jump-fuel indicator rectangle, redraws the embedded HUD asset into that panel, and presents the updated region immediately when combat is not in fullscreen redraw mode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateJumpFuelGauge_v129": {
		"family": "CombatHud",
		"summary": "Updates the vertical jump-fuel gauge fill and warning color from the current local reserve value.",
		"notes": [
			"Tracks the last displayed jump-fuel reserve in `DAT_0048b0dc`, replaces the fill-color band over only the portion of the gauge that changed, and then updates the warning color strip to one of the retail full, caution, or critical colors based on the new reserve threshold.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateRadarRangeHudIndicator_v129": {
		"family": "CombatOverlay",
		"summary": "Advances the retail tactical-radar range selection and redraws the matching `RDR1`-`RDR5` HUD indicator.",
		"notes": [
			"Stores the selected radar range in `DAT_004f5128`, stepping through the retail range ladder `50 / 100 / 300 / 800 / 2500` when invoked from the presentation hotkey path. Redraws the transparent radar-range indicator panel at `(0xcc,0x114)-(0x108,0x137)` and the static range label overlay, and Combat_RenderTacticalRadarPanel_v129 reads the same state when plotting in-range contacts.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateHudZoomIndicators_v129": {
		"family": "CombatHud",
		"summary": "Updates the paired retail `ZOM*` / `ZMB*` HUD zoom indicators and the shared HUD zoom-state byte.",
		"notes": [
			"Mutates `DAT_004f6c38` across the retail three-state zoom ladder, then redraws both the large zoom-mode badge and its companion button panel. Other HUD helpers read the same state to scale the heading tape / marker spacing, so this wrapper is the presentation-layer entry point for those zoom changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateEjectStatusHudIndicator_v129": {
		"family": "CombatHud",
		"summary": "Redraws the retail `EJE1`-`EJE5` HUD strip for the current local eject-status state.",
		"notes": [
			"Maps the eject-status byte `DAT_0047d2b0` into the five retail `EJE*` bitmap states, with the non-idle states also driving the associated countdown / warning cue helper. Bootstrap initializes it in the idle state, while the paired small callers transition the status byte and then route back through this redraw helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_IsEjectConfirmPending_v129": {
		"family": "CombatControl",
		"summary": "Returns whether the retail local eject flow is waiting for its confirming hotkey press.",
		"notes": [
			"Reads the shared eject-status byte `DAT_0047d2b0` and returns true only for state `1`, the intermediate armed state entered after the first eject hotkey press. Combat_HandleLocalControlHotkey_v129 uses it to decide whether a non-eject key should cancel the pending confirm or whether a second eject key press should advance the sequence.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ClearPendingEjectConfirm_v129": {
		"family": "CombatControl",
		"summary": "Cancels a pending local eject confirmation and redraws the retail eject-status HUD strip.",
		"notes": [
			"Resets `DAT_0047d2b0` back to the idle state and immediately refreshes the `EJE*` HUD indicator through Combat_UpdateEjectStatusHudIndicator_v129. Combat_HandleLocalControlHotkey_v129 calls it whenever some other hotkey interrupts the armed one-press eject confirmation state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_AdvanceEjectConfirmState_v129": {
		"family": "CombatControl",
		"summary": "Advances the retail two-step local eject confirmation state and starts the warning/audio phase on the second press.",
		"notes": [
			"State `0` moves to the armed confirmation state and redraws the `EJE*` indicator. State `1` resets local motion, advances to the live eject phase, refreshes the HUD indicator again, stops the earlier cue if needed, plays the eject warning cues, and sets the pending-send bit in `DAT_0047cbc0` so Combat_SendEjectCommandAfterCue_v129 can transmit the actual command when the warning finishes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SendEjectCommandAfterCue_v129": {
		"family": "CombatControl",
		"summary": "Flushes the retail local eject opcode once the armed warning cue finishes playing.",
		"notes": [
			"Checks the pending eject-send bit in `DAT_0047cbc0`, waits for cue `0x1c` to stop, clears the bit, appends outbound opcode `0x05`, and flushes the retail command buffer immediately. Combat_MainLoop_v129 calls it each frame after Combat_AdvanceEjectConfirmState_v129 has armed the send latch.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Combat_UpdateCmbHudToggle_v129": {
		"family": "CombatPresentation",
		"summary": "Updates the retail `CMB1`-`CMB4` HUD toggle strip and its paired presentation-mode bit.",
		"notes": [
			"Presentation hotkey `0x2b` and the paired timeout helpers route through this wrapper. It flips the transient `DAT_0047d3b0` state, toggles the persisted presentation bit `(DAT_0047a04c & 1)`, swaps the active combat callback slot between the retail handlers, and redraws the matching `CMB*` bitmap at `(0x23a,0x80)-(0x27b,0x94)`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ClearCmbOrCmpHudToggleByHotkey_v129": {
		"family": "CombatPresentation",
		"summary": "Routes the normalized presentation hotkey for `CMB` or `CMP` back into the default toggle state.",
		"notes": [
			"Accepts only hotkey `0x2b` or `0x49` and forwards them into Combat_UpdateCmbHudToggle_v129 or Combat_UpdateCmpHudToggle_v129 with the second state argument forced to `0`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SetCmbOrCmpHudToggleByHotkey_v129": {
		"family": "CombatPresentation",
		"summary": "Routes the normalized presentation hotkey for `CMB` or `CMP` into the alternate toggle state.",
		"notes": [
			"Accepts only hotkey `0x2b` or `0x49` and forwards them into Combat_UpdateCmbHudToggle_v129 or Combat_UpdateCmpHudToggle_v129 with the second state argument forced to `1`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ClearCmbOrCmpHudToggleByHotkeyThunk_v129": {
		"family": "CombatPresentation",
		"summary": "Tiny retail tail wrapper that forwards into Combat_ClearCmbOrCmpHudToggleByHotkey_v129.",
		"notes": [
			"Decompiles as a nine-byte thunk that immediately tail-calls the main `CMB`/`CMP` clear dispatcher without adding any extra state of its own.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SetCmbOrCmpHudToggleByHotkeyThunk_v129": {
		"family": "CombatPresentation",
		"summary": "Tiny retail tail wrapper that forwards into Combat_SetCmbOrCmpHudToggleByHotkey_v129.",
		"notes": [
			"Decompiles as a nine-byte thunk that immediately tail-calls the main `CMB`/`CMP` set dispatcher; the only inbound control-flow Ghidra currently exposes is the small preceding branch at `00415ff6`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateChbHudToggle_v129": {
		"family": "CombatPresentation",
		"summary": "Updates the retail `CHB1`-`CHB4` HUD toggle strip from the current presentation toggle state.",
		"notes": [
			"Presentation hotkey `0x4a` uses this wrapper after toggling one of the retail presentation bits in `DAT_0047fecc`. The implementation only draws the edge `CHB1` / `CHB4` states directly, leaving the intermediate `CHB2` / `CHB3` assets available for bootstrap or future state transitions, and presents the updated strip at `(0x23e,0x96)-(0x27a,0xaa)`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateLogHudToggle_v129": {
		"family": "CombatPresentation",
		"summary": "Updates the retail `LOG1` / `LOG2` HUD toggle, including the associated log-overlay state flip.",
		"notes": [
			"Presentation hotkey `0x2a` routes here after flipping the retail overlay flags in `DAT_0047a04c` and `DAT_0047fecc`. The helper refreshes the cached frame regions used by the overlay path, redraws the matching `LOG*` bitmap at `(0x230,0xab)-(0x280,0xd3)`, and presents the updated rectangle immediately.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ShowTimedStatusMessage_v129": {
		"family": "CombatHud",
		"summary": "Latches one timed combat status message into the shared HUD buffer and mirrors it into the capture log when logging is active.",
		"notes": [
			"Stores the caller-supplied text in `DAT_004f50c0`, sets the expiry tick in `DAT_004f511c`, clears the small auxiliary latch at `DAT_004f5114`, and leaves Combat_MainLoop_v129 to draw the message through the fixed `(0x14,0xcf)` status-text path until the timer expires.",
			"Used by Combat_Cmd74_DisplayStatusMessage_v129, the local/presentation hotkey toggles, Combat_TickVoiceTransmissionSpeechInState_v129, and the capture-log helpers when retail needs to surface a transient status line to the player.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RedrawEq1HudIndicator_v129": {
		"family": "CombatHud",
		"summary": "Redraws the leftmost lower-row EQ1 HUD indicator from the local actor's cached indicator state.",
		"notes": [
			"Selects among the retail `EQ1G`, `EQ1R`, and `EQ1B` bitmaps using the state byte at `(DAT_004f5778 + 0x1ae)` and presents the updated indicator rectangle immediately unless combat is already in a fullscreen redraw pass.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RedrawEq2HudIndicator_v129": {
		"family": "CombatHud",
		"summary": "Redraws the second lower-row EQ2 HUD indicator from the local actor's cached indicator state.",
		"notes": [
			"Selects among the retail `EQ2G`, `EQ2R`, and `EQ2B` bitmaps using the state byte at `(DAT_004f5778 + 0x1b2)` and presents the updated indicator rectangle immediately unless combat is already in a fullscreen redraw pass.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RedrawEq3HudIndicator_v129": {
		"family": "CombatHud",
		"summary": "Redraws the third lower-row EQ3 HUD indicator from the local actor's cached indicator state.",
		"notes": [
			"Selects among the retail `EQ3G`, `EQ3Y`, `EQ3R`, and `EQ3B` bitmaps using the state byte at `(DAT_004f5778 + 0x1b4)` and presents the updated indicator rectangle immediately unless combat is already in a fullscreen redraw pass.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RedrawEq4HudIndicator_v129": {
		"family": "CombatHud",
		"summary": "Redraws the rightmost lower-row EQ4 HUD indicator from the local actor's cached indicator state.",
		"notes": [
			"Selects among the retail `EQ4G`, `EQ4R`, and `EQ4B` bitmaps using the state byte at `(DAT_004f5778 + 0x1b0)` and presents the updated indicator rectangle immediately unless combat is already in a fullscreen redraw pass.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateCmpHudToggle_v129": {
		"family": "CombatPresentation",
		"summary": "Updates the retail `CMP1`-`CMP4` HUD toggle strip and the paired presentation-mode side effects.",
		"notes": [
			"Presentation hotkey `0x49` routes through this helper and its timeout helpers. The wrapper redraws the active `CMP*` bitmap at `(0x6,0x1c8)-(0x19,0x1df)`, conditionally forwards the toggle into the retail overlay helper when the related presentation bit is set, and triggers the paired side-effect path when switching into the non-default state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SetHudTimeoutSlotExpiry_v129": {
		"family": "CombatHud",
		"summary": "Arms one of the small combat HUD timeout slots for the current tick plus a caller-supplied duration.",
		"notes": [
			"Writes `System_GetCentisecondTickCount_v129() + duration` into `DAT_004e9100[slot]` when the slot index is in the fixed `0..5` range.",
			"Retail uses these timeout slots for lightweight HUD state transitions such as the blinking eject indicator and the paired CMP presentation-toggle follow-up timers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ProcessExpiredHudTimeoutSlots_v129": {
		"family": "CombatHud",
		"summary": "Polls the six lightweight combat HUD timeout slots and fires the follow-up indicator updates whose expiry time has passed.",
		"notes": [
			"Called from Combat_MainLoop_v129 with the current centisecond tick count and walks `DAT_004e9100[0..5]`, clearing any slot whose deadline has expired.",
			"Retail currently uses this poller to complete the eject indicator blink and to restore the deferred CMB/CMP presentation-toggle states by routing back into Combat_UpdateEjectStatusHudIndicator_v129, Combat_UpdateCmbHudToggle_v129, and Combat_UpdateCmpHudToggle_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
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
	"Combat_ToggleInvertedMouseThrottle_v129": {
		"family": "MouseControl",
		"summary": "Toggles the retail inverted-mouse-throttle latch used by the mouse throttle zone.",
		"notes": [
			"Flips the sign latch `DAT_0048af24` when mouse throttle is active, causing Combat_ProcessMouseThrottleZoneInput_v129 to negate the computed throttle target. Passing a nonzero argument clears the latch back to normal, which the presentation reset path uses when combat visual/control state is rebuilt.",
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
	"Combat_FireWeaponBank_v129": {
		"family": "WeaponFire",
		"summary": "Executes the armed weapons in one local weapon bank against the current target and spawns the matching retail impact/effect side effects.",
		"notes": [
			"Walks the enable flags for the supplied local weapon-bank index, resolves the current target attachment or fallback impact coordinates, queues the retail weapon-fire screen shake, and then either spawns an immediate impact effect or routes the shot through the deferred projectile/effect path. Returns nonzero when an immediate impact-style effect was emitted.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_GetWeaponSlotMuzzleOrigin_v129": {
		"family": "WeaponFire",
		"summary": "Resolves the world-space muzzle origin for one weapon slot from the actor's attachment tags.",
		"notes": [
			"Maps the slot's mount-location code onto a fixed attachment-tag table, reads that attachment's local offset from the active actor model, and transforms it into world space.",
			"For the local actor it uses the simplified chassis-heading rotation path before adding the actor origin; remote actors use the full actor transform matrix. Combat_BuildWeaponEffectSpawnGeometry_v129 and Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129 both rely on the same origin helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_ComputeEffectAimAnglesToPoint_v129": {
		"family": "CombatEffects",
		"summary": "Computes the retail pitch/yaw effect angles that face from one world point toward another.",
		"notes": [
			"Zeros the roll component, derives pitch from the vertical delta over the horizontal range, and derives yaw from the XY deltas with the same quadrant correction the retail actor/effect code uses before scaling into the `0xb6` angle units stored on active effect slots.",
			"Both the pitch and yaw paths route through Combat_ComputeArcTanDegreesFromScaledRatio_v129 before the final fixed-angle conversion.",
			"Combat_BuildWeaponEffectSpawnGeometry_v129 uses it when seeding newly spawned weapon effects, and Combat_UpdateProjectileEffectState_v129 reruns it whenever an effect is still tracking a live attachment target.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputePointDistance_v129": {
		"family": "CombatEffects",
		"summary": "Returns the Euclidean distance between two combat world points with the retail overflow-safe 1/32 scaling step.",
		"notes": [
			"Shifts the XYZ deltas down by five bits before squaring, runs the shared integer square-root helper, and then shifts the result back up so the caller gets a world-space distance without risking overflow on large coordinate deltas.",
			"Used by the local fire path, replicated cmd68 effect spawns, and Combat_UpdateProjectileEffectState_v129 when converting origin/impact coordinates into projectile travel lengths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeVectorMagnitude3_v129": {
		"family": "CombatEffects",
		"summary": "Returns the Euclidean magnitude of a supplied 3-axis combat-space delta vector.",
		"notes": [
			"Computes `sqrt(x*x + y*y + z*z)` through System_IntegerSquareRoot_v129 without applying the overflow-safe pre-scaling used by Combat_ComputePointDistance_v129.",
			"Combat_RenderActiveEffectsPass_v129 and Combat_RenderModelAttachments_v129 use it after building camera-relative XYZ deltas to rank nearby effect entries and attachment meshes by distance.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildWeaponEffectSpawnGeometry_v129": {
		"family": "WeaponFire",
		"summary": "Builds the origin, target point, travel flags, and initial aim angles for one weapon-effect spawn.",
		"notes": [
			"Resolves the firing slot's world-space muzzle origin, optionally derives a default forward impact point for the local actor when no explicit target attachment is locked, and otherwise transforms the target actor's attachment/tag offset into world space.",
			"Finishes by calling Combat_ComputeEffectAimAnglesToPoint_v129 so both the local fire path and Combat_Cmd68_SpawnWeaponEffect_v129 can seed the exact same active effect state block before handing it to Combat_SpawnActiveWeaponEffect_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SpawnActiveWeaponEffect_v129": {
		"family": "WeaponFire",
		"summary": "Allocates a free active projectile/effect slot and seeds it from one weapon-effect spawn request.",
		"notes": [
			"Scans the active effect pool at `DAT_0047f730` for a free `0x1ff`-byte slot, records the allocated index in `DAT_0048b914`, stores the origin/angles/target bookkeeping, and chooses the beam-style versus projectile-style travel cadence from the named weapon-type predicates.",
			"When Combat_WeaponTypeUsesCachedEffectModel_v129 succeeds it also loads the cached 3D object record from `DAT_0047aaf8 + weapon_type * 0x5c` through Combat_LoadCached3dObjectRecord_v129 and marks the slot for model rendering instead of fallback sprite/beam rendering.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_CanAppendDamageCodeValueToActiveEffect_v129": {
		"family": "CombatEffects",
		"summary": "Returns whether one live active effect slot can absorb another deferred damage code/value pair for the same target actor.",
		"notes": [
			"Validates the slot index against the active effect pool at `DAT_0047f730`, requires the slot's live bit to be set, matches the slot's tracked target actor against the supplied actor id, and caps the deferred pair count at `0x14` entries.",
			"Combat_ApplyDamagePairOrQueueEffect_v129 uses it to decide whether a fresh damage packet can piggyback on the already active local weapon effect instead of immediately playing impact feedback and applying the damage to the actor state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_AppendDamageCodeValueToActiveEffect_v129": {
		"family": "CombatEffects",
		"summary": "Appends one deferred damage code/value pair onto an active effect slot's pending impact list.",
		"notes": [
			"Writes the supplied damage code and value into the slot's paired arrays at offsets `+0x145` and `+0x195` using the current deferred-pair count stored at `+0x141`, then increments that count.",
			"Called only after Combat_CanAppendDamageCodeValueToActiveEffect_v129 succeeds, letting Combat_ApplyDamagePairOrQueueEffect_v129 batch multiple impact updates onto the same in-flight local effect.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_RenderImmediateWeaponFireOverlay_v129": {
		"family": "WeaponFire",
		"summary": "Renders the small local immediate-fire overlay used by non-projectile, non-model weapon shots.",
		"notes": [
			"Used only on the local immediate-impact path when the weapon type does not route through cached effect models or deferred projectile effects.",
			"Maps weapon types `2..5` onto fixed overlay dimensions, maps the weapon mount location onto a small set of cockpit-view anchor positions, then submits three backdrop-style quads and presents the updated combat view rectangle immediately.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_GetLastSpawnedWeaponEffectSlotIndex_v129": {
		"family": "WeaponFire",
		"summary": "Returns the active effect-pool index most recently reserved by Combat_SpawnActiveWeaponEffect_v129.",
		"notes": [
			"Thin accessor over `DAT_0048b914`, the global that Combat_SpawnActiveWeaponEffect_v129 updates when it claims a free slot from the active projectile/effect pool.",
			"Combat_Cmd68_SpawnWeaponEffect_v129 reads it immediately after spawning a replicated effect so the command handler can remember which active slot was just created.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_ResolveLocalWeaponFallbackImpactPoint_v129": {
		"family": "WeaponFire",
		"summary": "Resolves the local actor's fallback impact point when a weapon effect is fired without a locked target attachment.",
		"notes": [
			"Builds the local actor's inverse transform, projects a forward point using the weapon-type range vector from `DAT_0047aad8`, and then either clips that path against the currently selected terrain-scenery face or falls back to the ground-plane intersection.",
			"Returns the small retail path flag consumed by Combat_BuildWeaponEffectSpawnGeometry_v129 and Combat_SpawnActiveWeaponEffect_v129 alongside the resolved target point, which is why the helper stays local-fire specific instead of serving the replicated cmd68 path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_WeaponTypeUsesCachedEffectModel_v129": {
		"family": "WeaponFire",
		"summary": "Returns whether a retail weapon type should use the cached 3D effect-model path instead of the sprite/beam fallback.",
		"notes": [
			"Checks the paired weapon metadata tables at `DAT_0047aab0` and `DAT_0047aaf4`, succeeding only when the fallback-style field is zero and the cached effect-model record field is populated.",
			"Combat_FireWeaponBank_v129 and the pooled projectile/effect allocator both call it before loading the cached object record from `DAT_0047aaf8 + weapon_type * 0x5c` through Combat_LoadCached3dObjectRecord_v129 and enabling the scaled effect-model render path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_WeaponTypeUsesProjectileEffectPath_v129": {
		"family": "WeaponFire",
		"summary": "Returns whether a retail weapon type belongs to the projectile-style effect path set.",
		"notes": [
			"Matches weapon type ids `6..9`, the same class group that keeps Combat_FireWeaponBank_v129 on the pooled projectile/effect-object path even when no cached effect model is available.",
			"Combat_RenderWeaponEffectFallbackSpriteOrBeam_v129 renders these classes as the short-lived projectile-sprite fallback, while the direct-fire hotkey path uses this predicate to avoid the immediate beam/impact shortcut used by the beam-style set.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_WeaponTypeUsesBeamEffectPath_v129": {
		"family": "WeaponFire",
		"summary": "Returns whether a retail weapon type belongs to the beam-style effect path set.",
		"notes": [
			"Matches weapon type ids `2..5`, the same class group that the fallback renderer turns into the muzzle-to-impact beam/quad presentation when no cached effect model is present.",
			"Combat_UpdateActiveProjectileEffects_v129 also checks this set when deciding how aggressively to keep active weapon-effect entries visible, so the predicate spans both fire-path routing and effect rendering.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RedrawWeaponBankHudReadouts_v129": {
		"family": "CombatHud",
		"summary": "Redraws the local weapon-bank readout rows on the combat HUD.",
		"notes": [
			"Iterates the local mech's weapon banks, clears each readout strip, and formats either a placeholder or a computed per-bank value before presenting the updated rows. The readout refresh is triggered during combat HUD bootstrap and after local weapon-bank fire paths update the underlying weapon state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_FireCurrentWeaponBank_v129": {
		"family": "WeaponFire",
		"summary": "Fires the currently selected local weapon bank and refreshes the dependent combat HUD panels.",
		"notes": [
			"Checks the selected local weapon-bank index, routes the actual firing through Combat_FireWeaponBank_v129, and then redraws the weapon-bank readouts, heat gauge / palette tint, and local movement HUD. Combat_HandlePresentationHotkey_v129 uses this wrapper for the current-bank fire shortcut path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ComputeActorDistance_v129": {
		"family": "Movement",
		"summary": "Computes the retail 3D distance between two combat actors from their world coordinates.",
		"notes": [
			"Subtracts the actors' X/Y/Z positions, scales the deltas down by 100 world units, and returns the Euclidean distance used by range, contact, and warning-tone helpers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
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
	"Combat_TickLocalGroundMovementCadenceCue_v129": {
		"family": "CombatAudio",
		"summary": "Ticks the alternating grounded movement cadence cue while the local mech has a nonzero throttle target.",
		"notes": [
			"Called only from Combat_TickLocalActorControlLoop_v129. When the local actor is grounded and the one-second cadence timer has expired, it checks the encrypted throttle-target field at `+0x36e`, plays cue `0x22` if that target is nonzero, alternates the cue pan between the left/right endpoints through the nearby sound-parameter helper, and rearms the timer for another 100 centiseconds.",
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
	"Combat_SetAudioCue0NameVolumeAndPriority_v129": {
		"family": "CombatAudio",
		"summary": "Primes audio cue slot 0 with a KSND sound name plus optional volume and priority overrides before playback.",
		"notes": [
			"Copies the supplied sound name into the cue-0 runtime block at `DAT_004810d4`, optionally writes parameter id `0` on that named sound through KSND_C_setParamName, and can also raise parameter id `2` toward `0x7f` when the caller requests a priority bump.",
			"Shell_PlayUiRejectCue_v129 uses it with the named sound `alm4` and the current frontend SFX slider value before calling Combat_PlayAudioCue_v129(0).",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClearAudioCue0RuntimeHandle_v129": {
		"family": "CombatAudio",
		"summary": "Clears the stored runtime handle for audio cue slot 0.",
		"notes": [
			"Writes zero to `DAT_004810f5`, the handle field for cue slot `0` inside the shared retail audio-cue runtime block.",
			"Shell_PlayUiRejectCue_v129 calls it immediately after Combat_PlayAudioCue_v129(0) so the shared UI reject sound leaves no live cue-0 handle behind in the combat audio wrapper state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetLasrSoundState_v129": {
		"family": "CombatAudio",
		"summary": "Resets the retail LASR sound state machine, clears the current/target state ids, and releases active LASR handles.",
		"notes": [
			"Clears the LASR enable/ramp flags, resets the current and pending LASR state ids plus the target volume bookkeeping, unregisters any active LASR sound handles, and zeroes the loop counters used by the LASR playback sequencer.",
			"It also routes the Miles callback clear through Combat_RegisterLasrSequenceCallback_v129 so every live LASR sequence handle drops its current retail sequence callback before the state machine goes idle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_StopLasrSound_v129": {
		"family": "CombatAudio",
		"summary": "Stops the active LASR sound profile and resets the LASR state machine when LASR is armed.",
		"notes": [
			"When the LASR enabled/armed bits are both set, stops the currently active LASR sound profile through the shared profile-stop helper and then calls Combat_ResetLasrSoundState_v129 to clear the runtime state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetLasrSoundState_v129": {
		"family": "CombatAudio",
		"summary": "Maps an abstract LASR state id to the concrete retail sound profile and target volume bookkeeping.",
		"notes": [
			"When LASR is enabled and armed, translates the requested LASR state into a concrete profile id and target volume value, marks the target volume for ramping when needed, latches the requested abstract state, and schedules the LASR playback sequencer to refresh the active sound profile.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_GetLasrSoundState_v129": {
		"family": "CombatAudio",
		"summary": "Returns the currently latched LASR state id when the LASR sound system is enabled.",
		"notes": [
			"Returns the abstract LASR state stored in `DAT_0047d5bc` when the LASR enabled bit is set, otherwise returns `-1` so the caller can treat LASR as inactive.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_EnsureLasrMidiOutputOpen_v129": {
		"family": "CombatAudio",
		"summary": "Ensures the Miles MIDI output used by the LASR sound layer is open.",
		"notes": [
			"Returns success immediately when the shared MIDI-open flag is already set. Otherwise opens the Miles MIDI output device, records the handle in `DAT_0048b92c`, sets the shared MIDI-open bit on success, and clears that bit again when the open call fails.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_EnsureLasrSoundInitialized_v129": {
		"family": "CombatAudio",
		"summary": "Initializes the LASR sound system on first use and resets the runtime LASR state when initialization succeeds.",
		"notes": [
			"If the LASR enabled bit is not set, attempts the one-time LASR backend initialization, clears the transient LASR runtime state through the shared reset helper, and marks LASR as enabled. Returns whether LASR is now available so callers can skip LASR work when initialization fails.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadLasrSequenceData_v129": {
		"family": "CombatAudio",
		"summary": "Loads one LASR sequence data blob into a profile slot and seeds its default tempo/volume values.",
		"notes": [
			"Loads the named sequence resource through the shared asset loader, stores the resulting data pointer in the destination LASR slot, and initializes the slot's default tempo to `100` with volume `0` before playback handles are allocated.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadLasrSequenceProfiles_v129": {
		"family": "CombatAudio",
		"summary": "Loads the retail LASR profile table by splitting each profile's sequence list and loading every named MIDI sequence.",
		"notes": [
			"Walks the LASR profile descriptors in `DAT_0047d620`, splits each space-delimited sequence list into individual names, prepends the retail MUSIC path/suffix, loads every sequence through Combat_LoadLasrSequenceData_v129, and marks the LASR profile table as armed when all profiles load successfully.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_OpenLasrProfileSequences_v129": {
		"family": "CombatAudio",
		"summary": "Allocates and initializes playback handles for every sequence in one LASR profile.",
		"notes": [
			"Walks the sequence slots in the requested LASR profile, allocates a Miles sequence handle for each slot, initializes that handle from the preloaded sequence data, and clears the LASR pending-swap flags when the profile is ready.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_StopLasrProfileSequences_v129": {
		"family": "CombatAudio",
		"summary": "Stops and releases every active sequence handle in one LASR profile.",
		"notes": [
			"Iterates over the active sequence slots in the requested LASR profile, stops each sequence handle, and then releases the handle so the profile can be re-opened or discarded cleanly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetLasrProfileVolume_v129": {
		"family": "CombatAudio",
		"summary": "Sets the current volume value across every sequence in one LASR profile.",
		"notes": [
			"Adds the requested delta into the shared LASR profile volume accumulator and applies the resulting value to each sequence slot in the selected profile through Combat_SetLasrSequenceVolume_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AdjustLasrProfileTempo_v129": {
		"family": "CombatAudio",
		"summary": "Adjusts the playback tempo across every sequence in one LASR profile.",
		"notes": [
			"Applies the requested tempo delta to the shared LASR profile tempo accumulator and forwards the updated tempo to each sequence slot in the profile through Combat_AdjustLasrSequenceTempo_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_StepLasrProfileVolumeTowardTarget_v129": {
		"family": "CombatAudio",
		"summary": "Steps the active LASR profile volume one unit toward the pending target volume.",
		"notes": [
			"Chooses a `+1` or `-1` step based on the difference between the current and target LASR volume values, applies that step through Combat_SetLasrProfileVolume_v129, and clears the LASR ramp-in-progress bit once the target volume has been reached.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FadeOutLasrProfileVolume_v129": {
		"family": "CombatAudio",
		"summary": "Fades the current LASR profile down by one volume step until it reaches silence.",
		"notes": [
			"Calls Combat_SetLasrProfileVolume_v129 with a `-1` step and clears the LASR fade-out bit once the shared LASR profile volume reaches zero.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AutoSelectLasrSoundState_v129": {
		"family": "CombatAudio",
		"summary": "Auto-selects the retail LASR sound state from the current target, nearest hostile, and range/visibility rules.",
		"notes": [
			"Chooses either the pinned hostile target or the nearest valid hostile actor, derives the desired LASR state from distance thresholds and line-of-sight style checks, compares it to the current LASR state from Combat_GetLasrSoundState_v129, and calls Combat_SetLasrSoundState_v129 when the selected state changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AreActorsWithinAnyWeaponRange_v129": {
		"family": "CombatAudio",
		"summary": "Checks whether either actor currently sits within any configured weapon range band of the other.",
		"notes": [
			"Measures the actor-to-actor distance, walks the equipped weapon ids for the local actor and then for the opposing actor, resolves each weapon's range band from the shared weapon definition table, and returns success as soon as the measured distance fits within any of those weapon ranges.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeActorEffectivenessScore_v129": {
		"family": "CombatAudio",
		"summary": "Computes a normalized remaining combat-effectiveness score for one actor from armor, weapon, and component losses.",
		"notes": [
			"Starts from the chassis baseline score stored in the actor definition, subtracts armor deficit, unavailable weapon value, and additional component-loss penalties, and returns the remaining effectiveness figure later used by the LASR relative-state selector.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeActorSubsystemEffectivenessTotals_v129": {
		"family": "CombatAudio",
		"summary": "Accumulates one actor's non-weapon subsystem effectiveness totals and returns both the baseline total and the missing amount.",
		"notes": [
			"Walks the fixed-length subsystem value block on the actor record alongside the corresponding chassis-definition values, sums the current and maximum subsystem effectiveness points, and returns the lost-point deficit as the second out parameter. Combat_ComputeActorEffectivenessScore_v129 uses that deficit as one of the non-armor penalties in the LASR effectiveness model.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ComputeActorWeaponEffectivenessTotals_v129": {
		"family": "CombatAudio",
		"summary": "Accumulates one actor's weapon effectiveness totals and returns both the baseline value and the unavailable-weapon deficit.",
		"notes": [
			"Iterates the chassis weapon list, sums each slot's effectiveness weight from the retail weapon-value table, and separately accumulates only the currently usable weapons after checking slot presence/ammo state on the actor record. Combat_ComputeActorEffectivenessScore_v129 subtracts the resulting unavailable-weapon deficit when deriving the LASR relative-effectiveness score.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CompareActorRelativeEffectiveness_v129": {
		"family": "CombatAudio",
		"summary": "Compares two actors by normalized remaining combat effectiveness and returns a scaled ratio.",
		"notes": [
			"Calls Combat_ComputeActorEffectivenessScore_v129 for both actors, divides those scores after normalizing by each chassis baseline score, and returns the resulting relative-effectiveness ratio scaled by `1000` for the LASR selector.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetLasrRelativeEffectivenessState_v129": {
		"family": "CombatAudio",
		"summary": "Resets the stored LASR relative-effectiveness ratio and state latch to their drop-scene defaults.",
		"notes": [
			"Seeds the prior relative-effectiveness ratio back to `1000` and clears the companion state word that Combat_StepLasrRelativeEffectivenessState_v129 uses when smoothing the next combat-relative advantage transition. Shell_EnterDropScene_v129 calls it before the next combat/bootstrap sequence begins.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_StepLasrRelativeEffectivenessState_v129": {
		"family": "CombatAudio",
		"summary": "Steps the LASR relative-advantage state one slot up or down from the previous effectiveness ratio.",
		"notes": [
			"Uses the stored prior relative-effectiveness ratio in `DAT_0047e588` plus the current LASR state to choose a base state in the retail `7..13` range, then nudges that state by one step depending on whether the new ratio increased or decreased before storing the new ratio for the next tick.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_TickLasrSoundState_v129": {
		"family": "CombatAudio",
		"summary": "Advances the retail LASR sound state machine, including pending volume ramps and sound-handle swaps.",
		"notes": [
			"When LASR is enabled and armed, advances any pending target-volume ramp, counts down the current LASR playback step, swaps active LASR sound handles when the queued profile changes, and dispatches the current LASR profile callback to keep the alert sound sequence running.",
			"Whenever the active LASR sequence handle changes, it rebinds the Miles sequence callback through Combat_RegisterLasrSequenceCallback_v129 so the alert sequencer keeps driving the retail state machine.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RegisterLasrSequenceCallback_v129": {
		"family": "CombatAudio",
		"summary": "Thin wrapper around the Miles sequence-callback registration used by the retail LASR sound state machine.",
		"notes": [
			"Delegates directly to `_AIL_register_sequence_callback_8` for the supplied sequence handle and callback pointer.",
			"Combat_ResetLasrSoundState_v129 uses it to clear callbacks during LASR teardown, and Combat_TickLasrSoundState_v129 reuses it when a new LASR profile sequence becomes active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitLasrSequenceHandle_v129": {
		"family": "CombatAudio",
		"summary": "Allocates and initializes one Miles playback handle for a LASR sequence slot.",
		"notes": [
			"Allocates a Miles sequence handle on the shared LASR MIDI output, initializes that handle from the slot's preloaded sequence data, and records the requested sequence index in the slot for later playback.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_StartLasrSequence_v129": {
		"family": "CombatAudio",
		"summary": "Starts one LASR sequence handle and reapplies the slot's current tempo and volume.",
		"notes": [
			"Starts the Miles sequence handle in the supplied LASR slot, then reapplies the slot's cached tempo and volume values so the sequence begins with the profile's current playback settings.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_StopLasrSequence_v129": {
		"family": "CombatAudio",
		"summary": "Stops one active LASR sequence handle.",
		"notes": [
			"Calls the Miles stop-sequence API for the LASR slot's active sequence handle when the LASR MIDI layer is available and the slot currently owns a handle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_EndLasrSequence_v129": {
		"family": "CombatAudio",
		"summary": "Ends one active LASR sequence handle immediately.",
		"notes": [
			"Calls the Miles end-sequence API for the LASR slot's active sequence handle, forcing that sequence to terminate without waiting for the normal completion path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ReleaseLasrSequenceHandle_v129": {
		"family": "CombatAudio",
		"summary": "Releases one LASR sequence handle and clears the slot's handle pointer.",
		"notes": [
			"Calls the Miles release-handle API for the LASR slot's active sequence handle and writes zero back into the slot so later profile reloads can allocate a fresh handle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AdjustLasrSequenceTempo_v129": {
		"family": "CombatAudio",
		"summary": "Adjusts one LASR sequence slot's cached tempo and applies it to the active handle.",
		"notes": [
			"Adds the requested tempo delta to the slot's cached tempo, clamps the result to at least `1`, stores that updated tempo in the slot, and applies it to the active Miles sequence handle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetLasrSequenceVolume_v129": {
		"family": "CombatAudio",
		"summary": "Sets one LASR sequence slot's cached volume and applies it to the active handle.",
		"notes": [
			"Stores the requested volume in the LASR slot and forwards that value to the active Miles sequence handle when the LASR MIDI layer and handle are both available.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_GetLasrSequenceStatus_v129": {
		"family": "CombatAudio",
		"summary": "Returns the Miles playback status for one LASR sequence slot.",
		"notes": [
			"Returns `-1` when the LASR MIDI layer or the slot's sequence handle is unavailable; otherwise returns the Miles sequence-status code for the active LASR sequence handle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/combat/combat.gd",
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
	"Combat_SetAudioCuePan_v129": {
		"family": "CombatAudio",
		"summary": "Sets the stereo pan for a combat audio cue slot.",
		"notes": [
			"Uses Miles `KSND_C_setParamName`/`KSND_C_setParamSnd` with parameter id `1`, matching the retail cue-slot storage used by Combat_SetAudioCueVolume_v129 and Combat_SetAudioCuePitch_v129. The grounded cadence helper alternates this value between the left/right endpoints while reusing cue slot `0x22`.",
		],
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
			"Combat_MainLoop_v129 refreshes the preview model's per-section damage colors through Combat_UpdateActorPreviewSectionStatusColors_v129 immediately before each self/target render pass.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SelectActorAnimationStateRecord_v129": {
		"family": "CombatPreview",
		"summary": "Selects one raw actor animation-state record by id and resets the preview controller counters without running the full transition path.",
		"notes": [
			"Clears the transition-in-progress bit on the animation controller, searches the controller's state-record table for the requested id, swaps the active record pointer, marks the controller dirty, and zeroes the two progress counters used by Combat_BuildActorAnimationPose_v129.",
			"Combat_RenderActorPreviewPanel_v129 uses it to snap the preview controller to state `0` before building the neutral preview pose.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_FillRectWithRandomInterferenceRuns_v129": {
		"family": "CombatPreview",
		"summary": "Paints randomized opaque span runs into a combat panel rect to create the retail interference/static effect.",
		"notes": [
			"Called only by Combat_MainLoop_v129 after the caller clears the destination rect with palette value `0x0c`. The helper walks the rect a row at a time, seeds random 4-pixel span runs with `0xffffffff`, and can either cover every row or just a moving striped band depending on the stride arguments.",
			"Combat_MainLoop_v129 uses the full-rect mode when the actor-panel interference level is severe and the striped mode when Combat_GetActorPanelInterferenceLevel_v129 returns the lighter rolling-static state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateActorPreviewSectionStatusColors_v129": {
		"family": "CombatPreview",
		"summary": "Updates the combat actor preview model's per-section status colors from the current armor and internal structure values.",
		"notes": [
			"Walks the eleven mech detail rows, compares the live armor/internal values in the actor block against the decoded mech record and the internal-structure maxima, chooses one of four hard-coded status colors, and writes that color onto the matching preview-model section entry through the private mesh-color setter at `FUN_00436420`.",
			"Called from Combat_MainLoop_v129 immediately before both self and target Combat_RenderActorPreviewPanel_v129 draws so the preview mesh reflects current section damage without rebuilding the panel layout.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SetActorPreviewSectionStatusColor_v129": {
		"family": "CombatPreview",
		"summary": "Writes one color override into the tagged preview-model section entry used by the actor preview panel.",
		"notes": [
			"Searches the preview model's section-tag table for the requested row tag and stores the supplied color value into the per-section record at offset `+6`.",
			"Combat_UpdateActorPreviewSectionStatusColors_v129 calls it once per active preview section after choosing the red/orange/green/destroyed color for that mech detail row.",
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
	"Combat_ResetImpactScreenShakeState_v129": {
		"family": "CombatEffects",
		"summary": "Clears the active and queued impact-driven screen-shake banks used by combat rendering.",
		"notes": [
			"Zeros both impact-shake state blocks plus the shared shake timestamp latch. Called from combat result-scene init and the broader combat scene reset path before a fresh combat runtime starts.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_QueueImpactScreenShake_v129": {
		"family": "CombatEffects",
		"summary": "Queues one impact-driven screen shake using a damage-class magnitude and caller-supplied duration.",
		"notes": [
			"Used by queued damage/impact resolution. Looks up the base shake magnitude from the retail damage-class table, seeds the primary impact-shake bank when none is active, and otherwise stores the stronger pending shake in the queued bank so it takes over when the current impact shake expires.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_PollScreenShakeMode_v129": {
		"family": "CombatEffects",
		"summary": "Polls the combat shake banks and returns the currently active screen-shake mode when the next shake tick is due.",
		"notes": [
			"Returns `0` when neither shake bank is active or when less than 10 ms have elapsed since the last shake sample. Otherwise latches and returns mode `1` for impact shake or mode `2` for weapon-fire shake, preferring the stronger bank when both are armed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_PollJoystickButtonsAndHatBindings_v129": {
		"family": "JoystickControl",
		"summary": "Polls the configured combat joystick buttons and POV hat, dispatching newly pressed bindings into either presentation hotkeys or the bound action handler.",
		"notes": [
			"Runs once per Combat_MainLoop_v129 tick when a joystick is present and enabled. Button bindings tagged as presentation controls route into Combat_HandlePresentationHotkey_v129 on edge transitions, while action bindings route into the separate joystick action dispatcher; the POV hat follows the same split when the retail hat-switch flags are enabled.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RefreshJoystickCapabilitiesAndAxisConfig_v129": {
		"family": "JoystickControl",
		"summary": "Probes the retail joystick device, refreshes cached capability/calibration state, and clears unsupported axis-mode assignments.",
		"notes": [
			"Runs the `joyGetPosEx` / `joyGetDevCaps` detection sequence, chooses the first working joystick device, retries once after the retail first-pass load when the device strings/caps are incomplete, caches the live center/range values for the supported axes, and clears the saved per-axis mode bytes `DAT_0047f8e5/e9/ed/f1` when no valid joystick/capability set is available. Shell_InitializeFrontendResourcesAndAudio_v129 calls it during startup, and the nearby joystick-status formatter reuses the same refresh path before reporting device availability.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Combat_InitializeJoystickBindingLookupTables_v129": {
		"family": "JoystickControl",
		"summary": "Loads or migrates the retail joystick keymap when needed, then rebuilds the runtime lookup tables used to resolve bound joystick actions.",
		"notes": [
			"Ensures the joystick keymap cache is loaded, performs the one-time registry-backed migration for the legacy binding sentinel, clears the four reverse-lookup tables under `DAT_004e4b60`-`DAT_004e5170`, and repopulates them from the active binding records in `DAT_004e8860` according to each binding's category bits. Shell_RunFrontendMain and Combat_ResetPresentationStateAndLoadVisualOptions_v129 both call it before any joystick-driven control handling so the runtime can translate incoming keyboard or joystick codes back to bound retail actions through Combat_LookupBoundKeyAction_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetLocalControlActionPressedState_v129": {
		"family": "JoystickControl",
		"summary": "Sets or clears the held-state bit for one continuous retail local-control action.",
		"notes": [
			"Maps the bound action id onto the shared local-control bitfield `DAT_004e4f64`, updating only the continuous actions that movement, jump, help-overlay, and voice-input ticks sample each frame.",
			"Frame_TranslateKeyMessageToNormalizedKey_v129, Combat_PollJoystickButtonsAndHatBindings_v129, and the combat mouse-control branch inside Frame_DispatchMouseEventToWindowStack_v129 all route press/release changes through this helper before Combat_ProcessLocalMovementAndJumpInput_v129, Combat_JumpJetInputTick_v129, and Combat_TickVoiceTransmissionSpeechInState_v129 consume the latched state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_LookupBoundKeyAction_v129": {
		"family": "JoystickControl",
		"summary": "Resolves a retail combat action id from the current keyboard-binding tables using an encoded key plus modifier mask.",
		"notes": [
			"Chooses one of the four reverse-lookup tables populated by Combat_InitializeJoystickBindingLookupTables_v129 for the plain, Alt, Ctrl, or Shift binding category and returns the bound action id for the low-byte key code.",
			"Frame_TranslateKeyMessageToNormalizedKey_v129 uses it to decide whether an incoming key should fire an edge-triggered hotkey immediately or update the held-action state through Combat_SetLocalControlActionPressedState_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_OpenJoystickConfigDialog_v129": {
		"family": "JoystickControl",
		"summary": "Opens the modal retail joystick-configuration dialog from the shell frontend.",
		"notes": [
			"Thin wrapper around `DialogBoxParamA(..., resource 0x71, Combat_JoystickConfigDialogProc_v129, 0)`. Shell_RunFrontendMain_v129 and the nearby unnamed shell/options path both reuse it when the player opens the combat joystick setup surface.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_OpenJoystickControlPanelApplet_v129": {
		"family": "JoystickControl",
		"summary": "Launches the Windows joystick control-panel applet and starts the helper thread that hooks the spawned CPL window.",
		"notes": [
			"Creates the helper thread backed by Combat_HookJoystickControlPanelWindowThread_v129, loads `joy.cpl`, resolves the exported `CPlApplet` entrypoint, and drives the standard init/inquire/open/stop/exit message sequence for the control-panel applet before unloading the module.",
			"The nearby unnamed joystick-options surface uses it when the player requests the operating-system joystick calibration/settings panel from inside the retail frontend.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FindJoystickControlPanelWindowEnumProc_v129": {
		"family": "JoystickControl",
		"summary": "EnumWindows callback that finds the spawned joystick control-panel window owned by the retail frontend.",
		"notes": [
			"Checks each top-level window's owner against the cached frontend window handle, stores the matching joystick control-panel HWND, and signals the waiting helper thread once the target window appears.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_HookJoystickControlPanelWindowThread_v129": {
		"family": "JoystickControl",
		"summary": "Helper thread that waits for the spawned joystick control-panel window, installs the retail hook pointer, and normalizes its extended style.",
		"notes": [
			"Loops until Combat_FindJoystickControlPanelWindowEnumProc_v129 discovers the joy.cpl window, snapshots the existing callback pointer stored in the applet's window-extra slot, installs the retail handler at `0x414550`, clears the `0x400` extended-style bit, and forces a redraw before exiting.",
			"Combat_OpenJoystickControlPanelApplet_v129 runs this helper in parallel with the control-panel applet so the spawned system dialog adopts the retail shell's expected behavior and chrome rules.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildJoystickCapabilityFlagTable_v129": {
		"family": "JoystickControl",
		"summary": "Builds the small joystick capability flag table consumed by the retail options/property-sheet UI.",
		"notes": [
			"Writes a fixed leading marker in slot `0`, mirrors the current joystick-present state into slots `1` and `2`, and fills the remaining slots from the detected capability bits in `DAT_004e91d0`, clearing every optional entry when no joystick or no active device is available.",
			"Shell_JoystickOptionsPageProc_v129 reuses this helper before enabling its per-axis controls and rebuilding the live selector rows shown in the frontend settings UI.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FindJoystickCapabilityIndexByComboSelection_v129": {
		"family": "JoystickControl",
		"summary": "Maps one joystick-options combo-box selection back to the underlying seven-slot capability index.",
		"notes": [
			"Linearly scans the seven-entry selector mapping table built beside `DAT_0048b0b8` and returns the matching capability slot, or `-1` when the combo selection does not correspond to any currently exposed row.",
			"Shell_JoystickOptionsPageProc_v129 uses it on apply to convert the four combo-box selections back into the persisted `DAT_0047f8e5`..`DAT_0047f8f1` joystick capability indices after the duplicate-check pass succeeds.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetJoystickCapabilitySummaryControlText_v129": {
		"family": "JoystickControl",
		"summary": "Builds the localized joystick capability summary string and writes it directly into one retail options dialog control.",
		"notes": [
			"Starts from the shared joystick-status prefix in `DAT_0047cd48`, appends one or more localized fragments selected from the current `DAT_0048afe8` capability/state bits, joins multi-fragment output with the shared separator at `DAT_0047d1ec`, and commits the final text through `SetDlgItemTextA`.",
			"Shell_AudioOptionsPageProc_v129 refreshes control `0x446` with this helper whenever the live joystick capability flags change, while the broader frontend flow keeps using Combat_FormatJoystickStatusSummary_v129 for the simpler buffer-based status line cases.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_PollJoystickAxisState_v129": {
		"family": "JoystickControl",
		"summary": "Refreshes the cached retail joystick axis state when the current device and capability flags permit it.",
		"notes": [
			"Runs from Combat_MainLoop_v129 before higher-level joystick input handling. Rebuilds the JOYINFOEX flag mask from the detected capability bits in `DAT_004e91d0`, rate-limits polling through `DAT_0047d000`, and stores the latest axis-position snapshot in the shared joystick state block used by the movement and aim control paths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FormatJoystickBindingLabel_v129": {
		"family": "JoystickControl",
		"summary": "Formats a retail joystick binding code into the human-readable label shown by the joystick dialogs.",
		"notes": [
			"Builds an optional binding-category prefix from the `0x100/0x200/0x400` flag bits, then appends either a known symbolic label from the retail joystick-name table or a formatted fallback code string for anonymous inputs. Combat_JoystickConfigDialogProc_v129 and Combat_RebuildJoystickConflictList_v129 both use it to paint the current binding text shown in the joystick setup dialogs.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_HasDuplicateJoystickBindings_v129": {
		"family": "JoystickControl",
		"summary": "Returns whether the active retail joystick action-binding table contains any duplicate assignments.",
		"notes": [
			"Scans the live `DAT_004e8860` action-binding table for repeated nonzero bindings and returns immediately when a duplicate is found. Shell_RunFrontendMain_v129 calls it after Combat_InitializeJoystickBindingLookupTables_v129 so startup can force the joystick configuration flow when duplicate bindings are present.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FormatJoystickStatusSummary_v129": {
		"family": "JoystickControl",
		"summary": "Builds the localized retail joystick status string for the combat-controls/options UI and returns the availability state code.",
		"notes": [
			"Refreshes device capabilities through Combat_RefreshJoystickCapabilitiesAndAxisConfig_v129, then writes one of three localized status strings into the caller-supplied buffer: `0` for a detected joystick with its formatted name/capability flags, `1` when no joysticks are attached, and `2` when a joystick exists but no usable active device was selected. The unnamed joystick-options UI callers reuse this formatter whenever the control-options surface needs to repaint its current device status line.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_JoystickBindingDialogProc_v129": {
		"family": "JoystickControl",
		"summary": "Handles the retail joystick binding-assignment dialog for buttons, POV directions, and axis channels.",
		"notes": [
			"On `WM_INITDIALOG` it clones the live button/POV and axis binding tables into a working buffer, populates the action list plus the available joystick inputs/axis channels, and then services reassignment, per-action reset, defaults restore, apply, and cancel commands. The dialog writes the chosen binding label into the preview control and persists changes through Combat_SaveJoystickKeymap_v129 only when the user confirms the dialog.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_JoystickConfigDialogProc_v129": {
		"family": "JoystickControl",
		"summary": "Handles the retail joystick-configuration dialog lifecycle, selection changes, assignment edits, and apply/reset actions.",
		"notes": [
			"On `WM_INITDIALOG` it clones the live joystick binding tables into a working buffer, resolves the key controls, and populates the list widgets. Later message branches handle list-selection changes, live assignment capture, reset/default actions, apply/cancel, and the final validation/persist step through the nearby joystick-table helpers before the dialog closes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RebuildJoystickConflictList_v129": {
		"family": "JoystickControl",
		"summary": "Recomputes the retail joystick binding-conflict list and repopulates the dialog list box with the duplicate assignments.",
		"notes": [
			"Clones the working joystick binding table, scans it for repeated action assignments, stores the conflicting slot ids into the dialog scratch array at `DAT_0048f058`, and formats each duplicate as `action : binding` text for the target list box. Combat_JoystickConfigDialogProc_v129 calls it after init, reassignment, reset, and revert actions so the conflict list always mirrors the current working keymap.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_HasConfiguredJoystickAxisModes_v129": {
		"family": "JoystickControl",
		"summary": "Returns whether any of the retail joystick axis-control channels currently has an active mode assignment.",
		"notes": [
			"Checks the four saved axis-mode bytes that back upper-body horizontal/vertical control, chassis turning, and throttle, and returns true when any channel uses the active retail mode values `1` or `2`. Combat_PollJoystickButtonsAndHatBindings_v129 uses the predicate to skip the button/POV polling path when no joystick-driven axis control mode is configured.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SaveJoystickKeymap_v129": {
		"family": "JoystickControl",
		"summary": "Writes the current retail joystick/keymap tables to `keymap.bin` and returns whether every table write succeeded.",
		"notes": [
			"Opens `keymap.bin`, writes the retail `'b'` file marker, then serializes the small axis-mode table, the two-word axis-direction block, the button/POV binding table, and the main action-binding table in that order. Combat_JoystickConfigDialogProc_v129 uses the boolean result to decide whether to show the save-failure warning after the player applies joystick-config changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_LoadJoystickKeymap_v129": {
		"family": "JoystickControl",
		"summary": "Loads the retail joystick/keymap tables from `keymap.bin`, falling back to the built-in defaults when the file is absent or malformed.",
		"notes": [
			"Seeds the caller's main action-binding table from the built-in defaults, then tries to read the version byte plus the axis-mode, axis-direction, button/POV, and action-binding tables from `keymap.bin`. Any open/read/version failure restores the retail default tables before marking the joystick config cache as initialized, which is why Combat_JoystickConfigDialogProc_v129 can treat the helper as both cache warm-up and file load.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildCameraShakeOffsets_v129": {
		"family": "CombatEffects",
		"summary": "Builds signed screen-shake offsets for the active combat shake mode.",
		"notes": [
			"Zeroes the output pair when no shake mode is active, dispatches mode `2` into the weapon-fire shake builder, and routes all other active modes through the impact-shake builder.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildImpactScreenShakeOffsets_v129": {
		"family": "CombatEffects",
		"summary": "Builds signed X/Y offsets for the active impact-driven screen shake and rolls queued impact shakes forward as they expire.",
		"notes": [
			"Samples the current impact-shake magnitude and duration state, uses MakeRandomModulo to pick signed offsets inside that magnitude, and when the active shake window expires promotes the queued impact shake bank into the primary slot before continuing.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetWeaponFireScreenShakeState_v129": {
		"family": "CombatEffects",
		"summary": "Clears the weapon-fire screen-shake bank used by combat rendering.",
		"notes": [
			"Zeros the dedicated weapon-fire shake state block and resets the shared shake timestamp latch. Called alongside the impact-shake reset helpers during combat result-scene init and full combat runtime reset.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_QueueWeaponFireScreenShake_v129": {
		"family": "CombatEffects",
		"summary": "Queues a fixed-duration weapon-fire screen shake based on the current weapon/effect id.",
		"notes": [
			"Used by the local weapon-fire / spawned-impact paths. Looks up the shake magnitude from the retail weapon-effect table, arms the dedicated weapon-fire shake bank for the fixed retail duration `0x28`, and only replaces the current bank when the new shake is at least as strong as the old one.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildWeaponFireScreenShakeOffsets_v129": {
		"family": "CombatEffects",
		"summary": "Builds signed X/Y offsets for the active weapon-fire screen-shake bank.",
		"notes": [
			"Uses MakeRandomModulo to generate signed offsets from the weapon-fire shake magnitude, scaling the horizontal component more tightly than the vertical component, and clears the bank once the fixed weapon-fire shake window expires.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SelectActiveScreenShakeMode_v129": {
		"family": "CombatEffects",
		"summary": "Selects which combat screen-shake bank should drive the current frame when multiple shake banks are armed.",
		"notes": [
			"When both the impact and weapon-fire banks are armed, compares their current magnitudes and returns mode `1` for the stronger impact shake or mode `2` for the stronger weapon-fire shake, updating the shared active-mode flag in place.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
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
	"Combat_SetAttachmentSubtreeHiddenStateByTag_v129": {
		"family": "CombatEffects",
		"summary": "Recursively sets or clears the hidden-state bit for one attachment tag and all of its child attachments.",
		"notes": [
			"Walks the model attachment hierarchy rooted at the requested tag and toggles the bitmask stored at `model + 0x54`. Combat_RenderModelAttachments_v129 skips any attachment whose bit is set, and the internal-structure destruction path uses this helper to propagate that state across a whole attachment subtree.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_IsAttachmentTagHidden_v129": {
		"family": "CombatEffects",
		"summary": "Returns whether an actor's attachment tag is currently hidden in the retail attachment-state bitmask.",
		"notes": [
			"Looks up the actor's active model, finds the requested attachment tag, and checks the corresponding bit in the model visibility mask at `model + 0x54`. Combat_UpdateProjectileEffectState_v129 uses it to stop tracking an impact attachment once that attachment has been hidden or detached.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_GetAttachmentTrailColorByTag_v129": {
		"family": "CombatEffects",
		"summary": "Returns the retail trail-strip color associated with one attachment tag.",
		"notes": [
			"Walks the model attachment table and returns the packed color/material value stored alongside the requested tag. Retail impact and projectile paths feed that value directly into Combat_SpawnEffectTrailStripBurst_v129 so attachment-based effects inherit the attachment's color.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_GetAttachmentLocalOffsetByTag_v129": {
		"family": "CombatEffects",
		"summary": "Returns the local attachment offset for one attachment tag in model space.",
		"notes": [
			"Reads the attachment's local XYZ offset from the model attachment transform table and copies it into the caller buffer. Retail projectile tracking, impact-effect placement, and effect-model rendering all use this helper before transforming the point into world or camera space.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SpawnAttachmentSubtreeEffectModelsByTag_v129": {
		"family": "CombatEffects",
		"summary": "Recursively spawns detached effect-model entries for one attachment subtree rooted at the requested tag.",
		"notes": [
			"Finds the requested attachment tag, transforms its local offset into world space, recurses through child attachments, marks the subtree hidden in the model visibility bitmask, allocates render-type `8` effect-model entries, and seeds matching trail-strip bursts using Combat_GetAttachmentTrailColorByTag_v129. Combat_SpawnInternalStructureDestructionEffect_v129 uses it to turn a damaged internal-structure subtree into detached effect models.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CollectVisibleActorRenderEntries_v129": {
		"family": "CombatEffects",
		"summary": "Advances active actor presentation state, rebuilds actor poses, and queues visible actor records for the retail effect/render pass.",
		"notes": [
			"Called from Combat_RenderActiveEffectsPass_v129 after terrain-scenery and projectile collectors fill the transient render list. Rebuilds each active actor pose through Combat_BuildActorAnimationPose_v129, refreshes the remote presentation state when the actor is flagged for it, and appends actor records with an active model into the shared visible-object list at `DAT_004f5130`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CacheActorRenderDistance_v129": {
		"family": "CombatEffects",
		"summary": "Caches the current camera distance on one actor record for the retail effect/render pass.",
		"notes": [
			"Used only by Combat_RenderActiveEffectsPass_v129 for actor entries in the transient visible-object list. Stores the just-computed camera distance into the actor's encoded render-distance slot before the pass dispatches that actor through the per-type rendering path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitializeActiveEffectRenderPools_v129": {
		"family": "CombatEffects",
		"summary": "Allocates and clears the retail combat effect render pools used by the active-effects pass.",
		"notes": [
			"Called from Combat_ResetPresentationStateAndLoadVisualOptions_v129 during combat visual bootstrap. Ensures the sprite, hit-proxy model, trail-strip, and model-effect pools are allocated, then clears their active flags through Combat_ResetActiveEffectRenderPools_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetActiveEffectRenderPools_v129": {
		"family": "CombatEffects",
		"summary": "Clears the live-entry flags across the retail combat effect render pools without freeing their storage.",
		"notes": [
			"Resets the sprite-effect pool, the type-6 hit-proxy model pool, the trail-strip pool, and the model-effect pool so a new combat presentation pass starts with no active transient entries.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeActiveEffectRenderPools_v129": {
		"family": "CombatEffects",
		"summary": "Releases the retail combat effect render pools during combat visual teardown.",
		"notes": [
			"Frees the two smaller transient-effect pools directly, then delegates the trail-strip and model-effect pool teardown to their dedicated free helpers. Called from the higher-level combat visual shutdown path after other effect state is released.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetEffectSpriteEntries_v129": {
		"family": "CombatEffects",
		"summary": "Clears the active-state flags across the retail transient effect-sprite pool.",
		"notes": [
			"Walks the 60-entry `DAT_0047f844` pool and clears both the queued-for-render and active bits on each sprite-effect record. Combat_ResetActiveEffectRenderPools_v129 uses it when combat visual state is reinitialized.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetEffectHitProxyModelEntries_v129": {
		"family": "CombatEffects",
		"summary": "Clears the active-state flags across the retail type-6 effect hit-proxy model pool.",
		"notes": [
			"Walks the 60-entry `DAT_0047f848` pool and clears both the queued-for-render and active bits on each hit-proxy model record. Combat_ResetActiveEffectRenderPools_v129 uses it when combat visual state is reinitialized.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateEffectModelEntries_v129": {
		"family": "CombatEffects",
		"summary": "Allocates the fixed retail pool of transient effect-model entries.",
		"notes": [
			"Creates the 60-entry `DAT_0047f0bc` pool used by render type `8` model effects. Combat_InitializeActiveEffectRenderPools_v129 calls it during bootstrap before the pool is cleared by Combat_ResetEffectModelEntries_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeEffectModelEntries_v129": {
		"family": "CombatEffects",
		"summary": "Frees the fixed retail pool of transient effect-model entries.",
		"notes": [
			"Releases `DAT_0047f0bc` and clears the pool pointer. Combat_FreeActiveEffectRenderPools_v129 uses it during combat visual teardown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetEffectModelEntries_v129": {
		"family": "CombatEffects",
		"summary": "Clears the active-state flags across the retail transient effect-model pool.",
		"notes": [
			"Walks the 60-entry `DAT_0047f0bc` pool and clears both the queued-for-render and active bits on each model-effect record. Combat_ResetActiveEffectRenderPools_v129 uses it when combat visual state is reinitialized.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateEffectTrailStripEntries_v129": {
		"family": "CombatEffects",
		"summary": "Allocates the fixed retail pool of transient trail-strip effect entries.",
		"notes": [
			"Creates the 120-entry `DAT_00481080` pool used by render type `4` trail-strip effects. Combat_InitializeActiveEffectRenderPools_v129 calls it during bootstrap before the pool is cleared by Combat_ResetEffectTrailStripEntries_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeEffectTrailStripEntries_v129": {
		"family": "CombatEffects",
		"summary": "Frees the fixed retail pool of transient trail-strip effect entries.",
		"notes": [
			"Releases `DAT_00481080` and clears the pool pointer. Combat_FreeActiveEffectRenderPools_v129 uses it during combat visual teardown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetEffectTrailStripEntries_v129": {
		"family": "CombatEffects",
		"summary": "Clears the active-state flags across the retail transient trail-strip pool.",
		"notes": [
			"Walks the 120-entry `DAT_00481080` pool and clears both the queued-for-render and active bits on each trail-strip record. Combat_ResetActiveEffectRenderPools_v129 uses it when combat visual state is reinitialized.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CollectVisibleEffectHitProxyModels_v129": {
		"family": "CombatEffects",
		"summary": "Queues the active type-6 effect model entries that are rendered through the retail hit-proxy path.",
		"notes": [
			"Walks the fixed 60-slot `DAT_0047f848` pool, retires expired entries, and appends still-live records into the shared visible-object list at `DAT_004f5130`. In Combat_RenderActiveEffectsPass_v129 those queued entries are dispatched through Combat_RenderEffectModelHitProxy_v129 rather than the normal visible model renderer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BuildActiveEffectsCameraTransform_v129": {
		"family": "CombatEffects",
		"summary": "Builds the local active-effects camera transform, applying screen shake and the current local actor pose before the render pass runs.",
		"notes": [
			"Seeds the render-context timestamp, copies the local actor camera-angle fields into the temporary view basis, applies any active screen-shake offsets, rebuilds the local actor pose, and pulls the camera node transform for state tag `1`.",
			"It then rotates and translates that camera basis into world space, builds the inverse affine matrix stored in the active render context, and mirrors the resulting transform back into the local actor block at `+0xe0`. Combat_RenderActiveEffectsPass_v129 calls it before terrain, actor, and effect collection begins.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CollectVisibleEffectModels_v129": {
		"family": "CombatEffects",
		"summary": "Queues the active type-8 model-effect entries that are still alive for the retail effect/render pass.",
		"notes": [
			"Walks the fixed 60-slot `DAT_0047f0bc` pool, retires expired entries, advances moving entries through Combat_UpdateEffectModelEntryMotion_v129, refreshes their camera-relative transform, and appends still-live records into the shared visible-object list at `DAT_004f5130`.",
			"Combat_RenderActiveEffectsPass_v129 dispatches those queued records through Combat_RenderEffectModelAndCheckCursorHit_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_UpdateEffectModelEntryMotion_v129": {
		"family": "CombatEffects",
		"summary": "Advances one active transient effect-model entry's spin, velocity, and height with the retail damped-falloff rules.",
		"notes": [
			"Ticks the entry's local rotation matrix on a 5-centisecond cadence from the stored Euler rates, integrates its position from the fixed-point velocity triplet, and applies the vertical acceleration term stored on the entry.",
			"When the entry drops below height `1`, retail damps the vertical speed, horizontal drift, and spin rates toward zero; once both vertical terms reach zero it clears the motion-duration field so Combat_CollectVisibleEffectModels_v129 stops updating that entry.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CollectVisibleEffectSprites_v129": {
		"family": "CombatEffects",
		"summary": "Queues the active timed sprite effects that are still alive for the retail effect/render pass.",
		"notes": [
			"Walks the fixed 60-slot sprite-effect pool rooted at `DAT_0047f844`, clears expired entries, and appends still-live sprite records into the shared visible-object list at `DAT_004f5130`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SpawnEffectSprite_v129": {
		"family": "CombatEffects",
		"summary": "Allocates one timed retail effect sprite entry at a world position.",
		"notes": [
			"Claims a free record from the sprite-effect pool, writes render type `2`, seeds the start time and expiry, chooses the sprite resource through `FUN_00435630`, and marks the entry active so Combat_CollectVisibleEffectSprites_v129 can queue it for rendering.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateEffectSpriteAnimationInstance_v129": {
		"family": "CombatEffects",
		"summary": "Claims one live effect-sprite animation instance slot, seeds its timers, and returns the generation-tagged handle.",
		"notes": [
			"Scans the 100-entry live animation-instance pool for an expired record, binds it to the requested effect-animation slot, seeds the expiry and next-frame deadlines from the slot metadata, stores the caller-supplied initial frame index and restart flag, and returns the retail `(generation << 8) | slot_index` handle.",
			"Combat_SpawnEffectSprite_v129 uses it for both the ordinary fixed-slot path and the special case that randomizes the initial smoke frame through MakeRandomModulo.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CollectVisibleEffectTrailStrips_v129": {
		"family": "CombatEffects",
		"summary": "Advances the active trail-strip effects and queues the live ones for the retail effect/render pass.",
		"notes": [
			"Walks the 120-slot trail-strip pool rooted at `DAT_00481080`, updates each live entry through Combat_UpdateEffectTrailStripState_v129 while it remains unexpired, and appends the still-active strip records into the shared visible-object list at `DAT_004f5130`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CollectVisibleSpriteTrailAndHitProxyEffects_v129": {
		"family": "CombatEffects",
		"summary": "Queues the non-model transient effect pools that retail renders after the visible model-effect pass.",
		"notes": [
			"Bundles the three subordinate collectors for render types `2`, `4`, and `6` by calling Combat_CollectVisibleEffectSprites_v129, Combat_CollectVisibleEffectHitProxyModels_v129, and Combat_CollectVisibleEffectTrailStrips_v129 in sequence.",
			"Combat_RenderActiveEffectsPass_v129 calls it immediately after Combat_CollectVisibleEffectModels_v129 so all transient sprite, trail-strip, and hit-proxy entries land in the shared visible-object list at `DAT_004f5130` before the distance-sorted render walk begins.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SpawnEffectTrailStripBurst_v129": {
		"family": "CombatEffects",
		"summary": "Spawns a retail burst of multiple trail-strip effects around one world position.",
		"notes": [
			"Loops the requested burst count and delegates each strip to Combat_SpawnEffectTrailStrip_v129 with the same origin, spacing the initial velocity seed from the supplied magnitude. Retail uses this burst helper for internal-structure destruction and several projectile/impact fallout paths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SpawnEffectTrailStrip_v129": {
		"family": "CombatEffects",
		"summary": "Allocates one retail trail-strip effect entry and seeds its initial point chain, velocity, and transform.",
		"notes": [
			"Claims a free record from the trail-strip pool, writes render type `4`, seeds three local control points, randomizes the initial velocity vector around the supplied bias, and initializes the strip transform so Combat_UpdateEffectTrailStripState_v129 and Combat_RenderEffectTrailStrip_v129 can advance and draw it.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_UpdateEffectTrailStripState_v129": {
		"family": "CombatEffects",
		"summary": "Advances one active retail trail-strip effect and damps its motion until the strip collapses.",
		"notes": [
			"Refreshes the cached point chain and orientation vectors every 5 ms, integrates the strip's position and velocity, and decays the motion parameters toward zero. When the strip runs out of lift and motion, it clears the active point chain so Combat_CollectVisibleEffectTrailStrips_v129 can retire the entry.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SpawnTerrainSceneryImpactTrailBursts_v129": {
		"family": "CombatEffects",
		"summary": "Spawns the paired retail trail-strip bursts used when an impact hits a qualifying terrain-scenery instance.",
		"notes": [
			"Validates the target scenery instance in the `DAT_0047f728` terrain-scenery pool, checks the retail impact-capable flag on that instance, and emits the two fixed-color trail-strip bursts at the supplied world coordinate. Called from both Combat_SpawnImpactEffectAtAttachmentOrCoord_v129 and Combat_ResolveProjectileImpactDamage_v129 when the impact lands on scenery instead of an attachment-driven effect path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RenderActiveEffectsPass_v129": {
		"family": "CombatEffects",
		"summary": "Runs the retail combat effect render pass: updates active effects, depth-sorts the visible ones, and dispatches type-specific draw helpers.",
		"notes": [
			"Called from Combat_MainLoop_v129 after the camera basis is prepared. It begins by rebuilding the active-effects camera transform through Combat_BuildActiveEffectsCameraTransform_v129, then resets the transient effect hit-test globals before drawing and feeds the visible-effect list through the per-type sprite, trail, and model renderers.",
			"Combat_InitializeSharedRenderProjectionContexts_v129 preloads the fixed world, radar, and effect-panel projection descriptors consumed by the backdrop draw, terrain collection, and hit-proxy rendering paths inside this pass.",
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
			"Chooses the visible attachment view variant through Combat_ComputeVisibleAttachmentViewVariantIndex_v129, draws each polygon group through Combat_RenderTexturedPolygonGroup_v129 or Combat_RenderFlatShadedPolygonGroup_v129, and merges the resulting projected bounds back into the caller's screen-space extents.",
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
	"Combat_RenderEffectSpriteAnimationInstance_v129": {
		"family": "CombatEffects",
		"summary": "Validates, advances, scale-selects, and draws one live effect-sprite animation instance.",
		"notes": [
			"Validates the generation-tagged animation-instance handle, advances the active frame when its cadence timer elapses, retires non-restarting instances at the last frame, and walks the smaller/larger slot links when the projected sprite size no longer fits the current animation frames.",
			"After clipping the projected quad to the active viewport it delegates the actual scaled blit to Combat_BlitScaledEffectSpriteFrame_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_BlitScaledEffectSpriteFrame_v129": {
		"family": "CombatEffects",
		"summary": "Blits one scaled effect-sprite frame into the combat backbuffer through the retail sprite-scale table.",
		"notes": [
			"Uses the selected sprite-scale table row to map destination pixels back into the source frame, skips transparent source bytes, and writes the scaled frame into the active combat backbuffer stride.",
			"When the source rows repeat, it reuses the temporary row buffer at `DAT_0047efe4` so repeated scaled rows can be emitted more cheaply before Combat_RenderEffectSpriteAnimationInstance_v129 resumes normal clipping and timing.",
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
			"Reconstructs the effect's sampled trail points relative to the current camera, chooses the forward or reverse basis from the stored trail normals, then submits the strip through Combat_RenderLitClippedPolygon_v129.",
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
			"The beam branch clips the muzzle-to-impact segment through Combat_ClipLineSegmentToViewVolume_v129 before both endpoints are forwarded through Combat_ProjectWorldPointToScreenVertex_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_HandlePresentationHotkey_v129": {
		"family": "CombatPresentation",
		"summary": "Handles combat-scene presentation hotkeys, including detail toggles, voice-panel mode changes, and other in-scene UI shortcuts.",
		"notes": [
			"When the voice-transmission panel has focus it delegates immediately to Combat_HandleVoiceTransmissionInput_v129. Otherwise it routes individual hotkey opcodes into display-flag toggles, detail-level changes, small presentation-mode state flips, and the remaining generic combat shortcut dispatcher.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_HandleLocalControlHotkey_v129": {
		"family": "CombatPresentation",
		"summary": "Dispatches the retail combat local-control hotkeys for weapon slots, fire controls, movement shortcuts, and voice-panel subcontrols.",
		"notes": [
			"Installed as the combat frame's local hotkey callback and also reached from Combat_HandlePresentationHotkey_v129. Routes the retail control opcodes into weapon-slot selection and fire paths, throttle and targeting-mode shortcuts, presentation-toggle refreshes, and the roster/tune/history controls used by the voice-transmission panel.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/ui/combat_radar.gd",
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
	"Combat_SelectWeaponSlotHudEntry_v129": {
		"family": "WeaponHud",
		"summary": "Moves the active local weapon-slot HUD selection to the requested slot and flips the retail highlight colors.",
		"notes": [
			"Toggles the highlight rectangle off the previously selected slot and onto the newly selected slot through `Frame_SwapPaletteIndicesInRect_v129`, then stores the selected index in both the local actor state `(DAT_004f5778 + 0x376)` and the HUD cache `DAT_004e90f8`. Presentation hotkeys use this helper for direct slot picks and next/previous slot cycling.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SumWeaponTypeAmmoAndSlotCount_v129": {
		"family": "WeaponHud",
		"summary": "Sums the remaining ammo/value pool and matching slot count for one retail weapon type across the local mech loadout.",
		"notes": [
			"Walks the actor-local weapon slot table, matches entries whose retail weapon-type id equals the requested type, accumulates the per-slot remaining value from the actor state, and returns both the total and the number of contributing slots. The slot-availability refresh path uses it to decide when all slots of one ammo-sharing type have gone dry.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_UpdateWeaponSlotHudAvailability_v129": {
		"family": "WeaponHud",
		"summary": "Refreshes one weapon-slot HUD cell set to reflect the current shared-ammo and fireability state.",
		"notes": [
			"Checks whether the slot's retail weapon type still has any pooled ammo/value remaining and whether the slot is presently fireable, then remaps the slot's highlight colors accordingly and redraws the dependent HUD cell content. Combat uses this after ammo depletion, reload-style state changes, and other slot-state transitions.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_InitializeWeaponSlotHud_v129": {
		"family": "WeaponHud",
		"summary": "Builds the local weapon-slot HUD grid, binds its hotkeys, and seeds the initial per-slot cell state.",
		"notes": [
			"Creates the three hotkey controls for each visible weapon slot row, seeds their cell graphics through the shared slot-cell drawer, and then draws the header glyph / keycap strip across the weapon HUD. Bootstrap calls it once during combat scene setup before the slot selection and availability paths take over steady-state updates.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RedrawWeaponSlotHudGrid_v129": {
		"family": "WeaponHud",
		"summary": "Redraws the static local weapon-slot HUD grid and refreshes every slot's availability state.",
		"notes": [
			"Called from the combat HUD/control bootstrap after the root combat frame is ready. Rebuilds the per-row slot boxes and header strip when requested, reapplies the presentation highlight treatment for occupied rows, and then runs Combat_UpdateWeaponSlotHudAvailability_v129 across each visible weapon slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RedrawWeaponSlotHudWeaponTypeIcons_v129": {
		"family": "WeaponHud",
		"summary": "Redraws the retail weapon-type icon strip down the local weapon-slot HUD rows.",
		"notes": [
			"Called from Combat_RedrawWeaponSlotHudGrid_v129. Walks the visible weapon rows, looks up each row's retail weapon-type bitmap, blits those icons into the left side of the slot grid, and presents the shared icon column rectangle when the compact presentation mode permits immediate redraws.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawWeaponSlotHudOptionCell_v129": {
		"family": "WeaponHud",
		"summary": "Draws one retail weapon-slot option cell bitmap for the requested slot row and option column.",
		"notes": [
			"Used by weapon-slot bootstrap, expiry refresh, and the local-control hotkey toggles for the three per-slot option columns. Chooses the active, inactive, or unavailable retail bitmap according to the slot's stored toggle bit and availability flag, blits it into the matching HUD cell rectangle, and presents that cell when the compact presentation mode allows immediate redraws.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DrawWeaponSlotRangeIndicator_v129": {
		"family": "WeaponHud",
		"summary": "Draws the local weapon-slot range-bracket indicator for one slot against the current target distance.",
		"notes": [
			"Clears the slot's range-indicator rectangle, checks whether the selected slot is populated and presently usable, compares the supplied target distance against the retail min/short/medium/long thresholds for that weapon type, and then draws the matching bracket glyph before presenting the row strip when appropriate.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_FindNextFireableWeaponSlot_v129": {
		"family": "WeaponHud",
		"summary": "Finds the next local weapon slot that is presently eligible to fire.",
		"notes": [
			"Starts from the current selection when available, scans the local weapon rows circularly, and returns the first slot whose weapon is present, not cooling down, enabled by the current option-column filter, and backed by whatever ammo pool state the weapon type requires. The local-control hotkey path uses it for the next/previous slot fallback and for post-fire reselection.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_IsTargetWithinWeaponMaxRange_v129": {
		"family": "WeaponHud",
		"summary": "Returns whether the current target lies within the retail maximum range for a weapon type.",
		"notes": [
			"Rejects the sentinel `-1` target id immediately, then compares the current actor-to-target distance against the weapon type's max-range threshold from the retail weapon table. Combat_FireWeaponBank_v129 and the local direct-fire hotkey path use this predicate before choosing the target-lock source for spawned effects.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_IsWeaponSlotEnabledByBankFilter_v129": {
		"family": "WeaponHud",
		"summary": "Returns whether one local weapon slot is enabled by the active retail weapon-bank filter state.",
		"notes": [
			"Evaluates the current bank/filter bits in `DAT_004f6428` against the slot's retail category flags and bank selector fields. The slot-availability drawer, next-fireable-slot scan, and slot-fire activation helper all use this predicate to suppress rows that are filtered out of the current fire mode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_IsWeaponSlotFireable_v129": {
		"family": "WeaponHud",
		"summary": "Returns whether one local weapon slot is presently eligible to fire.",
		"notes": [
			"Checks the slot index bounds, verifies that the slot is populated and not cooling down, confirms the local option-column filter permits the slot, and then enforces the retail ammo-pool requirement when the weapon type consumes shared ammo. The local-control hotkey dispatcher uses this predicate before direct slot fire and option toggles proceed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RemapWeaponSlotsToAmmoPoolIndex_v129": {
		"family": "WeaponHud",
		"summary": "Reassigns all local weapon slots of one weapon type to the matching shared-ammo pool index.",
		"notes": [
			"Walks the retail trailing ammo/detail rows to find a live ammo pool for the requested weapon type and then rewrites the per-slot ammo-pool index for every matching weapon row. Combat_ActivateWeaponSlotForFire_v129 uses it after a shared-ammo pool is depleted so the remaining rows move onto the next compatible pool if one exists.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_WeaponTypeUsesAmmoPool_v129": {
		"family": "WeaponHud",
		"summary": "Returns whether the supplied retail weapon type consumes shared ammo-pool entries.",
		"notes": [
			"Tests the weapon-type metadata table entry at `DAT_0047aaf0` and returns true when that type expects a positive shared-ammo pool count. The range-indicator, expiry refresh, and weapon-slot fire paths all use this predicate before consulting the slot's current ammo-pool index.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ActivateWeaponSlotForFire_v129": {
		"family": "WeaponHud",
		"summary": "Commits one local weapon slot into its retail fire/cooldown state and refreshes the dependent HUD cells.",
		"notes": [
			"Validates the slot's current fireability, decrements the bound shared-ammo pool when the weapon type uses one, remaps matching slots onto a replacement ammo pool when the current pool runs dry, starts the slot cooldown timer from the retail cadence tables, redraws the option cells, and plays the weapon-type fire cue. Combat_FireWeaponBank_v129 relies on the returned success flag before spawning effects for that slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ApplyWeaponRowDamageCode_v129": {
		"family": "WeaponHud",
		"summary": "Applies a higher retail damage code to one weapon-detail row and refreshes the matching local weapon-slot HUD state.",
		"notes": [
			"Used by Combat_ApplyDamageCodeValue_v129 for mech-detail section 3 weapon rows. Stores the stronger weapon damage code when it increases, then refreshes the local option cells, range indicator, and availability state for that slot when the damaged actor is the local mech.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DepleteAmmoPoolDetailEntry_v129": {
		"family": "WeaponHud",
		"summary": "Zeros one retail ammo-pool detail entry and refreshes all local weapon slots that share that ammo pool's weapon type.",
		"notes": [
			"Used by Combat_ApplyDamageCodeValue_v129 for mech-detail section 4 ammo/detail rows. Clears the selected ammo-pool count, walks every local weapon slot whose weapon type matches that pool, refreshes availability/range/option cells for those rows, redraws the weapon-bank readouts, and plays the shared depletion cue.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_PlayWeaponTypeFireCue_v129": {
		"family": "WeaponHud",
		"summary": "Plays the retail fire audio cue associated with a weapon type.",
		"notes": [
			"Maps the supplied weapon type id onto the corresponding retail fire cue id and plays that cue through Combat_PlayAudioCue_v129. Combat_ActivateWeaponSlotForFire_v129 calls this after committing the slot's cooldown/ammo state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_HasAnyWeaponSlotEnabledByBankFilter_v129": {
		"family": "WeaponFire",
		"summary": "Returns whether the current retail weapon-bank filter leaves any local weapon slot enabled.",
		"notes": [
			"Scans the visible local weapon rows and returns true as soon as Combat_IsWeaponSlotEnabledByBankFilter_v129 accepts one slot. An unnamed main-loop HUD helper uses it to suppress the bank-filter reticle bitmap when the active filter would disable every local slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SetWeaponBankFilterState_v129": {
		"family": "WeaponFire",
		"summary": "Applies one retail weapon-bank filter selection and updates the slot highlight rectangles whose filter eligibility changed.",
		"notes": [
			"Maps the incoming retail selector code plus the two boolean modifier flags onto the composite bank-filter bits in `DAT_004f6428`. When the new state differs from `DAT_004f6a60`, it walks every local slot, uses Combat_DoesWeaponSlotBankFilterStateChange_v129 to find rows whose enabled state changed, flips those slot highlight rectangles, and then commits the new filter state as the steady-state bank filter.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DoesWeaponSlotBankFilterStateChange_v129": {
		"family": "WeaponFire",
		"summary": "Returns whether one local weapon slot would change enabled/highlight state under the pending retail bank filter.",
		"notes": [
			"Evaluates the slot against both the current bank-filter state and the pending state staged in `DAT_004f6428`, rejecting slots that are absent or cooling down. Combat_SetWeaponBankFilterState_v129 uses this predicate to decide which slot rectangles need their palette-swapped highlight refreshed during a filter change.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ProcessWeaponBankFilterInput_v129": {
		"family": "WeaponFire",
		"summary": "Processes the local directional weapon-bank filter inputs and updates the derived retail filter selection state.",
		"notes": [
			"Consumes the six-button input cluster staged by Combat_ProcessLocalMovementAndJumpInput_v129, converts the directional combination through the retail selector-angle table, preserves the sticky neutral state when the view-lock flag is active, and forwards the resulting selector plus modifier flags into Combat_SetWeaponBankFilterState_v129. It also toggles the same local command bit that retail uses to reflect whether the filter input cluster is currently active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ApplyDetailRowDamageCode_v129": {
		"family": "CombatDamage",
		"summary": "Applies a higher retail damage code to one non-weapon mech-detail row and triggers the coupled local HUD/state fallout.",
		"notes": [
			"Used by Combat_ApplyDamageCodeValue_v129 for the general mech-detail section returned as row class 0. Raises the stored detail damage code when it worsens, then updates whichever local state that detail metadata controls, including movement shutdown/fallover side effects, throttle resets, and the `EQ1`-`EQ4` indicator redraw paths for the local mech.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_SpawnInternalStructureDestructionEffect_v129": {
		"family": "CombatEffects",
		"summary": "Spawns the retail destruction effect for a fully depleted internal-structure row.",
		"notes": [
			"Called from Combat_ApplyDamageCodeValue_v129 only when an internal-structure condition value falls to zero. Maps the destroyed internal row to the corresponding mech section id, emits the matching destruction effect through the combat effect path, and triggers the local-player companion effect when the destroyed actor is the local mech.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
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
	"Combat_SendLocalWeaponEffectUpdate_v129": {
		"family": "CombatWire",
		"summary": "Packages one local weapon-fire/effect update from the computed fire solution and forwards it to the retail outbound combat stream.",
		"notes": [
			"Called from Combat_HandleLocalControlHotkey_v129 and Combat_FireWeaponBank_v129 after the local fire path has already resolved the current slot, target actor, attachment/tag source, and effect origin coordinates.",
			"Normalizes the hidden angle/coordinate inputs into retail wire units and forwards the assembled payload into Combat_SendWeaponEffectUpdate_v129, making it the high-level local-fire wrapper around the lower-level outbound effect sender.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SendWeaponEffectUpdate_v129": {
		"family": "CombatWire",
		"summary": "Appends one outbound retail weapon/effect update frame with source-target bytes plus angle and XYZ payload.",
		"notes": [
			"Appends outbound opcode `0x0A`, maps positive target actor slots through the shared slot-to-network lookup table `DAT_0047e138`, encodes the remaining selector/tag bytes, and then serializes the scaled angle plus XYZ/effect arguments into the stream.",
			"The decoded shape matches the fields consumed later by Combat_Cmd68_SpawnWeaponEffect_v129, so this helper is the lower-level sender used by Combat_SendLocalWeaponEffectUpdate_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/arena_client.gd",
			"res://scripts/net/ws_client.gd",
		],
	},
	"Combat_SendCmd19Action_v129": {
		"family": "CombatWire",
		"summary": "Queues outbound combat cmd19 and flushes it immediately.",
		"notes": [
			"Called at the tail of Combat_InitializeBattlefieldVisualState_v129 after the combat presentation state is ready. It appends opcode `0x13` to the outbound shell command buffer and then forces an immediate flush, making it a safe placeholder for the retail scene-ready / post-bootstrap combat action frame.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/arena_client.gd",
			"res://scripts/net/ws_client.gd",
		],
	},
	"Combat_SendLocalActorStateChecksum_v129": {
		"family": "CombatWire",
		"summary": "Builds and sends the retail local-actor checksum reply from the inbound challenge seed.",
		"notes": [
			"Decodes a 4-byte seed, folds selected local-actor and linked mech-record bytes through System_UpdateCrc32_v129, clamps each compared value to `0xFF`, and keeps the larger of the runtime-versus-record pair before hashing it.",
			"After hashing the fixed stat block plus the variable-length component arrays, it appends outbound opcode `0x19`, writes the computed checksum as a 4-byte arg, and flushes immediately.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/arena_client.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_InitializeVisualResourcesAndHudState_v129": {
		"family": "CombatInit",
		"summary": "Initializes the retail combat visual resources, fonts, and baseline HUD state before the main loop enters steady-state rendering.",
		"notes": [
			"Begins by freeing any previously loaded combat visual resources and cached location-map data through Combat_FreeVisualResourcesAndLocationMap_v129, then refreshes the two combat HUD fonts, delegates bulk bitmap/bootstrap loading to Combat_LoadVisualResourceTables_v129, resets several actor/HUD state fields, and primes the active combat surface/backbuffer handle used by later draws.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_InitializeIdentityByteLookupTable_v129": {
		"family": "CombatInit",
		"summary": "Resets the shared combat byte lookup table to the identity mapping `0..255`.",
		"notes": [
			"Called by Combat_Cmd72_InitLocalActor_v129 near the end of the local-actor bootstrap path. It rewrites `DAT_004e9340` so each entry contains its own byte index, rebuilding a clean identity lookup table before steady-state local actor updates begin.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeVisualResourcesAndLocationMap_v129": {
		"family": "CombatInit",
		"summary": "Releases the currently loaded combat visual resource tables and cached world location map before combat visuals are rebuilt.",
		"notes": [
			"Calls Combat_FreeVisualResourceTables_v129 to close the tagged archives and free the cached combat bitmap tables, then frees the cached world location map through World_FreeLocationMapData_v129.",
			"Used by Combat_InitializeVisualResourcesAndHudState_v129 so a fresh combat visual bootstrap starts from a fully cleared resource set.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_FreeVisualResourceTables_v129": {
		"family": "CombatInit",
		"summary": "Closes the active combat tagged archives and frees the cached retail combat bitmap tables.",
		"notes": [
			"Closes the pair of active tagged archives, frees the bitmap arrays rooted at `DAT_004e7cd0` and `DAT_004e7a90`, zeroes those slots, and then runs Frame_FreeWorldShellDialogBitmapTables_v129 for the additional shared frontend/world bitmap groups.",
			"Called from both Combat_FreeVisualResourcesAndLocationMap_v129 during combat reinitialization and Shell_ShutdownFrontendResourcesAndAudio_v129 during full frontend teardown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Combat_ResetPresentationStateAndLoadVisualOptions_v129": {
		"family": "CombatInit",
		"summary": "Resets the retail combat presentation state and loads the saved visual-detail / overlay option bits into the active runtime flags.",
		"notes": [
			"Called from Shell_EnterDropScene_v129 before the combat scene is fully entered. Clears many transient presentation globals, restores the saved detail level from `DAT_0047f898`, maps the persisted display-flag bits from `DAT_0047f89c` into `DAT_0047a044`, and resets the screen-shake state before steady-state rendering begins.",
			"Before the steady-state flags are restored it tears down any prior actor presentation table, conditionally decodes the previously seeded presentation globals, captures a fresh time-based seed, rebuilds the active eight-slot actor presentation table, and re-encodes the shared presentation globals around that new seed.",
			"It also reseeds the fixed render/projection context blocks through Combat_InitializeSharedRenderProjectionContexts_v129 so the backdrop, terrain-projection, tactical-radar, and active-effects passes all restart from the retail default panel bounds.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_InitializeSharedRenderProjectionContexts_v129": {
		"family": "CombatInit",
		"summary": "Initializes the shared combat render/projection context blocks used by the backdrop, terrain projection, tactical radar, and active-effects passes.",
		"notes": [
			"Called only from Combat_ResetPresentationStateAndLoadVisualOptions_v129 during combat presentation reset. It clears and seeds the fixed world-camera panel descriptor at `DAT_004e6f20`, the player-centered radar/projection descriptor at `DAT_004e5fc0`, and the companion effect-panel descriptor rooted at `DAT_004e6ba0` from the active root surface pointer in `DAT_0047d4b0 + 0x4c`.",
			"It finishes by restoring the shared render limit globals through `FUN_00469e29(0x8000, 0)`, after which Combat_RenderSkyAndGroundBackdrop_v129, Combat_RenderTerrainSceneryProjection_v129, and Combat_RenderActiveEffectsPass_v129 all consume those same default retail bounds and projection constants.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ResetPresentationStateSeedGuard_v129": {
		"family": "CombatInit",
		"summary": "Clears the one-shot guard that allows the retail presentation-state XOR seed to be refreshed.",
		"notes": [
			"Only called from Combat_ResetPresentationStateAndLoadVisualOptions_v129 immediately before Combat_CapturePresentationStateSeedTick_v129. It resets `DAT_0048a48c` so the next helper can sample a new tick-derived seed into `DAT_004f6c14`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_CapturePresentationStateSeedTick_v129": {
		"family": "CombatInit",
		"summary": "Captures the current tick count as the retail presentation-state XOR seed when the guard is open.",
		"notes": [
			"If `DAT_0048a48c` is clear it stores `timeGetTime()` into `DAT_004f6c14` and then closes the guard by setting `DAT_0048a48c = 1`.",
			"Combat_DecodePresentationStateGlobals_v129 and Combat_InitializeActorPresentationStateTable_v129 both use this seed to XOR-protect the shared presentation globals and encoded actor-state fields.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_AllocateActorPresentationStateTable_v129": {
		"family": "CombatInit",
		"summary": "Allocates the retail eight-slot actor presentation state table and refreshes its companion heap-noise buffer.",
		"notes": [
			"Frees the prior random-sized decoy allocation at `DAT_0047cbf8` when present, allocates a fresh decoy block sized from `_rand()`, then allocates the fixed `0x24e0`-byte actor table at `DAT_004f5778` and marks `DAT_004f6c34 = 1`.",
			"Called from Shell_InitializeFrontendResourcesAndAudio_v129 to prewarm the combat presentation heap and from Combat_ResetPresentationStateAndLoadVisualOptions_v129 whenever the active actor table needs to be rebuilt.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_FreeActorPresentationStateTable_v129": {
		"family": "CombatInit",
		"summary": "Frees the active retail actor presentation state table and clears its allocation flag.",
		"notes": [
			"When `DAT_004f6c34` is set it releases `DAT_004f5778` and clears the flag back to zero.",
			"Combat_ResetPresentationStateAndLoadVisualOptions_v129 uses this as the first step of the presentation reset before allocating and seeding a fresh actor table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_DecodePresentationStateGlobals_v129": {
		"family": "CombatInit",
		"summary": "XOR-decodes the shared retail combat presentation globals with the previously captured presentation seed.",
		"notes": [
			"Uses `DAT_004f6c14` and its low 16 bits to decode the short/int presentation tables rooted near `DAT_0047a818`, `DAT_0047aaa8`, `DAT_004f5774`, and related globals outside the actor table.",
			"Combat_ResetPresentationStateAndLoadVisualOptions_v129 only calls it after the first combat bootstrap, when `DAT_004f5788` shows those globals are still encoded with the prior seed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_InitializeActorPresentationStateTable_v129": {
		"family": "CombatInit",
		"summary": "Zeroes and seeds the retail actor presentation state table, then reapplies XOR encoding to the shared presentation globals.",
		"notes": [
			"Clears the full `0x24e0`-byte table at `DAT_004f5778`, then walks each `0x49c`-byte actor slot seeding the encoded position, heading, temperature, and status fields from `DAT_004f6c14` before steady-state combat updates begin.",
			"After the actor slots are seeded it XORs the same shared presentation globals unlocked by Combat_DecodePresentationStateGlobals_v129, effectively rotating the retail presentation-state encoding around the freshly captured seed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ResetActorLookupState_v129": {
		"family": "CombatInit",
		"summary": "Clears the shared actor-id lookup state and transient effect scratch globals used by retail combat sync.",
		"notes": [
			"Only called from Combat_ResetPresentationStateAndLoadVisualOptions_v129 during combat bootstrap. Resets both actor lookup tables (`DAT_0047e110` and `DAT_0047e138`) plus their associated counters/heads, and also clears the transient effect scratch ids later reused by Combat_Cmd68_SpawnWeaponEffect_v129 and Combat_Cmd71_ResetEffectState_v129.",
			"Combat_Cmd64_AddActor_v129 repopulates the remote actor slot mappings after this reset, while Combat_Cmd72_InitLocalActor_v129 seeds the local actor entry in the forward lookup table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_InitializeBattlefieldVisualState_v129": {
		"family": "CombatInit",
		"summary": "Initializes the battlefield-facing visual runtime after combat resources are loaded, including terrain palette state, scenery, backdrop layers, and projectile effect slots.",
		"notes": [
			"Called directly from Combat_InitializeVisualResourcesAndHudState_v129. Applies the terrain palette overrides, installs the active terrain palette table, initializes terrain scenery, sky and ground detail layers, allocates the active projectile/effect slot pool, redraws the root window stack, seeds the default steady-state render mode globals, initializes the default environment light direction through Combat_SetEnvironmentLightDirectionAngles_v129, and then emits outbound combat cmd19.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_InitializeCombatHudAndControlState_v129": {
		"family": "CombatInit",
		"summary": "Installs the retail combat HUD/control callbacks and seeds the initial in-scene HUD state after the battlefield visuals are ready.",
		"notes": [
			"Called from Combat_InitializeBattlefieldVisualState_v129 after the root combat frame exists. Installs the combat frame callback table, resets transient local-control state, initializes the weapon-slot HUD, redraws the steady-state combat HUD strips, seeds the compact voice status strip, and applies the initial presentation-toggle state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_LoadVisualResourceTables_v129": {
		"family": "CombatInit",
		"summary": "Opens COMBAT.DAT and bulk-loads the combat bitmap/resource tables required by the retail HUD and effect surfaces.",
		"notes": [
			"Walks the tagged COMBAT.DAT archive, loads many bitmap resources into fixed global tables through ResourceArchive_SeekTaggedEntry_v129 and Frame_LoadBitmapFromFile_v129, then derives an additional masked span-run table through Frame_EncodeMaskedSpanRuns_v129 before releasing the temporary bitmap objects.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Shell_RunFrontendMain_v129": {
		"family": "ShellUI",
		"summary": "Main retail frontend entry path that initializes the client windowing/network stack, runs the shell message loop, and shuts down on exit.",
		"notes": [
			"Performs the single-instance check, resolves the working directory, initializes the cached shell version banner through Shell_InitializeVersionString_v129, creates the Win32 shell window and message queue, initializes the DirectDraw display path through System_InitializeDirectDrawDisplay_v129, unlocks the software rasterizer span code through System_InitializeSoftwareRasterizerSpanCode_v129, sets up the frontend bootstrap through Shell_InitializeFrontendResourcesAndAudio_v129, then services inbound shell/network frames until shutdown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"System_DetectDirectXCapabilityLevel_v129": {
		"family": "System",
		"summary": "Probes the OS plus DirectDraw and DirectInput runtime support and returns the retail DirectX capability level code used by frontend startup.",
		"notes": [
			"Splits the Win9x and NT-era paths with GetVersionExA, then verifies the availability of DirectDraw, the DirectDraw2 upgrade path, DirectInputCreateA, cooperative-level setup, and a temporary surface/format query before returning capability codes such as `0x200`, `0x300`, or `0x501` through the first out-parameter.",
			"Shell_RunFrontendMain_v129 uses it purely as a startup gate and only continues into System_InitializeDirectDrawDisplay_v129 when the detected capability level comes back above `0x2ff`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_InitializeDirectDrawDisplay_v129": {
		"family": "System",
		"summary": "Initializes the retail DirectDraw display path, including the palette state and the primary frontend rendering surfaces.",
		"notes": [
			"Called only from Shell_RunFrontendMain_v129 after System_DetectDirectXCapabilityLevel_v129 accepts the runtime. It creates the DirectDraw object, configures the cooperative/display mode path, snapshots the system palette into `DAT_00498580`, seeds the retail palette payload, creates the primary rendering surfaces and clipper chain, and marks the frontend display-active flag `DAT_0047fdec = 1` on success.",
			"Any DirectDraw failure is translated through System_GetDirectDrawErrorString_v129 and reported via System_ReportBterrorEvent_v129 before frontend startup aborts.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_InitializeSoftwareRasterizerSpanCode_v129": {
		"family": "System",
		"summary": "Unlocks and seeds the retail software-rasterizer span code used by the combat polygon fill routines.",
		"notes": [
			"Called only from Shell_RunFrontendMain_v129 after System_InitializeDirectDrawDisplay_v129 succeeds. Uses VirtualProtect on the self-patching rasterizer block rooted at `FUN_0046a764` so the inner span code can update its embedded surface and step constants at runtime.",
			"It also precomputes the reciprocal step constant `DAT_004859b8 = 1.0 / DAT_004859b4`; the span walker at `FUN_0046d8f4` consumes that value when the textured path expands its 16-pixel interpolation increments.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"System_GetSoftwareRasterizerSpanCodeSize_v129": {
		"family": "System",
		"summary": "Returns the byte size of the self-patching software-rasterizer span-code block.",
		"notes": [
			"Currently returns the fixed size `0x30ac`, which System_InitializeSoftwareRasterizerSpanCode_v129 passes to VirtualProtect when unlocking the span-code region rooted at `FUN_0046a764`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"System_FreeHeapBlock_v129": {
		"family": "SystemRuntime",
		"summary": "Frees one retail heap block when the supplied pointer is non-null.",
		"notes": [
			"Thin wrapper around `HeapFree(DAT_004f70c4, 0, ptr)` guarded by a null check, so higher-level teardown paths can release owned buffers without repeating the process-heap handle lookup.",
			"Used broadly by shell queue teardown, message-catalog shutdown, frame/window cleanup, resource-archive release, and multiple combat visual/cache free helpers whenever one owned heap payload needs to be discarded.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_AllocateHeapBlock_v129": {
		"family": "SystemRuntime",
		"summary": "Allocates one retail heap block using the default retry/failure-handler mode.",
		"notes": [
			"Thin wrapper over System_AllocateHeapBlockWithRetry_v129 that supplies the global retry-mode flag `DAT_00485f5c`, making it the default owned-buffer allocator shared by retail subsystems.",
			"System_LoadFileIntoBuffer_v129, Shell_LoadMessageCatalog_v129, Frame_LoadBitmapFontDescriptor_v129, World_LoadLocationMapDataFile_v129, and multiple combat effect/cache initializers all route their heap allocations through this helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_AllocateHeapBlockWithRetry_v129": {
		"family": "SystemRuntime",
		"summary": "Attempts a retail heap allocation and optionally retries after invoking the allocation-failure handler.",
		"notes": [
			"Rejects requests above `0xffffffe0`, coerces zero-byte requests to a one-byte allocation, and then loops on System_AllocateHeapBlockRaw_v129 until it succeeds or the retry path declines another attempt.",
			"When the caller-supplied retry flag is non-zero and one raw allocation fails, it calls System_InvokeAllocationFailureHandler_v129 with the requested size; a non-zero callback result restarts the allocation loop, while zero returns failure immediately.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_AllocateHeapBlockRaw_v129": {
		"family": "SystemRuntime",
		"summary": "Calls `HeapAlloc` on the cached retail process heap handle for one requested size.",
		"notes": [
			"Direct wrapper around `HeapAlloc(DAT_004f70c4, 0, size)` with no retry logic or bookkeeping of its own.",
			"Used only by System_AllocateHeapBlockWithRetry_v129 as the raw allocation primitive underneath the higher-level retry/new-handler policy.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_InvokeAllocationFailureHandler_v129": {
		"family": "SystemRuntime",
		"summary": "Invokes the retail allocation-failure callback for one requested heap size.",
		"notes": [
			"Calls the optional function pointer stored at `DAT_004e4948` with the requested allocation size and returns non-zero only when that callback asks the caller to retry.",
			"System_AllocateHeapBlockWithRetry_v129 uses it after one raw `HeapAlloc` failure so the runtime can run its installed low-memory recovery hook before deciding whether to try again.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_SplitPathComponents_v129": {
		"family": "SystemRuntime",
		"summary": "Splits one path string into retail drive, directory, filename, and extension buffers.",
		"notes": [
			"Behavior matches the classic `_splitpath` family: optional drive extraction for `X:`, slash-aware directory slicing, basename capture, and extension capture into the caller-provided output buffers.",
			"Shell_BuildExecutableDirectoryPath_v129 uses it after `GetModuleFileNameA` so frontend startup can recover just the install drive-and-directory prefix rather than the full executable filename.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"System_CloseFileStream_v129": {
		"family": "SystemRuntime",
		"summary": "Flushes, closes, and tears down one retail `FILE*` stream.",
		"notes": [
			"Calls the CRT flush/free-buffer/close sequence for the supplied `FILE*`, clears the stream flags, and frees any temporary filename buffer through System_FreeHeapBlock_v129 before returning the close status.",
			"Used by the shared file-length, file-load, manifest verification, capture-log, joystick keymap, location-map, and resource-archive helpers wherever one temporary retail file stream needs to be closed cleanly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_OpenFileStream_v129": {
		"family": "SystemRuntime",
		"summary": "Opens one retail file stream with the requested mode string and the shared frontend file-sharing policy.",
		"notes": [
			"Thin wrapper around `__fsopen(path, mode, 0x40)`, so retail file helpers consistently open files with the same share mode rather than calling the CRT directly.",
			"Used by the shared file-length/load helpers, manifest verification, capture logging, joystick keymap persistence, resource-archive open/close, and multiple combat/world asset loaders.",
			"It first claims or reuses one `FILE` structure through System_AllocateFileStreamSlot_v129 before binding the requested descriptor/mode state into that stream object.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_ReallocateHeapBlock_v129": {
		"family": "SystemRuntime",
		"summary": "Reallocates one retail heap block, allocating on null and freeing on zero size.",
		"notes": [
			"When the incoming pointer is null it delegates to System_AllocateHeapBlock_v129, when the new size is zero it frees through System_FreeHeapBlock_v129, and otherwise it loops on `HeapReAlloc` with the shared low-memory retry callback until it succeeds or the retry policy declines.",
			"Used by multiple string/UI helpers that grow owned buffers in place, including the compose-editor reset path and joystick capability summary formatting helpers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"System_AllocateZeroedHeapBlock_v129": {
		"family": "SystemRuntime",
		"summary": "Allocates one zero-initialized retail heap block sized as `count * bytes_per_item`.",
		"notes": [
			"Computes the total byte size from the caller's element count and stride, coerces a zero-byte request to one byte, and then calls `HeapAlloc(..., HEAP_ZERO_MEMORY, bytes)` with the same low-memory retry callback policy used by the other shared heap wrappers.",
			"Used by editable-text, mech-record, bitmap-file, message-view, and LASR/profile loaders when the retail runtime needs freshly zeroed owned storage.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"System_InitializeProcessHeap_v129": {
		"family": "SystemRuntime",
		"summary": "Creates the dedicated retail process heap used by the shared allocation wrappers.",
		"notes": [
			"Calls `HeapCreate(1, 0x1000, 0)` and stores the resulting heap handle in `DAT_004f70c4`, which System_AllocateHeapBlockRaw_v129 and System_FreeHeapBlock_v129 later reuse for all shared owned-buffer allocations.",
			"Called directly from the startup entry path before higher-level shell, file, and combat initialization begins.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_InitializeFpmathDispatchTable_v129": {
		"family": "SystemRuntime",
		"summary": "Initializes the retail floating-point helper dispatch table used by the CRT fpmath runtime.",
		"notes": [
			"Seeds the shared function-pointer slots at `0x486198`-`0x4861ac` with the x87/fdiv helper entry points selected for the active CPU/runtime path.",
			"Called only from `__fpmath` after the processor test path decides which floating-point helper implementations should be installed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_SetCrtRandomSeed_v129": {
		"family": "SystemRuntime",
		"summary": "Stores the seed used by the retail CRT `_rand` generator.",
		"notes": [
			"Writes the caller-provided seed into `DAT_00485a00`, the same runtime global that `_rand` reads and advances on each subsequent pseudo-random draw.",
			"Combat_LoadLasrSequenceProfiles_v129 and Combat_InitializeAmbientGroundDetail_v129 both seed the CRT generator with `_time(NULL)` through this helper before they fan out into `_rand`-driven retail selection logic.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_CloseFileDescriptor_v129": {
		"family": "SystemRuntime",
		"summary": "Closes one retail low-level file descriptor and clears its CRT descriptor-table slot.",
		"notes": [
			"Validates the descriptor index against the CRT descriptor table, closes the underlying OS handle unless it aliases the shared stdout/stderr console handle pair, and then clears the live/open flag for that slot through System_ClearFileDescriptorSlot_v129.",
			"System_VerifyExecutableChecksumFromDisk_v129, Combat_LoadCached3dObjectRecord_v129, Combat_LoadAnimationKeyframeSet_v129, Combat_Load3dObjectDefinition_v129, Combat_BuildTerrainSceneryField_v129, and Mech_LoadRecordIntoBufferById_v129 all use it after raw descriptor-based reads complete.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"System_ReadFileDescriptorBytes_v129": {
		"family": "SystemRuntime",
		"summary": "Reads bytes from one retail low-level file descriptor into a caller buffer.",
		"notes": [
			"Uses `ReadFile` on the OS handle associated with the descriptor-table slot and returns the byte count on success while surfacing CRT-style error codes on failure.",
			"When the descriptor is flagged as text mode it also performs the retail CRLF-to-LF translation and honors `0x1A` as end-of-file, which is why the same helper can back both checksum/asset reads and text-oriented runtime paths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"System_QuickSort_v129": {
		"family": "SystemRuntime",
		"summary": "Sorts an array of fixed-size records with the retail quicksort implementation.",
		"notes": [
			"Implements the classic in-place quicksort partition loop over `count` records of `stride` bytes using the caller-supplied comparison callback.",
			"For partitions of eight elements or fewer it falls back to System_ShortSort_v129, and World_EnsureLocationMapIndex_v129 uses it to order its cached location-map index records.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_ShortSort_v129": {
		"family": "SystemRuntime",
		"summary": "Sorts a tiny fixed-size record range with the retail short-sort fallback used by quicksort.",
		"notes": [
			"Walks the current small partition, selects the greatest record under the caller comparator, and swaps it into the tail position until the range is ordered.",
			"Used only by System_QuickSort_v129 for the final small partitions where the full quicksort stack would be wasteful.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_SeekFileDescriptor_v129": {
		"family": "SystemRuntime",
		"summary": "Moves one retail low-level file descriptor to a new byte offset.",
		"notes": [
			"Validates the descriptor slot, resolves the backing OS handle, performs `SetFilePointer(handle, offset, NULL, origin)`, and clears the CRT end-of-file flag on success so later reads resume from the new position.",
			"Used by System_VerifyExecutableChecksumFromDisk_v129 to skip the embedded checksum block, by Combat_SeekIndexedAssetById_v129 for raw indexed asset positioning, and by the descriptor open path when append/text-mode startup needs to probe or move the underlying file cursor.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"System_WriteFileDescriptorBytes_v129": {
		"family": "SystemRuntime",
		"summary": "Writes bytes from one caller buffer into a retail low-level file descriptor.",
		"notes": [
			"Uses `WriteFile` on the descriptor's backing OS handle, honoring text-mode newline expansion and append-mode cursor behavior before returning the effective source-byte count written.",
			"System_SetFileDescriptorLength_v129 uses it to extend a file with zero-filled blocks, while the CRT flush/write paths reuse it for ordinary descriptor-backed output.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_CloseAllFileStreams_v129": {
		"family": "SystemRuntime",
		"summary": "Closes every retail `FILE` stream beyond the standard stdin/stdout/stderr trio.",
		"notes": [
			"Walks the shared stream table rooted at `DAT_004f70d4`, calls System_CloseFileStream_v129 for each live stream whose flags show an open or buffered handle, and counts how many closes succeed.",
			"When a stream slot was backed by a heap-allocated `0x20`-byte `FILE` structure rather than the static startup table, the helper also frees that storage through System_FreeHeapBlock_v129 before clearing the slot pointer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_MapLocaleStringA_v129": {
		"family": "SystemRuntime",
		"summary": "Applies locale-aware `LCMapStringA`-style transforms to a multibyte source string.",
		"notes": [
			"Prefers the direct ANSI `LCMapStringA` path when the host runtime supports it, but otherwise converts the caller string to wide characters, maps it through `LCMapStringW`, and converts the result back to the requested code page.",
			"The retail CRT `_tolower`, `__toupper_lk`, and `__strlwr` wrappers all call it for locale-aware case mapping once the active locale has been initialized.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_InitializeFileDescriptorTable_v129": {
		"family": "SystemRuntime",
		"summary": "Builds the retail CRT file-descriptor table from startup info and standard handles.",
		"notes": [
			"Allocates the first `0x20` descriptor slots, seeds every slot with the default invalid-handle state, then expands the table further when `GetStartupInfoA` exposes inherited handle data for more descriptors.",
			"Finishes by binding stdin/stdout/stderr to the current process standard handles when they were not inherited explicitly, making it the descriptor-table bootstrap that runs directly from the retail `entry` path before argument parsing.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_InitializeEnvironmentPointerTable_v129": {
		"family": "SystemRuntime",
		"summary": "Builds the retail `environ` pointer table from the copied process environment block.",
		"notes": [
			"Counts the NUL-terminated environment strings already staged in `DAT_00485f3c`, skipping entries that begin with `=`, then allocates the pointer table at `DAT_00485f18` and duplicates each surviving string into its own heap buffer.",
			"Called from the startup `entry` path immediately after System_LoadEnvironmentStringsA_v129 and before `__cinit`, matching the CRT environment bootstrap sequence.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_LoadEnvironmentStringsA_v129": {
		"family": "SystemRuntime",
		"summary": "Loads the process environment block as a heap-owned ANSI string bundle.",
		"notes": [
			"Prefers `GetEnvironmentStringsW` and converts the wide block to ANSI with `WideCharToMultiByte`, but falls back to `GetEnvironmentStringsA` when only the ANSI block is available.",
			"The retail startup `entry` path stores its result in `DAT_00485f3c`, and System_InitializeEnvironmentPointerTable_v129 later walks that copied bundle to build `environ`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_ReportRuntimeErrorMessage_v129": {
		"family": "SystemRuntime",
		"summary": "Reports one retail CRT runtime-error message to stderr or a modal dialog.",
		"notes": [
			"Looks up the requested runtime error code in the shared message table at `DAT_00486408`, writes the message to the active stderr handle in console mode, or builds the `Runtime Error!` message-box body in GUI mode.",
			"`__amsg_exit` and `__FF_MSGBANNER` route their visible runtime-failure reporting through this helper before the CRT terminates the process.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_CommitFileDescriptor_v129": {
		"family": "SystemRuntime",
		"summary": "Commits one retail file descriptor by flushing its underlying OS handle buffers.",
		"notes": [
			"Validates the descriptor slot, resolves the backing OS handle with `__get_osfhandle`, and calls `FlushFileBuffers`, translating failure into the same runtime error globals used by the descriptor layer.",
			"`_fflush` uses it for descriptor-backed streams whose flags request a hard OS-level commit after the buffered CRT flush completes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_MapWin32ErrorToRuntimeError_v129": {
		"family": "SystemRuntime",
		"summary": "Maps one Win32 `GetLastError` code into the retail runtime error globals.",
		"notes": [
			"Stores the original OS error in `DAT_00485ef4`, translates known Win32 error codes through the retail lookup table and fallback ranges, and writes the corresponding runtime error code into `DAT_00485ef0`.",
			"Used by the descriptor open/read/write/seek/close helpers when a raw Win32 file API call fails and the runtime needs a CRT-style error result.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_AllocateFileDescriptorSlot_v129": {
		"family": "SystemRuntime",
		"summary": "Claims one free retail file-descriptor slot, growing the descriptor table on demand.",
		"notes": [
			"Scans the active descriptor-table blocks for one slot whose open flag is clear; if none exists it allocates a new 32-slot block through System_AllocateHeapBlock_v129, initializes the default per-slot state, and returns the first slot in that new block.",
			"System_OpenFileDescriptorWithShareMode_v129 uses it before binding a new OS handle into the runtime descriptor table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_ClearFileDescriptorSlot_v129": {
		"family": "SystemRuntime",
		"summary": "Clears one retail file-descriptor slot after its OS handle has been closed or detached.",
		"notes": [
			"Resets the stored handle to `-1` and, when the runtime is tracking redirected standard handles, also clears the matching Win32 `STDIN` / `STDOUT` / `STDERR` handle through `SetStdHandle`.",
			"System_CloseFileDescriptor_v129 calls it after the underlying OS handle is no longer needed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_SetFileDescriptorLength_v129": {
		"family": "SystemRuntime",
		"summary": "Truncates or extends one retail low-level file descriptor to a caller-selected byte length.",
		"notes": [
			"Captures the current file position, compares it against the requested target length, truncates with `SetEndOfFile` when shrinking, or extends the file by writing zero-filled blocks through System_WriteFileDescriptorBytes_v129 when growing.",
			"Always restores the original file position through System_SeekFileDescriptor_v129 before returning, matching the behavior expected by the CRT `_chsize` path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_AllocateFileStreamSlot_v129": {
		"family": "SystemRuntime",
		"summary": "Claims or reuses one retail `FILE` stream structure from the shared stream table.",
		"notes": [
			"Scans the global stream pointer table rooted at `DAT_004f70d4` for an unused or fully idle stream entry, allocating a new `0x20`-byte stream structure through System_AllocateHeapBlock_v129 when necessary.",
			"`__fsopen` uses it before binding a low-level descriptor plus mode flags into the returned `FILE` object, which is why System_OpenFileStream_v129 depends on it indirectly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_ScanFormatCore_v129": {
		"family": "SystemRuntime",
		"summary": "Shared retail scanf-style parsing core used by the CRT scan wrappers.",
		"notes": [
			"Parses the caller-supplied scan format string, consumes bytes from the active stream/buffer source, applies width and conversion rules, and writes the matched results into the caller-provided argument list.",
			"Called by `_sscanf`, making it the common scanf engine in the same way System_FormatPrintfCore_v129 backs the printf-style formatters.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_TestFdivAcrossProcessors_v129": {
		"family": "SystemRuntime",
		"summary": "Runs the retail Pentium FDIV/self-test across the available processor affinity masks.",
		"notes": [
			"Checks the current CPU with the low-level FDIV probe first, then queries process/thread affinity APIs from `KERNEL32` and repeats the probe across each available processor bit when the process can run on multiple CPUs.",
			"`__fpmath` uses the result to decide whether the runtime must install the slower fallback floating-point helper dispatch table for the active machine.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_OpenFileDescriptor_v129": {
		"family": "SystemRuntime",
		"summary": "Opens one retail low-level file descriptor with the default share mode used by raw asset readers.",
		"notes": [
			"Thin wrapper over System_OpenFileDescriptorWithShareMode_v129 that fixes the share-mode argument to `0x40`, matching the default descriptor-open policy used by the retail asset and checksum loaders.",
			"System_VerifyExecutableChecksumFromDisk_v129, Combat_LoadCached3dObjectRecord_v129, Combat_LoadAnimationKeyframeSet_v129, Combat_Load3dObjectDefinition_v129, Combat_BuildTerrainSceneryField_v129, and Mech_LoadRecordIntoBufferById_v129 all route their raw descriptor opens through this helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"System_OpenFileDescriptorWithShareMode_v129": {
		"family": "SystemRuntime",
		"summary": "Creates one retail low-level file descriptor from a path, open flags, share mode, and permission bits.",
		"notes": [
			"Maps the CRT-style open flags onto `CreateFileA` access, creation, sharing, and attribute flags, allocates one free descriptor-table slot through System_AllocateFileDescriptorSlot_v129, stores the returned OS handle there, and seeds the per-descriptor text/binary/device/append flags used by the later read/seek/close helpers.",
			"System_OpenFileDescriptor_v129 is the game-facing wrapper, while the CRT-side `__openfile` path also reuses this lower-level helper when it needs an explicit share-mode-aware descriptor open.",
			"When text or append-mode startup needs to inspect or reposition the file cursor, it delegates the actual move to System_SeekFileDescriptor_v129 rather than touching `SetFilePointer` directly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"System_FormatPrintfCore_v129": {
		"family": "SystemRuntime",
		"summary": "Shared retail printf-style format engine used by the CRT string and stream formatting wrappers.",
		"notes": [
			"Parses the caller-supplied format string, consumes varargs through the dedicated System_ReadVarArg32_v129 / System_ReadVarArg64_v129 / System_ReadVarArg16_v129 helpers, and emits the formatted characters into the caller-selected output sink.",
			"Called by `_sprintf`, `FID_conflict:_fwprintf`, and `FID_conflict:_vfwprintf`, making it the common formatting core beneath the runtime error/log/message paths rather than a game-specific text helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_ReadVarArg32_v129": {
		"family": "SystemRuntime",
		"summary": "Reads one 32-bit value from the retail vararg cursor and advances the cursor.",
		"notes": [
			"Treats the caller cursor as a pointer to 4-byte argument slots, returns the current slot value, and then advances the cursor to the next argument position.",
			"System_FormatPrintfCore_v129 uses it for the ordinary 32-bit integer, pointer, and narrow-character format cases.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_ReadVarArg64_v129": {
		"family": "SystemRuntime",
		"summary": "Reads one 64-bit value from the retail vararg cursor and advances the cursor.",
		"notes": [
			"Returns the current 8-byte argument slot and then advances the caller cursor by eight bytes.",
			"System_FormatPrintfCore_v129 uses it for the 64-bit integer and floating-point format cases that consume paired 32-bit argument slots.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_ReadVarArg16_v129": {
		"family": "SystemRuntime",
		"summary": "Reads one 16-bit value from the retail vararg cursor while consuming one aligned argument slot.",
		"notes": [
			"Returns the low 16-bit value at the current argument slot and then advances the caller cursor by one 4-byte aligned slot, matching the CRT's promoted-vararg layout on 32-bit Windows.",
			"System_FormatPrintfCore_v129 uses it for the narrow subset of short-width or wide-character format cases that still consume one aligned argument slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_ExitProcess_v129": {
		"family": "SystemRuntime",
		"summary": "Runs the retail shutdown sequence with the default flags and then terminates the process with one exit code.",
		"notes": [
			"Thin wrapper over System_RunExitSequence_v129 that passes the standard `run terminators / do not return` flag combination for the ordinary process-exit path.",
			"Called from the startup entry path once initialization or the main runtime returns its final status code.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"System_RunExitSequence_v129": {
		"family": "SystemRuntime",
		"summary": "Runs the retail CRT shutdown sequence and optionally terminates the process.",
		"notes": [
			"Guards against re-entrant exit, optionally executes the registered shutdown callback stacks and static terminator ranges, records the caller's exit-mode flags, and then either returns or finishes with `ExitProcess(code)`.",
			"The direct `__exit` path reuses this helper with different flags, while System_ExitProcess_v129 is the ordinary wrapper that requests the full shutdown-and-exit path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/main/main.gd",
		],
	},
	"Shell_BuildExecutableDirectoryPath_v129": {
		"family": "ShellUI",
		"summary": "Builds the retail executable directory path from the current module filename.",
		"notes": [
			"Uses `GetModuleFileNameA` plus System_SplitPathComponents_v129 to rebuild the drive-and-directory prefix into the caller buffer, matching the current install directory rather than the full executable path.",
			"If the module filename lookup fails it loads the localized shell error strings and shows the fallback modal message box before returning failure to Shell_RunFrontendMain_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_CreateMainWindow_v129": {
		"family": "ShellUI",
		"summary": "Registers the retail MPBattleTech window class and creates the hidden main shell window.",
		"notes": [
			"Registers the `MPBattleTech` Win32 class with the retail window procedure, icon, cursor, and menu resource, then calls `CreateWindowExA` for the top-level shell window.",
			"On success it shows and updates the new window, caches the instance handle, window handle, and UI thread id in the shared shell globals used by the later socket and auxiliary-window helpers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_HandleSocketWindowCreationFailure_v129": {
		"family": "ShellUI",
		"summary": "Logs the fatal frontend socket-window creation failure and tears down the main shell window.",
		"notes": [
			"Only called from Shell_RunFrontendMain_v129 when `MakeSocketWindow(DAT_0047a050)` returns zero during frontend startup. Copies the localized frontend title string into a stack buffer, reports the caller-supplied failure text through System_ReportBterrorEvent_v129, and then destroys the main shell window `DAT_0047a050` so startup aborts cleanly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_ShowModalMessageBox_v129": {
		"family": "ShellUI",
		"summary": "Shows a frontend modal message box while preserving the retail palette snapshot rules used by shell dialogs.",
		"notes": [
			"Wraps Win32 `MessageBoxA` on the main shell window `DAT_0047a050`. When the modal-palette flag `DAT_0047fdec` is set it refreshes the palette snapshot first and restores the full palette after the message box closes, which is why System_ReportBterrorEvent_v129 and the joystick/config warning paths use this helper instead of calling `MessageBoxA` directly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_OpenStatusTextDialog_v129": {
		"family": "ShellUI",
		"summary": "Opens the small modeless shell status-text dialog and writes one caller-supplied line into it.",
		"notes": [
			"Refreshes the modal palette snapshot, closes any existing instance through Shell_CloseStatusTextDialog_v129, creates dialog resource `0x6f` with Shell_StatusTextDialogProc_v129, copies up to 100 characters into the shared buffer `DAT_00498d90`, and writes that text into control `0x41A` before showing the dialog.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_CloseStatusTextDialog_v129": {
		"family": "ShellUI",
		"summary": "Closes the active modeless shell status-text dialog when one is open.",
		"notes": [
			"Destroys `DAT_0047fdf0`, clears the stored window handle, and restores the full palette after the dialog is dismissed. Shell_HandlePreVersionBannerLine_v129 uses it when the pre-version banner line advances the shell state and the dialog must disappear before the transition continues.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_StatusTextDialogProc_v129": {
		"family": "ShellUI",
		"summary": "Minimal dialog procedure for the modeless shell status-text dialog.",
		"notes": [
			"Only distinguishes the `WM_INITDIALOG` path and otherwise leaves all message handling to the default dialog manager. Shell_OpenStatusTextDialog_v129 installs it on resource `0x6f`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_ConfirmClientExit_v129": {
		"family": "ShellUI",
		"summary": "Shows the retail exit confirmation prompt and posts the shell shutdown command when the player accepts.",
		"notes": [
			"Refreshes the display palette snapshot through Frame_CaptureDisplayPaletteState_v129, shows the localized `0xE9/0xEA` Yes/No confirmation text on the main shell window, and on `IDYES` posts message `0x401` with command `2` before setting the shared exit flag bit in `DAT_0047a040`.",
			"World_TravelCompassPage_HandleMouse_v129 uses it for the fixed EXIT button, and World_MenuDialog_HandleInput_v129 reuses the same helper for menu entries whose selection id resolves to the retail exit action `100`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_OpenOptionsPropertySheet_v129": {
		"family": "ShellUI",
		"summary": "Opens the shared retail options property sheet used by the frontend and world-shell option buttons.",
		"notes": [
			"Builds up to four localized property-sheet pages from the caller's bitmask, sets the shared shell modal flag, starts the short timer callback used by the sheet, captures the active palette through Frame_CaptureDisplayPaletteState_v129, and restores the palette after PropertySheetA returns.",
			"Shell_RunFrontendMain_v129 plus the world byte-selection and travel-compass handlers all reuse it for the fixed options action instead of opening one-off dialogs.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_TickOptionsPropertySheetAudio_v129": {
		"family": "ShellUI",
		"summary": "Timer callback that keeps the retail audio service layer advancing while the shared options property sheet is open.",
		"notes": [
			"Installed through `SetTimer(..., 0xfa, Shell_TickOptionsPropertySheetAudio_v129)` by Shell_OpenOptionsPropertySheet_v129 before PropertySheetA takes over the modal message loop.",
			"Calls `KSND_C_update()` plus Combat_TickLasrSoundState_v129 so the retail options sheet continues servicing Miles-backed UI and LASR state while the shell is inside the property-sheet dialog.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_InitializePropertySheetPage_v129": {
		"family": "ShellUI",
		"summary": "Fills one retail property-sheet page descriptor before the shared options sheet is shown.",
		"notes": [
			"Writes the fixed `0x28`-byte page structure with the caller's module handle, dialog-template id, page dialog proc, and per-page lParam value. Shell_OpenOptionsPropertySheet_v129 calls it once per enabled options page before passing the descriptor array to PropertySheetA.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_InitializeVersionString_v129": {
		"family": "ShellUI",
		"summary": "Formats the cached retail version banner string used by the shell title and credits overlays.",
		"notes": [
			"Builds the static `BattleTech II Version ...` banner in the shared shell string buffer from the compiled retail version components during frontend startup.",
			"Shell_RunFrontendMain_v129 calls it once before creating the main shell window, and Shell_ShowTitleAndCreditsSequence_v129 later reuses the cached banner without recomputing it.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_OptionsPropertySheetInitCallback_v129": {
		"family": "ShellUI",
		"summary": "Initialization callback for the retail options property sheet window.",
		"notes": [
			"Records the created property-sheet window handle, clears the window-long flag bit used by the stock shell wrapper, and installs the custom subclass proc stored at `0x414470` when the property sheet is initialized.",
			"Shell_OpenOptionsPropertySheet_v129 passes it through the property-sheet header callback field so the options sheet can reuse the shell's palette and input handling rules.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_AudioOptionsPageProc_v129": {
		"family": "ShellUI",
		"summary": "Dialog proc for the retail options tab that owns audio sliders, speech/LASR preview controls, mixer launch, and live capability-status text.",
		"notes": [
			"Shell_OpenOptionsPropertySheet_v129 registers this proc for property-sheet resource `0x6d`. On `WM_INITDIALOG` it seeds the global/music sliders, speech and LASR preview buttons, and the live capability-status text from the saved frontend config plus the current `DAT_0048afe8` joystick capability bits.",
			"Handles the preview buttons by routing through `KSND_C_setParamSnd`, Combat_SetLasrSoundState_v129, and the speech-in Miles helpers, launches `SNDVOL32` from the mixer button, persists the updated sound flags through System_SaveFrontendConfigToRegistry_v129 on apply, and refreshes control `0x446` through Combat_SetJoystickCapabilitySummaryControlText_v129 whenever the page state changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_JoystickOptionsPageProc_v129": {
		"family": "ShellUI",
		"summary": "Dialog proc for the retail options tab that exposes joystick axis-mode selectors, sensitivity sliders, binding dialogs, and control-panel refresh.",
		"notes": [
			"Shell_OpenOptionsPropertySheet_v129 registers this proc for property-sheet resource `0x6c`. On `WM_INITDIALOG` it populates four joystick selector combo boxes from Combat_BuildJoystickCapabilityFlagTable_v129, restores the cached slider and checkbox state, and refreshes the localized status line through Combat_FormatJoystickStatusSummary_v129.",
			"Handles the config and binding modal buttons, opens the joystick control-panel applet from the fixed refresh button, rebuilds the selector rows after that applet returns, rejects duplicate selector choices through the localized warning path, converts accepted combo selections back into capability-slot ids through Combat_FindJoystickCapabilityIndexByComboSelection_v129, then calls Combat_RefreshJoystickCapabilitiesAndAxisConfig_v129 and System_SaveFrontendConfigToRegistry_v129 on apply.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_LoadMessageCatalog_v129": {
		"family": "ShellUI",
		"summary": "Loads an `END`-delimited retail message catalog file into one frontend catalog slot and optionally selects an initial section.",
		"notes": [
			"Parses the source text file into grouped sections split by literal `END` lines, allocates the packed line-length, pointer, and text buffers for the chosen slot through System_AllocateHeapBlock_v129, and records the caller-supplied user value alongside the parsed section table. Shell_RunFrontendMain_v129 uses it to load `mpbt.msg` before selecting the active startup catalog/section.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_FreeMessageCatalog_v129": {
		"family": "ShellUI",
		"summary": "Frees one loaded retail message-catalog slot and clears the active selection when that same slot was selected.",
		"notes": [
			"Releases the catalog slot's packed section descriptor, pointer table, and backing text buffer through System_FreeHeapBlock_v129, zeroes the slot's section count, and resets the global active catalog pointers when the freed slot matches Shell_GetActiveMessageCatalogIndex_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_SelectMessageCatalog_v129": {
		"family": "ShellUI",
		"summary": "Selects one loaded retail message-catalog slot as the active shell text source.",
		"notes": [
			"Validates the requested slot and points the global active catalog/section pointers at that slot's root descriptor so later shell, world, and combat text helpers read from the chosen message file.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_SelectMessageCatalogSection_v129": {
		"family": "ShellUI",
		"summary": "Selects one section inside a loaded retail message catalog and updates the active section pointer.",
		"notes": [
			"Validates the catalog slot and zero-based section index, then repoints that slot's current-section descriptor and the shared active-section pointer so Shell_GetActiveMessageCatalogLine_v129 returns lines from the chosen block.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_GetActiveMessageCatalogIndex_v129": {
		"family": "ShellUI",
		"summary": "Returns the currently active retail message-catalog slot index, or `-1` when no catalog is selected.",
		"notes": [
			"Computes the slot index from the global active-catalog descriptor pointer used by the shell text system. Shell_FreeMessageCatalog_v129 uses it to decide whether freeing a slot also needs to clear the active selection.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_GetActiveMessageCatalogLine_v129": {
		"family": "ShellUI",
		"summary": "Returns one 1-based line from the active retail message-catalog section, falling back to the explicit `\"Bad message!\"` sentinel when unavailable.",
		"notes": [
			"Reads the selected section's pointer table and cached line-length table, trims the trailing newline in place, and returns the resulting string buffer for the caller. The helper is reused broadly for startup/status strings, capture-log feedback, menu text, world dialogs, and combat presentation labels.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_GetVersionString_v129": {
		"family": "ShellUI",
		"summary": "Returns the cached retail version banner string prepared during frontend startup.",
		"notes": [
			"Thin accessor over the shared shell version buffer initialized by Shell_InitializeVersionString_v129.",
			"Shell_ShowTitleAndCreditsSequence_v129 and the timed archive slideshow caption path call it repeatedly when centering the version text over the first title card.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_ParseComstarIdCode_v129": {
		"family": "SystemRuntime",
		"summary": "Parses a five-character retail ComStar ID code into the corresponding numeric ID, returning `-1` on invalid or out-of-range input.",
		"notes": [
			"Validates the code length, converts the upper-case base36 payload through System_Base36StringToInt_v129, then adds the retail ComStar ID offset and rejects results outside the accepted numeric ID range. Frame_DrawFormattedText_v129 uses it for the inline `||#` / `||%` list-metadata tags that attach player IDs to formatted shell rows.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"System_FormatComstarIdCode_v129": {
		"family": "SystemRuntime",
		"summary": "Formats one retail numeric ComStar ID into its zero-padded five-character display code.",
		"notes": [
			"Rejects numeric IDs outside the retail ComStar range, subtracts the fixed ComStar base offset, converts the result through System_IntToBase36String_v129, and left-pads the output to five characters in a shared static buffer. World_Cmd14_PersonnelRecord_v129 uses it when rendering the dossier page's visible ID field.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"System_Base36StringToInt_v129": {
		"family": "SystemRuntime",
		"summary": "Converts a short ASCII base36 string into an integer, logging invalid digits and overflow through the retail debug stream.",
		"notes": [
			"Accepts up to six characters, treats alphabetic digits case-insensitively, and accumulates the result in base 36. The ComStar ID parser wrapper uses it before applying the retail numeric-range checks.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"System_IntToBase36String_v129": {
		"family": "SystemRuntime",
		"summary": "Converts a non-negative integer into an upper-case base36 string stored in a shared static buffer.",
		"notes": [
			"Repeatedly divides by 36, reverses the generated digit run into the shared output buffer, and rejects negative input through the retail debug stream. System_FormatComstarIdCode_v129 builds the visible five-character ComStar code on top of this helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"Shell_ServiceNetworkStateLoop_v129": {
		"family": "ShellUI",
		"summary": "Polls queued shell/network frames, dispatches them through the shell state handlers, and advances the active frontend state tick.",
		"notes": [
			"Drains the queued inbound-line FIFO through Shell_DequeueQueuedInboundLineBuffer_v129, feeds each copied line buffer to Shell_HandlePostVersionBannerLine_v129, and releases the owned buffer with Shell_FreeQueuedInboundLineBuffer_v129 before continuing.",
			"After the queue drain finishes it updates sound/auxiliary polling and ticks the current shell state branch according to the retail DAT_0047c8d4 state value.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Shell_CreateQueuedInboundLineBuffer_v129": {
		"family": "ShellUI",
		"summary": "Allocates an owned retail shell-line buffer and copies one inbound text line into it.",
		"notes": [
			"Allocates an 8-byte descriptor whose first slot points at a newly allocated copy buffer and whose second slot stores the caller-supplied line length.",
			"The copy buffer is sized as `length + 10`, then populated byte-for-byte from the source line so later queue consumers can own and free the text independently of the socket receive buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_FreeQueuedInboundLineBuffer_v129": {
		"family": "ShellUI",
		"summary": "Frees an owned retail shell-line buffer descriptor and its copied text payload.",
		"notes": [
			"Releases the copied line buffer stored in slot zero through System_FreeHeapBlock_v129 and then frees the 8-byte descriptor itself through the same helper.",
			"Used by Shell_ServiceNetworkStateLoop_v129 after one queued line has been dispatched and by Shell_ClearQueuedInboundLineQueue_v129 when startup or shutdown discards queued work wholesale.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_ResetQueuedInboundLineQueueState_v129": {
		"family": "ShellUI",
		"summary": "Resets the retail queued inbound-line FIFO counters and pointers without freeing payloads.",
		"notes": [
			"Zeros the shared queued-line count, head pointer, and tail pointer at `DAT_0047f880` / `DAT_0047f884` / `DAT_0047f888`.",
			"Shell_RunFrontendMain_v129 uses it when initializing the shell runtime, and Shell_ClearQueuedInboundLineQueue_v129 calls it after draining all outstanding nodes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_ClearQueuedInboundLineQueue_v129": {
		"family": "ShellUI",
		"summary": "Drains the retail queued inbound-line FIFO, freeing each copied line buffer and then resetting queue state.",
		"notes": [
			"Repeatedly dequeues pending line buffers through Shell_DequeueQueuedInboundLineBuffer_v129, frees each copied payload through Shell_FreeQueuedInboundLineBuffer_v129, then finishes by calling Shell_ResetQueuedInboundLineQueueState_v129.",
			"Shell_RunFrontendMain_v129 uses it during teardown so no queued shell text survives a frontend restart or shutdown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_EnqueueQueuedInboundLineBuffer_v129": {
		"family": "ShellUI",
		"summary": "Appends one copied shell-line buffer to the tail of the retail queued inbound-line FIFO.",
		"notes": [
			"Wraps the caller-supplied buffer descriptor in a small queue node from Shell_CreateQueuedInboundLineQueueNode_v129 and then links that node onto the head/tail globals.",
			"The queued-line count is incremented only when the node allocation succeeds.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_DequeueQueuedInboundLineBuffer_v129": {
		"family": "ShellUI",
		"summary": "Removes and returns the oldest copied shell-line buffer from the retail queued inbound-line FIFO.",
		"notes": [
			"Returns zero when the queue is empty; otherwise it detaches the head node, repairs the tail pointer when the last entry is removed, frees the queue node through Shell_FreeQueuedInboundLineQueueNode_v129, decrements the queued-line count, and returns the payload descriptor.",
			"Shell_ServiceNetworkStateLoop_v129 uses it to drain incoming shell text in FIFO order.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_CreateQueuedInboundLineQueueNode_v129": {
		"family": "ShellUI",
		"summary": "Allocates one retail FIFO node for a queued inbound-line buffer.",
		"notes": [
			"Allocates an 8-byte node whose first slot stores the queued buffer descriptor and whose second slot stores the next-node pointer.",
			"Used only by Shell_EnqueueQueuedInboundLineBuffer_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_FreeQueuedInboundLineQueueNode_v129": {
		"family": "ShellUI",
		"summary": "Clears and frees one retail queued inbound-line FIFO node.",
		"notes": [
			"Zeros the node's payload and next pointers before releasing the node allocation.",
			"Used only by Shell_DequeueQueuedInboundLineBuffer_v129 after the payload descriptor has been detached from the queue.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_RunWorldStateTick_v129": {
		"family": "ShellUI",
		"summary": "Runs the retail shell state-3 world/frontend tick after banner handling finishes.",
		"notes": [
			"Polls keyboard state, restores the main shell window when transient auxiliary windows disappear, advances the shell/world bitmap animations, refreshes the shell status strip, and rotates the small shell text list used by the frontend chrome.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_RunCombatStateTick_v129": {
		"family": "ShellUI",
		"summary": "Runs the retail shell state-4 combat tick by polling input and stepping the combat main loop.",
		"notes": [
			"Calls Combat_MainLoop_v129 from the shell state machine and, when the post-combat selection flag is armed, refreshes the retail follow-up target/selection state before returning to the main service loop.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_HandleReceivedMessage_v129": {
		"family": "ShellUI",
		"summary": "Handles a retail inbound message payload by routing it to the world shell console or the combat transmission history.",
		"notes": [
			"In shell state 3 it decodes a type1-length string and appends it to the world message surface with a trailing newline. In shell state 4 it decodes a standard string, queues it through Combat_AppendVoiceTransmissionHistoryEntry_v129, and plays the retail message cue. Other states log the explicit retail 'attempting to receive a message' warning.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_SetArrowCursorMode_v129": {
		"family": "ShellUI",
		"summary": "Restores the retail arrow cursor and clears the wait-cursor state bit.",
		"notes": [
			"When frontend cursor resources are active, routes cursor mode `0` through Frame_SetSavedCursorByMode_v129 so the saved cursor slot becomes the Win32 arrow cursor and the live cursor updates immediately when it is visible.",
			"It then latches `DAT_0047c8c8 = 0` so the shell knows the pointer is back in its normal mode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_SetWaitCursorMode_v129": {
		"family": "ShellUI",
		"summary": "Enters the retail wait-cursor mode and latches the corresponding shell state bit.",
		"notes": [
			"When frontend cursor resources are active, routes cursor mode `1` through Frame_SetSavedCursorByMode_v129 so the saved cursor slot becomes the Win32 wait cursor and the live cursor updates immediately when it is visible.",
			"It then latches `DAT_0047c8c8 = 1` so later shell input checks know the pointer is in busy mode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_PlayUiRejectCue_v129": {
		"family": "ShellUI",
		"summary": "Plays the shared retail UI reject cue when interface sound effects are enabled.",
		"notes": [
			"Checks the shell UI-sound enable bit, primes cue slot `0` with the named sound `alm4` and the current frontend SFX slider through Combat_SetAudioCue0NameVolumeAndPriority_v129, then plays cue id `0` through the shared audio wrapper.",
			"It immediately clears the stored cue-0 runtime handle through Combat_ClearAudioCue0RuntimeHandle_v129 so the transient reject beep does not persist as an active combat cue slot.",
			"Invalid wrapped-text edits, numeric prompts, menu/dialog navigation misses, and other rejected UI actions all route through this helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Shell_ResetFrontendTransientState_v129": {
		"family": "ShellUI",
		"summary": "Resets transient shell/frontend protocol, marquee, and input state before entering a fresh frontend scene.",
		"notes": [
			"Reinitializes the active packet-buffer pointers, clears the heartbeat and marquee helpers through Shell_ResetHeartbeatState_v129 and Shell_ClearStatusMarqueeBuffer_v129, zeroes shell input/edit fields when a world surface is live, and resets several drop/frontend transition globals.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_ResetHeartbeatState_v129": {
		"family": "ShellUI",
		"summary": "Resets the retail shell heartbeat bookkeeping during frontend state transitions.",
		"notes": [
			"Re-arms the shell heartbeat flag and clears the current heartbeat state byte back to zero. Called from the pre/post-version transition paths and from the broader shell transient-state reset wrapper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_SelectInboundCommandTable_v129": {
		"family": "ShellUI",
		"summary": "Selects the active inbound retail command table and protocol label for the shell's RPS or COMBAT stream.",
		"notes": [
			"Mode `0` selects the Solaris RPS label and the inbound command table rooted at `DAT_0047e7d0`; mode `1` selects the Solaris COMBAT label and the command table rooted at `DAT_0047ea38`. Invalid modes emit the retail protocol-selection error log instead of changing the active dispatch profile.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_RestoreMainWindowIfAuxiliaryClosed_v129": {
		"family": "ShellUI",
		"summary": "Restores the main shell window when the tracked auxiliary world window is no longer valid.",
		"notes": [
			"Checks the shell flag that marks an auxiliary world window as active, clears that flag when the stored window handle is no longer valid, and shows the main shell window again before the world tick continues.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_ClearNumLockToggleState_v129": {
		"family": "ShellUI",
		"summary": "Consumes the retail Num Lock toggle edge so world/combat keyboard handling does not inherit a stale toggle bit.",
		"notes": [
			"Checks `GetAsyncKeyState(VK_NUMLOCK)` for a fresh toggle edge, reads the full keyboard state when one is seen, clears the Num Lock key's low toggle bit in that snapshot, and writes the normalized state back before the next shell tick continues.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_ClearStatusMarqueeBuffer_v129": {
		"family": "ShellUI",
		"summary": "Clears the active shell status marquee text buffer and resets its tracked length.",
		"notes": [
			"Sets the marquee length counter to zero and writes a NUL terminator at the start of the scrolling status buffer. Used when the shell frontend resets its transient UI state before new marquee text arrives.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_AppendStatusMarqueeText_v129": {
		"family": "ShellUI",
		"summary": "Appends one decoded text segment into the scrolling shell status marquee buffer.",
		"notes": [
			"Decodes a string argument, pads the active marquee buffer out to the retail minimum visual width, appends the shared separator token, then concatenates the new text and a trailing separator before recomputing the marquee length.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_SendHeartbeat_v129": {
		"family": "ShellUI",
		"summary": "Sends the retail shell heartbeat command appropriate for the active world or combat state.",
		"notes": [
			"In shell state 3 it emits outbound opcode `0x21`; in shell state 4 it emits opcode `0x14`. Other states log the explicit retail 'attempting to send a heartbeat' warning before the helper still flushes the outbound command buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_EncodeRpsPreambleStateByte_v129": {
		"family": "ShellUI",
		"summary": "Encodes one outbound Solaris RPS pre-dispatch state byte pair.",
		"notes": [
			"Writes the fixed byte marker `1` followed by the supplied state value. Used by Shell_HandleRpsPreambleStateByte_v129 when the inbound RPS preamble byte changes and retail echoes the new state back before normal command handling continues.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_HandleRpsPreambleStateByte_v129": {
		"family": "ShellUI",
		"summary": "Processes the Solaris RPS pre-dispatch state byte that precedes ordinary inbound shell commands.",
		"notes": [
			"Runs through the `PTR_FUN_0047e7c8` pre-dispatch hook before the normal Solaris RPS command table is consulted. When the decoded byte exceeds `0x2A`, retail normalizes it by subtracting `0x2B`, echoes the new state through Shell_EncodeRpsPreambleStateByte_v129, flushes immediately, and suppresses ordinary command dispatch when the resulting state byte is unchanged from the last latched value reset by Shell_ResetHeartbeatState_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_RespondToFrq_v129": {
		"family": "ShellUI",
		"summary": "Responds to the retail FRQ request in combat state by sending the cached four-field response payload.",
		"notes": [
			"When the shell state is combat (`4`), appends outbound opcode `0x18`, encodes four cached 4-byte values from the active combat/session globals, clears those cached fields, and flushes the response. Other states emit the retail warning string `Unknown state attempting to respond to FRQ`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/arena_client.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_TickScrollingStatusMarquee_v129": {
		"family": "ShellUI",
		"summary": "Advances and redraws the scrolling shell status marquee when the world state is idle enough to show it.",
		"notes": [
			"Checks the retail marquee timer and shell/UI state flags, then only advances the marquee when World_HasNoActiveStackedShellWindow_v129 reports that the stacked world-shell modal flag is clear. When allowed, it shifts the active status text buffer left by one character, recomputes the remaining length, redraws the marquee text strip, and presents the updated rectangle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_HasNoActiveStackedShellWindow_v129": {
		"family": "WorldUI",
		"summary": "Returns whether the shared stacked world-shell active flag is currently clear.",
		"notes": [
			"Reads bit `0x100` from `DAT_0047d4ec` and returns true when no stacked shell/modal world overlay is active. Shell_TickScrollingStatusMarquee_v129 uses it to suppress marquee scrolling while a stacked shell owns the UI.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_ClearStackedShellActiveFlag_v129": {
		"family": "WorldUI",
		"summary": "Clears the shared stacked world-shell active flag without touching the current window stack directly.",
		"notes": [
			"Clears bit `0x100` in `DAT_0047d4ec`, which is the same stacked-shell active flag that the older world-shell close/response helpers clear inline. Shell_EnterDropScene_v129 uses it before the DROP scene resets the rest of the shell/world UI.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"Shell_AppendEscDelimitedStreamChunk_v129": {
		"family": "ShellUI",
		"summary": "Appends raw shell stream bytes into the active line buffer, flushing the current line whenever an escape delimiter arrives.",
		"notes": [
			"Ignores CR/LF, treats ESC as the record boundary, and forwards completed line buffers to the next parser stage before resetting the write cursor.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_ValidateAndDispatchEscCommandBuffer_v129": {
		"family": "ShellUI",
		"summary": "Finalizes the current ESC-delimited shell command buffer, verifies it, and dispatches the validated command stream.",
		"notes": [
			"Terminates the active line buffer, routes the completed payload through Shell_VerifyEscCommandChecksum_v129 and Shell_DispatchValidatedCommandBuffer_v129, and on validation failure queues the fallback opcode `0x02` through Shell_AppendOutboundCommandOpcode_v129 before flushing the outbound buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_VerifyEscCommandChecksum_v129": {
		"family": "ShellUI",
		"summary": "Verifies the rolling checksum on a completed retail shell command buffer using the active shell/combat state seed.",
		"notes": [
			"Copies the pending command bytes into the working decode buffer, seeds the rolling checksum with the retail state-3 or state-4 constant, then compares the trailing decoded checksum against the computed value before dispatch continues.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_DispatchValidatedCommandBuffer_v129": {
		"family": "ShellUI",
		"summary": "Walks a validated shell command payload and dispatches each opcode through the retail handler table.",
		"notes": [
			"Skips spacer bytes, decodes the `!`-offset command opcode, validates the handler slot and payload length, executes the mapped command callback, and logs malformed or unexpectedly slow command handlers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_AppendOutboundCommandOpcode_v129": {
		"family": "ShellUI",
		"summary": "Appends one outbound retail shell command opcode into the transmit buffer using the `!`-offset wire encoding.",
		"notes": [
			"Adds `0x21` to the requested opcode byte and writes the encoded command marker into the current outbound shell buffer before other arguments and checksum bytes are finalized.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_FlushOutboundCommandBuffer_v129": {
		"family": "ShellUI",
		"summary": "Finalizes and sends the current outbound shell command buffer when it contains a complete command frame.",
		"notes": [
			"Adds the retail trailer/checksum bytes through the shared packet-finalization helper, suppresses the actual TCP send when the shell is in no-send mode, and then resets the transmit buffer state for the next command.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_AppendOutboundCommandChecksumTrailer_v129": {
		"family": "ShellUI",
		"summary": "Appends the retail checksum/trailer bytes that finalize one outbound shell command frame.",
		"notes": [
			"Chooses the scene-specific checksum seed from the active shell mode, folds the already encoded payload bytes into the retail rolling checksum, writes the resulting two-byte trailer through Frame_EncodeArg_v129, and then appends the closing escape byte.",
			"Shell_FlushOutboundCommandBuffer_v129 calls it immediately before the optional transport send whenever the transmit buffer already contains at least one opcode byte.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_ResetOutboundCommandBuffer_v129": {
		"family": "ShellUI",
		"summary": "Resets the outbound shell command buffer and seeds it with the retail ESC/`!` frame prefix.",
		"notes": [
			"Moves the active write pointer back to the transmit buffer base, writes bytes `0x1b` and `0x21`, and leaves the buffer ready for Shell_AppendOutboundCommandOpcode_v129 or the lower-level frame argument encoders.",
			"Called after successful sends by Shell_FlushOutboundCommandBuffer_v129 and explicitly reused by the banner-transition handlers before they assemble their direct state-change control frames.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_AppendBannerStateChangeControlFrame_v129": {
		"family": "ShellUI",
		"summary": "Appends the direct retail state-change control frame used by the pre/post-version banner transition handlers.",
		"notes": [
			"Assumes Shell_ResetOutboundCommandBuffer_v129 has already seeded the ESC/`!` header, then appends outbound opcode `0x03` followed by bytes `1`, `0x1d`, `0x03`, and a final state selector of `1` or `3` depending on the low world/combat state bit in `DAT_0047a040._1_1_`.",
			"Shell_HandlePreVersionBannerLine_v129 and Shell_HandlePostVersionBannerLine_v129 both call it immediately before Shell_FlushOutboundCommandBuffer_v129 to finalize the negotiated shell-state transition frame.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_HandlePostVersionBannerLine_v129": {
		"family": "ShellUI",
		"summary": "Handles inbound shell/banner lines after the frontend has already entered the active post-version state machine.",
		"notes": [
			"Classifies known banner lines through Shell_ClassifyBannerLine_v129, triggers the result-scene or DROP-scene transitions for the recognized retail banners, and otherwise falls back to Shell_AppendEscDelimitedStreamChunk_v129 for ordinary streamed shell text.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_HandlePreVersionBannerLine_v129": {
		"family": "ShellUI",
		"summary": "Handles inbound shell/banner lines during the retail pre-version negotiation phase.",
		"notes": [
			"Uses Shell_ClassifyBannerLine_v129 to recognize the introductory banner lines, arms the shell for version exchange when the expected pre-version banner arrives, and enters the DROP scene path when the alternate banner is encountered.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_ClassifyBannerLine_v129": {
		"family": "ShellUI",
		"summary": "Classifies an incoming retail shell line as one of the known introductory copyright/banner lines.",
		"notes": [
			"Checks the ESC-prefixed shell line against the hardcoded `MMW Copyright Kesmai Corp. 1991` and `MMC Copyright Kesmai Corp. 1991` banners and returns the retail classifier code consumed by the pre/post-version handlers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
		],
	},
	"Shell_SendCloseCommandsToVisibleThreadWindows_v129": {
		"family": "ShellUI",
		"summary": "Broadcasts the retail auxiliary-window close commands to each visible non-main window on the current UI thread.",
		"notes": [
			"Enumerates thread windows and delegates each candidate to Shell_SendCloseCommandsToVisibleThreadWindow_v129, which sends WM_COMMAND `2` and `7` to every visible window except the main shell window before the combat transition continues.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_SendCloseCommandsToVisibleThreadWindow_v129": {
		"family": "ShellUI",
		"summary": "Sends the retail close command pair to one visible non-main auxiliary window on the shell UI thread.",
		"notes": [
			"Skips the cached main shell window `DAT_0047a050`, checks visibility on the candidate HWND, and then sends WM_COMMAND ids `2` and `7` when that auxiliary window is visible.",
			"Used only as the per-window callback passed by Shell_SendCloseCommandsToVisibleThreadWindows_v129 to `EnumThreadWindows`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_EnterDropScene_v129": {
		"family": "ShellUI",
		"summary": "Clears the active shell/world UI and enters the retail DROP scene card flow from SCENES.DAT.",
		"notes": [
			"Resets the active world/shell widgets, clears the stacked-shell active bit through World_ClearStackedShellActiveFlag_v129, drops the lingering scroll-list and mech-management page flags through World_ClearScrollListShellActiveFlag_v129 and World_ClearPagedMechListAndComponentActionFlags_v129, shows the DROP bitmap through Frame_ShowCenteredArchiveBitmap_v129, optionally starts the associated scene audio cue, and clears shell-state flags before the next transition continues.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Shell_ShutdownFrontendResourcesAndAudio_v129": {
		"family": "ShellUI",
		"summary": "Tears down the retail frontend shell resources, fonts, idle timer, and audio layer on exit.",
		"notes": [
			"Called by Shell_RunFrontendMain_v129 during frontend shutdown. It frees the active message catalog, releases the combat/world visual tables through Combat_FreeVisualResourceTables_v129, releases the pair of TFONT descriptors through Frame_FreeBitmapFontDescriptor_v129, stops the inactivity timer through Shell_StopInactivityShutdownTimer_v129, and closes any lingering frontend shell state that still owns modal resources.",
			"When the retail sound-state bits show audio was initialized, it delegates to Shell_ShutdownFrontendAudio_v129 before finishing with `_AIL_shutdown`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Shell_InitializeFrontendResourcesAndAudio_v129": {
		"family": "ShellUI",
		"summary": "Performs the one-shot retail frontend bootstrap for palettes, fonts, picture archives, and audio startup.",
		"notes": [
			"Seeds the shell palette ramp, loads the default TFONT1 fonts, ensures the location-map index is ready, initializes the saved/current cursor state to the stock arrow shape through Frame_InitializeSavedArrowCursor_v129, loads the shared MW picture archives/tables, initializes additional frontend resources, and starts the Miles/AIL audio layer according to the saved sound configuration bits through Shell_InitializeFrontendAudio_v129.",
			"It also prewarms the combat actor presentation table allocation once during frontend bootstrap so Shell_EnterDropScene_v129 can immediately reseed and rebuild that runtime state when combat starts.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/audio/audio_manager.gd",
			"res://scripts/assets/asset_registry.gd",
		],
	},
	"Shell_InitializeFrontendAudio_v129": {
		"family": "ShellUI",
		"summary": "Initializes the retail frontend sound driver, volumes, and LASR sound support flags from the saved shell audio configuration bits.",
		"notes": [
			"Configures the KSND driver parameters, starts `KSND_C_init`, applies the saved music and sound-effect volumes, and updates the shared frontend capability flags based on the returned driver feature mask.",
			"It then probes LASR sound support through Combat_EnsureLasrSoundInitialized_v129, maps the caller-supplied enable bits into `DAT_0047a040`, and finishes by reading the retail `mpbt.kdt` sound table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_ShutdownFrontendAudio_v129": {
		"family": "ShellUI",
		"summary": "Shuts down the retail frontend sound driver and clears the associated sound-state flags.",
		"notes": [
			"Calls `KSND_C_shutdown` and then clears the frontend sound-enable bits in `DAT_0047a040` so later state transitions stop treating the sound layer as active.",
			"Used only by Shell_ShutdownFrontendResourcesAndAudio_v129 when the frontend previously initialized retail audio support.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_StopInactivityShutdownTimer_v129": {
		"family": "ShellUI",
		"summary": "Stops the retail inactivity shutdown timer when the frontend shell is being torn down.",
		"notes": [
			"Kills the timer stored in `DAT_0047e250` if one is active. Shell_ShutdownFrontendResourcesAndAudio_v129 uses it during frontend cleanup so the idle watchdog cannot fire while the shell is exiting.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_StartInactivityShutdownTimer_v129": {
		"family": "ShellUI",
		"summary": "Starts the retail inactivity shutdown timer and records the current activity tick.",
		"notes": [
			"Installs the global timer callback Shell_HandleInactivityShutdownTimer_v129 with the caller-supplied seconds interval and seeds `DAT_0047a060` from GetTickCount so the idle-warning path has its initial activity baseline.",
			"Shell_InitializeFrontendResourcesAndAudio_v129 calls it during frontend bootstrap to arm the long idle shutdown watchdog.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_HandleInactivityShutdownTimer_v129": {
		"family": "ShellUI",
		"summary": "Timer callback that warns about prolonged frontend inactivity and eventually forces the retail idle shutdown.",
		"notes": [
			"After roughly 14 minutes of inactivity it opens Shell_OpenInactivityShutdownWarningDialog_v129 once; after roughly 15 minutes it posts the shell close command, sets the inactivity-exit flag bit, and records the localized `Shutdown due to inactivity.` event through System_ReportBterrorEvent_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_OpenInactivityShutdownWarningDialog_v129": {
		"family": "ShellUI",
		"summary": "Opens the small modeless warning dialog shown shortly before the retail inactivity shutdown fires.",
		"notes": [
			"Captures the current palette state through Frame_CaptureDisplayPaletteState_v129 and creates dialog resource `0x70` with Shell_InactivityShutdownDialogProc_v129, storing the returned window handle in `DAT_0047e254` so the timer callback can avoid opening duplicates or close the warning on forced shutdown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_InactivityShutdownDialogProc_v129": {
		"family": "ShellUI",
		"summary": "Dialog procedure for the retail inactivity shutdown warning prompt.",
		"notes": [
			"Shows the warning dialog on init, treats button `1` as recent activity by resetting `DAT_0047a060` to the current tick and posting a close message to itself, and on close restores the full palette before clearing `DAT_0047e254`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Combat_RedrawVoiceTransmissionHud_v129": {
		"family": "VoiceTransmission",
		"summary": "Dispatches the combat voice-transmission HUD redraw to the active retail layout variant.",
		"notes": [
			"Selects among the blank, history, and roster-style voice HUD variants according to the current voice-transmission state flags. Called by the voice-transmission command handlers and by setup helpers that need to refresh the panel immediately.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_AllocateVoiceTransmissionHistoryBuffer_v129": {
		"family": "VoiceTransmission",
		"summary": "Allocates and initializes the retail combat voice-transmission history ring buffer.",
		"notes": [
			"Allocates the fixed 12000-byte history slab, seeds the 100 per-entry text pointers at `DAT_00499250` to successive `0x78`-byte rows, clears each row's timed-expiry field, and resets the ring-buffer head/tail/status indices.",
			"It also clears the cached active-status pointer state and sets `DAT_00499710 = -1` so Combat_SelectActiveVoiceTransmissionStatusMessage_v129 knows the working copy must be rebuilt the first time the compact status strip asks for text.",
			"Combat_ResetPresentationStateAndLoadVisualOptions_v129 calls it during combat presentation reset before the retail voice/effect HUD resources are reinitialized.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_AppendVoiceTransmissionHistoryEntry_v129": {
		"family": "VoiceTransmission",
		"summary": "Appends one status or transmission line into the combat voice-history ring buffer and refreshes the HUD when needed.",
		"notes": [
			"Copies a bounded text row into the 100-entry retail history ring, stores the associated style/state value, marks sticky entries when requested, and triggers Combat_RedrawVoiceTransmissionHud_v129 when the voice panel is currently visible.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_HandleVoiceTransmissionInput_v129": {
		"family": "VoiceTransmission",
		"summary": "Handles the active combat voice-transmission text-entry mode, including typing, submit, and local history echo.",
		"notes": [
			"Accepts printable keys into the active voice/transmission text buffer, supports backspace and cancel, routes ordinary transmit-mode submissions through Combat_SendVoiceTransmissionText_v129, routes speech-out submissions through Combat_SendSpeechOutText_v129, mirrors the local entry into the history feed, plays the confirm cue, and flushes the outbound shell buffer when the entry completes.",
			"When speech-out mode is armed (`DAT_0047fec8 == 2`), it prefixes the locally echoed history row with the fixed `*` marker from `DAT_0047d3e8` before appending the typed text.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SendSpeechOutText_v129": {
		"family": "VoiceTransmission",
		"summary": "Sends one combat speech-out text payload through the retail outbound shell buffer.",
		"notes": [
			"Appends outbound opcode `0x0f`, then encodes the supplied text with the combat byte-counted string codec.",
			"Used only by Combat_HandleVoiceTransmissionInput_v129 when speech-out mode is armed; the caller mirrors the same text into the local history feed with the fixed `*` speech-out prefix before flushing the outbound buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SendVoiceTransmissionText_v129": {
		"family": "VoiceTransmission",
		"summary": "Sends one combat voice-transmission text payload through the retail outbound shell buffer.",
		"notes": [
			"Appends outbound opcode `0x04`, then encodes the supplied text with the combat byte-counted string codec in combat state and the older type1 string codec elsewhere. Used by the voice-transmission input path when transmit-text mode is armed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SendVoiceTransmissionActorState_v129": {
		"family": "VoiceTransmission",
		"summary": "Encodes and flushes the outbound combat voice-transmission actor-state command.",
		"notes": [
			"Emits outbound opcode `0x16`, encodes the selected actor id from the local voice roster, then encodes the requested enabled/disabled state byte before flushing the shell command buffer. Used by the roster toggle wrapper when combat networking is active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_SendVoiceTransmissionTuneToChannelId_v129": {
		"family": "VoiceTransmission",
		"summary": "Encodes and flushes the outbound combat voice-transmission tune/channel-selection command.",
		"notes": [
			"Validates the requested tune id in the retail `0..2` range, emits outbound opcode `0x17`, encodes the single tune/channel byte, and flushes the shell command buffer when combat networking is active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_RedrawVoiceTransmissionHudBlank_v129": {
		"family": "VoiceTransmission",
		"summary": "Redraws the blank/base combat voice-transmission HUD panel.",
		"notes": [
			"Clears the retail voice panel rectangle to the base fill color and optionally presents the updated region when the caller requests an immediate redraw.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_RedrawVoiceTransmissionHudHistory_v129": {
		"family": "VoiceTransmission",
		"summary": "Redraws the history-style combat voice-transmission HUD variant with recent transmission rows.",
		"notes": [
			"Walks the recent voice/transmission ring buffer from newest to oldest, draws the text rows through Combat_DrawVoiceTransmissionHudLabel_v129, and updates the small mode/status icon shown in the panel corner.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_DrawVoiceTransmissionHudLabel_v129": {
		"family": "VoiceTransmission",
		"summary": "Draws one clipped label row inside the combat voice-transmission HUD using the active HUD font colors.",
		"notes": [
			"Wraps Frame_DrawString_v129 with the fixed retail voice-panel bounds and color pair, clipping long rows to the panel bottom edge.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_DrawVoiceTransmissionStatusHud_v129": {
		"family": "VoiceTransmission",
		"summary": "Draws the live combat voice-transmission status HUD, including the selected talker/target label.",
		"notes": [
			"Called from the combat main loop. Chooses between the compact and expanded retail layouts based on voice HUD flags, draws the current speaker/target name when present, and presents the updated HUD strip when needed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeVoiceTransmissionHistoryBuffer_v129": {
		"family": "VoiceTransmission",
		"summary": "Frees the retail combat voice-transmission history buffer during teardown.",
		"notes": [
			"Releases the heap buffer that stores the 100-entry voice/transmission history ring. Combat_Cmd63_ResultSceneInit_v129 uses it when combat exits into the result scene and clears the old runtime voice HUD state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SelectActiveVoiceTransmissionStatusMessage_v129": {
		"family": "VoiceTransmission",
		"summary": "Selects the currently visible retail voice/status message and advances the compact status-strip queue.",
		"notes": [
			"Walks the voice history ring's timed display indices, advances expired entries, copies the newly active text into a working buffer, and returns the cached text/style pair used by Combat_DrawVoiceTransmissionStatusHud_v129. When the full voice history panel is not open, it also refreshes the per-entry expiry timer for the compact status-strip presentation window.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_UpdateVoiceTransmissionStatusStrip_v129": {
		"family": "VoiceTransmission",
		"summary": "Updates the compact combat voice-transmission status strip bitmaps and talkback meter.",
		"notes": [
			"Called from the combat main loop and the voice HUD bootstrap path. Caches the last compact-strip state, redraws the `IFF*`, `SID*`, and `TKB*` bitmap slices only when the relevant voice flags or talkback fill value change, and then presents the fixed `(0x0f,0x44)-(0x3f,0x60)` retail HUD rectangle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClearSpeechOutActorLabelSlots_v129": {
		"family": "VoiceTransmission",
		"summary": "Clears the two retail speech-out actor label slots shown across the top edge of the combat HUD.",
		"notes": [
			"Resets both slot-active flags and their actor indices back to zero, removing any pending left/right speech-out speaker labels before the next combat presentation frame draws them again.",
			"Combat_InitializeVisualResourcesAndHudState_v129 calls this during combat HUD bootstrap so the speech-out overlay starts empty after presentation resources are rebuilt.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_DrawSpeechOutActorLabels_v129": {
		"family": "VoiceTransmission",
		"summary": "Draws the active retail speech-out speaker labels across the top row of the combat HUD.",
		"notes": [
			"Called from Combat_MainLoop_v129 after the steady-state voice/status HUD work. When the left slot is active it draws the fixed `*` prefix followed by that actor's callsign at `(0x05,0x03)`; when the right slot is active it right-aligns the other actor's callsign against the combat frame's right edge.",
			"The two slots are fed by the KSND speech-out callback path through Combat_SetSpeechOutActorLabelSlot_v129 and Combat_ClearSpeechOutActorLabelSlot_v129, making this a lightweight live speaker overlay rather than part of the larger voice-panel window.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetSpeechOutActorLabelSlot_v129": {
		"family": "VoiceTransmission",
		"summary": "Marks one speech-out actor label slot active for the actor currently mapped to a sound-source index.",
		"notes": [
			"Looks up the sound-source index through the shared actor lookup table at `DAT_0047e110`, then stores the resolved actor slot into one of the two top-row speech-out label slots and marks that slot active.",
			"The KSND speech-out event callback uses this helper when a callback packet advertises the start/show flag for a label slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ClearSpeechOutActorLabelSlot_v129": {
		"family": "VoiceTransmission",
		"summary": "Clears one active speech-out actor label slot on the combat HUD.",
		"notes": [
			"Resets the chosen top-row speech-out label slot back to inactive and zeroes its stored actor index so Combat_DrawSpeechOutActorLabels_v129 stops drawing that speaker name on subsequent frames.",
			"The KSND speech-out event callback uses this helper when a callback packet advertises the hide/stop flag for a label slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RebuildVoiceTransmissionRosterOrder_v129": {
		"family": "VoiceTransmission",
		"summary": "Rebuilds the retail roster-display order used by the voice-transmission roster HUD.",
		"notes": [
			"Walks the active actors by retail voice-channel/tune grouping and writes the visible roster order plus inverse lookup tables used by Combat_RedrawVoiceTransmissionHudRoster_v129. The roster redraw refreshes this ordering lazily when the cached roster map is stale.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_InitializeVoiceTransmissionHudControls_v129": {
		"family": "VoiceTransmission",
		"summary": "Initializes the retail combat voice-transmission HUD controls and default panel state.",
		"notes": [
			"Called during Combat_InitializeBattlefieldVisualState_v129. Builds the tune and roster hotkey controls for the voice panel, resets the local voice-panel selection state, and seeds the default voice-transmission flags before the first redraw.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_FreeVoiceTransmissionHudControls_v129": {
		"family": "VoiceTransmission",
		"summary": "Releases the retail combat voice-transmission HUD control surface and clears the panel flags.",
		"notes": [
			"Disposes the off-screen voice HUD surface allocated by Combat_InitializeVoiceTransmissionHudControls_v129 and clears the cached voice-panel mode flags. Retail calls it during combat/result teardown before rebuilding the non-combat presentation state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_PresentCollapsedVoiceTransmissionHudPanel_v129": {
		"family": "VoiceTransmission",
		"summary": "Presents the cached collapsed retail voice-transmission HUD panel region.",
		"notes": [
			"Updates only the fixed lower panel rectangle `(0x000,0x0f0)-(0x27f,0x1df)` on the main frame without redrawing the voice panel contents. Combat_RedrawVoiceTransmissionHudTransitionFrame_v129 uses it for the fully collapsed stage of the open/close animation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ScrollVoiceTransmissionHudHistory_v129": {
		"family": "VoiceTransmission",
		"summary": "Scrolls the retail combat voice-transmission history view and redraws the voice HUD.",
		"notes": [
			"Handles the voice-panel history up/down hotkeys (`0x2c` / `0x2d`). Updates the bounded history offset in the 100-entry voice log, wrapping or clamping as needed, and then immediately redraws the active voice-transmission HUD variant.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_TickVoiceTransmissionHudToggleAnimation_v129": {
		"family": "VoiceTransmission",
		"summary": "Ticks the retail expand/collapse animation for the combat voice-transmission HUD.",
		"notes": [
			"Called from Combat_MainLoop_v129. Advances the panel through the staged open/close heights every 10 ticks, redraws each transition frame through Combat_RedrawVoiceTransmissionHudTransitionFrame_v129, and flips the voice-panel control enable state once the animation reaches its fully open or fully closed endpoint.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_ResetVoiceTransmissionHudToggleAnimation_v129": {
		"family": "VoiceTransmission",
		"summary": "Resets the staged voice-transmission HUD toggle animation back to its baseline state.",
		"notes": [
			"Clears the latched transition-state globals `DAT_00499228` and `DAT_00499224`, then restores the root combat frame's stored voice-panel height slot at `+0x58` to `0x48`.",
			"Combat_InitializeBattlefieldVisualState_v129 uses it while seeding the initial combat HUD so the voice panel starts from a stable non-animated state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_IsVoiceTransmissionHudToggleAnimationActive_v129": {
		"family": "VoiceTransmission",
		"summary": "Returns whether the voice-transmission HUD toggle animation is still in flight.",
		"notes": [
			"Compares the live CMP voice-toggle bit `DAT_0047a04c & 2` against the latched endpoint value in `DAT_00499228` and returns true while they differ.",
			"Combat HUD redraw helpers use it to suppress immediate `Frame_PresentFrameRect_v129` blits until the staged open/close transition reaches its settled endpoint.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_RefreshOpenVoiceTransmissionHud_v129": {
		"family": "VoiceTransmission",
		"summary": "Refreshes the currently open retail voice-transmission HUD variant and re-enables its controls.",
		"notes": [
			"Only acts when the voice panel is already open. Redraws the active voice HUD view through Combat_RedrawVoiceTransmissionHud_v129 and then re-enables the registered voice controls through Combat_SetVoiceTransmissionHudControlsEnabled_v129 so the panel stays interactive after log/roster mode changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SetVoiceTransmissionHudControlsEnabled_v129": {
		"family": "VoiceTransmission",
		"summary": "Enables or disables the registered retail voice-transmission HUD controls for the current panel mode.",
		"notes": [
			"Walks the frame control table and toggles the hotkeys/buttons bound to the voice panel. The helper treats the history scroll controls specially and only enables the roster-specific controls when the roster mode bit is active in `DAT_0047fecc`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_FreeVoiceAndEffectPresentationResources_v129": {
		"family": "VoiceTransmission",
		"summary": "Frees the retail voice HUD surface and active-effect presentation pools during combat/result teardown.",
		"notes": [
			"Calls Combat_FreeVoiceTransmissionHudControls_v129 and Combat_FreeActiveEffectRenderPools_v129 back-to-back, then marks the shared presentation resource state as unloaded. Combat_Cmd63_ResultSceneInit_v129 uses this helper while tearing down the live combat presentation before the result scene comes up.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RedrawVoiceTransmissionHudTransitionFrame_v129": {
		"family": "VoiceTransmission",
		"summary": "Redraws one staged transition frame for the retail voice-transmission HUD open/close animation.",
		"notes": [
			"Builds the intermediate panel height for stages `0..3`, blits the shared frame chrome, redraws the active voice HUD contents, and presents only the rectangle affected by that animation stage. The fully collapsed stage delegates to a tiny present-only helper instead of redrawing the voice contents.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_RedrawVoiceTransmissionCmpStatusIcon_v129": {
		"family": "VoiceTransmission",
		"summary": "Redraws the small CMP-status icon embedded in the retail voice-transmission HUD.",
		"notes": [
			"Blits one of the two CMP status bitmaps into the voice panel surface and presents just that icon rectangle when the HUD is already stable. Combat_UpdateCmpHudToggle_v129 uses it to keep the voice panel's CMP indicator in sync with the main CMP toggle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"Combat_SelectVoiceTransmissionTune_v129": {
		"family": "VoiceTransmission",
		"summary": "Handles one local combat voice-transmission tune selection from the retail voice panel.",
		"notes": [
			"Accepts one of the three retail tune/channel choices, updates the local voice panel selection state, and forwards the requested tune through Combat_SendVoiceTransmissionTuneToChannelId_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_ToggleVoiceTransmissionActorState_v129": {
		"family": "VoiceTransmission",
		"summary": "Toggles one actor's combat voice-transmission enabled state from the roster-style voice panel.",
		"notes": [
			"Maps the selected visible roster row back to the underlying actor id, flips that actor's local enabled state, and forwards the change through Combat_SendVoiceTransmissionActorState_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_TickVoiceTransmissionSpeechInState_v129": {
		"family": "VoiceTransmission",
		"summary": "Ticks the retail combat speech-in capture state, talkback meter, and outbound voice packet path.",
		"notes": [
			"Called from Combat_MainLoop_v129. Applies the signed talkback delta to the compact voice meter, starts or stops the KSND speech-in stream according to the selected tune/state flags, forwards captured packets through SendTCPSound, and raises the retail warning cue when the speech-in path stops or cannot continue.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_RedrawVoiceTransmissionHudRoster_v129": {
		"family": "VoiceTransmission",
		"summary": "Redraws the roster-style combat voice-transmission HUD variant with channel/participant status rows.",
		"notes": [
			"Draws the roster headers and per-entry labels, chooses the small transmission-state bitmaps for each slot, and refreshes the common voice panel icon strip.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Mech_GetVariantCodeById_v129": {
		"family": "MechRuntime",
		"summary": "Returns the localized mech variant code string for one mech id, such as `HBK-4G`.",
		"notes": [
			"Maps mech ids `0..0xa0` onto message-catalog lines starting at `0x3ae` and falls back to the retail `HBK-4G` placeholder when the id is out of range.",
			"Used by runtime init and the mech-management list pages anywhere retail needs the short variant/designation code separate from the longer chassis display name.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Mech_GetChassisDisplayNameById_v129": {
		"family": "MechRuntime",
		"summary": "Returns the localized mech chassis/family display name for one chassis id, such as `HUNCHBACK`.",
		"notes": [
			"Maps chassis ids `0..0x41` onto message-catalog lines starting at `0x36c` and falls back to the retail `HUNCHBACK` placeholder when the id is out of range.",
			"Mech_InitRuntimeStateFromRecord_v129 combines this longer family name with Mech_GetVariantCodeById_v129 when it builds the cached runtime display label, and the world mech-management pages reuse it for ranked/mech-detail lists.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Mech_GetWeaponTypeLabelById_v129": {
		"family": "MechRuntime",
		"summary": "Returns the localized retail weapon-type label for one weapon id, choosing either the long detail wording or the compact status-column wording.",
		"notes": [
			"Maps weapon ids `0..0x10` onto the two adjacent message-catalog line ids stored in the retail weapon metadata table: `DAT_0047aaa4` for the long/detail label path and `DAT_0047aaa0` for the compact label path.",
			"World_GetMechDetailRowLabel_v129 uses the long variant for mech-component detail rows, while the mech status/component pages reuse the same table for compact per-weapon labels. Out-of-range ids fall back to the retail `unknown w` placeholder.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Mech_ClassifyPagedListStatusById_v129": {
		"family": "MechRuntime",
		"summary": "Maps one mech id onto the shared four-way status/group byte used by the retail paged mech-list windows.",
		"notes": [
			"Cmd26 and Cmd27 receive this per-row byte directly from the server, but World_Cmd32_AlternateRankingList_v129 synthesizes it locally from the mech id by returning bucket values `0..3` across the retail id ranges `1..0x24`, `0x25..0x54`, `0x55..0x7f`, and `0x80+`.",
			"The helper stays named around the generic paged-list status role rather than the ranking packet because the same byte lives in the shared chooser/paged-list row model at `DAT_004f6c40`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Mech_AllocateAndLoadRecordById_v129": {
		"family": "MechRuntime",
		"summary": "Allocates a retail mech-record buffer and fills it with the decoded mechdata entry for one mech id.",
		"notes": [
			"Allocates the fixed `0x228`-byte mech-record block with the retail heap helper and reports a BT error event if that allocation fails.",
			"On success it immediately delegates to Mech_LoadRecordIntoBufferById_v129. Combat_Cmd64_AddActor_v129 and the world mech-management pages use this wrapper when they need a temporary decoded mech record by id.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Mech_SeedRecordCipherFromFilenameSuffix_v129": {
		"family": "MechRuntime",
		"summary": "Seeds the retail mech-record XOR stream from the last four characters of the mechdata filename stem.",
		"notes": [
			"Searches for the final `.` in the caller-supplied path; if no extension is present it uses the final four path characters instead. The copied four-byte suffix is stored into `DAT_0047cb9c` and becomes the starting state for Mech_NextRecordCipherWord_v129.",
			"Mech_LoadRecordIntoBufferById_v129 lowercases the mechdata path before calling it, so the seed is stable across filesystem case differences.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Mech_XorRecordBufferWithCipherStream_v129": {
		"family": "MechRuntime",
		"summary": "XOR-decodes a mechdata record buffer byte-by-byte using the rolling filename-seeded retail cipher stream.",
		"notes": [
			"Walks the loaded mechdata bytes and XORs each byte with the next value from Mech_NextRecordCipherWord_v129, advancing the destination pointer one byte at a time across the full record length.",
			"Mech_LoadRecordIntoBufferById_v129 applies this pass immediately after reading the `0x228`-byte record from disk and before the later per-field ushort normalization pass.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Mech_NextRecordCipherWord_v129": {
		"family": "MechRuntime",
		"summary": "Advances the retail mech-record XOR generator and returns the next stream word derived from the filename-suffix seed.",
		"notes": [
			"Updates `DAT_0047cb9c` with the retail linear-congruential step and then folds the high and low halves together to produce the next XOR word.",
			"Used only by Mech_XorRecordBufferWithCipherStream_v129 during mechdata record decode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Mech_LoadRecordIntoBufferById_v129": {
		"family": "MechRuntime",
		"summary": "Loads, decrypts, and normalizes one retail mechdata record into a caller-supplied buffer.",
		"notes": [
			"Builds the mechdata file path from Mech_GetVariantCodeById_v129 plus the static mechdata directory/extension strings, opens the file, reads the fixed `0x228`-byte record, and XOR-decodes the packed ushort fields in place.",
			"Also lowercases the variant code for the companion asset lookup, validates the decoded mech id range, and applies the retail post-load normalization pass before returning the populated buffer to Mech_AllocateAndLoadRecordById_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
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
		"notes": [
			"Seeds the live armor, internal-structure, weapon-condition, and misc-detail arrays from the mech record, and initializes the eight internal-structure maxima through Mech_GetInternalStructureMaxByTonnageAndSection_v129 so later mech-status pages and combat damage paths can compare current values against the correct tonnage-scaled baseline.",
		],
		"implementation_status": STATUS_PARTIAL_ANALOG,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Mech_GetInternalStructureMaxByTonnageAndSection_v129": {
		"family": "MechRuntime",
		"summary": "Returns the retail maximum internal-structure value for one mech tonnage bucket and section index.",
		"notes": [
			"Uses the tonnage divided by five to index the internal-structure tables and folds the shared torso/arm/leg section cases onto the correct retail max-value column, returning `9` for the head section.",
			"Mech_InitComponentStatusFromRecord_v129 uses it to seed the current/max internal-structure state, and the mech-status/component-action pages plus the combat status panel reuse it when converting row values into percentages or display colors.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Mech_MapDetailRowToInternalStructureSection_v129": {
		"family": "MechRuntime",
		"summary": "Maps the 11 mech-detail armor/status rows onto the eight retail internal-structure section indices.",
		"notes": [
			"Leaves the head/arm/leg rows distinct while collapsing the mirrored rear-torso rows onto the same torso section indices used by the internal-structure arrays.",
			"Combat_DrawActorStatusPanel_v129, the nearby actor-preview color helper, and World_Cmd30_MechStatusOptionPage_v129 use it before looking up max/current internal-structure values for a displayed row.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
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
	"World_Cmd10_ParseCachedNamedEntryList_v129": {
		"family": "WorldUI",
		"summary": "Parses the early-world cached named-entry list and emits a compact summary line into the live shell text surface.",
		"notes": [
			"Clears the cached entry table, decodes repeated `(id, state, text)` records until the retail terminator marker arrives, stores each entry in the shared table used by the cmd11/cmd12 follow-up handlers, then formats a natural-language summary of the received names when the world text surface is active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd11_UpdateCachedNamedEntryText_v129": {
		"family": "WorldUI",
		"summary": "Updates the cached text for one named entry id and appends the corresponding shell log line.",
		"notes": [
			"Looks up the shared cached entry slot by retail id, formats the before/after shell text line through a resource string, copies the new text into the slot, and appends the update to the live shell text surface when present.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd12_UpdateCachedNamedEntryState_v129": {
		"family": "WorldUI",
		"summary": "Updates the per-entry state for one cached named entry and appends the matching shell status line.",
		"notes": [
			"Resolves the cached entry by retail id, updates its active/state fields from the incoming byte code, and chooses among several resource-formatted shell lines to describe the new state before redrawing the world text surface.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd13_StoreCachedNamedEntry_v129": {
		"family": "WorldUI",
		"summary": "Stores or updates one cached named entry record and appends the corresponding shell line when the text surface is live.",
		"notes": [
			"Resolves an existing cached entry by retail id or allocates the next free slot, stores the decoded text into that slot, and appends the resource-formatted shell line that announces the cached entry change when the world text surface is visible.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd14_PersonnelRecord_v129": {
		"family": "WorldUI",
		"summary": "Renders the retail personnel-record modal page with ID, battle-count, and dossier text rows.",
		"notes": [
			"Decodes a ComStar/personnel id, battle total, and six text fields, then fills the shared modal text page with those values and wires a single confirm button.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_Cmd15_OpenNumericPrompt_v129": {
		"family": "WorldUI",
		"summary": "Opens a range-checked numeric input prompt bound to a retail follow-up command id.",
		"notes": [
			"Decodes the outbound follow-up command id, minimum value, maximum value, and prompt text, then opens the shared modal text window, installs the numeric prompt callback, and latches the bounds on the window structure for submit-time validation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd20_ParseTextDialog_v129": {
		"family": "WorldUI",
		"summary": "Decodes the late-world text-dialog payload and forwards it into the shared stacked text dialog builder.",
		"notes": [
			"Reads a follow-up/list id, a one-byte button-layout mode, and one body string, then passes the decoded data to World_OpenStackedTextDialog_v129. Used for generic server text dialogs as well as the mech-stats style page routed through the older shell window stack.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_Cmd04_TravelCompassPage_v129": {
		"family": "WorldUI",
		"summary": "Builds the early-world travel-compass page with one center slot, four surrounding travel slots, and fixed byte-selection actions.",
		"notes": [
			"Clears the active world root surface, resets the shared compass-label strip counter, latches the current slot and flag tables, optionally refreshes the cached four outer slot ids plus byte-selection state, and redraws the five-slot picture layout before restoring the arrow cursor.",
			"Installs World_TravelCompassPage_HandleInput_v129 and World_TravelCompassPage_HandleMouse_v129 as the page callbacks. Special picture ids reuse the cached location-label bitmap built by World_LoadLocationLabelBitmap_v129 instead of a static PIC entry.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd05_SetArrowCursor_v129": {
		"family": "WorldUI",
		"summary": "Dispatches the early-world command that restores the arrow cursor mode.",
		"notes": [
			"Thin command-table wrapper over Shell_SetArrowCursorMode_v129. Used by the early shell/world command stream when the retail frontend wants to leave busy mode and restore the normal pointer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd06_SetWaitCursor_v129": {
		"family": "WorldUI",
		"summary": "Dispatches the early-world command that switches the frontend into wait-cursor mode.",
		"notes": [
			"Thin command-table wrapper over Shell_SetWaitCursorMode_v129. Used by the early shell/world command stream when the retail frontend wants to show a busy pointer while work is pending.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd09_OpenNumberedTextSelection_v129": {
		"family": "WorldUI",
		"summary": "Decodes and opens the older numbered text-selection modal from a streamed string list.",
		"notes": [
			"Checks the leading subcommand byte for the open-list path, decodes the item count plus one plain string per choice into the shared `DAT_004f6c90` table, then routes into World_OpenTextSelectionModalWindow_v129 to replace the root UI with the numbered selection surface.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd29_QueueTransientNotice_v129": {
		"family": "WorldUI",
		"summary": "Decodes one late-world transient notice payload and enqueues it for the shared notice window/queue.",
		"notes": [
			"Reads a type1 notice id plus two byte-sized mode/variant fields and a type1 string payload. When the payload begins with a `#` resource token, it resolves the retail string-table entry before handing the text and flags to the shared transient-notice queue helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd34_TravelCompassLabelStrip_v129": {
		"family": "WorldUI",
		"summary": "Updates the upper label strip on the early-world travel-compass page from streamed text rows.",
		"notes": [
			"Decodes one string per call, clears the strip and draws the shared heading resource on the first row, then blits each decoded label into the next `0x50`-wide column while advancing the shared travel-compass column counter.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd42_BitmaskSelectionList_v129": {
		"family": "WorldUI",
		"summary": "Decodes a numbered checkbox list and opens the shared late-world multi-select dialog.",
		"notes": [
			"Reads a follow-up command id, an initial bitmask, a heading string, and one plain-text row per entry. It formats the numbered rows into the shared style-2 shell window, seeds each checkbox from the incoming bitmask through Frame_SetTextDecorationToggleStateByIndex_v129, and installs World_BitmaskSelectionList_HandleInput_v129 as the active confirm/toggle callback.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd48_KeyedTripleStringList_v129": {
		"family": "WorldUI",
		"summary": "Wraps the shared triple-string list dialog builder with the keyed item-id column enabled.",
		"notes": [
			"Routes the incoming list payload through World_OpenTripleStringListDialog_v129 with the leading key/id field preserved, yielding rows that carry one stored submit value plus three visible text columns.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd50_ClearLocationBrowserSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Calls the shared location-browser highlight callback in clear mode for the currently latched selection.",
		"notes": [
			"Forwards `(browser_window, 0)` into the callback stored at location-browser window field `0x508`. In the browser mouse handlers the same phase clears the old palette-swapped location highlight before the selected location index changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_Cmd51_DrawLocationBrowserSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Calls the shared location-browser highlight callback in redraw mode for the current selection.",
		"notes": [
			"Forwards `(browser_window, 1)` into the callback stored at location-browser window field `0x508`. In the browser mouse handlers the same phase redraws the highlight for the new `DAT_0048f598` selection and updates the window's latched selected-row field.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_Cmd52_RejectShortcutBinding_v129": {
		"family": "WorldUI",
		"summary": "Rejects a pending shortcut binding, removes the optimistic local row, and reports the failure dialog.",
		"notes": [
			"Reads the `(menu_id, selection_id)` pair for the rejected shortcut, removes the matching row from the shared shortcut table, formats the failure text with the entry label, and opens World_OpenStackedTextDialog_v129 in one-button informational mode before the shortcut display is refreshed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd53_ConfirmShortcutBinding_v129": {
		"family": "WorldUI",
		"summary": "Confirms a pending shortcut binding and replaces the optimistic marker with the final Alt-key assignment.",
		"notes": [
			"Reads the `(menu_id, selection_id)` pair, finds the corresponding shortcut row, clears the pending high-bit marker on the stored shortcut key, formats the `Alt-%c defined for %s.` confirmation text, and opens World_OpenStackedTextDialog_v129 before the shortcut display is refreshed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_RemoveShortcutBindingAtIndex_v129": {
		"family": "WorldUI",
		"summary": "Removes one locally cached shortcut-binding row by table index and persists the updated shortcut list.",
		"notes": [
			"Shifts the later rows in the shared shortcut table `DAT_0047f8b4` down over the removed entry, decrements the active shortcut count `DAT_0047f8b0`, and then calls System_SaveFrontendConfigToRegistry_v129.",
			"The unnamed stacked-shell callback at `0x0043f265` uses it after reading the selected shortcut row and before closing the popup / restoring focus.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_FindCachedNamedEntrySlotById_v129": {
		"family": "WorldUI",
		"summary": "Finds the cached named-entry slot for a retail id inside the early-world entry table.",
		"notes": [
			"Walks the shared cmd10/cmd11/cmd12 entry table until it finds an active slot whose stored retail id matches the requested value, returning `-1` when no slot exists.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_OpenCachedNamedEntrySelectionDialog_v129": {
		"family": "WorldUI",
		"summary": "Opens a world selection dialog over the cached named-entry table and wires the shared selection callback.",
		"notes": [
			"Allocates a type-7 world window, formats the action/header/footer labels from resources `0x120` through `0x128`, builds the visible numbered rows from the shared cached named-entry table rooted at `DAT_004f57a0`, stores each row's submit value in `DAT_00498238`, and installs World_CachedNamedEntrySelectionDialog_HandleInput_v129 as the active callback before showing the dialog.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_CachedNamedEntrySelectionDialog_ToggleSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Inverts one cached-entry selection-dialog highlight rectangle.",
		"notes": [
			"Computes the two-column option rectangle from the current dialog window, then calls Frame_SwapPaletteIndicesInRect_v129 so the same helper can both apply and clear the cached-entry selection highlight.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_CachedNamedEntrySelectionDialog_UpdateSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Selection-change callback for the cached named-entry selection dialog.",
		"notes": [
			"Highlights the currently active cached-entry choice when the dialog requests an apply pass, unhighlights the previously latched choice on a clear pass, and routes both operations through World_CachedNamedEntrySelectionDialog_ToggleSelectionHighlight_v129.",
			"World_OpenCachedNamedEntrySelectionDialog_v129 installs this callback on the type-7 selection window alongside the existing keyboard input handler.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_CachedNamedEntrySelectionDialog_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Handles navigation and submit actions for the cached named-entry selection dialog.",
		"notes": [
			"Closes on Escape, rotates the highlighted row on the retail arrow/page-style input ids, and maps the fixed action keys plus the current row selection into World_SendMenuSelection_v129 with list id `3`. Dynamic row submits use the value latched in `DAT_00498238` plus the retail `+2` offset before the shell buffer is flushed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_NumericPrompt_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Handles Enter/Escape on the retail numeric prompt, validates the typed number, and sends the follow-up command.",
		"notes": [
			"Reads the current edit-field text, validates it against the latched minimum and maximum bounds, sends the response through the old cmd10-family submit helper, tears down the modal prompt stack, and flushes the outbound shell buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_CreateShellWindowByStyle_v129": {
		"family": "WorldUI",
		"summary": "Builds one of the shared framed world-shell window layouts by style id.",
		"notes": [
			"Dispatches among the retail small, medium, wide, and full-size shell window frames, drawing the corresponding border art and returning the created window. Styles that need to become the active stacked world child route through World_OpenStackedShellWindow_v129; the others create a standalone framed window directly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_CloseStackedShellWindow_v129": {
		"family": "WorldUI",
		"summary": "Closes the current stacked world-shell child window and restores the previous active shell window when one is saved.",
		"notes": [
			"Frees the current stacked shell window, pops the saved world-window stack when nested overlays remain, and clears the stacked-window state bit when the stack becomes empty. When the stack fully unwinds it restores focus through World_ReactivateStackedShellOwnerWindow_v129, and when the world shell is active and unobstructed afterward it refreshes the underlying travel-compass page highlight state before returning to the caller.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_ReactivateStackedShellOwnerWindow_v129": {
		"family": "WorldUI",
		"summary": "Reactivates the stacked world-shell owner window when the stacked-shell focus flag is armed.",
		"notes": [
			"Called by World_CloseStackedShellWindow_v129, World_MenuDialog_HandleInput_v129, and World_Cmd04_TravelCompassPage_v129 after a stacked child is dismissed or a menu action completes. When the stacked-shell focus bit is set, it simply reactivates the owner window stored in `DAT_0047d4e4`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_RestoreStackedShellFocusTarget_v129": {
		"family": "WorldUI",
		"summary": "Restores stacked-shell focus to the correct owner or fallback window before pointer-driven selection handling runs.",
		"notes": [
			"Called only by World_HandleStackedShellSelectionPointer_v129 on pointer-down passes. When the stacked-shell focus bit is armed it either reactivates the stored owner window at `DAT_0047d4e4` or, when that owner is already the active shell root, activates the topmost alternate window instead.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_ToggleStackedShellSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Toggles the palette-swapped highlight rectangle for one stacked-shell selection row.",
		"notes": [
			"Uses the selection-row rect table embedded in the active stacked shell window at `DAT_0047d4e4` and swaps palette indices in the indexed row rectangle. The stacked menu/text selection handlers call it to flip the old and new row highlights without redrawing the full shell, while World_ToggleStackedShellSelectionRowHighlight_v129 exposes the same one-row palette swap for helpers that only need to clear a previously recorded selection slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_ToggleStackedShellSelectionRowHighlight_v129": {
		"family": "WorldUI",
		"summary": "Swaps the palette-highlight state for one indexed row in the active stacked world-shell dialog.",
		"notes": [
			"Looks up the indexed row rectangle in the active stacked shell window at `DAT_0047d4e4` and swaps palette indices `0x00` and `0x23` across that rect. The tiny row-state wrappers around the stacked selection handlers use it when they need to clear a previously highlighted row stored in dialog-local state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_HandleStackedShellSelectionPointer_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for stacked world-shell selection dialogs backed by text-decoration rows.",
		"notes": [
			"Installed as the pointer callback by multiple unnamed stacked-shell dialog builders. On pointer-down passes it first restores the correct focus target through World_RestoreStackedShellFocusTarget_v129, then resolves the enabled text decoration under the pointer, routes in-range selection rows either through the local stacked-shell callback or `World_SendCmd1dControlFrame_v129`, updates the shared row-selection globals, and otherwise falls back to Frame_DefaultTextDecorationPointerHandler_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_OpenStackedStatsDialog_v129": {
		"family": "WorldUI",
		"summary": "Builds the shared stacked world-shell stats dialog family for the older early-world summary/detail pages.",
		"notes": [
			"Reads a mode byte plus mixed string and numeric payload from the incoming world frame, reuses or creates a type-7 stacked shell window, and formats the header/body rows for several old summary pages. Mode `3` delegates to World_OpenStackedDualSelectionDialog_v129, mode `7` delegates to World_OpenStackedDetailedStatsDialog_v129, and the remaining modes build a shorter stats page that can be either read-only or interactive depending on the action byte.",
			"When the dialog is interactive it installs World_HandleStackedShellSelectionPointer_v129 as the pointer callback and seeds the shared stacked-shell selection globals so World_HandleStackedStatsDialogInput_v129 can edit or submit the highlighted row values. Certain action-byte variants instead route Enter/ESC through World_HandleStackedShellActionHotkey_v129 or the local confirm/cancel path through World_HandleStackedStatsDialogConfirmInput_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_OpenStackedDetailedStatsDialog_v129": {
		"family": "WorldUI",
		"summary": "Builds the six-row stacked world-shell detailed stats dialog used by one of the older summary-page modes.",
		"notes": [
			"Invoked only from World_OpenStackedStatsDialog_v129 when the mode byte is `7`. It formats a taller type-7 stacked shell page with up to six labeled numeric rows plus an optional detail line, then either leaves the rows read-only or wires them into the shared stacked-shell selection callback family headed by World_HandleStackedStatsDialogInput_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_OpenStackedDualSelectionDialog_v129": {
		"family": "WorldUI",
		"summary": "Builds a compact stacked world-shell dialog with two selectable named/value rows.",
		"notes": [
			"Invoked only from World_OpenStackedStatsDialog_v129 when the mode byte is `3`. It writes two formatted name/value blocks into a style-5 stacked shell window, registers the two row hit regions, and optionally exposes one-button or two-button footer controls depending on the action byte. Keyboard confirm/cancel shortcuts for the remote-action variant route through World_HandleStackedShellActionHotkey_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_HandleStackedStatsDialogInput_v129": {
		"family": "WorldUI",
		"summary": "Keyboard input handler for the interactive stacked world-shell stats dialogs.",
		"notes": [
			"Used by World_OpenStackedStatsDialog_v129 and World_OpenStackedDetailedStatsDialog_v129 for the editable numeric-row variants. It handles digit entry, backspace, row switching, stepwise increment/decrement controls, Escape cancel, and submit keys, then serializes the edited values back into the appropriate outbound world opcode for the active stats-dialog mode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_HandleStackedShellActionHotkey_v129": {
		"family": "WorldUI",
		"summary": "Maps confirm/cancel hotkeys on stacked world-shell action dialogs into the retail Cmd1D control-frame actions.",
		"notes": [
			"Used by World_OpenStackedStatsDialog_v129, World_OpenStackedDetailedStatsDialog_v129, and World_OpenStackedDualSelectionDialog_v129 for the remote-action variants. Escape and semicolon send choice `0`, while `S`/Enter send choice `1`, with the active action group taken from `DAT_0048af80`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_HandleStackedStatsDialogConfirmInput_v129": {
		"family": "WorldUI",
		"summary": "Handles the simple confirm/cancel keyboard path for the non-editable stacked stats dialog variants.",
		"notes": [
			"Used by World_OpenStackedStatsDialog_v129 when the action byte selects the local confirm/cancel flow rather than the shared Cmd1D action path. Escape closes the stacked shell and emits outbound opcode `0x0b`, while Enter emits opcode `0x0d`, switches to the wait cursor, and flushes the outbound shell buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_HandleStackedStatsDialogResponse_v129": {
		"family": "WorldUI",
		"summary": "Consumes the response frame for the older stacked stats dialog family and opens the resulting notice or modal text window.",
		"notes": [
			"Closes the active stacked shell if one is still open, clears the stacked-shell focus bit, and decodes a type-1 result code from the inbound world frame. Result `0` queues transient notice line `0x1c1`; result `6` opens World_OpenModalTextWindow_v129 with a combined `0x1c2` + `0x1c3` body; all other non-zero results open the same modal window with line `0x1c3` alone, then restore the arrow cursor and return the parent page mode to `4`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_OpenModalTextWindow_v129": {
		"family": "WorldUI",
		"summary": "Opens the shared modal world text window with optional seeded input text.",
		"notes": [
			"Allocates the common modal page shell, writes the supplied body text, installs the shared close/submit callbacks, and optionally creates a child edit field preloaded with caller-provided text.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_ModalTextWindow_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Shared input handler for the retail modal text window and its text-entry variants.",
		"notes": [
			"Handles `Tab` by focusing the child edit field when one exists, `Esc` by sending an empty string response through the old text-response helper, and `Enter` by copying the current edit text into a local buffer before dispatching the window-specific follow-up action.",
			"For the generic text-response path it forwards the typed string through World_SendLegacyTextResponse_v129, then closes the stacked shell and flushes the outbound buffer. Special follow-up ids branch into the retail shortcut-binding flow, the numbered text-selection reopen path, and the local file-open path used by the late-world shell.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_OpenStackedShellWindow_v129": {
		"family": "WorldUI",
		"summary": "Pushes the current world child window onto the shell stack, then opens a new stacked shell window as the active child.",
		"notes": [
			"Preserves the current child-shell pointer on the shared stack when one is already active, allocates the replacement shell window through the low-level world window allocator, and marks the stacked-window flag when the new child window opens successfully.",
			"When a fresh stacked child is opened over the world shell and no higher-priority overlays are active, the helper refreshes the underlying travel-compass highlights before switching the active child window pointer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_OpenStackedTextDialog_v129": {
		"family": "WorldUI",
		"summary": "Builds the shared stacked world text dialog with one-button or two-button action layouts.",
		"notes": [
			"Creates the shared style-2 stacked shell window, resolves resource-token strings when the dialog text starts with `#`, and formats a small set of special follow-up ids through retail resource strings `0x8C` through `0x8F` before the dialog body is drawn.",
			"Configures either a single confirm button or a two-button choice layout based on the incoming mode byte. Informational dialogs route dismissals through World_CloseStackedShellWindow_v129, while selection variants keep the follow-up id latched for the dialog-local callbacks.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_OpenUnkeyedTripleStringListDialog_v129": {
		"family": "WorldUI",
		"summary": "Thin wrapper that opens the shared triple-string list dialog without the leading key/id column.",
		"notes": [
			"Routes into World_OpenTripleStringListDialog_v129 with wrapper mode `0`, producing numbered rows with only the three decoded text columns visible while still preserving the shared per-row submit values internally.",
			"No command-table slot currently points at this wrapper in the world dispatch table, so it may be a local helper or a dormant path retained alongside the keyed cmd48 variant.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_OpenTextSelectionModalWindow_v129": {
		"family": "WorldUI",
		"summary": "Tears down the current world root UI and opens the shared modal shell used by numbered text-selection pages.",
		"notes": [
			"Clears the root world windows, opens a type-3 modal text window with retail string resource `5` as the seeded body text, installs the numbered-selection callback, and resets the root-window mode field before the numbered options are built.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_OpenNumberedTextSelectionDialog_v129": {
		"family": "WorldUI",
		"summary": "Builds the numbered text-selection dialog from the shared choice-string table.",
		"notes": [
			"Allocates the shared type-3 modal page, writes the resource `6` heading, enumerates the decoded choice strings in `DAT_004f6c90` as `1.`, `2.`, and so on, stores the per-row submit values on the window, and installs the numbered-selection callbacks before showing the page.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_NumberedTextSelectionDialog_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Handles numeric hotkeys for the older numbered text-selection dialog.",
		"notes": [
			"Converts the normalized digit key into a one-based row index, rejects digits beyond the decoded choice count, and otherwise sends the selected numbered response before destroying the modal page and flushing the outbound buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd45_ScrollListShell_v129": {
		"family": "WorldUI",
		"summary": "Decodes the retail Cmd45 scroll-list shell, populates its visible rows, and installs the shared keyboard, mouse, and selection callbacks.",
		"notes": [
			"Builds the style-6 shell window, swaps the frame over to the alternate list font through Frame_SetActiveFont_v129, lays out the current page of visible entries and optional MORE row, and stores the callback/context state used by the shared input helpers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
		],
	},
	"World_ClearScrollListShellActiveFlag_v129": {
		"family": "WorldUI",
		"summary": "Clears the active-bit for the shared Cmd45 scroll-list shell window.",
		"notes": [
			"Clears bit `0x4` in `DAT_0047d4ec`, which is the same shell-active flag set by World_Cmd45_ScrollListShell_v129 when it installs the reusable type-6 scroll-list window in `DAT_0047d4b8`.",
			"Shell_EnterDropScene_v129 uses it before the DROP transition tears down the remaining world UI state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
		],
	},
	"World_ScrollListShell_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Keyboard handler for the retail Cmd45 scroll-list shell, including row movement, MORE paging, and submit behavior.",
		"notes": [
			"Handles ESC to close and send the cancel opcode, SPACE to request the built-in MORE action on the eligible Cmd45 modes, ENTER to either send the selected row value or open the special follow-up dialog when the latched scroll-list id is zero, and Up/Down to move the active row while skipping empty metadata slots in `DAT_004f6440`.",
			"Uses the installed row-highlight callback on the active shell window before and after cursor movement so the visible selection stays aligned with the current row index in `DAT_004e8854`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
		],
	},
	"World_ScrollListShell_HandleMouse_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the retail Cmd45 scroll-list shell, covering hover selection, click submit, and close-on-activate behavior.",
		"notes": [
			"Maps the pointer y-position into one visible list row, rejects out-of-range or empty rows through the shared UI fallback path, and uses the installed selection-highlight callback to keep hover state synchronized with `DAT_004e8854` whenever the mouse moves across the shell.",
			"On activation it either sends the selected row through World_SendMenuSelection_v129 or opens World_OpenScrollListEntryActionDialog_v129 when the latched scroll-list id is zero, matching the same special-case split used by the keyboard handler.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
		],
	},
	"World_ScrollListShell_ToggleRowHighlight_v129": {
		"family": "WorldUI",
		"summary": "Inverts the palette-highlight rectangle for one visible Cmd45 scroll-list row.",
		"notes": [
			"Computes the row rectangle from the active type-6 shell window, the shared row height of `0xe`, and the current row index, then calls Frame_SwapPaletteIndicesInRect_v129 so the same leaf can both apply and clear the highlight.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_ScrollListShell_UpdateSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Selection-change callback for the retail Cmd45 scroll-list shell.",
		"notes": [
			"Highlights the current `DAT_004e8854` row when the caller requests an apply pass, unhighlights the previously latched row stored on the window when the caller requests a clear pass, and routes both operations through World_ScrollListShell_ToggleRowHighlight_v129.",
			"World_Cmd45_ScrollListShell_v129 installs this helper in the shell window callback slot used by both World_ScrollListShell_HandleInput_v129 and World_ScrollListShell_HandleMouse_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_OpenScrollListEntryActionDialog_v129": {
		"family": "WorldUI",
		"summary": "Opens the special two-option follow-up dialog for one selected Cmd45 scroll-list entry.",
		"notes": [
			"Builds a style-2 shell window whose heading combines the selected row label with the formatted ComStar id code, then renders two localized action rows from message-catalog lines `0x91` and `0x92` before installing the standard menu-dialog input and mouse handlers.",
			"World_ScrollListShell_HandleInput_v129 reaches this helper only when the latched scroll-list id is zero, making it the special-case follow-up surface layered on top of the generic Cmd45 list shell.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
		],
	},
	"World_OpenTripleStringListDialog_v129": {
		"family": "WorldUI",
		"summary": "Builds the late-world triple-string list dialog, optionally including the stored leading key column.",
		"notes": [
			"Creates the shared style-4 shell window, decodes one stored per-row key plus three text columns per entry, and formats each numbered row with either three visible text fields or an added numeric key column depending on the wrapper mode.",
			"Stores the per-row submit values in the window state, installs World_MenuDialog_HandleInput_v129 and World_MenuDialog_HandleMouse_v129 as the active callbacks, and finishes with the standard close button used by the older world list family.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_QueueTransientNotice_v129": {
		"family": "WorldUI",
		"summary": "Appends a transient notice entry into the shared 12-slot world notice queue and auto-shows it when idle.",
		"notes": [
			"Copies the supplied text into the next queue slot, stores the decoded notice id plus two small mode fields, advances the circular write index, and immediately opens the next notice when no notice window is currently active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_ResetTransientNoticeQueue_v129": {
		"family": "WorldUI",
		"summary": "Clears the shared world transient-notice queue indices and active window pointer.",
		"notes": [
			"Resets the active-slot index, the next-display index, the next-write index, and the currently open notice window so later world notice commands start from an empty queue.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_SendLegacySelectionResponse_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the old cmd10-family world selection response with a command id and type4 payload value.",
		"notes": [
			"Appends outbound opcode `0x0A`, encodes the retail follow-up command id as a type1 arg, then appends the selected value as a type4 arg. Shared by cached-entry pickers, numeric prompts, and older checkbox/selection widgets.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"World_SendLegacyTextResponse_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the old cmd08-family world text response with a command id and byte-counted string payload.",
		"notes": [
			"Appends outbound opcode `0x08`, encodes the retail follow-up command id as a type1 arg, then appends the submitted text as a byte-counted string. Shared by the modal text-window input handler for generic text submit and cancel-with-empty-string flows.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"World_SendNumberedTextSelectionResponse_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the response frame for the older numbered text-selection dialog.",
		"notes": [
			"Appends outbound opcode `0x09`, encodes the fixed subcommand byte `0x01`, then serializes the latched text context plus the chosen numbered row value as the retail reply payload.",
			"Used exclusively by World_NumberedTextSelectionDialog_HandleInput_v129 after the pressed digit is validated against the current row count.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"World_BitmaskSelectionList_HandleInput_v129": {
		"family": "WorldSubmit",
		"summary": "Handles confirm/cancel input and per-row toggles for the late-world checkbox selection dialog.",
		"notes": [
			"Escape sends a zero value through World_SendLegacySelectionResponse_v129, Enter recomputes the checked-row bitmask by querying each checkbox through Frame_IsTextDecorationToggleStateSetByIndex_v129 and submits `bitmask + 1`, and numeric row hotkeys toggle the corresponding checkbox through Frame_SetTextDecorationToggleStateByIndex_v129 before redrawing it in place.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
		],
	},
	"World_ShowNextTransientNotice_v129": {
		"family": "WorldUI",
		"summary": "Opens the next queued world transient notice, or routes certain type-2 notices through the direct shell text path.",
		"notes": [
			"Consumes the next queued notice slot, opens the shared type-3 notice popup with one-button or two-button controls based on the stored notice mode, and advances the circular display index. When the queue entry is a special type-2 notice and the shell flags allow it, the helper bypasses the popup and forwards the text through the direct shell notice path instead.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_OpenStackedTransientNoticeWindow_v129": {
		"family": "WorldUI",
		"summary": "Opens the stacked shell-child notice window used by queued type-2 transient notices.",
		"notes": [
			"Allocates the shared style-2 stacked shell window, writes the queued notice text, adds the single confirm button, and routes dismissals through World_CloseStackedShellWindow_v129 instead of the separate transient-notice popup pointer.",
			"Used by World_ShowNextTransientNotice_v129 when the queued notice flags select the direct stacked-shell presentation instead of the shared popup layer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_HandleTransientNoticeInput_v129": {
		"family": "WorldUI",
		"summary": "Handles the active world transient-notice popup input and advances the queue after dismissals.",
		"notes": [
			"Consumes button/input callbacks for the currently open transient-notice window, closes type-2 notice popups on confirm/cancel, restores the world root when needed, clears the active popup pointer, and immediately opens the next queued notice when entries remain.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_RestoreTransientNoticeWindowFocus_v129": {
		"family": "WorldUI",
		"summary": "Restores focus to the active transient-notice popup after a travel-compass page rebuild or z-order shuffle.",
		"notes": [
			"Only runs when a queued transient-notice window is currently open. Temporarily reactivates the popup, lets the next-highest world window repair the stack underneath it, and redraws the travel-compass highlights before reactivating the popup again when the compass root still owns the active overlay state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_TransientNoticeDialog_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Handles the interactive transient-notice dialog choices and advances the notice queue afterward.",
		"notes": [
			"Reads the active queued notice record, maps `Esc`/`N` to a zero response, `Y` to a one response, and `Enter` to the notice's stored default/type value, then sends the reply through the shared transient-notice response helper before flushing the outbound buffer.",
			"Type-2 notices bypass the response send and simply advance the queue, matching the one-button informational notice path opened by World_ShowNextTransientNotice_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_RegisterShortcutBinding_v129": {
		"family": "WorldUI",
		"summary": "Registers a world shortcut / hotkey binding.",
		"notes": [
			"Appends a pending shortcut row into the shared `DAT_0047f8b4` table, persists the updated list through System_SaveFrontendConfigToRegistry_v129, and sends outbound opcode `0x1f` with the `(menu_id, selection_id)` pair that the server later accepts or rejects.",
			"World_RemoveShortcutBindingAtIndex_v129 is the matching local removal helper for the same shortcut table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_SendByteSelection_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the compact one-byte world selection response used by older popup/list handlers.",
		"notes": [
			"Appends outbound opcode `0x05`, encodes the selected value as a single byte argument, and immediately flushes the shell command buffer. Used by older world option dialogs that latch byte-sized selection ids.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"World_SendTransientNoticeResponse_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the response frame for an interactive transient notice.",
		"notes": [
			"Appends outbound opcode `0x12`, encodes the notice id as a type1 arg, the selected response/state as a type4 arg, and the queued notice's variant byte as the trailing selector field.",
			"Used by World_TransientNoticeDialog_HandleInput_v129 for the yes/no and default-action notice variants.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"World_SendTravelCompassSlotSelection_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the travel-compass selection for one of the four surrounding page slots.",
		"notes": [
			"Checks the corresponding slot-availability bit before appending outbound opcode `0x17`, maps the requested outer slot index to the retail byte payload stored for the current page, flushes the shell command buffer, and switches the cursor into wait mode.",
			"When the requested slot is disabled it shows the retail unavailable message instead of sending the selection packet.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/world_travel_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"World_OpenByteSelectionMenuHelp_v129": {
		"family": "WorldUI",
		"summary": "Opens the retail `wnd_menu` help topic for byte-selection menus.",
		"notes": [
			"Builds the `solaris.hlp` path from the active install directory, hides the current cursor through Frame_HideCursor_v129, and calls WinHelpA first with the topic-open action and then with the small `wnd_menu` help menu descriptor when the help file launches successfully.",
			"On success it latches the WinHelp window handle and sets the shared help-open flag in `DAT_0047a040`; on failure it immediately restores the saved cursor through Frame_RestoreSavedCursor_v129. World_ByteSelectionMenu_HandleInput_v129 uses it for the page-local help button `0x100`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_TickAnimatedShellBitmaps_v129": {
		"family": "WorldUI",
		"summary": "Advances and redraws any timed animated shell bitmaps registered for the world-state tick.",
		"notes": [
			"Walks the active world-shell animation descriptors, checks each entry's next-due timestamp, advances the frame index modulo 16, blits the selected frame from the descriptor's bitmap table into the target window, then presents each dirty rectangle once the due updates finish.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_ByteSelectionMenu_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Handles the legacy world byte-selection menu and submits the chosen byte value.",
		"notes": [
			"Treats input id `0x100` as the help action that opens `solaris.hlp`, maps ids `0x101` through `0x105` through the byte-value table rooted at `DAT_004e7404`, sends the selected value through World_SendByteSelection_v129, and otherwise falls back to the shared cancel/close handler.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_TravelCompassPage_TestPointerHit_v129": {
		"family": "WorldUI",
		"summary": "Runs the travel-compass page pointer hit-test only while that page is the active world root.",
		"notes": [
			"Rejects the pointer probe unless the current root window and child window stack still belong to the active travel-compass page and the page mode field remains `5`, then delegates to the shared rectangle hit-test helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_TravelCompassPage_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Keyboard and hotkey handler for the early-world travel-compass page.",
		"notes": [
			"Routes the shared byte-selection hotkeys through World_ByteSelectionMenu_HandleInput_v129, opens the cached named-entry picker on input id `0x121`, maps the four outer-slot hotkeys `0x118` through `0x11B` into World_SendTravelCompassSlotSelection_v129, and preserves the page's legacy help and close actions.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_TravelCompassPage_HandleMouse_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the early-world travel-compass page.",
		"notes": [
			"Maps clicks on the center slot into World_OpenCachedNamedEntrySelectionDialog_v129, routes the four surrounding slot hits into World_SendTravelCompassSlotSelection_v129, and preserves the fixed byte-selection action buttons plus help/close behavior on the same page.",
			"When the shared shell-control redirect flag is active it delegates the click-to-command translation through World_SendTravelCompassMouseControlFrame_v129 instead of executing the local action immediately.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_SendTravelCompassMouseControlFrame_v129": {
		"family": "WorldUI",
		"summary": "Translates one travel-compass mouse hit into the corresponding outbound Cmd1D control-frame action.",
		"notes": [
			"Compares the clicked control id against the page's active center control, maps clicks above/below that anchor into the retail relative control opcodes, and forwards the result through World_SendCmd1dControlFrame_v129.",
			"World_TravelCompassPage_HandleMouse_v129 only uses this path while the shared shell redirect flag is set, which is why ordinary local clicks still branch directly into slot selection, cached-entry popup, EXIT confirmation, or the CMP button animation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_ActivateTravelCompassCmpButton_v129": {
		"family": "WorldUI",
		"summary": "Plays the travel-compass CMP button flash/press animation and then opens the shared CMP action dialog.",
		"notes": [
			"Only called from World_TravelCompassPage_HandleInput_v129 and World_TravelCompassPage_HandleMouse_v129 for the travel-compass page's fixed CMP action button. Blits the pressed-state bitmap, waits roughly `0x15` centiseconds, restores the idle art, and then opens Shell_OpenCmpActionDialog_v129 unless the caller requested the visual-only phase.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_IsTravelCompassCurrentLabelPictureId_v129": {
		"family": "WorldUI",
		"summary": "Returns whether a travel-compass picture id is the singleton current-label placeholder.",
		"notes": [
			"Matches picture id `0x16`, the one-off placeholder that World_Cmd04_TravelCompassPage_v129 and World_RedrawTravelCompassPageArt_v129 treat as eligible for substitution with the live location-label bitmap loaded into `DAT_0047fb5c`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_IsTravelCompassDistrictLabelPictureId_v129": {
		"family": "WorldUI",
		"summary": "Returns whether a travel-compass picture id falls in the district-label placeholder range.",
		"notes": [
			"Matches picture ids `0x21` through `0x25`, the five label-backed district placeholder variants that the travel-compass page swaps to the live location-label bitmap instead of the cached `I101+` art table when `DAT_0047fb5c` is available.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_DrawTravelCompassPageFrameArt_v129": {
		"family": "WorldUI",
		"summary": "Draws the fixed shell-frame bitmap layers used by the early-world travel-compass page.",
		"notes": [
			"Blits the preloaded frame, trim, and lower-panel ornament bitmaps at their fixed coordinates around the five-slot compass layout. World_Cmd04_TravelCompassPage_v129 uses it during initial page construction before the variable slot art and highlights are refreshed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_RedrawTravelCompassPageHighlights_v129": {
		"family": "WorldUI",
		"summary": "Repaints the travel-compass page slot highlights, borders, and unavailable-slot overlays.",
		"notes": [
			"Refreshes the palette-swapped slot rectangles, redraws the underlying five-slot page art through World_RedrawTravelCompassPageArt_v129, then reapplies the per-slot hatch fill and beveled borders for the currently tracked travel choices before optionally presenting the window.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_RedrawTravelCompassPageArt_v129": {
		"family": "WorldUI",
		"summary": "Redraws the five picture panels and fixed shell art for the travel-compass page.",
		"notes": [
			"Draws the center picture plus the four surrounding slot pictures from the cached page slot table, substituting the live location-label bitmap when the current picture id maps to the special label-backed travel cases, then repaints the fixed shell ornament bitmaps loaded by Frame_LoadWorldShellBitmapTables_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_DrawTravelCompassSlotHatchFill_v129": {
		"family": "WorldUI",
		"summary": "Draws the alternating hatch fill used on one travel-compass slot rectangle.",
		"notes": [
			"Writes every other pixel row/column across the target slot rectangle using the slot's cached highlight byte, producing the striped unavailable-state overlay used by the travel-compass page.",
		],
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
	"World_OpenPagedMechListWindow_v129": {
		"family": "WorldUI",
		"summary": "Creates the shared four-slot paged mech-list window used by the late-world cmd26/cmd27/cmd32 chooser family.",
		"notes": [
			"Reuses or allocates the fullscreen frame-backed window, switches the header/action labels according to the current mech-list mode, seeds four slot decorations plus the bottom action buttons, installs the slot-highlight callback and keyboard handlers, redraws the first visible page, and shows the initial selection highlight. Cmd26 mech lists, cmd27 alternate mech choosers, and cmd32 alternate ranking lists all converge here after decoding their row data.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_ClearPagedMechListAndComponentActionFlags_v129": {
		"family": "WorldUI",
		"summary": "Clears the active state bits shared by the paged mech-list window and the mech component-action page.",
		"notes": [
			"ANDs `DAT_0047d4ec` with `~0x201`, dropping the `0x1` flag set by World_OpenPagedMechListWindow_v129 and the `0x200` flag set by World_Cmd31_MechComponentActionPage_v129.",
			"Shell_EnterDropScene_v129 uses it to invalidate those mech-management page states before the DROP scene resets the rest of the world UI.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_DrawPagedMechListShellFrame_v129": {
		"family": "WorldUI",
		"summary": "Draws the static shell bitmap frame used under the retail paged mech-list window.",
		"notes": [
			"Blits the fixed top, side, divider, and lower border art into the shared paged mech-list frame before any row text, mech art, or action labels are rendered.",
			"World_OpenPagedMechListWindow_v129 uses it during initial construction and World_RedrawPagedMechListWindow_v129 reuses it whenever the visible page contents are rebuilt.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_RedrawPagedMechListWindow_v129": {
		"family": "WorldUI",
		"summary": "Repaints the current page of four visible mech-list slots, centered captions, footer text, and paging controls.",
		"notes": [
			"Clears and redraws the current visible slice of the shared paged mech-list window using the global page offset, drawing each slot's mech bitmap, primary caption, optional secondary caption, and the footer/action labels. It is the main render pass beneath cmd26 mech lists, cmd27 alternate choosers, and cmd32 ranking-style lists whenever the page offset changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_RedrawPagedMechListChoiceLabels_v129": {
		"family": "WorldUI",
		"summary": "Redraws the per-slot secondary choice labels for the visible paged mech-list entries and presents the updated window.",
		"notes": [
			"When the shared paged mech-list window is in alternate-choice mode, this helper repaints the centered choice/value label inside each visible slot using the current per-row selection index table, then refreshes the composed window. The keyboard handler calls it after cycling the active slot's alternate value.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_ClearPagedMechListSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Restores the unselected border and bitmap placement for one paged mech-list slot and presents the slot rectangle.",
		"notes": [
			"Resolves the visible slot decoration for the supplied absolute row index, redraws its beveled border in the inactive state, restores the mech bitmap at the unpressed offset, and presents just that slot rectangle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_DrawPagedMechListSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Draws the active highlight border for one paged mech-list slot and presents the updated slot rectangle.",
		"notes": [
			"Uses the pressed-state border variant and the nudged bitmap offset for the selected visible slot, then presents only that slot rectangle so focus can move without redrawing the full page.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_UpdatePagedMechListSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Clears the previously highlighted paged mech-list slot and draws the new active highlight.",
		"notes": [
			"The shared slot-selection callback used by the paged mech-list window. On deselect it clears the last highlighted row when one exists; on select it redraws the new highlighted slot and stores the active row index on the window state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_PagedMechList_HandlePointer_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the shared paged mech-list window.",
		"notes": [
			"Runs the shared frame hit test across the four visible slots plus the previous/next page controls. Hovering a visible row updates the selection highlight through the installed slot callback, clicking a visible row keeps the highlight in sync, and clicking the paging controls redraws the next or previous four-row page before restoring the active highlight.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_PagedMechList_ActivatePointerSelection_v129": {
		"family": "WorldUI",
		"summary": "Activates the currently pointed visible mech-list row through the shared paged mech-list input path.",
		"notes": [
			"Re-runs the row hit test, rejects clicks that land beyond the decoded row count on the current page, and forwards valid visible-row activations into World_PagedMechList_HandleInput_v129 using the retail synthetic select key so mouse selection reuses the keyboard submit path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_SendPagedMechListControlFrame_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the cmd1d control-frame actions used by the paged mech-list footer buttons and alternate-choice submit path.",
		"notes": [
			"Maps `Enter` to the current alternate-choice index plus ten, `Esc` to cancel, `N` and `P` to the retail previous/next choice actions, and `X` to the explicit examine action, then forwards the selected control id through World_SendCmd1dControlFrame_v129 with the paged mech-list action opcode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_SendPagedMechListAlternateChoiceTable_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the alternate-choice table selected from the retail paged mech-list window.",
		"notes": [
			"Appends outbound opcode `0x10`, encodes the owning paged-list command id plus the number of visible alternate-choice rows, then serializes one `(choice-index, selected-value)` pair per row from the shared paged mech-list state tables.",
			"World_PagedMechList_HandleInput_v129 reaches this helper only in alternate-choice mode after duplicate-assignment validation passes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_PagedMechList_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Handles confirm, cancel, paging, selection movement, alternate-choice cycling, and examine input for the shared paged mech-list window.",
		"notes": [
			"Enter submits the current selection or the current alternate-choice table, `Esc`/`C` cancels, the retail up/down keys move the highlighted row through the paged four-slot list, `N` and `P` cycle alternate per-slot values when that mode is enabled, and `X` sends the explicit examine/control-frame request. When alternate-choice mode detects duplicate assignments it plays the shared UI reject cue instead of submitting.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"World_MenuDialog_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Keyboard input handler for the retail menu-dialog surface.",
		"notes": [
			"Accepts numeric menu shortcuts plus ESC, dispatches the chosen response through World_SendMenuSelection_v129, closes the stacked shell when appropriate, then restores the owner shell focus through World_ReactivateStackedShellOwnerWindow_v129 before flushing the outbound command buffer.",
		],
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
	"World_HotkeySelectionMenu_DispatchNormalizedKey_v129": {
		"family": "WorldUI",
		"summary": "Normalizes the hotkey selection menu's special Space shortcut and forwards it into the active window key dispatcher.",
		"notes": [
			"Maps `Space` to `m` before calling the generic active-window dispatcher so the cmd57 hotkey menu can trigger the appended `More Personal Stats` row with the same key path as an explicit `m` press.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_SendHotkeySelectionMenuControlFrame_v129": {
		"family": "WorldSubmit",
		"summary": "Sends the cmd1d control frame for the active hotkey selection menu, mapping the `More` row to sentinel value `1000`.",
		"notes": [
			"Builds a `cmd1d` control-frame packet with subtype `0x09`, the latched menu id, and the selected hotkey value. When the chosen key is `m` or `M`, it sends the retail sentinel `1000` instead of the raw character code so the server can resolve the special `More Personal Stats` row.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
		],
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
	"World_MechStatusOptionPage_HandleActionHotkey_v129": {
		"family": "WorldUI",
		"summary": "Hotkey/control helper for the mech-status option hub.",
		"notes": [
			"Handles the shared cmd1d control-frame hotkeys installed on the mech-status option page. Numeric row keys send the corresponding option index, while `Enter`, `Esc`, and the Done hotkey collapse to the page's zero-value control action and reuse the same mech-status follow-up opcode path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_CloseMechStatusOptionPage_v129": {
		"family": "WorldUI",
		"summary": "Closes the active mech-status option page window and restores the normal arrow cursor.",
		"notes": [
			"Checks the cmd30 mech-status page flag in the shared world-shell bitfield, destroys the window tracked in `DAT_0047d4e0`, restores arrow cursor mode, and clears the ownership bit so the status page can be reopened cleanly later.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"World_TeardownRootUiWindows_v129": {
		"family": "WorldUI",
		"summary": "Closes the active world root and auxiliary UI windows and clears the corresponding world-shell state bits.",
		"notes": [
			"When the world-shell active bit is set, marks teardown in progress, clears world UI children, destroys the root/auxiliary popup windows tracked in the shared world globals, clears the optional overlay/dialog windows guarded by bits `0x40` and `0x04`, and resets the world-shell flag mask before returning. When the world shell is not active, it falls back to the shared UI cleanup path through Frame_ResetRootWindowTextLayout_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
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
	"World_MechComponentActionPage_UpdateSelectionHeader_v129": {
		"family": "WorldUI",
		"summary": "Refreshes the mech component-action page header/detail strip for the currently selected row.",
		"notes": [
			"Rebuilds the temporary component-status state for the active mech record, formats the selected component name plus its current and maximum condition values, and redraws just the top header strip of the component-action page. Both the keyboard and pointer paths call it whenever the focused component row changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_DrawMechManagementListSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Applies the highlighted palette state for the currently selected wide mech-management row.",
		"notes": [
			"Used by the shared mech-management list selection callback on the select path. Resolves the active row rectangle from the current window, clamps the highlight width to the retail wide-row span, and swaps the row palette into the highlighted state without redrawing the whole page.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_ClearMechManagementListSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Restores the non-highlighted palette state for the previously selected wide mech-management row.",
		"notes": [
			"Used by the shared mech-management list selection callback on the deselect path. Resolves the stored row rectangle from the active window, clamps the redraw width to the retail wide-row span, and swaps the palette back to the unselected state in place.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_UpdateMechManagementListSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Shared selection-highlight callback for the mech component-action and buy-extra-ammo list pages.",
		"notes": [
			"Implements the standard frame callback contract used by late-world lists: deselect clears the previously highlighted wide row when one exists, and select palette-swaps the new row and stores its absolute index in the active window state. World_Cmd31_MechComponentActionPage_v129 and World_Cmd39_BuyExtraAmmoList_v129 both install this helper as their row-highlight callback.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
	},
	"World_MechStatusOptionPage_GetWeaponRangeBandIndex_v129": {
		"family": "WorldUI",
		"summary": "Buckets one mech-status weapon entry into the short, medium, or long range band used by the retail status page.",
		"notes": [
			"Reads the retail weapon metadata range field and classifies it against the page's built-in thresholds of roughly 90m, 270m, and 900m. World_Cmd30_MechStatusOptionPage_v129 uses the returned index to select one letter from the embedded `SML` table when drawing the weapon list.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"World_MechStatusOptionPage_ClassifyWeaponDamageTier_v129": {
		"family": "WorldUI",
		"summary": "Maps a mech-status weapon entry onto the four retail damage tiers used by the status page.",
		"notes": [
			"Uses the page-local weapon damage table to bucket each weapon into light, medium, heavy, or assault-class damage groups. The thresholds line up with the retail damage bands used by the status page renderer rather than the raw per-shot damage values stored in Godot's MecParser table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"World_MechStatusOptionPage_GetWeaponDamageTierLabel_v129": {
		"family": "WorldUI",
		"summary": "Returns the retail text label for one mech-status weapon damage tier bucket.",
		"notes": [
			"Maps the four damage-tier indices used by World_MechStatusOptionPage_ClassifyWeaponDamageTier_v129 onto MPBT.MSG labels `0x479..0x47C` for display in the status-page weapon table.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"World_GetMechDetailRowCount_v129": {
		"family": "WorldUI",
		"summary": "Returns the total number of detail rows available for the active mech detail record.",
		"notes": [
			"Combines the fixed retail mech-detail rows with the current weapon-entry count and ammo/detail tail count stored on the active mech record. The shared row-section helper uses this total to reject out-of-range row indices.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"World_GetMechDetailRowSection_v129": {
		"family": "WorldUI",
		"summary": "Classifies a retail mech-detail row index into its backing section and base offset.",
		"notes": [
			"Buckets the supplied row index into the fixed-detail rows, the armor table, the internal-structure table, the weapon-entry range, or the trailing ammo/detail range, and writes the matching section base through the out-parameter. Shared by the mech-status decoder, the component-action page label/percent helpers, and combat-side damage application.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"World_SetMechDetailRowConditionValue_v129": {
		"family": "WorldUI",
		"summary": "Stores one decoded retail condition value into the correct mech-detail row backing array.",
		"notes": [
			"Uses World_GetMechDetailRowSection_v129 to route a row/value pair into the fixed-detail, armor, internal-structure, or weapon-condition arrays on the temporary mech-detail state block. World_Cmd30_MechStatusOptionPage_v129 calls it while decoding the server-provided condition updates for the page.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"World_GetMechDetailRowLabel_v129": {
		"family": "WorldUI",
		"summary": "Builds the display label string for one selected mech-detail row.",
		"notes": [
			"Formats row labels for the nearby mech-management UI family, including fixed-detail labels, standard armor, internal structure, weapon names, and trailing detail entries. World_MechComponentActionPage_UpdateSelectionHeader_v129 uses the returned scratch buffer to redraw the selected-row title strip.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"World_GetMechDetailRowConditionPercent_v129": {
		"family": "WorldUI",
		"summary": "Returns the normalized condition percentage for one mech-detail row on the component-action page.",
		"notes": [
			"Uses World_GetMechDetailRowSection_v129 to choose the correct max/current value source for the selected row, then converts that source into a retail 0-100 condition percentage. The component-action page renderer uses the result for the per-row condition column and for the matching color selection.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/assets/mec_parser.gd",
		],
	},
	"World_MechComponentActionPage_GetConditionPercentColor_v129": {
		"family": "WorldUI",
		"summary": "Maps a component-action row condition percentage onto the retail text color used by the page.",
		"notes": [
			"Converts the normalized row-condition percentage from World_GetMechDetailRowConditionPercent_v129 into the palette-coded text colors used across the component-action page's condition columns, including the distinct perfect-condition color at 100%.",
		],
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
	"Frame_DecodeByteArg_v129": {
		"family": "FrameProtocol",
		"summary": "Decodes one retail `!`-offset byte argument from the active packet cursor.",
		"notes": [
			"Advances the current inbound command cursor by one byte and subtracts the retail `0x21` wire offset, yielding the raw 0-84 value consumed by world/combat command handlers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Frame_DecodeType1Arg_v129": {
		"family": "FrameProtocol",
		"summary": "Decodes one retail type1 integer argument from the active packet cursor.",
		"notes": [
			"Thin wrapper around `Frame_DecodeArg_v129(1)` that preserves the decoded return value for the caller. Shared by older world menu, scroll-list, prompt, and message handlers that consume the compact retail base-85 integer encoding.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Frame_DecodeStringArg_v129": {
		"family": "FrameProtocol",
		"summary": "Decodes a retail string argument into a caller-owned buffer and returns its length.",
		"notes": [
			"Uses Frame_DecodeStringSpanArg_v129 to resolve either an inline packet string or an indirect string-table entry, copies the bytes into the destination buffer, and appends a trailing NUL terminator for UI-facing command handlers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_DecodeType1StringArg_v129": {
		"family": "FrameProtocol",
		"summary": "Decodes a retail type1-length string argument into a caller-owned buffer and returns its length.",
		"notes": [
			"Uses Frame_DecodeType1StringSpanArg_v129 to resolve the source span, then copies the text into the destination buffer and appends a trailing NUL terminator. Shared by world dialog, message-view, and hotkey/list text handlers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"Frame_DecodeStringSpanArg_v129": {
		"family": "FrameProtocol",
		"summary": "Decodes a retail string argument as a pointer-plus-length span from the active packet cursor.",
		"notes": [
			"Reads the leading one-byte encoded string length. Ordinary lengths point directly at the inline packet bytes, while the sentinel `-1` form decodes a type1 string-table id and resolves it through the retail UI string table before returning the span.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_DecodeType1StringSpanArg_v129": {
		"family": "FrameProtocol",
		"summary": "Decodes a retail type1-length string argument as a pointer-plus-length span from the active packet cursor.",
		"notes": [
			"Reads the string length through Frame_DecodeArg_v129 using type1 width, then returns the inline packet span without copying. This is the length format used by several world text/menu handlers.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"Frame_EncodeArg_v129": {
		"family": "FrameProtocol",
		"summary": "Encodes a variable-width retail base-85 integer into the outbound command buffer.",
		"notes": [
			"Writes the requested type1 through type4 integer width using the retail `!`-offset base-85 digit scheme and clamps the value to the maximum representable range for that width.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Frame_EncodeByteArg_v129": {
		"family": "FrameProtocol",
		"summary": "Encodes one raw byte argument into the outbound retail command buffer using the `!`-offset wire format.",
		"notes": [
			"Adds the retail `0x21` wire offset to the supplied byte value and appends the encoded result to the active outbound command buffer. Shared by world, combat, and shell command builders for one-byte arguments.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/auth_client.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Frame_EncodeByteCountedStringArg_v129": {
		"family": "FrameProtocol",
		"summary": "Encodes a retail byte-counted string argument into the outbound command buffer.",
		"notes": [
			"Writes a one-byte `!`-offset length prefix capped to 0x54 bytes, then copies the raw string payload into the outbound buffer. Used by command send helpers that take a short inline text field.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Frame_EncodeType1StringArg_v129": {
		"family": "FrameProtocol",
		"summary": "Encodes a retail type1-length string argument into the outbound command buffer.",
		"notes": [
			"Computes the string length, emits it through Frame_EncodeArg_v129 using type1 width, then appends the raw string bytes. Used by outbound helpers that need the wider retail length prefix rather than the one-byte counted form.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Frame_EncodeType1Arg_v129": {
		"family": "FrameProtocol",
		"summary": "Thin wrapper that encodes a retail type1 integer argument into the outbound command buffer.",
		"notes": [
			"Delegates to Frame_EncodeArg_v129 with width type1, which emits the two-digit retail base-85 representation used by many small command ids and scalar fields.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/world_client.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"ResourceArchive_CloseTaggedArchive_v129": {
		"family": "ResourceArchive",
		"summary": "Closes a retail tagged archive descriptor, releases its directory buffer, and frees the archive wrapper.",
		"notes": [
			"Used by slideshow, title-card, bitmap-cache, and combat/world picture-table cleanup paths once no more tagged entry seeks are needed. It closes the underlying FILE handle when present, frees the in-memory tag directory block, and then frees the small archive descriptor itself.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/asset_registry.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"ResourceArchive_OpenTaggedArchive_v129": {
		"family": "ResourceArchive",
		"summary": "Opens a retail tagged archive file and reads its fixed-size entry directory into memory.",
		"notes": [
			"Returns a small archive descriptor containing the file handle, entry count, and the in-memory table of four-character tag plus offset pairs used by later seeks.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/asset_registry.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"ResourceArchive_SeekTaggedEntry_v129": {
		"family": "ResourceArchive",
		"summary": "Locates a four-character tagged entry inside an opened retail archive and seeks the archive file to that payload.",
		"notes": [
			"Scans the in-memory archive directory, compares each four-byte tag against the requested name, endian-fixes the stored file offset, and returns the same FILE handle positioned at the matching payload.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/asset_registry.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_GetCachedBitmapBuffer_v129": {
		"family": "FrameBlit",
		"summary": "Looks up or loads a cached bitmap buffer by resource name from the requested retail archive.",
		"notes": [
			"Maintains a small fixed-size cache keyed by bitmap name. On a cache miss it opens the requested archive/package handle, delegates the actual bitmap load to Frame_LoadBitmapBufferFromArchive_v129, then stores the resulting buffer pointer for reuse.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_InitializeBitmapLookupTableCache_v129": {
		"family": "FrameBlit",
		"summary": "Initializes the shared retail bitmap lookup-table cache used by buffered bitmap loads.",
		"notes": [
			"Allocates the small eight-record cache backing the x-axis and y-axis bitmap lookup tables, splits it into two four-entry banks, and seeds the default table pairs needed by the combat presentation reset path. Combat_ResetPresentationStateAndLoadVisualOptions_v129 calls it before bitmap-backed presentation assets are loaded.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_GetBitmapLookupTablePair_v129": {
		"family": "FrameBlit",
		"summary": "Returns the cached retail x-axis and y-axis lookup tables for a bitmap buffer descriptor, allocating them on demand.",
		"notes": [
			"Maintains two four-entry lookup-table banks keyed by bitmap width and height/stride parameters. It resolves each axis through Frame_GetOrCreateBitmapLookupTable_v129, and Frame_LoadBitmapBufferFromArchive_v129 uses the resulting pair to attach reusable lookup tables to each loaded bitmap buffer descriptor instead of rebuilding the wrapped row/column offsets every time.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_GetOrCreateBitmapLookupTable_v129": {
		"family": "FrameBlit",
		"summary": "Looks up or allocates one bitmap lookup table inside the shared retail lookup-table cache.",
		"notes": [
			"Searches the selected four-entry lookup-table bank for a record matching the requested dimensions, allocates a new lookup buffer if no match exists, and fills the table with the wrapped row or column offsets used by retail bitmap blitters. Frame_GetBitmapLookupTablePair_v129 calls it twice to obtain the x-axis and y-axis tables for a bitmap buffer descriptor.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_FreeBitmapLookupTableCache_v129": {
		"family": "FrameBlit",
		"summary": "Frees the shared retail bitmap lookup-table cache and clears both lookup-table banks.",
		"notes": [
			"Releases every allocated lookup-table payload hanging off the eight cache records, then frees the cache header itself and clears the global bank pointers. Combat_Cmd63_ResultSceneInit_v129 uses it during combat presentation teardown, and Frame_InitializeBitmapLookupTableCache_v129 also falls back to it if seeding the default tables fails.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_LoadBitmapBufferFromArchive_v129": {
		"family": "FrameBlit",
		"summary": "Loads a bitmap resource from an opened retail archive into a heap buffer descriptor.",
		"notes": [
			"Opens the named bitmap entry, decodes the retail bitmap payload, allocates a destination buffer plus descriptor, requests the matching lookup tables through Frame_GetBitmapLookupTablePair_v129, and copies the full pixel payload through Frame_CopyBitmapPixelsToBuffer_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_LoadBitmapFromFile_v129": {
		"family": "FrameBlit",
		"summary": "Loads a retail bitmap resource from the current FILE position into a heap bitmap object.",
		"notes": [
			"Allocates the bitmap header object, reads the fixed header words, optionally loads the embedded palette block through Frame_LoadBitmapPaletteBlock_v129, then decodes the pixel payload. On any partial-read or decode failure it frees the half-built bitmap through Frame_FreeBitmap_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_LoadBitmapPaletteBlock_v129": {
		"family": "FramePalette",
		"summary": "Loads the optional palette block for one retail bitmap resource.",
		"notes": [
			"Reads the palette-block byte size into the bitmap header, allocates the attached palette buffer at bitmap offset `+0x0c`, and copies the raw palette payload from the current FILE position.",
			"Frame_LoadBitmapFromFile_v129 calls it only when the bitmap header flags include the optional palette bit, and later palette users such as Frame_CopyBitmapPaletteToBuffer_v129 consume the same attached block.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_LoadBitmapPixelPayload_v129": {
		"family": "FrameBlit",
		"summary": "Loads the variable-size pixel payload block for one retail bitmap object.",
		"notes": [
			"Reads the payload width, height, and byte count into the bitmap header, allocates the backing buffer at `+0x18`, then copies the raw payload bytes from the current FILE position.",
			"Frame_LoadBitmapFromFile_v129 calls it after the optional palette/aux block loader succeeds, and any short read or allocation failure forces the parent loader to free the half-built bitmap.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_LoadMwPictureArchivesAndTables_v129": {
		"family": "FrameBlit",
		"summary": "Opens MW_MPICS.DAT, preloads the shared bitmap tables, and opens the unit bitmap archives used by retail inline/image surfaces.",
		"notes": [
			"Loads the HOU1-HOU5 house bitmaps plus the I101+ shared inline bitmap table from MW_MPICS.DAT, delegates the larger world-shell surface bundle to Frame_LoadWorldShellBitmapTables_v129, then opens HUNITS.DAT and UNITS.DAT for later dynamic unit-image lookups.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_LoadUnitBitmapByTag_v129": {
		"family": "FrameBlit",
		"summary": "Loads a unit bitmap by tag from the pre-opened HUNITS.DAT and UNITS.DAT retail archives.",
		"notes": [
			"Tries the human-unit archive first, then the generic unit archive, and returns a freshly loaded bitmap object only when the tag is not already satisfied by the preloaded inline bitmap tables.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_LoadWorldShellBitmapTables_v129": {
		"family": "FrameBlit",
		"summary": "Loads the fixed MW_MPICS world-shell bitmap tables into the retail global caches.",
		"notes": [
			"Bulk-loads the shell artwork groups such as FUL*, RAD*, DSC*, MOV*, SHO*, BUT*, and CHK* from MW_MPICS.DAT so the world shell, option panes, and other framed retail surfaces can draw without reopening the archive for each tag.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FreeWorldShellBitmapTables_v129": {
		"family": "FrameBlit",
		"summary": "Frees the cached MW_MPICS world-shell bitmap tables and clears their global slots.",
		"notes": [
			"Walks the same global bitmap groups populated by Frame_LoadWorldShellBitmapTables_v129, frees each loaded bitmap, clears the cached pointer tables, releases the auxiliary heap block at `DAT_004e7a40`, and drops the optional extra buffer at `DAT_004e7e30`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FreeWorldShellBitmapTableEntry_v129": {
		"family": "FrameBlit",
		"summary": "Frees one heap-allocated world-shell bitmap table entry and its owned bitmap payload.",
		"notes": [
			"Checks the table-entry pointer for null, frees the owned bitmap block stored in the first field when present, and then releases the outer entry header.",
			"Frame_FreeWorldShellBitmapTables_v129 uses it while tearing down the per-tag MW_MPICS shell bitmap tables.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FreeWorldShellDialogBitmapTables_v129": {
		"family": "FrameBlit",
		"summary": "Frees the additional world-shell dialog/subpanel bitmap tables loaded from MW_MPICS and clears their globals.",
		"notes": [
			"Walks the extra global bitmap groups rooted at `DAT_004e81a0`, `DAT_004e79f0`, `DAT_004e7d70`, `DAT_004e7e10`, and `DAT_004e7d50`, frees every resident bitmap through Frame_FreeBitmap_v129, and zeroes the table slots afterward.",
			"Those groups are populated by Frame_LoadWorldShellBitmapTables_v129 and reused by stacked stats dialogs, mech pages, message/compose windows, the location browser, and other world-shell subpanels. Combat_FreeVisualResourceTables_v129 calls this helper during broader frontend teardown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FreeBitmap_v129": {
		"family": "FrameBlit",
		"summary": "Frees a retail heap bitmap object and any decoded pixel/palette storage it owns.",
		"notes": [
			"Used by the file-loader error paths, the formatted-text inline asset path, combat bootstrap cleanup, and world map/data loading when temporary bitmap objects are no longer needed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_FreeBitmapOwnedBuffers_v129": {
		"family": "FrameBlit",
		"summary": "Frees the palette and pixel buffers owned by one retail bitmap object and clears both pointers.",
		"notes": [
			"Releases the optional block at offset `+0x18` and the earlier decoded buffer at offset `+0x0C`, then zeroes both fields so the parent bitmap header can be safely freed afterward.",
			"Frame_FreeBitmap_v129 delegates to this helper before releasing the outer bitmap object itself.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_FreeLoadedBitmapBuffer_v129": {
		"family": "FrameBlit",
		"summary": "Frees one loaded bitmap-buffer descriptor and the owned heap blocks it carries.",
		"notes": [
			"Releases the primary payload pointer stored in the first field, frees the optional secondary block stored near offset `0x314` when present, and then releases the outer descriptor itself.",
			"Frame_FreeCachedBitmapBufferCache_v129 uses it when tearing down the shared 40-entry cache behind Frame_GetCachedBitmapBuffer_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_FreeCachedBitmapBufferCache_v129": {
		"family": "FrameBlit",
		"summary": "Frees the shared cached bitmap-buffer table populated by Frame_GetCachedBitmapBuffer_v129.",
		"notes": [
			"Walks the fixed 40-entry cache rooted at `DAT_0047f0f8`, frees every resident loaded bitmap buffer through Frame_FreeLoadedBitmapBuffer_v129, then releases the cache header itself and clears the global pointer.",
			"Combat_Cmd63_ResultSceneInit_v129 calls it during result-scene teardown so the archive-backed bitmap-buffer cache does not leak across combat sessions.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_ResolveInlineBitmapTag_v129": {
		"family": "FrameBlit",
		"summary": "Resolves a retail inline bitmap token to either a preloaded shared bitmap or a newly loaded unit bitmap.",
		"notes": [
			"Recognizes house tokens such as HOU1-HOU5, the preloaded I### bitmap table, and fallback dynamic unit tags loaded through Frame_LoadUnitBitmapByTag_v129. Sets the out flag when the caller owns a freshly loaded bitmap and must free it after drawing.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_ShowCenteredArchiveBitmap_v129": {
		"family": "FrameBlit",
		"summary": "Loads a bitmap from a named retail archive, centers it on the active frame, presents it, and releases the temporary bitmap.",
		"notes": [
			"Used by the shell/result-scene flow to show full-screen or centered splash art from archives such as SCENES.DAT without keeping the bitmap resident after presentation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Frame_ClearActiveFrameAndPresent_v129": {
		"family": "FrameBlit",
		"summary": "Clears the active fullscreen frame to palette index 0 and immediately presents it to the display.",
		"notes": [
			"Builds a full-frame rectangle from the active shell frame, fills that backing rectangle through Frame_FillRect_v129, and then pushes the cleared frame to the display through Frame_PresentFrameRect_v129. Frame_ShowCenteredArchiveBitmap_v129 uses it as the fallback path when archive lookup or bitmap loading fails.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_ClearFrontendDisplayAndApplyCurrentPalette_v129": {
		"family": "ShellUI",
		"summary": "Clears the full frontend display to color 0 and reapplies the current frontend palette table.",
		"notes": [
			"Fills the retail 640x480 display rectangle through the low-level DirectDraw fill helper, then copies the active frontend palette block into the display palette. Used when frontend/title flows need to recover from a failed slideshow step or restore the baseline shell display after a temporary fullscreen sequence closes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_OpenTimedArchiveSlideshow_v129": {
		"family": "ShellUI",
		"summary": "Begins a timed fullscreen archive slideshow session from a tagged archive name and a delay/tag script string.",
		"notes": [
			"Stores the slideshow mode and script pointers, allocates a temporary 640x480 frame, opens the requested tagged archive, clears the palette state to black, arms the one-shot timer that feeds Shell_TickTimedArchiveSlideshow_v129, and hides the cursor while the slideshow owns the screen.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_CloseTimedArchiveSlideshow_v129": {
		"family": "ShellUI",
		"summary": "Stops the active timed archive slideshow, restores the frontend display, and clears the slideshow session globals.",
		"notes": [
			"Releases the temporary slideshow frame and archive handle, tears down the timer, stops any slideshow-owned audio cue through Shell_ControlFrontendSlideshowAudioCue_v129, restores the baseline frontend display through Shell_ClearFrontendDisplayAndApplyCurrentPalette_v129, shows the cursor again, and zeroes the stored slideshow session block.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_ShowTitleAndCreditsSequence_v129": {
		"family": "ShellUI",
		"summary": "Shows the retail title and credits bitmap sequence from TITLE.DAT.",
		"notes": [
			"Opens TITLE.DAT, displays the TITL card followed by the CRDT card when available, drives the shared frontend slideshow audio cue through Shell_ControlFrontendSlideshowAudioCue_v129, overlays the centered version banner from Shell_GetVersionString_v129 on the first card, presents each frame full-screen, and frees the temporary bitmap after each slide.",
			"After the title card it waits up to five seconds for a keypress through Shell_WaitForKeypressOrTimeout_v129, and after the credits card it reuses the same helper with the shorter four-second timeout before fading back to the shell.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_TickTimedArchiveSlideshow_v129": {
		"family": "ShellUI",
		"summary": "Advances one timed archive slideshow step, loads the next bitmap tag, presents it, and rearms the slideshow timer.",
		"notes": [
			"Parses the current script token as `<seconds> <tag>`, loads the referenced bitmap from the open archive, centers it in the temporary fullscreen frame, overlays the title caption on the first mode-1 slide, optionally starts the slideshow audio cue for mode 2 through Shell_ControlFrontendSlideshowAudioCue_v129, uploads the bitmap palette, then rearms the timer for the next delay. On exhaustion or failure it posts the completion message back to the main shell window.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Shell_ControlFrontendSlideshowAudioCue_v129": {
		"family": "ShellUI",
		"summary": "Starts, stops, or fades the shared frontend slideshow audio cue used by the title/credits sequence and slideshow mode 2.",
		"notes": [
			"Called by Shell_ShowTitleAndCreditsSequence_v129, Shell_TickTimedArchiveSlideshow_v129, and Shell_CloseTimedArchiveSlideshow_v129. Mode `0` starts the shared cue handle in `DAT_0047d008`, mode `1` stops it, and mode `2` ramps its active parameter downward before returning control to the caller.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Frame_CreateRootWindow_v129": {
		"family": "FrameWindow",
		"summary": "Clears the retail window-stack globals and creates the fullscreen root frame used as the compose/display anchor.",
		"notes": [
			"Resets the live window count, allocates a 640x480 root frame through Frame_CreateWindow_v129, installs the root-only keyboard callback, and refreshes the global root/active-frame pointers plus the cached compose-surface pointer derived from that frame.",
			"Shell_InitializeFrontendResourcesAndAudio_v129 calls it during frontend bootstrap, and Frame_ResetWindowStack_v129 reuses it after destroying transient windows when the retail shutdown flag is not set.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_CreateWindow_v129": {
		"family": "FrameWindow",
		"summary": "Allocates and initializes a retail frame/window with backing storage, callbacks, and optional inset text layout.",
		"notes": [
			"Registers the new frame in the global z-order array, zeroes its control state, stores the requested screen position and dimensions, allocates the backing rectangle metadata block, seeds the default input/render callbacks, and finishes by resetting the text-layout state. When the caller sets the final flag it also enables the standard shell text insets used by modal pages and slideshow windows.",
			"If the requested window is larger than the retail 80x24-style threshold, it also sets the fullscreen-stack flag later queried by Frame_FindTopFullscreenWindowInStack_v129 during active-window repair after fullscreen page teardown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_SetActiveFont_v129": {
		"family": "FrameText",
		"summary": "Stores the active bitmap-font descriptor on a retail frame and refreshes the font-derived row metrics that travel with it.",
		"notes": [
			"Writes the caller-supplied font descriptor into the frame text state, then synchronizes the cached text-row baseline and the default row pitch used by the shell's list-style text decorations.",
			"Frame_CreateWindow_v129 uses it during frame initialization, while World_Cmd45_ScrollListShell_v129 switches the shared scroll-list shell over to the alternate font descriptor before laying out the visible rows.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_ConfigureTextGridMetrics_v129": {
		"family": "FrameText",
		"summary": "Configures the active line height and derived text-grid metrics for a retail frame/window.",
		"notes": [
			"Stores the caller-supplied line height in the frame's text-layout state, derives the matching wrapped-column and visible-row counts from the frame dimensions, and updates the related cached limits used by the text writer and scroll helper.",
			"Combat HUD panels plus many world shell list/dialog windows call it immediately after Frame_CreateWindow_v129 so later formatted-text and decoration helpers share consistent monospace grid metrics.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FindTopWindowAtPoint_v129": {
		"family": "FrameWindow",
		"summary": "Returns the topmost retail frame/window whose screen rectangle contains the supplied display coordinates.",
		"notes": [
			"Walks the live window-stack array from topmost to bottommost and returns the first frame whose on-screen bounds contain the requested point.",
			"Frame_DispatchMouseEventToWindowStack_v129 uses it as the shared pointer hit-test entry before applying modal-window and focused-control rules.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FindWindowStackIndex_v129": {
		"family": "FrameWindow",
		"summary": "Returns the current z-order index of a retail frame/window in the global window stack, or -1 when absent.",
		"notes": [
			"Performs the linear scan over the global frame pointer array shared by the generic redraw and destroy helpers. The retail windowing layer uses it to locate the first composited window and to remove windows from the stack without keeping a back-pointer index on each object.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_RedrawWindowStackFrom_v129": {
		"family": "FrameWindow",
		"summary": "Recomposites visible retail windows starting at a given frame and presents the affected screen region.",
		"notes": [
			"Finds the supplied frame's index in the global window stack, copies each visible backing surface from that point upward into the shared full-screen compose buffer, and then either presents the caller's rectangle or refreshes the full display when the frame is marked fullscreen. Title/credits, timed slideshow, world menus, and wrapped-text editors all route their display refresh through this helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_ResetWindowStack_v129": {
		"family": "FrameWindow",
		"summary": "Destroys every live retail frame/window in the stack and recreates the root frame unless full shutdown is active.",
		"notes": [
			"Walks the global frame array, releases each frame's backing rectangle, owned auxiliary buffers, and heap object, then clears the stored stack slots.",
			"When the frontend shutdown flag is not set it finishes by rebuilding the fullscreen root frame through Frame_CreateRootWindow_v129 so later shell flows still have a valid compose/display anchor.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_ResetRootWindowTextLayout_v129": {
		"family": "FrameWindow",
		"summary": "Clears the root frame's registered text-decoration state and restores its default text layout.",
		"notes": [
			"Targets the shared fullscreen root frame, zeroes its decoration/control counts and related root-only layout flags, then delegates to Frame_ResetTextLayoutState_v129 so the root surface returns to the retail default text box state.",
			"World_TeardownRootUiWindows_v129 uses it as the fallback cleanup path when no active world-root window tree is present but the shared shell compose frame still needs to be reset.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DestroyWindow_v129": {
		"family": "FrameWindow",
		"summary": "Destroys a retail frame/window, recursively releasing child frames, backing storage, and active-window state.",
		"notes": [
			"Removes the frame from the global z-order array, recursively tears down any owned child window tree, frees linked UI-control blocks and auxiliary buffers, repairs the active/focused window globals, and finally releases the frame object itself. It is the shared close path beneath stacked shell windows, slideshow teardown, and many world-dialog cleanup callbacks.",
			"After removing the target, it can fall back through Frame_FindTopFullscreenWindowInStack_v129 so fullscreen/root-style pages reclaim focus instead of leaving a smaller inset shell window active when the current replacement target still requests fullscreen redraw semantics.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FindTopFullscreenWindowInStack_v129": {
		"family": "FrameWindow",
		"summary": "Returns the topmost retail frame/window in the live stack whose fullscreen flag is set.",
		"notes": [
			"Scans the current z-order array from bottom to top and keeps the last window whose flag word at `+0x48` contains bit `4`, yielding the topmost fullscreen-capable frame currently present in the stack.",
			"Frame_CreateWindow_v129 sets that bit for the large/full-display windows, and Frame_DestroyWindow_v129 uses this helper when repairing the active-window pointer after one of those fullscreen-style pages closes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_ActivateWindow_v129": {
		"family": "FrameWindow",
		"summary": "Moves a retail frame/window to the top of the z-order stack, marks it active, and redraws the affected display region.",
		"notes": [
			"When stacked-shell state is active it first keeps the window's stored parent/owner frame immediately beneath it in the global stack, then shifts the target window itself to the stack tail, updates the active-frame global, and redraws either from that window or from the root frame depending on the fullscreen flag. World location-browser, transient-notice, and auxiliary shell overlays use this helper whenever focus needs to move to an existing window.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_ActivateTopWindowExcept_v129": {
		"family": "FrameWindow",
		"summary": "Chooses the highest-priority retail frame/window other than one excluded target and activates that replacement window.",
		"notes": [
			"Scans the live window stack for the remaining frame with the greatest priority field, stores that frame as the new active target, and then delegates to Frame_ActivateWindow_v129 for the actual z-order repair and redraw. Auxiliary comparison windows and transient-notice overlays use it when temporarily yielding focus back to the best underlying window.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_AllocateEditableTextBuffer_v129": {
		"family": "FrameText",
		"summary": "Allocates the backing editable text buffer for a retail frame and stores its maximum character capacity.",
		"notes": [
			"Allocates a heap string buffer sized for the requested character count plus terminator, stores that pointer in the frame edit-state block, and records the maximum editable length used by voice-transmission, compose-editor, hotkey, and modal-text entry flows.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_AllocateSelectionValueTable_v129": {
		"family": "FrameWindow",
		"summary": "Allocates the per-entry integer value table used by retail selection dialogs and related frame menus.",
		"notes": [
			"Reserves a `count * 4` heap buffer, stores the resulting pointer in the frame's dialog-state block, and records the entry count alongside it. World menu dialogs, numbered selection lists, triple-string lists, and compose-editor flows use this table to map visible rows back to command ids or attached selection values.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FlashHotkeyControl_v129": {
		"family": "FrameControl",
		"summary": "Briefly flashes the retail control bound to a normalized hotkey, showing its pressed state before restoring the normal artwork.",
		"notes": [
			"Scans the frame's registered controls for the supplied hotkey, draws the control's pressed or active visual according to its decoration type, waits for the short retail key-click delay, and then restores the control's default appearance. Message, compose, travel-compass, and transient-notice key handlers use it before dispatching the logical action.",
			"For decoration type `0`, it toggles the pressed-state look by calling Frame_InvertTextDecorationPaletteByIndex_v129 before and after the short delay instead of drawing alternate bitmap or bevel assets.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Frame_InvertTextDecorationPaletteByIndex_v129": {
		"family": "FrameControl",
		"summary": "Inverts the palette indices inside one type-0 text-decoration rect, producing the retail pressed/flash visual for plain text controls.",
		"notes": [
			"Looks up the decoration rectangle plus its stored fill width from the frame's registered text-decoration table, then swaps palette indices `0xd7` and `0x00` across that rect through Frame_SwapPaletteIndicesInRect_v129.",
			"Frame_DefaultTextDecorationPointerHandler_v129 uses it when a type-0 decoration is pressed or released with the mouse, and Frame_FlashHotkeyControl_v129 reuses the same helper to flash those controls for keyboard hotkeys.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_SetTextDecorationTextByIndex_v129": {
		"family": "FrameControl",
		"summary": "Copies one string into a registered text-decoration entry and expands the decoration width to fit the measured label text.",
		"notes": [
			"Stores the supplied string into the decoration record payload at offset `+0x26`, measures its rendered width with Frame_MeasureStringWidth_v129, and extends the decoration's right edge when the current width is too small.",
			"When the incoming string is empty, it still enforces the retail fallback minimum width of `0x20` pixels. The currently known unnamed caller uses it while assembling shell-style text-decoration controls with dynamic captions.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DispatchNormalizedKeyToActiveWindow_v129": {
		"family": "FrameControl",
		"summary": "Dispatches a normalized key to the active retail window callback, flashing any bound hotkey control first.",
		"notes": [
			"Checks the active frame global for a registered key handler, triggers Frame_FlashHotkeyControl_v129 so the matching control renders its pressed state, and then invokes the frame's normalized-key callback with the same key code. World message views, numbered menus, hotkey selection, and other stacked shell windows share this wrapper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Frame_TranslateKeyMessageToNormalizedKey_v129": {
		"family": "FrameControl",
		"summary": "Translates a packed retail key message into the normalized key code used by frame callbacks and text-entry handling.",
		"notes": [
			"Consumes the retail key-message scancode/flag packing, updates the cached modifier state through Frame_UpdateModifierKeyState_v129, maps Shift/Ctrl/Alt variants through the retail translation tables, and suppresses disallowed repeats before returning the normalized key id. The helper is the keyboard-side counterpart to Frame_DispatchMouseEventToWindowStack_v129 for shared shell/combat input dispatch.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_UpdateModifierKeyState_v129": {
		"family": "FrameControl",
		"summary": "Updates the cached retail modifier-key state from Shift/Ctrl/Alt make-break scan codes.",
		"notes": [
			"Recognizes the left/right Shift, Ctrl, and Alt scan codes in the incoming retail key message stream, updates their bitfields in `DAT_004e4f64`, and returns zero for those pure modifier events so higher-level key translation can stop early.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_HandleCtrlShiftDebugToggleChord_v129": {
		"family": "FrameControl",
		"summary": "Handles the retail Ctrl+Shift debug chords that arm the FPS overlay and capture-log toggles.",
		"notes": [
			"Only acts while both Ctrl and Shift are held. Maps `X` to the framerate-overlay bit and `.` to the capture-log toggle bit inside `DAT_004e4f68`, returning nonzero when one of those debug chords was consumed so Frame_TranslateKeyMessageToNormalizedKey_v129 can suppress normal key dispatch.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DispatchMouseEventToWindowStack_v129": {
		"family": "FrameControl",
		"summary": "Hit-tests the retail window stack at a mouse position and dispatches the resulting mouse event into the selected frame/control callback.",
		"notes": [
			"Finds the target frame under the supplied screen coordinates, enforces the retail modal and stacked-window rules, tracks the current pressed control in `DAT_0047d4f8`, and routes mouse-down, release, and drag-style events into the frame's registered callbacks. Shell menus and combat overlays share this helper for generic pointer input, with a small combat-state special case that can translate certain mouse events into Combat_HandlePresentationHotkey_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DefaultTextDecorationPointerHandler_v129": {
		"family": "FrameControl",
		"summary": "Shared default mouse handler for retail frames that use registered text-decoration controls.",
		"notes": [
			"Hit-tests the frame's enabled decoration table, tracks the currently pressed decoration index, updates each supported control type's pressed/released artwork in place, and forwards completed releases into the frame's registered action dispatcher callback.",
			"Type-0 controls use Frame_InvertTextDecorationPaletteByIndex_v129 for their reversible pressed-state feedback, while the other supported decoration kinds redraw their bevel, bitmap, or palette-swap visuals directly.",
			"Frame_CreateWindow_v129 installs it as the default pointer callback, and world paged lists, scroll-list shells, travel-compass buttons, and other shell pages reuse it unless they replace the frame-local mouse handler with a custom implementation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DispatchTextDecorationActionById_v129": {
		"family": "FrameControl",
		"summary": "Dispatches a released text-decoration/control id into the frame's primary or alternate action callback.",
		"notes": [
			"On release, reads the registered decoration id from the selected entry and forwards it into either the primary action callback slot at `+0x1430` or the alternate slot at `+0x1438`, depending on the current retail pointer-mode state.",
			"Frame_CreateWindow_v129 installs it as the default decoration-action callback, while World_TravelCompassPage_HandleMouse_v129 also calls it directly for the older button strip path before applying its cursor-side effects.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_SeedEditableTextBuffer_v129": {
		"family": "FrameText",
		"summary": "Draws an initial formatted string into a retail edit field and copies that same text into the frame's editable buffer state.",
		"notes": [
			"Used when a text-entry window opens with prefilled content. It renders the supplied text through Frame_DrawFormattedText_v129, copies the string into the previously allocated edit buffer, and stores both the current text length and the matching cursor position.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
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
	"Frame_EncodeMaskedSpanRuns_v129": {
		"family": "FrameBlit",
		"summary": "Encodes a bitmap-sized mask surface into the packed `(mask_word, run_length)` stream consumed by Frame_CompositeMaskedSpanRuns_v129.",
		"notes": [
			"When the output pointer is null it only counts how many dwords the encoded stream will require; otherwise it emits the per-row run pairs and a trailing `(0, 0)` terminator after collapsing adjacent equal mask words.",
			"Combat_LoadVisualResourceTables_v129 uses it twice on the temporary bitmap blitted into `DAT_004e7a40`: first to size the heap allocation for `DAT_004e7e30`, then again to write the final masked span-run table later consumed by the tactical radar and actor preview overlays.",
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
	"Frame_LoadBitmapFontDescriptor_v129": {
		"family": "FrameText",
		"summary": "Loads a retail TFONT data file into a font descriptor and precomputes the printable glyph advances.",
		"notes": [
			"Allocates the `0x84`-byte descriptor through System_AllocateHeapBlock_v129, loads the raw TFONT blob from disk through System_LoadFileIntoBuffer_v129, and then calls Frame_InitializeBitmapFontDescriptorAdvances_v129 so the printable `0x20`-`0x7e` glyph widths are cached beside the loaded font data.",
			"Shell_InitializeFrontendResourcesAndAudio_v129 uses it for TFONT1, while Combat_InitializeVisualResourcesAndHudState_v129 and Combat_Cmd63_ResultSceneInit_v129 swap in TFONT2 or the result-scene TFONT1 variant before rebuilding combat/world text surfaces.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_InitializeBitmapFontDescriptorAdvances_v129": {
		"family": "FrameText",
		"summary": "Builds the cached printable glyph-advance table for a loaded retail bitmap font descriptor.",
		"notes": [
			"Seeds the descriptor's advance cache with the retail default width marker and then walks the printable ASCII range, reading each glyph's stored advance from the raw TFONT blob so later text measurement and drawing paths can use constant-time lookups.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FreeBitmapFontDescriptor_v129": {
		"family": "FrameText",
		"summary": "Releases one retail bitmap font descriptor and its loaded TFONT data blob.",
		"notes": [
			"Frees the raw font blob referenced by the descriptor, clears the cached advance region, releases the descriptor itself, and nulls the caller-owned slot.",
			"Shell_ShutdownFrontendResourcesAndAudio_v129 plus the combat/result-scene font swap paths call it before loading replacement TFONT resources.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
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
	"Frame_LayoutAndDrawWrappedFormattedText_v129": {
		"family": "FrameText",
		"summary": "Wraps a formatted retail text string, accounts for inline asset markers, and either measures or draws the resulting lines.",
		"notes": [
			"When called with a frame pointer it uses the frame's current text layout bounds to word-wrap the incoming string, handles inline `[P....]` and `[R....]` asset markers, and emits each final line through the formatted-text writer paths. When called with a null frame it runs in measurement mode, returning the required line count and caching the widest rendered line width for callers that need to size message or notice windows first.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_SetTextCursorPixelPos_v129": {
		"family": "FrameText",
		"summary": "Moves the retail frame text cursor to a clamped pixel position and updates the derived column and row state.",
		"notes": [
			"Clamps the requested pixel coordinates to the 640x480 retail surface bounds, stores the pixel x-position directly, derives the text column from `x / 8`, and derives the text row from `y / line_height` using the frame's active line-height field. Modal editors, cached-entry dialogs, label strips, and menu builders use it before streaming text into a specific insertion point.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_ClearCurrentTextLine_v129": {
		"family": "FrameText",
		"summary": "Clears the current retail text line, resets the cursor x-position, and drops the latched line metadata.",
		"notes": [
			"Fills exactly one active text-row band of the frame surface using the current line index and the frame's active line height, then resets the current pixel x-position to column zero and clears the cached row metadata slot at `+0x1404`.",
			"Formatted shell text helpers use it before rewriting the current line so inline list metadata and other per-line state do not leak across redraws.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
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
	"Frame_DrawStringAt_v129": {
		"family": "FrameText",
		"summary": "Draws a retail string at a frame-local pixel position using a temporary text color and an optional font override.",
		"notes": [
			"Builds a temporary draw rectangle anchored to the target frame, switches the shared text color to the requested palette entry for the duration of the draw, chooses either the supplied font or the frame's default font, and then delegates to Frame_DrawString_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_DrawCenteredStringInWidth_v129": {
		"family": "FrameText",
		"summary": "Measures a retail string and draws it horizontally centered within a caller-supplied width at the current text row.",
		"notes": [
			"Uses the frame's active font to measure the glyph run, computes the centered x offset inside the supplied local width, derives the y position from the current text row and line height, and then delegates to Frame_DrawStringAt_v129 with the requested palette color.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
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
	"Frame_WriteCharAtCursorAndPresent_v129": {
		"family": "FrameText",
		"summary": "Writes one character at the current retail text cursor, presents the touched region immediately, and falls back to a full redraw on wrap and newline paths.",
		"notes": [
			"Fast-path printable characters draw a single glyph directly into the frame backing buffer, present only the affected rectangle, and update the current cursor width trackers. Newline, carriage-return, and last-column cases delegate to the lower line and column writer, apply scroll handling when enabled, and redraw the containing window stack before resetting the x cursor.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
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
	"Frame_ScrollClippedRectWithWrapOrFill_v129": {
		"family": "FramePrimitive",
		"summary": "Shifts a clipped frame rectangle by the requested delta, then either fills the exposed area with a solid byte or wraps in pixels from a source tile buffer.",
		"notes": [
			"In fill mode it reuses Frame_CopyOrFillClippedRect_v129 to move the surviving pixels and fills the newly exposed strips with the supplied palette byte; if the shift exceeds the rect dimensions it falls back to a full Frame_FillRect_v129.",
			"In wrap mode it treats the final argument as a source tile buffer, normalizes the deltas modulo the rect width and height, and repaints the nine translated neighbor regions to synthesize wrapped scrolling. Frame_ScrollTextViewportUpIfAtBottom_v129 uses the fill path for the retail text viewport scroll.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
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
	"Frame_ClearPaletteToBlack_v129": {
		"family": "FramePalette",
		"summary": "Sets every palette entry in the active frame palette table to black and uploads the full palette.",
		"notes": [
			"Loops over all 256 palette slots, writes zeroed RGB triplets through Frame_SetPaletteEntryRgb_v129, then pushes the full palette to the active palette object through Frame_UpdateFullPalette_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_ClearPaletteFadeTargetBuffer_v129": {
		"family": "FramePalette",
		"summary": "Zeroes the shared RGB palette-fade target buffer so the next retail fade interpolates toward black.",
		"notes": [
			"Clears the 64-dword scratch table at `DAT_004e7e90`, which the palette-fade helper at `FUN_004583a9` reads as a packed RGB destination buffer.",
			"Shell_OpenTimedArchiveSlideshow_v129, Shell_ShowTitleAndCreditsSequence_v129, and Combat_InitializeCombatHudAndControlState_v129 call it before black-palette transitions so later fades do not reuse stale RGB values from an earlier bitmap palette.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_PresentFrameRect_v129": {
		"family": "FrameBlit",
		"summary": "Presents a rectangle from a frame surface to the display at the requested screen coordinates.",
		"notes": [
			"Clips the requested source rectangle against the backing frame bounds, then chooses the retail DirectDraw blit path that copies the frame pixels into the display surface. Higher-level helpers such as Frame_BlitRelativeRect_v129 and Frame_DrawLineAndPresent_v129 normalize their rectangles first and then delegate to this primitive present path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_FillDisplayRect_v129": {
		"family": "FrameBlit",
		"summary": "Color-fills a rectangle on the active display surface with a palette index.",
		"notes": [
			"Wraps the retail DirectDraw color-fill call used by shell and fullscreen reset flows. Callers pass the display-space rectangle and the target palette index, most often `0` when clearing the entire visible surface.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_FillRect_v129": {
		"family": "FrameBlit",
		"summary": "Fills a clipped rectangle inside a frame's backing buffer with one palette index value.",
		"notes": [
			"Clamps the requested rectangle to the frame bounds, then writes the fill byte directly across each affected scanline in the backing pixel buffer. Many HUD, message, world-map, and fallback shell draw paths use it before presenting the affected region.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Frame_CopyBitmapPaletteToBuffer_v129": {
		"family": "FramePalette",
		"summary": "Copies a bitmap resource's palette into a caller-provided RGB triplet buffer.",
		"notes": [
			"Reads up to 256 palette entries from the bitmap palette block, converts the stored channels to the retail 0-63 RGB form, and writes the resulting triplets contiguously into the destination buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_ApplyBitmapPalette_v129": {
		"family": "FramePalette",
		"summary": "Copies a bitmap resource's palette into the active frame palette table and uploads the full palette.",
		"notes": [
			"Walks the bitmap palette block entry-by-entry, writes each converted RGB triplet into the shared frame palette table through Frame_SetPaletteEntryRgb_v129, and then commits all 256 palette slots with Frame_UpdateFullPalette_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_UpdateFullPalette_v129": {
		"family": "FramePalette",
		"summary": "Uploads the full 256-entry frame palette table to the active palette object.",
		"notes": [
			"Thin wrapper over Frame_UpdatePaletteRange_v129 that refreshes the entire palette table rather than a caller-selected subset.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_CaptureDisplayPaletteState_v129": {
		"family": "FramePalette",
		"summary": "Captures the current display palette state before shell dialogs or modal prompts disturb it.",
		"notes": [
			"Copies the working palette table into the backup buffer, queries the active palette object for the live 256-entry RGB block, retries once after restoring the DirectDraw palette owner when the first read reports the lost-surface error, and then clears the modal-palette latch bit `DAT_0047fdec`.",
			"Shell_ShowModalMessageBox_v129, Shell_OpenStatusTextDialog_v129, the shared CMP dialogs, and the exit confirmation path all reuse it so the frontend can restore the prior palette cleanly after the dialog closes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Shell_WaitForKeypressOrTimeout_v129": {
		"family": "ShellUI",
		"summary": "Pumps the Windows message queue until the deadline expires or the user presses a key.",
		"notes": [
			"Repeatedly peeks and removes pending Windows messages, returning `0` as soon as it sees a key-down message (`WM_KEYDOWN`) and returning `1` once `_time` advances past the caller-supplied absolute deadline.",
			"Shell_ShowTitleAndCreditsSequence_v129 uses it to let the title and credits cards advance early on any keypress while still honoring the retail fixed 5-second / 4-second delays when the user does nothing.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Frame_SetCursorScreenPos_v129": {
		"family": "FrameControl",
		"summary": "Moves the Windows cursor to an absolute screen-space position.",
		"notes": [
			"Thin wrapper over SetCursorPos. Combat_ProcessMouseUpperBodyAimInput_v129 uses it to warp the mouse back to the fixed `(320, 240)` aim origin after consuming the current-frame torso-yaw and pitch deltas.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_SetSavedCursorByMode_v129": {
		"family": "FrameControl",
		"summary": "Loads one stock cursor shape into the saved retail cursor slot and applies it when the cursor is visible.",
		"notes": [
			"Maps cursor mode `0` to the Win32 arrow cursor, mode `1` to the wait cursor, and the fallback mode to the stock `IDC_NO` cursor, then stores the resulting handle in `DAT_00498988`.",
			"If the cursor is currently visible (`DAT_00498984 != NULL`), it mirrors that handle into the active-cursor slot and calls SetCursor immediately so shell busy/normal transitions take effect without waiting for a later restore.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_InitializeSavedArrowCursor_v129": {
		"family": "FrameControl",
		"summary": "Initializes the retail saved/current cursor handles to the stock arrow cursor.",
		"notes": [
			"Loads the Win32 arrow cursor into both the saved cursor slot `DAT_00498988` and the active cursor slot `DAT_00498984`, then returns `1` so the shell bootstrap can latch that cursor resources are ready.",
			"Shell_InitializeFrontendResourcesAndAudio_v129 uses it during one-shot frontend initialization before any shell code switches between normal and wait cursor modes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_RestoreSavedCursor_v129": {
		"family": "FrameControl",
		"summary": "Restores the saved retail cursor handle as the active Windows cursor.",
		"notes": [
			"Copies the stored cursor handle from `DAT_00498988` into the current-cursor slot `DAT_00498984` and immediately applies it with SetCursor. The help path, redraw path, and a few combat mouse-state transitions reuse it when a temporary cursor override ends.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_HideCursor_v129": {
		"family": "FrameControl",
		"summary": "Clears the current retail cursor and hides the Windows cursor.",
		"notes": [
			"Zeros the active cursor slot `DAT_00498984` and calls SetCursor(NULL). Used by the byte-selection help launcher and a few redraw / combat mouse paths before another helper restores the stored cursor shape.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_CyclePaletteEntries_v129": {
		"family": "FramePalette",
		"summary": "Rotates a contiguous palette range at a fixed tick interval and uploads the updated entries.",
		"notes": [
			"Reads the current RGB triplets from the frame palette table, shifts the requested entry range by one slot, writes the rotated colors back, and then pushes the modified palette range to the active palette object.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_GetPaletteEntryRgb_v129": {
		"family": "FramePalette",
		"summary": "Reads one palette entry's RGB triplet from the frame palette table into a caller-provided buffer.",
		"notes": [
			"Loads the three byte components from the shared palette table and converts them from the retail shifted storage format into plain 0-63 RGB channel values.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_SetPaletteEntryRgb_v129": {
		"family": "FramePalette",
		"summary": "Writes one RGB triplet back into the frame palette table in the retail shifted storage format.",
		"notes": [
			"Stores the supplied RGB bytes into the shared palette table after shifting them back to the packed format used by the retail DirectDraw palette buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"Frame_UpdatePaletteRange_v129": {
		"family": "FramePalette",
		"summary": "Uploads a contiguous palette range from the frame palette table to the active palette object.",
		"notes": [
			"Submits the selected entry range to the active palette interface, retries once after the retail lost-surface recovery path if needed, and marks the frame palette as dirty so the updated colors present on the next draw.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
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
	"Frame_ReplacePaletteIndexInRect_v129": {
		"family": "FrameText",
		"summary": "Replaces one palette index with another throughout a frame-local rectangle without presenting it automatically.",
		"notes": [
			"Walks the raw frame-surface bytes inside the supplied rectangle and only rewrites pixels whose palette index matches the requested source value. Combat jump-fuel, heat, and movement HUD helpers use it as the cheaper one-way color remap primitive beneath their higher-level panel refresh logic.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
			"res://scenes/combat/combat.gd",
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
	"Frame_EncodeTransparentBitmapCommandStream_v129": {
		"family": "FrameBlit",
		"summary": "Scans a clipped 8-bit bitmap rect against a transparent key, computes the non-transparent bounds, and encodes the surviving rows into the retail transparent bitmap command stream.",
		"notes": [
			"When an output buffer is supplied it writes a small header containing the source rect size, destination origin, and tight non-transparent bounding box offsets before appending the row payload. With a null output pointer it still walks the image and returns the encoded size requirement.",
			"It delegates each bounded row to Frame_EncodeTransparentBitmapCommandRow_v129 after trimming leading and trailing fully transparent rows and columns.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_EncodeTransparentBitmapCommandRow_v129": {
		"family": "FrameBlit",
		"summary": "Encodes one bounded bitmap row into transparent-skip, literal-byte, and repeated-byte commands for the retail transparent bitmap stream.",
		"notes": [
			"Walks the current row from left to right, distinguishing transparent-key spans, literal mixed spans, and repeated-byte runs before delegating the actual opcode emission to Frame_EmitTransparentBitmapRunCommand_v129.",
			"Always terminates the row with the zero end-of-row marker after flushing any pending transparent skip.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_EmitTransparentBitmapRunCommand_v129": {
		"family": "FrameBlit",
		"summary": "Appends one command to the retail transparent bitmap row stream and updates the tracked horizontal bounds for the encoded image.",
		"notes": [
			"Mode `0` resets the row state, mode `1` emits literal bytes, mode `2` emits repeated-byte runs, mode `3` defers a transparent skip, and mode `4` writes the row terminator.",
			"The helper also supports size-only passes when the destination buffer is null, so the enclosing encoder can precompute the exact command-stream allocation size.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_ComputeTransparentBitmapCommandBounds_v129": {
		"family": "FrameBlit",
		"summary": "Walks one retail transparent bitmap command stream entry and reports the bounding rectangle it would touch at the requested origin.",
		"notes": [
			"Parses the same transparent-skip, literal-byte, repeated-byte, and end-of-row commands emitted by the retail transparent bitmap encoder, tracking the minimum and maximum x/y coordinates reached by the stream.",
			"Applies horizontal and vertical mirror flags from the final argument before storing the output rectangle, making it the natural bounds helper for flipped command-stream draws.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_BlitTransparentBitmapCommandClipped_v129": {
		"family": "FrameBlit",
		"summary": "Blits one retail transparent bitmap command-stream entry into the destination frame with clip-rectangle handling.",
		"notes": [
			"Consumes the transparent-skip, literal-byte, repeated-byte, and end-of-row commands emitted by the retail encoder while clipping both horizontally and vertically against the destination frame rectangle.",
			"When the target rect fully contains the command bounds it falls through to Frame_BlitTransparentBitmapCommandFast_v129 for the straight-line inner loop.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_BlitTransparentBitmapCommandFast_v129": {
		"family": "FrameBlit",
		"summary": "Blits one retail transparent bitmap command-stream entry without additional clipping checks.",
		"notes": [
			"Assumes the caller has already verified the destination rect fully contains the command entry and then streams the literal and repeated-byte runs directly into the frame buffer.",
			"Used as the unclipped fast path by Frame_BlitTransparentBitmapCommandClipped_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_BlitPaletteMappedTransparentBitmapCommandClipped_v129": {
		"family": "FrameBlit",
		"summary": "Blits one retail transparent bitmap command-stream entry into the destination frame after remapping each source palette index through the active lookup table, with clip handling.",
		"notes": [
			"Uses the same transparent command stream as the raw variant but translates every emitted byte through `DAT_00483658` before writing it to the destination frame buffer.",
			"When the target rect fully contains the command bounds it falls through to Frame_BlitPaletteMappedTransparentBitmapCommandFast_v129 for the unclipped inner loop.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_BlitPaletteMappedTransparentBitmapCommandFast_v129": {
		"family": "FrameBlit",
		"summary": "Blits one palette-mapped retail transparent bitmap command-stream entry without additional clipping checks.",
		"notes": [
			"Assumes the caller has already verified the destination rect fully contains the command entry and emits the translated bytes directly into the frame buffer using the active palette lookup table.",
			"Used as the unclipped fast path by Frame_BlitPaletteMappedTransparentBitmapCommandClipped_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_BlitTransformedTransparentBitmapCommand_v129": {
		"family": "FrameBlit",
		"summary": "Blits one retail transparent bitmap command-stream entry through the transformed draw path, supporting rotation, independent x/y scale, and optional palette remapping.",
		"notes": [
			"When the angle is zero and both scales are `0x10000`, it falls straight through to either Frame_BlitTransparentBitmapCommandClipped_v129 or Frame_BlitPaletteMappedTransparentBitmapCommandClipped_v129.",
			"Otherwise it sizes a scratch surface from Frame_GetTransparentBitmapCommandSize_v129, derives the command origin from Frame_GetTransparentBitmapCommandOrigin_v129, optionally seeds that scratch surface from the indexed command entry, transforms the four command corners with Frame_TransformPointAroundPivotByAngleAndScale_v129, and scan-converts the resulting quadrilateral back into the destination frame.",
			"Flag bit `0` selects the palette-mapped source path; flag bit `1` skips rebuilding the scratch surface and reuses the caller-supplied scratch pixels.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_GetTransparentBitmapCommandSize_v129": {
		"family": "FrameBlit",
		"summary": "Returns the inclusive width and height of one retail transparent bitmap command-stream entry.",
		"notes": [
			"Reads the stored left/top/right/bottom bounds from the indexed command entry and converts them into `(width,height)` by subtracting the min coordinates and adding one.",
			"The transformed transparent-command wrapper uses it to size the temporary intermediate buffer that receives the unrotated command entry before the final transformed draw.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_GetTransparentBitmapCommandOrigin_v129": {
		"family": "FrameBlit",
		"summary": "Returns the stored top-left origin of one retail transparent bitmap command-stream entry.",
		"notes": [
			"Fetches the entry's stored left and top coordinates as a packed `(x,y)` pair without applying any mirroring or destination offset.",
			"The transformed transparent-command wrapper uses it as the pivot/origin when it builds the intermediate source surface for later rotation and scaling.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_TransformPointAroundPivotByAngleAndScale_v129": {
		"family": "FrameBlit",
		"summary": "Rotates and non-uniformly scales one point around a pivot using the retail fixed-angle lookup tables.",
		"notes": [
			"Treats the input point as an offset from the supplied pivot, applies independent x and y fixed-point scales, rotates the result with the cosine/sine pair from Frame_GetFixedCosSinByAngle_v129, then adds the pivot back.",
			"The transformed transparent-command wrapper calls it for each source corner while building the destination quadrilateral that bounds the rotated bitmap.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_GetFixedCosSinByAngle_v129": {
		"family": "FrameBlit",
		"summary": "Returns the retail fixed-point cosine and sine for an angle normalized into the renderer's 0xE10-step circle.",
		"notes": [
			"Normalizes the signed angle into the renderer's full turn and then reflects into the appropriate quadrant while reading the shared lookup tables.",
			"Important output order: the first out-parameter receives cosine and the second receives sine.",
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
	"Frame_NormalizeRect_v129": {
		"family": "FramePrimitive",
		"summary": "Normalizes an in-place retail rectangle so left<=right and top<=bottom.",
		"notes": [
			"Swaps the horizontal endpoints when the incoming right edge is left of the left edge, then performs the same correction for the vertical endpoints.",
			"Frame_DrawLineAndPresent_v129, Frame_InvertRectPixels_v129, and several world/combat redraw helpers call it before presenting or clipping a touched rectangle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawRectOutline_v129": {
		"family": "FramePrimitive",
		"summary": "Draws a one-pixel rectangle outline by emitting the four edge line segments.",
		"notes": [
			"Calls the low-level line drawer four times to cover the left, bottom, right, and top edges of the requested rectangle without filling its interior.",
			"Frame_DrawFilledBoxOrBitmapDecoration_v129 reuses it for the simple retail boxed-decoration style after filling the control interior.",
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
			"Normalizes the touched line rectangle through Frame_NormalizeRect_v129 after drawing the segment, then presents only that minimal updated region.",
			"Used by the world connector overlay commands and the immediate bevel helper when retail wants the line update shown right away rather than batched with a later blit.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_InvertRectPixels_v129": {
		"family": "FramePrimitive",
		"summary": "Bit-inverts every pixel in a frame-local rectangle and optionally presents the touched region afterward.",
		"notes": [
			"Walks the target pixel span row by row inside the frame backing buffer, replacing each byte with its bitwise inverse.",
			"When the final flag is nonzero, it normalizes the updated rectangle through Frame_NormalizeRect_v129 and presents the result immediately. World_DrawLocationBrowserSelectionMarker_v129 uses that path for the grouped-browser selection highlight.",
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
			"For type-3 decorations it fills the local decoration box, outlines it through Frame_DrawRectOutline_v129, and optionally adds crossing diagonal strokes; for type-8 decorations it chooses one of two bitmap resources and draws it into the decoration bounds.",
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
			"Reuses the shared Frame_AllocateRasterMaskBuffer_v129 / Frame_FreeRasterMaskBuffer_v129 scratch buffer pair, growing the cached square mask whenever the requested radius exceeds the previously allocated size.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_AllocateRasterMaskBuffer_v129": {
		"family": "FramePrimitive",
		"summary": "Allocates a zeroed byte-mask raster plus the small width/height bookkeeping header used by the filled-sector renderer.",
		"notes": [
			"Called by Frame_DrawFilledCircleSector_v129 to create the reusable square scratch surface sized to `(diameter + 1) x (diameter + 1)` bytes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_FreeRasterMaskBuffer_v129": {
		"family": "FramePrimitive",
		"summary": "Releases the scratch raster-mask buffer allocated for filled circle-sector rendering.",
		"notes": [
			"Only reached when Frame_DrawFilledCircleSector_v129 needs to replace its cached scratch surface with a larger square mask.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DrawEllipseOutline_v129": {
		"family": "FramePrimitive",
		"summary": "Draws an ellipse outline centered at the requested point using the supplied radii and palette index.",
		"notes": [
			"Uses the midpoint-ellipse stepping logic to plot the four symmetric edge points, clipping each pixel against the frame bounds before writing the destination palette value.",
			"When either radius is zero it falls back to the shared line helper, and the tactical radar reuses it for the small circular heading/marker outlines around the center panel.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/ui/combat_radar.gd",
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_CopyOrFillClippedRect_v129": {
		"family": "FramePrimitive",
		"summary": "Copies a clipped rectangle from a raw source pixel buffer into a destination frame rectangle, or fills that clipped region with a solid palette index.",
		"notes": [
			"Treats both source and destination as 8-bit pixel planes with inclusive clip bounds, intersects the translated source and destination rectangles, and then either copies each row or emits a repeated palette byte depending on the final selector argument.",
			"Used by HUD/world redraw helpers for opaque bitmap-region copies, and by Frame_ScrollTextViewportUpIfAtBottom_v129 as the low-level primitive behind its wrapped viewport scroll refresh.",
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
	"Frame_RegisterTextDecoration_v129": {
		"family": "FrameText",
		"summary": "Appends one typed decoration/control entry to a retail frame and initializes the stored rectangle, id, and payload fields.",
		"notes": [
			"Allocates the next `0x4e`-byte decoration slot in the frame-local table, stores the caller-supplied type/id/geometry, copies any inline label text, seeds the default palette/style fields for the supported decoration classes, and immediately draws the entry type when its registration path renders in-place.",
			"Retail combat HUD builders, world dialog/menu pages, transient notices, and the paged mech-list shell all use it as the common registration helper before later bitmap-pair or bevel-palette tweaks are applied to the created entry.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_SetTextDecorationBevelPalettePairByIndex_v129": {
		"family": "FrameText",
		"summary": "Stores the two bevel palette indices used by one registered border-style text decoration.",
		"notes": [
			"Writes the caller-supplied highlight and shadow palette indices into the decoration record fields consumed by Frame_DrawBeveledBorderDecoration_v129.",
			"World_OpenPagedMechListWindow_v129 uses it to recolor the four slot border decorations from the generic registration defaults before those entries are later flashed or disabled.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_EnableTextDecorationByIndex_v129": {
		"family": "FrameText",
		"summary": "Marks one registered text-decoration/control entry as enabled for hit-testing and interaction.",
		"notes": [
			"Sets the entry's enabled flag at the selected decoration-table slot without redrawing the control immediately.",
			"Retail combat HUD toggles, weapon slot grids, the travel-compass root page, and the paged mech-list redraw path use it to re-enable controls after mode changes or row availability updates.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_DisableTextDecorationByIndex_v129": {
		"family": "FrameText",
		"summary": "Marks one registered text-decoration/control entry as disabled so pointer hit-testing skips it.",
		"notes": [
			"Clears the same decoration enabled flag used by the hit-test and default pointer helpers, leaving the stored decoration geometry and artwork intact until a later redraw changes the visuals.",
			"Retail uses it to suppress inactive HUD toggles, unavailable paged mech-list arrows or rows, and travel-compass buttons whose mode-dependent action should not currently fire.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_SetTextDecorationBitmapPairByIndex_v129": {
		"family": "FrameText",
		"summary": "Stores the two bitmap resources used by one registered text-decoration/control entry and redraws that entry.",
		"notes": [
			"Writes the caller-supplied bitmap pair into the decoration record at the selected `0x4e`-byte entry offset, then immediately re-renders that decoration through Frame_DrawTextDecorationByIndex_v129.",
			"Retail uses it to assign the normal/active artwork for shell buttons, paged-list arrows, combat HUD controls, transient notices, and related text-decoration based widgets after creating them with the generic registration helper.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_SetTextDecorationToggleStateByIndex_v129": {
		"family": "FrameText",
		"summary": "Updates the checked or active state of one toggle-style text-decoration/control entry and redraws it in place.",
		"notes": [
			"Handles the two stateful decoration types used by the retail shell toggle widgets: the boxed checkmark entry and the paired-bitmap toggle entry. It writes the new state into the selected decoration record and then re-renders that one entry through Frame_DrawTextDecorationByIndex_v129.",
			"World_Cmd42_BitmaskSelectionList_v129 uses it to seed each checkbox from the incoming server bitmask, and World_BitmaskSelectionList_HandleInput_v129 reuses it whenever the player toggles a numbered row hotkey.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/mech/mech_select.gd",
		],
	},
	"Frame_IsTextDecorationToggleStateSetByIndex_v129": {
		"family": "FrameText",
		"summary": "Returns whether one toggle-style text-decoration/control entry is currently set.",
		"notes": [
			"Reads back the state fields for the two retail toggle decoration types: the boxed checkmark entry and the paired-bitmap toggle entry. Other decoration kinds report false so non-toggle widgets never contribute to checkbox bitmasks.",
			"World_BitmaskSelectionList_HandleInput_v129 uses it both when rebuilding the outgoing bitmask on Enter and when inverting one numbered checkbox row before the redraw pass.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
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
	"Frame_FindEnabledTextDecorationAtPoint_v129": {
		"family": "FrameText",
		"summary": "Returns the first enabled registered text-decoration/control entry whose rectangle contains the supplied frame-local point.",
		"notes": [
			"Scans the frame's decoration table from index 0 upward and requires both the entry-visible bit and the enabled bit before accepting a rectangle hit.",
			"Used by the default decoration pointer handler plus several custom world-shell mouse handlers that need to map a local pointer position back to the clicked control index.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
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
	"World_CloseLocationBrowserWindows_v129": {
		"family": "WorldUI",
		"summary": "Closes the active location-browser map window pair and clears the browser-open world-shell flag.",
		"notes": [
			"Destroys both cached location-browser windows, including the auxiliary shell tracked in `DAT_004e8838`, then clears world-shell flag `0x10` so later world pages know the browser overlay is no longer active.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_DrawLocationBrowserWindow_v129": {
		"family": "WorldUI",
		"summary": "Draws the standard location-browser map window, marker overlay, and compact selection-detail shell.",
		"notes": [
			"Paints the fixed browser chrome and current map bitmap, overlays the non-grouped room markers, creates the compact auxiliary detail window, redraws the current selection details, and writes the standard three button labels plus optional distance/scale readouts used by Cmd40.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_DrawGroupedLocationBrowserWindow_v129": {
		"family": "WorldUI",
		"summary": "Draws the grouped location-browser map window and its tall aggregated selection-detail shell.",
		"notes": [
			"Used by Cmd43's grouped browser mode: paints the alternate map layout, creates the taller auxiliary detail shell, redraws the currently selected grouped location entry, and writes the reduced two-button footer used by the grouped view.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_DrawLocationBrowserSelectionMarker_v129": {
		"family": "WorldUI",
		"summary": "Draws the current location-browser selection marker in either the standard map or grouped-browser mode.",
		"notes": [
			"In the standard map browser it draws the small retail marker around the selected room coordinate. In grouped mode it instead inverts the selected aggregate marker region through Frame_InvertRectPixels_v129 and updates the grouped selection-state flag that the shared browser highlight callback reuses.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_UpdateGroupedLocationBrowserSubmitControlState_v129": {
		"family": "WorldUI",
		"summary": "Updates the grouped location-browser submit control palette state when the current selection becomes submit-disabled or submit-enabled.",
		"notes": [
			"Reuses the cached grouped-browser flag in `DAT_0047ee10`, which is seeded from whether the current grouped selection is still one of the aggregate/non-submittable entries, and only swaps the submit control rectangle when that state changes.",
			"World_DrawLocationBrowserSelectionMarker_v129 calls it after redrawing the grouped marker so the footer submit control stays visually synchronized with the same flag that World_GroupedLocationBrowser_HandleMouse_v129 and World_LocationBrowser_HandleInput_v129 use to reject Enter/click submits.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_LocationBrowser_HandleMouse_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the shared location-browser map window.",
		"notes": [
			"Handles the three fixed bottom controls, opens the district-scoped side list on the middle control, submits or cancels through World_SendLegacySelectionResponse_v129 on the other two controls, and otherwise retargets the selected map room to the nearest location point before redrawing the shared browser highlight callback.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_GroupedLocationBrowser_HandleMouse_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the grouped location-browser map window used by Cmd43.",
		"notes": [
			"Handles the grouped browser's two footer controls for submit/cancel, otherwise retargets the selected grouped location entry from pointer hits on the map markers and redraws the current grouped selection details when the highlighted room changes.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_IsPointerInGroupedLocationBrowserMarkerBounds_v129": {
		"family": "WorldUI",
		"summary": "Hit-tests one grouped location-browser marker rectangle against the current pointer position.",
		"notes": [
			"Takes the pointer coordinates plus the marker rectangle origin and extents decoded from one grouped browser record, then returns whether the pointer falls inside the inclusive marker bounds.",
			"World_GroupedLocationBrowser_HandleMouse_v129 uses it while scanning the grouped location table so pointer motion and clicks can retarget the highlighted grouped room entry without reopening the footer-control path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_LocationBrowser_HandleInput_v129": {
		"family": "WorldUI",
		"summary": "Keyboard and hotkey handler for the shared location-browser map window.",
		"notes": [
			"Escape and `c` cancel through World_SendLegacySelectionResponse_v129, Enter and `t` submit the current room, `p` opens the district-scoped side list in ungrouped mode, and the four directional retail navigation keys retarget the selected room via the nearest-neighbor helper before the browser highlight is redrawn.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_FindNearestLocationBrowserRoomInDirection_v129": {
		"family": "WorldUI",
		"summary": "Finds the nearest selectable location-browser room in the requested directional cone.",
		"notes": [
			"Walks the active location-browser room table, skips the current room plus the grouped aggregate range, applies the retail up/down/left/right cone tests, and returns the closest matching room index for keyboard navigation.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_OpenLocationBrowserDistrictListWindow_v129": {
		"family": "WorldUI",
		"summary": "Opens the style-7 district-scoped location list window for the currently selected browser room.",
		"notes": [
			"Filters the shared location-browser room table by the current room's district byte, builds one text row per matching room into a stacked shell window, installs the district-list selection-highlight and mouse callbacks, and appends the retail close plus `s` action buttons under the list.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_RedrawLocationBrowserSelectionDetails_v129": {
		"family": "WorldUI",
		"summary": "Redraws the currently selected location-browser room details into the main map shell and auxiliary detail window.",
		"notes": [
			"Refreshes the district/house art, centered room title, optional grouped-mode fields, descriptive text block, and distance/status strings for the room currently selected by the location-browser map callbacks.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_ComputeLocationBrowserSelectionDistance_v129": {
		"family": "WorldUI",
		"summary": "Computes the scaled map distance from the current browser origin to the selected location entry.",
		"notes": [
			"Subtracts the selected room's map coordinates from the current browser origin, runs the planar delta through System_IntegerSquareRoot_v129, and then scales the result by the active distance multiplier `DAT_0048f590`.",
			"World_DrawLocationBrowserWindow_v129 and World_RedrawLocationBrowserSelectionDetails_v129 both call it before formatting the numeric distance readout shown beside the fixed location-browser labels.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_FormatLocationBrowserSelectionDistanceString_v129": {
		"family": "WorldUI",
		"summary": "Formats the currently selected room's distance string for the location-browser detail panel.",
		"notes": [
			"Formats the per-room distance field into the shared browser detail buffer, using the retail grouped-browser wording when grouped mode is active and the legacy thousand-separated world-distance wording for large standard values.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_FormatLocationBrowserDistanceScaleString_v129": {
		"family": "WorldUI",
		"summary": "Formats the current location-browser distance scale string shown above the selection details.",
		"notes": [
			"Expands the shared distance-scale value latched by World_Cmd44_SetLocationDistanceScale_v129 into the retail short, thousands, or millions string forms before the browser window prints it beside the fixed scale label.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_LocationBrowserDistrictList_UpdateSelectionHighlight_v129": {
		"family": "WorldUI",
		"summary": "Clears or redraws the currently selected row highlight in the district-scoped location list window.",
		"notes": [
			"Acts as the district-list callback stored at window field `0x508`: mode `0` clears the previously latched row highlight, and mode `1` redraws the row selected by `DAT_0048f508` and updates the window's latched row field.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_LocationBrowserDistrictList_HandleMouse_v129": {
		"family": "WorldUI",
		"summary": "Pointer handler for the district-scoped location list window opened from the browser and travel pages.",
		"notes": [
			"Tracks hover and click state across the generated district rows, updates the highlighted row through World_LocationBrowserDistrictList_UpdateSelectionHighlight_v129, and invokes the stored row action callback when the user releases on an active action row.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_CloseLocationBrowserDistrictListWindow_v129": {
		"family": "WorldUI",
		"summary": "Closes the district-scoped location list window and, when needed, tears down the paired location-browser windows.",
		"notes": [
			"Destroys the cached district-list shell when it is open, clears the district-list active flag, and when the world-shell browser-open bit remains set it also tears down the main location-browser window pair through World_CloseLocationBrowserWindows_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_LoadLocationLabelBitmap_v129": {
		"family": "WorldUI",
		"summary": "Rebuilds the current location-browser label bitmap from the active label code.",
		"notes": [
			"Formats the current shared browser label code into the retail bitmap tag string, applying the legacy 1000-offset adjustment for the lower code range, then reloads the cached label bitmap resource.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_ResetLocationLabelBitmapCache_v129": {
		"family": "WorldUI",
		"summary": "Clears the cached location-label bitmap pointer and invalidates the last latched label code.",
		"notes": [
			"Used during shell/world resets so the next World_Cmd47_SetLocationLabelCode_v129 refresh rebuilds the location label art instead of reusing stale bitmap state.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
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
	"World_FreeLocationMapDataBlock_v129": {
		"family": "WorldMap",
		"summary": "Frees one heap-owned location-map data block, including its room-table strings and decoded bitmap.",
		"notes": [
			"Walks each loaded room record, releases the two heap strings attached to that record, frees the room-table allocation, releases the decoded map bitmap, and finally frees the top-level location-map block itself.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/assets/map_parser.gd",
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
	"World_DrawLocationBrowserRoomMarkers_v129": {
		"family": "WorldMap",
		"summary": "Draws the one-pixel room marker dashes for the standard location-browser map view.",
		"notes": [
			"Walks the active room table and draws a short horizontal marker at each room's stored map coordinate while skipping the grouped aggregate slice that only exists in the alternate browser mode.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/world/solaris_map.gd",
			"res://scenes/world/world.gd",
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
	"World_FreeShellWindowAuxBuffers_v129": {
		"family": "WorldUI",
		"summary": "Frees the optional heap-backed auxiliary buffers attached to one shell window instance.",
		"notes": [
			"Releases and clears the three auxiliary pointers stored at offsets `0x1478`, `0x147c`, and `0x1480`. The read-message view, compose-submit path, and hotkey menu close flow all reuse this cleanup helper before their stacked shell window is dismissed.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_MessageView_HandleInput_v129": {
		"family": "ComstarUI",
		"summary": "Keyboard input handler for the read-message / reply-enabled ComStar message view.",
		"notes": [
			"Uses `m`/`M`/Space/PageDown to advance the paged text body, uses Shift-Tab/PageUp to move backward, closes the stacked shell window on the remaining actions, and opens World_OpenComposeEditor_v129 when the reply hotkey `r` is pressed and a reply target id is latched.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
	},
	"World_MessageView_DispatchNormalizedKey_v129": {
		"family": "ComstarUI",
		"summary": "Normalizes Escape/Space shortcuts for the reply-enabled message view and forwards them into the active-window key dispatcher.",
		"notes": [
			"Maps Escape to Enter and Space to `m` before routing through the generic current-window key dispatcher so the message view preserves its retail close and page-advance shortcuts.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_MessageView_ExtractReplyPrefixTags_v129": {
		"family": "ComstarUI",
		"summary": "Extracts hidden reply-prefix tags from a received message body into the window's auxiliary buffer and strips them from the visible text.",
		"notes": [
			"Scans the message for inline nine-byte `[p......]` and `[r......]` tags, copies those hidden routing markers into the aux buffer allocated by World_ResetComposeEditorState_v129, and rewrites the displayed body without them. Reply flows later prepend the captured prefix string back onto the outbound compose body.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
	},
	"Shell_OpenCmpActionDialog_v129": {
		"family": "ShellUI",
		"summary": "Opens the shared CMP action dialog used by both combat HUD and travel-compass entry points.",
		"notes": [
			"Called from Combat_UpdateCmpHudToggle_v129 when the CMP toggle is switched into the non-default state, and from World_ActivateTravelCompassCmpButton_v129 after the travel-compass CMP button flash completes.",
			"Refreshes the palette snapshot through the shared modal-prep helper and opens dialog resource `0x74` with Shell_CmpActionDialogProc_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
			"res://scripts/net/comstar_client.gd",
		],
	},
	"Shell_CmpActionDialogProc_v129": {
		"family": "ShellUI",
		"summary": "Dialog procedure for the shared CMP action chooser.",
		"notes": [
			"Centers the dialog over the root shell window, closes cleanly on `WM_CLOSE`, and routes the two action buttons according to the shared shell/combat state flag `DAT_0047c8d4`.",
			"In state `3` it either opens Shell_OpenCmpMessageEntryDialog_v129 or the one-button Shell_OpenCmpInfoDialog_v129; in state `4` the primary action sends the immediate CMP dialog opcode through Shell_SendCmpDialogCommand_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
			"res://scripts/net/comstar_client.gd",
		],
	},
	"Shell_OpenCmpInfoDialog_v129": {
		"family": "ShellUI",
		"summary": "Opens the one-button follow-up informational dialog used by the shared CMP action flow.",
		"notes": [
			"Reached from Shell_CmpActionDialogProc_v129 and from the cancel path of Shell_CmpMessageEntryDialogProc_v129. Uses dialog resource `0x75` with Shell_CmpInfoDialogProc_v129 after the same palette/modal preparation step as the other CMP dialogs.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
			"res://scripts/net/comstar_client.gd",
		],
	},
	"Shell_CmpInfoDialogProc_v129": {
		"family": "ShellUI",
		"summary": "Dialog procedure for the one-button CMP informational modal.",
		"notes": [
			"Centers the dialog, closes on `WM_CLOSE`, and dismisses the modal when its single confirm button is pressed before restoring the full palette.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
	},
	"Shell_OpenCmpMessageEntryDialog_v129": {
		"family": "ShellUI",
		"summary": "Opens the free-text CMP message-entry dialog.",
		"notes": [
			"Reached from Shell_CmpActionDialogProc_v129 when the shared state flag allows typed CMP text entry. Opens dialog resource `0x76` with Shell_CmpMessageEntryDialogProc_v129 after refreshing the modal palette snapshot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
			"res://scripts/net/comstar_client.gd",
		],
	},
	"Shell_CmpMessageEntryDialogProc_v129": {
		"family": "ShellUI",
		"summary": "Dialog procedure for the typed CMP message-entry modal.",
		"notes": [
			"Centers the dialog, caps the editable text length at `0x2ee`, and enables the confirm button only while the edit control is non-empty.",
			"On submit it normalizes an unexpected empty body to the retail debug placeholder, replaces non-identifier characters with `-`, and sends the resulting text through Shell_SendCmpDialogCommand_v129 using the CMP text opcode `0x22`. On cancel it falls back to Shell_OpenCmpInfoDialog_v129.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
			"res://scripts/net/comstar_client.gd",
		],
	},
	"Shell_SendCmpDialogCommand_v129": {
		"family": "ShellUI",
		"summary": "Sends one immediate CMP dialog command opcode and an optional type1 text payload, then flushes it immediately.",
		"notes": [
			"Only used by the shared CMP dialog flow. Appends the caller-supplied opcode to the outbound shell buffer, serializes the provided string only for opcode `0x22`, and then flushes the buffer immediately.",
			"This helper is distinct from World_ComposeEditor_SubmitMessage_v129: the compose editor writes the full recipient/body payload for opcode `0x15`, while this dialog helper sends only the tiny no-arg or text-only CMP prompt commands.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/comstar_client.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/world/world.gd",
		],
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
	"World_ComposeEditor_SubmitMessage_v129": {
		"family": "ComstarUI",
		"summary": "Prepends any hidden reply-prefix tags, encodes the recipient/body payload, and submits the active ComStar compose editor message.",
		"notes": [
			"Prepends the hidden reply prefix string when present, appends outbound opcode `0x15`, encodes the latched target id or recipient id list, writes the final type1 body string, then frees the window aux buffers and closes the stacked shell window before flushing the outbound command buffer.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
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
	"MakeRandomModulo": {
		"family": "SystemRuntime",
		"summary": "Advances the shared retail LCG seed and returns a modulo-bounded pseudo-random value.",
		"notes": [
			"Updates the global seed with the retail `seed * 0x41C64E6D + 0xBDF` linear-congruential step modulo `0x7FFFFFFF`, returns zero for a zero bound, and otherwise returns `seed % bound`. Used by both combat-side random placement/noise helpers and world-side signed jitter builders.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_SetRandomSeed_v129": {
		"family": "SystemRuntime",
		"summary": "Stores a new seed value for the shared retail LCG used by MakeRandomModulo.",
		"notes": [
			"Writes the caller-supplied value directly into the global seed consumed by MakeRandomModulo before later random draws advance it with the retail `seed * 0x41C64E6D + 0xBDF` step.",
			"Combat_InitializeCombatHudAndControlState_v129 seeds it from the current clock tick, while terrain-scenery and attachment-effect helpers reseed it from terrain ids, attachment tags, and fresh clock reads before drawing randomized placements or rotations.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"System_CopyCString_v129": {
		"family": "SystemRuntime",
		"summary": "Copies a null-terminated C string, including the trailing zero, from one retail buffer to another.",
		"notes": [
			"Scans the source for the terminating zero byte, then copies the full byte span into the destination in dword-sized chunks followed by the remaining tail bytes.",
			"Combat_LoadDefaultEffectAnimations_v129 uses it to copy the fixed `boom64.anm`, `smoke64.anm`, and `ack64.anm` path strings into its local filename buffer before loading each slot.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"System_IsProcessorTypeAtLeast_v129": {
		"family": "SystemRuntime",
		"summary": "Returns whether the current Windows processor type meets the supplied retail threshold.",
		"notes": [
			"Wraps `GetSystemInfo`, compares `dwProcessorType` against the caller-supplied minimum, and returns a boolean result. The shell frontend reuses it for both the NoGameCPUCheck and NoSpeechCPUCheck gating paths.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_OpenNoGameCpuCheckDialog_v129": {
		"family": "SystemRuntime",
		"summary": "Opens the frontend NoGameCPUCheck override dialog when the current CPU fails the retail game-speed threshold.",
		"notes": [
			"Returns immediately when the `Software\\\\Kesmai\\\\MultiPlayer Battletech Solaris\\\\NoGameCPUCheck` override key already exists or System_IsProcessorTypeAtLeast_v129 reports a processor type at least `0x1E6`.",
			"Otherwise opens dialog resource `0x77` with System_NoGameCpuCheckDialogProc_v129 and normalizes a dialog creation failure to the retail cancel code `2`.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_VerifyManifestFiles_v129": {
		"family": "SystemRuntime",
		"summary": "Validates that every file listed in `MANIFEST.TXT` exists before the frontend continues booting.",
		"notes": [
			"Opens `MANIFEST.TXT` relative to the retail install path, trims each line, and attempts to reopen every listed file. A missing manifest file or listed payload produces a localized `bterror.log` entry through System_ReportBterrorEvent_v129 that includes the missing filename and active install path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_SaveFrontendConfigToRegistry_v129": {
		"family": "SystemRuntime",
		"summary": "Writes the retail frontend config blob and version marker to the Kesmai registry key.",
		"notes": [
			"Opens `Software\\\\Kesmai\\\\MultiPlayer Battletech Solaris\\\\Config`, writes the single-character version marker for config schema `100`, then persists the `0x91`-byte settings blob rooted at `DAT_0047f890`. Any registry open/write failure is surfaced immediately through Shell_ShowModalMessageBox_v129.",
			"Combat_RefreshJoystickCapabilitiesAndAxisConfig_v129 plus the shortcut-binding accept/reject flows reuse this helper whenever they need to persist updated local frontend settings.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"System_LoadOrInitializeFrontendConfig_v129": {
		"family": "SystemRuntime",
		"summary": "Loads the retail frontend config blob from the Kesmai registry key or seeds it with defaults on first run.",
		"notes": [
			"Creates or opens the shared `...\\\\Config` key during Shell_RunFrontendMain_v129 startup, accepts the stored blob only when both the version value and the `0x91`-byte payload are present, and copies the bytes into `DAT_0047f890` on success.",
			"When the key is new, the version mismatches, or the payload read fails, it falls back to System_SaveFrontendConfigToRegistry_v129 so the in-memory defaults become the new persisted baseline.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"System_StartAolPaletteWatcherTimer_v129": {
		"family": "SystemRuntime",
		"summary": "Starts the retail AOL palette watcher timer when an AOL Frame25 host window is present.",
		"notes": [
			"Looks first for the exact `AOL Frame25` / `America  Online` top-level window pair, then falls back to any `AOL Frame25` window title if the localized caption differs.",
			"When a host window is found it arms a 30-second timer whose callback is System_TickAolPaletteWatcher_v129, enabling the legacy frontend compatibility path that auto-dismisses the external `_AOL_Palette` dialog.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_StopAolPaletteWatcherTimer_v129": {
		"family": "SystemRuntime",
		"summary": "Cancels the retail AOL palette watcher timer on the active shell host window.",
		"notes": [
			"Thin wrapper around `KillTimer` using the same host window handle tracked by the AOL compatibility path. The caller that toggles the watcher state uses it immediately after the start helper when the temporary poll window should be torn down.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_TickAolPaletteWatcher_v129": {
		"family": "SystemRuntime",
		"summary": "Ticks the retail AOL palette watcher, polling the palette window and dispatching the OK-button callback when needed.",
		"notes": [
			"Uses the first timer fire to arm the watcher flag, then on later ticks looks up the `_AOL_Palette` window and enumerates its children through System_ClickAolPaletteOkButton_v129.",
			"When the callback reports that it already pressed the button, this helper clears the one-shot click flag before the next poll cycle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_ClickAolPaletteOkButton_v129": {
		"family": "SystemRuntime",
		"summary": "Child-window callback that finds the AOL palette dialog's `OK` button and simulates the double-click needed to dismiss it.",
		"notes": [
			"Accepts only `_AOL_Button` child windows whose text is exactly `OK`, then sends two `WM_LBUTTONDOWN` / `WM_LBUTTONUP` pairs at the fixed client coordinate `0x000A000A`.",
			"Sets the shared watcher click flag after a successful synthetic double-click so System_TickAolPaletteWatcher_v129 can treat the next poll cycle as the post-dismiss phase.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"System_LoadStringResource_v129": {
		"family": "SystemRuntime",
		"summary": "Loads one Win32 string-table resource into the shared retail scratch buffer and returns it.",
		"notes": [
			"Wraps `LoadStringA(DAT_0047a054, resource_id, &DAT_004e47a0, 400)` and returns the shared `DAT_004e47a0` buffer. Retail shell, world, and combat paths reuse this helper for localized UI text before formatting status strings, dialog warnings, and HUD labels.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
			"res://scenes/settings/settings.gd",
		],
	},
	"System_GetDirectDrawErrorString_v129": {
		"family": "SystemRuntime",
		"summary": "Maps a DirectDraw/HRESULT failure code to the localized retail error string shown in BTERR reports.",
		"notes": [
			"Handles the known DirectDraw and COM failure constants through the string-table resources, then falls back to formatting the low 16-bit code into the generic unknown-error message buffer at `DAT_004f6a70`.",
			"Retail DirectDraw creation, surface setup, and present/release failure paths feed its result into System_ReportBterrorEvent_v129 before surfacing the frontend graphics error.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
		],
	},
	"System_DoesRegistryKeyExist_v129": {
		"family": "SystemRuntime",
		"summary": "Checks whether the requested registry subkey exists beneath the supplied root hive.",
		"notes": [
			"Wraps `RegOpenKeyExA(root, subkey, 0, KEY_READ, &handle)` and closes the handle immediately on success. The speech and NoGame CPU-check paths use it before reading override values or attempting to delete the override keys.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"System_CreateCurrentUserRegistryKey_v129": {
		"family": "SystemRuntime",
		"summary": "Creates the requested registry subkey beneath `HKEY_CURRENT_USER` and closes it immediately.",
		"notes": [
			"Calls `RegCreateKeyExA(HKEY_CURRENT_USER, subkey, ..., \"Application Stuff\", KEY_ALL_ACCESS, ...)` and returns success when the key can be opened or created. The formal root parameter is ignored in the body; the retail CPU-check dialogs still pass `HKEY_CURRENT_USER`, so the helper effectively codifies the current-user override policy.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"System_DeleteRegistryKeyIfPresent_v129": {
		"family": "SystemRuntime",
		"summary": "Deletes the requested registry subkey when it exists beneath the supplied root hive.",
		"notes": [
			"First reuses System_DoesRegistryKeyExist_v129 and then calls `RegDeleteKeyA(root, subkey)` only when the key is present, returning success when the key was absent or deleted cleanly. The speech and NoGame CPU-check dialogs use it when the override checkbox is turned off.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/settings/settings.gd",
			"res://scenes/world/world.gd",
		],
	},
	"System_NoGameCpuCheckDialogProc_v129": {
		"family": "SystemRuntime",
		"summary": "Dialog procedure for the retail NoGameCPUCheck override prompt.",
		"notes": [
			"Initializes the checkbox from the `NoGameCPUCheck` registry value, returns `1` or `2` for the OK/Cancel buttons, and toggles the registry override when the checkbox changes.",
			"When registry updates fail it reports the localized frontend error through System_ReportBterrorEvent_v129 and posts a synthetic cancel command so the dialog closes cleanly.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_ToggleCaptureLog_v129": {
		"family": "SystemRuntime",
		"summary": "Toggles the shared retail capture log file and posts the corresponding begin/end status lines.",
		"notes": [
			"Opens or closes `btcap_log`, flips the active capture bit in `DAT_0047a040`, posts the localized success/error status message through the shared shell/combat text path, and writes the timestamped `BEGIN/END capture` banner lines. Combat_MainLoop_v129 uses it when the Ctrl+Shift+`.` debug chord arms the capture bit, while Shell_HandlePostVersionBannerLine_v129 uses the same helper to close an active capture during the post-version/drop transition.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_ReportBterrorEvent_v129": {
		"family": "SystemRuntime",
		"summary": "Writes one formatted event to `bterror.log`, optionally surfaces it immediately, and can latch the shared retail error flags.",
		"notes": [
			"Formats the caller-supplied source file, source line, optional context string, and message into the retail `%s -- %s(%d):(%s)%s` log line, prefixed with the current timestamp from `_time`/`_ctime`.",
			"When the log file cannot be opened it falls back to the localized frontend error text path, and the two trailing flags control whether the message is surfaced immediately and whether `DAT_0047a040` receives the retail `0x802` error bits.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/net/server_bridge.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_ResolveSpeechCpuCheckMode_v129": {
		"family": "SystemRuntime",
		"summary": "Resolves the retail speech CPU-check mode during frontend initialization.",
		"notes": [
			"Accepts CPUs at or above the `0x24A` processor-type threshold immediately, otherwise checks the `NoSpeechCPUCheck` override registry path and optional `Override` value before opening the fallback resource `0x78` prompt.",
			"Normalizes the chosen mode into the speech-control bitfield at `DAT_0048afe8`, which is why Shell_InitializeFrontendResourcesAndAudio_v129 can treat the helper as the single source of speech CPU policy.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_SpeechCpuCheckDialogProc_v129": {
		"family": "SystemRuntime",
		"summary": "Dialog procedure for the retail NoSpeechCPUCheck override prompt.",
		"notes": [
			"Centers resource `0x78`, initializes the `NoSpeechCPUCheck` checkbox and two override radio buttons from the registry, and returns the selected override mode when the user confirms the dialog.",
			"When the checkbox is toggled it creates or removes the registry key, persists the `Override` DWORD through the speech override path, and reports localized failures through System_ReportBterrorEvent_v129 before forcing the dialog to close on error.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scripts/audio/audio_manager.gd",
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
		],
	},
	"System_WriteCaptureLogEntry_v129": {
		"family": "SystemRuntime",
		"summary": "Appends one formatted entry to `btcap_log` while the shared retail capture bit is enabled.",
		"notes": [
			"Opens `btcap_log` in the retail append mode, writes the caller-supplied wide-format string via `vfwprintf`, and closes the file after each entry. If the file can no longer be opened it clears the active capture bit and posts the localized failure status line through the shared shell/combat status path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/combat/combat.gd",
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
