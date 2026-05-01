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
			"Rebuilds the candidate face plane from the owning scenery instance's transformed vertex table, normalizes the face basis vectors, and solves the segment/plane intersection only when the current face index resolves to a polygonal face.",
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
			"The second parameter selects between the world camera surface (`DAT_004e6f20`) and the player-centered radar surface (`DAT_004e5fc0`). In both modes the helper rotates a shared basis, fills the destination panel, rasterizes the projected terrain outline list, and then renders each active scenery instance through the cached 3d object record path.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
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
			"Uses the detail level selected through `DAT_0047a048` to choose how many anchors to sample, transforms the special support mesh into camera space, projects the resulting polygon, and draws the selected GRD bitmap only for anchors that remain near enough to the active view.",
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
			"Called from Combat_RenderActiveEffectsPass_v129 when the main 3d scene is being drawn. The pass conditionally renders the `SKY0` backdrop when the matching visual toggle is enabled, draws two large transformed ground polygons, and then delegates the optional GRD sprite layer to Combat_RenderAmbientGroundDetail_v129.",
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
	"Combat_ResetLasrSoundState_v129": {
		"family": "CombatAudio",
		"summary": "Resets the retail LASR sound state machine, clears the current/target state ids, and releases active LASR handles.",
		"notes": [
			"Clears the LASR enable/ramp flags, resets the current and pending LASR state ids plus the target volume bookkeeping, unregisters any active LASR sound handles, and zeroes the loop counters used by the LASR playback sequencer.",
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
	"Combat_InitializeVisualResourcesAndHudState_v129": {
		"family": "CombatInit",
		"summary": "Initializes the retail combat visual resources, fonts, and baseline HUD state before the main loop enters steady-state rendering.",
		"notes": [
			"Refreshes the two combat HUD fonts, delegates bulk bitmap/bootstrap loading to Combat_LoadVisualResourceTables_v129, resets several actor/HUD state fields, and primes the active combat surface/backbuffer handle used by later draws.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_ResetPresentationStateAndLoadVisualOptions_v129": {
		"family": "CombatInit",
		"summary": "Resets the retail combat presentation state and loads the saved visual-detail / overlay option bits into the active runtime flags.",
		"notes": [
			"Called from Shell_EnterDropScene_v129 before the combat scene is fully entered. Clears many transient presentation globals, restores the saved detail level from `DAT_0047f898`, maps the persisted display-flag bits from `DAT_0047f89c` into `DAT_0047a044`, and resets the screen-shake state before steady-state rendering begins.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_InitializeBattlefieldVisualState_v129": {
		"family": "CombatInit",
		"summary": "Initializes the battlefield-facing visual runtime after combat resources are loaded, including terrain palette state, scenery, backdrop layers, and projectile effect slots.",
		"notes": [
			"Called directly from Combat_InitializeVisualResourcesAndHudState_v129. Applies the terrain palette overrides, installs the active terrain palette table, initializes terrain scenery, sky and ground detail layers, allocates the active projectile/effect slot pool, redraws the root window stack, seeds the default steady-state render mode globals, and then emits outbound combat cmd19.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/ui/combat_radar.gd",
		],
	},
	"Combat_LoadVisualResourceTables_v129": {
		"family": "CombatInit",
		"summary": "Opens COMBAT.DAT and bulk-loads the combat bitmap/resource tables required by the retail HUD and effect surfaces.",
		"notes": [
			"Walks the tagged COMBAT.DAT archive, loads many bitmap resources into fixed global tables through ResourceArchive_SeekTaggedEntry_v129 and Frame_LoadBitmapFromFile_v129, then derives an additional run-length/mask buffer from one loaded surface before releasing the temporary bitmap objects.",
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
			"Performs the single-instance check, resolves the working directory, initializes the Win32 shell window and message queue, sets up the frontend bootstrap through Shell_InitializeFrontendResourcesAndAudio_v129, then services inbound shell/network frames until shutdown.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
			"res://scripts/audio/audio_manager.gd",
		],
	},
	"Shell_ServiceNetworkStateLoop_v129": {
		"family": "ShellUI",
		"summary": "Polls queued shell/network frames, dispatches them through the shell state handlers, and advances the active frontend state tick.",
		"notes": [
			"Dequeues incoming packets, feeds each one to Shell_HandlePostVersionBannerLine_v129, updates sound/auxiliary polling, then ticks the current shell state branch according to the retail DAT_0047c8d4 state value.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/server_bridge.gd",
			"res://scripts/audio/audio_manager.gd",
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
			"When frontend cursor resources are active, loads the Win32 arrow cursor through the shared cursor helper and latches `DAT_0047c8c8 = 0` so the shell knows the pointer is back in its normal mode.",
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
			"When frontend cursor resources are active, loads the Win32 wait cursor through the shared cursor helper and latches `DAT_0047c8c8 = 1` so later shell input checks know the pointer is in busy mode.",
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
			"Checks the shell UI-sound enable bit, primes the common cue volume from the current frontend SFX slider, and plays cue id `0` through the shared audio wrapper. Invalid wrapped-text edits, numeric prompts, menu/dialog navigation misses, and other rejected UI actions all route through this helper.",
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
			"Checks the retail marquee timer and shell/UI state flags, shifts the active status text buffer left by one character, recomputes the remaining length, redraws the marquee text strip, and presents the updated rectangle.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
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
			"Enumerates thread windows and sends WM_COMMAND `2` and `7` to every visible window except the main shell window before the combat transition continues.",
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
			"Resets the active world/shell widgets, shows the DROP bitmap through Frame_ShowCenteredArchiveBitmap_v129, optionally starts the associated scene audio cue, and clears shell-state flags before the next transition continues.",
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
			"Seeds the shell palette ramp, loads the default TFONT1 fonts, ensures the location-map index is ready, loads the shared MW picture archives/tables, initializes additional frontend resources, and starts the Miles/AIL audio layer according to the saved sound configuration bits.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/audio/audio_manager.gd",
			"res://scripts/assets/asset_registry.gd",
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
			"Accepts printable keys into the active voice/transmission text buffer, supports backspace and cancel, routes transmit-mode submissions through Combat_SendVoiceTransmissionText_v129, mirrors local-entry rows into the history feed, plays the confirm cue, and flushes the outbound shell buffer when the entry completes.",
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
			"Reads a follow-up command id, an initial bitmask, a heading string, and one plain-text row per entry. It formats the numbered rows into the shared style-2 shell window, seeds each checkbox from the incoming bitmask, and installs World_BitmaskSelectionList_HandleInput_v129 as the active confirm/toggle callback.",
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
			"Frees the current stacked shell window, pops the saved world-window stack when nested overlays remain, and clears the stacked-window state bit when the stack becomes empty. When the world shell is active and unobstructed afterward, it refreshes the underlying travel-compass page highlight state before returning to the caller.",
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
	"World_BitmaskSelectionList_HandleInput_v129": {
		"family": "WorldSubmit",
		"summary": "Handles confirm/cancel input and per-row toggles for the late-world checkbox selection dialog.",
		"notes": [
			"Escape sends a zero value through World_SendLegacySelectionResponse_v129, Enter recomputes the checked-row bitmask and submits `bitmask + 1`, and numeric row hotkeys toggle the corresponding checkbox before redrawing its decoration in place.",
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
	"World_RegisterShortcutBinding_v129": {
		"family": "WorldUI",
		"summary": "Registers a world shortcut / hotkey binding.",
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
			"When the world-shell active bit is set, marks teardown in progress, clears world UI children, destroys the root/auxiliary popup windows tracked in the shared world globals, clears the optional overlay/dialog windows guarded by bits `0x40` and `0x04`, and resets the world-shell flag mask before returning. When the world shell is not active, it falls back to the shared UI cleanup path.",
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
	"Frame_LoadBitmapBufferFromArchive_v129": {
		"family": "FrameBlit",
		"summary": "Loads a bitmap resource from an opened retail archive into a heap buffer descriptor.",
		"notes": [
			"Opens the named bitmap entry, decodes the retail bitmap payload, allocates a destination buffer plus descriptor, computes the scaled dimensions, and copies the full pixel payload through Frame_CopyBitmapPixelsToBuffer_v129.",
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
			"Allocates the bitmap header object, reads the fixed header words, optionally decodes the embedded palette section, then decodes the pixel payload. On any partial-read or decode failure it frees the half-built bitmap through Frame_FreeBitmap_v129.",
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
			"Releases the temporary slideshow frame and archive handle, tears down the timer, stops any slideshow-owned audio cue, restores the baseline frontend display through Shell_ClearFrontendDisplayAndApplyCurrentPalette_v129, shows the cursor again, and zeroes the stored slideshow session block.",
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
			"Opens TITLE.DAT, displays the TITL card followed by the CRDT card when available, overlays the title caption on the first card, presents each frame full-screen, and frees the temporary bitmap after each slide.",
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
			"Parses the current script token as `<seconds> <tag>`, loads the referenced bitmap from the open archive, centers it in the temporary fullscreen frame, overlays the title caption on the first mode-1 slide, optionally starts the slideshow audio cue for mode 2, uploads the bitmap palette, then rearms the timer for the next delay. On exhaustion or failure it posts the completion message back to the main shell window.",
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"Frame_CreateWindow_v129": {
		"family": "FrameWindow",
		"summary": "Allocates and initializes a retail frame/window with backing storage, callbacks, and optional inset text layout.",
		"notes": [
			"Registers the new frame in the global z-order array, zeroes its control state, stores the requested screen position and dimensions, allocates the backing rectangle metadata block, seeds the default input/render callbacks, and finishes by resetting the text-layout state. When the caller sets the final flag it also enables the standard shell text insets used by modal pages and slideshow windows.",
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
	"Frame_DestroyWindow_v129": {
		"family": "FrameWindow",
		"summary": "Destroys a retail frame/window, recursively releasing child frames, backing storage, and active-window state.",
		"notes": [
			"Removes the frame from the global z-order array, recursively tears down any owned child window tree, frees linked UI-control blocks and auxiliary buffers, repairs the active/focused window globals, and finally releases the frame object itself. It is the shared close path beneath stacked shell windows, slideshow teardown, and many world-dialog cleanup callbacks.",
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
		],
		"implementation_status": STATUS_METADATA_ONLY,
		"godot_targets": [
			"res://scenes/world/world.gd",
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
			"In the standard map browser it draws the small retail marker around the selected room coordinate. In grouped mode it instead palette-swaps the selected aggregate marker region and updates the grouped selection-state flag that the shared browser highlight callback reuses.",
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
