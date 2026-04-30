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
