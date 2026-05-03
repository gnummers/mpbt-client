class_name RetailCommandCatalog
extends RefCounted

## Structured metadata for the saved/named retail v1.29 command handlers that
## are currently known in Ghidra. This builds on RetailFunctionCatalog so the
## Godot client can query retail command ids, names, addresses, and the current
## Godot surfaces that correspond to each handler family.

const FUNCTION_CATALOG_SCRIPT = preload("res://scripts/research/retail_function_catalog.gd")
const FUNCTION_PATTERN := "^(Combat|World)_Cmd[0-9]+_.*_v129$"

const OVERRIDES := {
	"World_Cmd04_TravelCompassPage_v129": {
		"summary": "Early-world travel-compass page with one center slot, four surrounding travel slots, and fixed action buttons.",
		"notes": [
			"Seeds the page slot and flag tables, installs dedicated keyboard and mouse callbacks, and redraws the five-slot picture layout used by the older travel shell.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd07_MenuDialog_v129": {
		"summary": "Server menu dialog renderer.",
		"godot_targets": [
			"res://scenes/main/main.gd",
			"res://scenes/world/world.gd",
		],
		"research_refs": ["RESEARCH.md:360"],
	},
	"World_Cmd05_SetArrowCursor_v129": {
		"summary": "Restores the retail arrow cursor mode for the world/frontend shell.",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd06_SetWaitCursor_v129": {
		"summary": "Enters the retail wait-cursor mode for the world/frontend shell.",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd09_OpenNumberedTextSelection_v129": {
		"summary": "Opens the older numbered text-selection modal window from a streamed list of choices.",
		"notes": [
			"Carries a small subcommand byte, then a count plus one decoded string per choice when the open path is requested.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd14_PersonnelRecord_v129": {
		"summary": "Personnel-record / dossier modal page.",
		"notes": [
			"Carries a personnel id, battle total, and six text fields that populate the shared modal world text window.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/comstar/comstar.gd",
		],
	},
	"World_Cmd15_OpenNumericPrompt_v129": {
		"summary": "Range-checked numeric input prompt.",
		"notes": [
			"Carries a follow-up command id plus minimum and maximum bounds, then opens the shared world numeric prompt for the player to enter a value.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd13_StoreCachedNamedEntry_v129": {
		"summary": "Stores or refreshes one cached named-entry record for the older world list/prompt family.",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd20_ParseTextDialog_v129": {
		"summary": "Server text dialog / mech-stats page renderer.",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scenes/mech/mech_select.gd",
		],
		"research_refs": ["RESEARCH.md:361"],
	},
	"World_Cmd29_QueueTransientNotice_v129": {
		"summary": "Queues a transient late-world notice into the shared popup/notice pipeline.",
		"notes": [
			"Carries a type1 notice id, two byte-sized mode fields, and a type1 string or resource token, then forwards the resolved text into the shared transient-notice queue.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd26_ParseMechList_v129": {
		"summary": "Mech list parser that feeds the mech-selection flow.",
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
		"research_refs": ["RESEARCH.md:362"],
	},
	"World_Cmd30_MechStatusOptionPage_v129": {
		"summary": "Mech status option page in the Solaris mech-management family.",
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
		"research_refs": ["RESEARCH.md:1182-1185"],
	},
	"World_Cmd31_MechComponentActionPage_v129": {
		"summary": "Mech component action page / maintenance submenu.",
		"godot_targets": [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		],
		"research_refs": ["RESEARCH.md:1182-1185"],
	},
	"World_Cmd32_AlternateRankingList_v129": {
		"summary": "Alternate ranking-style list parser.",
		"godot_targets": [
			"res://scenes/standings/standings.gd",
			"res://scripts/net/standings_client.gd",
		],
		"research_refs": ["RESEARCH.md:1123"],
	},
	"World_Cmd33_NoOp_v129": {
		"summary": "Compiled-out world dispatch slot that immediately returns zero.",
		"notes": [
			"Current v1.29 Ghidra dispatch-table state identifies 0x004468b0 as world-mode command slot 33.",
			"The body performs no decoding or UI work and returns zero immediately, so retail leaves this slot inert.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd34_TravelCompassLabelStrip_v129": {
		"summary": "Travel-compass label-strip updater for the older world travel shell.",
		"notes": [
			"Decodes one label string per call and paints it into the next top-strip travel-compass column, clearing the strip and redrawing the shared heading on the first row.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd35_RequestClientExit_v129": {
		"summary": "Server-driven world command that requests immediate client shutdown without a confirmation prompt.",
		"notes": [
			"Current v1.29 Ghidra dispatch-table state identifies 0x004031a0 as world-mode command slot 35.",
			"It posts shell command `2` to the main window and sets the shared exit bit in `DAT_0047a040`, matching the low-level shutdown action that Shell_ConfirmClientExit_v129 takes after the player accepts the local exit prompt.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd36_MessageView_v129": {
		"summary": "Read-message / reply-enabled ComStar message view.",
		"notes": [
			"Reply target id 0 yields a read-only page; nonzero enables reply controls.",
			"This is the received-message surface, not the compose editor.",
		],
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
		"research_refs": ["RESEARCH.md:1127"],
	},
	"World_Cmd37_OpenCompose_v129": {
		"summary": "Server wrapper that opens the local ComStar compose window.",
		"notes": [
			"Accepts either one target id or a count followed by multiple target ids.",
			"Still routes into the same local compose builder used by inquiry flows.",
			"Current v1.29 Ghidra state shows a thin packet wrapper at 0x00443d10 forwarding into World_OpenComposeEditor_v129 (0x00443d80); older RESEARCH notes that cited 0x00443fb0 were pointing at the deeper compose-state reset path.",
		],
		"godot_targets": [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		],
		"research_refs": ["RESEARCH.md:1128", "RESEARCH.md:6753-6757"],
	},
	"World_Cmd38_NoOp_v129": {
		"summary": "Compiled-out world dispatch slot that immediately returns zero.",
		"notes": [
			"Current v1.29 Ghidra state identifies 0x004467a0 as world-mode dispatch slot 38.",
			"The body is just `return 0;`, so retail leaves this command id inert and without any packet-decoding or UI side effects.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd40_LocationBrowser_v129": {
		"summary": "Shared world location / scene browser builder.",
		"notes": [
			"Uses the live room table and browser-selection globals, then rebuilds the shared browser window.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/world_travel_client.gd",
		],
		"research_refs": ["RESEARCH.md:6266-6276"],
	},
	"World_Cmd47_SetLocationLabelCode_v129": {
		"summary": "Updates the location-browser label code and refreshes its bitmap when the code changes.",
		"notes": [
			"Reads a one-arg label code, stores it in the shared browser-label global, and rebuilds the label bitmap only when the code differs from the previous value.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_Cmd42_BitmaskSelectionList_v129": {
		"summary": "Numbered checkbox / multi-select list routed through the older cmd10 bitmask submit path.",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
		"research_refs": ["RESEARCH.md:6758-6766"],
	},
	"World_Cmd43_GroupedLocationBrowser_v129": {
		"summary": "Grouped Solaris location browser / travel-mode aggregator.",
		"notes": [
			"Context id 0xC6 is the special Solaris travel-mode branch.",
			"Aggregates totals into the live location table before rebuilding the shared browser UI.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/world_travel_client.gd",
		],
		"research_refs": ["RESEARCH.md:6277-6288"],
	},
	"World_Cmd44_SetLocationDistanceScale_v129": {
		"summary": "Location-browser distance scale / range-setting helper.",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_Cmd45_ScrollListShell_v129": {
		"summary": "Scrollable list shell with inline row-feed grammar and MORE paging action.",
		"notes": [
			"Space on eligible modes sends client cmd28 as the built-in next-page action.",
			"The long body string can inline row-feed grammar rather than needing a separate visible carrier command.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
		"research_refs": ["RESEARCH.md:1136"],
	},
	"World_Cmd46_ClearWorldUiChildren_v129": {
		"summary": "Clears active world UI children before rebuilding a world sub-surface.",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd48_KeyedTripleStringList_v129": {
		"summary": "Late-world keyed triple-string list dialog with one item id column plus three streamed text columns per row.",
		"notes": [
			"Thin wrapper around the shared triple-string list builder that enables the leading numeric key column for each row before the common menu-dialog callbacks take over.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd49_MapConnectorOverlay_v129": {
		"summary": "Draws a Solaris map connector/path line between two locations.",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
		"research_refs": ["RESEARCH.md:1140", "RESEARCH.md:6289-6293"],
	},
	"World_Cmd50_ClearLocationBrowserSelectionHighlight_v129": {
		"summary": "Clears the currently latched location-browser selection highlight through the browser window callback.",
		"notes": [
			"Thin wrapper that forwards `(browser_window, 0)` into the shared location-browser callback stored at window field `0x508`. This is the same clear phase used before the browser mouse handlers switch to a new selected location.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_Cmd51_DrawLocationBrowserSelectionHighlight_v129": {
		"summary": "Redraws the current location-browser selection highlight through the browser window callback.",
		"notes": [
			"Thin wrapper that forwards `(browser_window, 1)` into the shared location-browser callback stored at window field `0x508`. This is the same redraw phase used after the browser updates its selected location index.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"World_Cmd52_RejectShortcutBinding_v129": {
		"summary": "Rejects a pending world shortcut binding, removes the optimistic local row, and reports the failure text.",
		"notes": [
			"Looks up the pending shortcut entry by `(menu_id, selection_id)`, removes it from the local shortcut table, opens the shared stacked text dialog with the failure message, and refreshes the shortcut UI afterward.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd53_ConfirmShortcutBinding_v129": {
		"summary": "Confirms a pending world shortcut binding and reports the final `Alt-<key>` assignment text.",
		"notes": [
			"Looks up the pending shortcut entry by `(menu_id, selection_id)`, clears its high-bit pending marker on success, opens the shared stacked text dialog with the confirmation string, and refreshes the shortcut UI.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
	},
	"World_Cmd56_MapRoomMarkerOverlay_v129": {
		"summary": "Draws a small highlight box over a room on the Solaris map.",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
		"research_refs": ["RESEARCH.md:1147"],
	},
	"World_Cmd57_HotkeySelectionMenu_v129": {
		"summary": "Hotkey-driven selection menu in the late-world list family.",
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
		"research_refs": ["RESEARCH.md:6748-6750"],
	},
	"World_Cmd58_SetScrollListId_v129": {
		"summary": "Companion helper that latches the current scroll-list id for Cmd45.",
		"notes": [
			"Not a visible UI command on its own.",
		],
		"godot_targets": [
			"res://scenes/world/world.gd",
		],
		"research_refs": ["RESEARCH.md:1149"],
	},
	"World_Cmd60_MapRoomMarkerOverlayWide_v129": {
		"summary": "Wide-range variant of the Solaris room-marker overlay.",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
		"research_refs": ["RESEARCH.md:1151"],
	},
	"World_Cmd61_MapConnectorOverlayWide_v129": {
		"summary": "Wide-range variant of the Solaris connector/path overlay family.",
		"godot_targets": [
			"res://scenes/world/world.gd",
			"res://scripts/world/solaris_map.gd",
		],
	},
	"Combat_Cmd62_StartCombat_v129": {
		"summary": "Begins the combat scene / combat session.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_Cmd63_ResultSceneInit_v129": {
		"summary": "Initializes the combat result scene / post-match surface.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_Cmd64_AddActor_v129": {
		"summary": "Creates or seeds a remote combatant slot with pilot/mech data.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:368"],
	},
	"Combat_Cmd65_UpdateActorPosition_v129": {
		"summary": "Primary remote actor position-sync handler.",
		"notes": [
			"Reads player id plus X/Y/Z, heading-ish bytes, and a speed/throttle-ish field into per-player motion state.",
		],
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:369"],
	},
	"Combat_Cmd66_ActorDamageUpdate_v129": {
		"summary": "Remote actor damage-state update.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_Cmd67_LocalDamageUpdate_v129": {
		"summary": "Local actor damage-state update.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_Cmd68_SpawnWeaponEffect_v129": {
		"summary": "Weapon/effect update that reads source-target ids plus angle and XYZ fields.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:370"],
	},
	"Combat_Cmd69_ImpactEffectAtCoord_v129": {
		"summary": "Projectile / sound / impact update with XYZ fields and local-distance checks.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:371"],
	},
	"Combat_Cmd70_ActorAnimState_v129": {
		"summary": "Combat state/animation control packet.",
		"notes": [
			"Action byte drives animation and flag helper calls.",
			"Current research ties adjacent references to fall/destruction animation-state paths.",
		],
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:372", "RESEARCH.md:2109-2115"],
	},
	"Combat_Cmd71_ResetEffectState_v129": {
		"summary": "Resets combat effect state after transient effect packets.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
	"Combat_Cmd72_InitLocalActor_v129": {
		"summary": "Initializes the local combat scene / self actor.",
		"notes": [
			"Loads local callsign/mech strings, origin coordinates, arena counts, and marks combat scene active.",
		],
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:373"],
	},
	"Combat_Cmd73_UpdateActorRateFields_v129": {
		"summary": "Stores scaled short control/aim/offset values into the combat actor table.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
		"research_refs": ["RESEARCH.md:374"],
	},
	"Combat_Cmd74_DisplayStatusMessage_v129": {
		"summary": "Displays combat status / HUD message text.",
		"godot_targets": [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		],
	},
}

static var _entries_cache: Array = []
static var _entries_by_name_cache: Dictionary = {}
static var _entries_by_domain_and_id_cache: Dictionary = {}


static func all() -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	return _entries_cache.duplicate(true)


static func by_function_name(name: String) -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	return (_entries_by_name_cache.get(name, {}) as Dictionary).duplicate(true)


static func by_command_id(domain: String, command_id: int) -> Dictionary:
	if _entries_cache.is_empty():
		_build_cache()
	var key := "%s:%d" % [domain.to_lower(), command_id]
	return (_entries_by_domain_and_id_cache.get(key, {}) as Dictionary).duplicate(true)


static func by_domain(domain: String) -> Array:
	if _entries_cache.is_empty():
		_build_cache()
	var matches: Array = []
	var normalized := domain.to_lower()
	for entry_v in _entries_cache:
		var entry := entry_v as Dictionary
		if str(entry.get("domain", "")).to_lower() == normalized:
			matches.append(entry.duplicate(true))
	return matches


static func metadata() -> Dictionary:
	return {
		"function_pattern": FUNCTION_PATTERN,
		"total_commands": all().size(),
		"domains": {
			"World": by_domain("World").size(),
			"Combat": by_domain("Combat").size(),
		},
	}


static func _build_cache() -> void:
	_entries_cache.clear()
	_entries_by_name_cache.clear()
	_entries_by_domain_and_id_cache.clear()

	for function_v in FUNCTION_CATALOG_SCRIPT.all():
		var function_entry := function_v as Dictionary
		var function_name := str(function_entry.get("name", ""))
		if not function_name.contains("_Cmd"):
			continue
		var parsed := _parse_command_name(function_name)
		if parsed.is_empty():
			continue

		var override := OVERRIDES.get(function_name, {}) as Dictionary
		var entry := {
			"domain": parsed.get("domain", ""),
			"command_id": parsed.get("command_id", 0),
			"function_name": function_name,
			"label": parsed.get("label", ""),
			"address": function_entry.get("address", ""),
			"xref_count": function_entry.get("xref_count", 0),
			"summary": str(override.get("summary", _default_summary(parsed))),
			"godot_targets": (override.get("godot_targets", _default_targets(parsed)) as Array).duplicate(true),
			"notes": (override.get("notes", []) as Array).duplicate(true),
			"research_refs": (override.get("research_refs", []) as Array).duplicate(true),
		}

		_entries_cache.append(entry)
		_entries_by_name_cache[function_name] = entry
		_entries_by_domain_and_id_cache[_cache_key(str(entry["domain"]), int(entry["command_id"]))] = entry


static func _parse_command_name(function_name: String) -> Dictionary:
	var parts := function_name.split("_")
	if parts.size() < 4:
		return {}
	var domain := parts[0]
	var cmd_token := parts[1]
	if not cmd_token.begins_with("Cmd"):
		return {}
	var command_id := int(cmd_token.trim_prefix("Cmd"))
	var label_parts := parts.slice(2, parts.size() - 1)
	var humanized_parts: PackedStringArray = []
	for label_part_v in label_parts:
		humanized_parts.append(_humanize_token(str(label_part_v)))
	return {
		"domain": domain,
		"command_id": command_id,
		"label": " ".join(humanized_parts),
	}


static func _default_summary(parsed: Dictionary) -> String:
	var label := str(parsed.get("label", ""))
	return "%s command handler for %s." % [parsed.get("domain", "Retail"), label]


static func _default_targets(parsed: Dictionary) -> Array:
	var domain := str(parsed.get("domain", ""))
	var command_id := int(parsed.get("command_id", -1))
	var label := str(parsed.get("label", "")).to_lower()
	if domain == "Combat":
		return [
			"res://scenes/combat/combat.gd",
			"res://scripts/net/arena_client.gd",
		]

	if label.contains("message") or label.contains("compose"):
		return [
			"res://scenes/comstar/comstar.gd",
			"res://scripts/net/comstar_client.gd",
		]
	if label.contains("mech"):
		return [
			"res://scenes/mech/mech_select.gd",
			"res://scripts/net/mech_client.gd",
		]
	if label.contains("ranking"):
		return [
			"res://scenes/standings/standings.gd",
			"res://scripts/net/standings_client.gd",
		]
	if label.contains("map") or label.contains("location") or label.contains("scroll") or label.contains("hotkey") or command_id in [44, 46, 49, 56, 57, 58, 60, 61]:
		return [
			"res://scenes/world/world.gd",
			"res://scripts/net/world_client.gd",
			"res://scripts/net/world_travel_client.gd",
		]
	return [
		"res://scenes/world/world.gd",
	]


static func _cache_key(domain: String, command_id: int) -> String:
	return "%s:%d" % [domain.to_lower(), command_id]


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
