class_name M6Parity
extends RefCounted

const CMD69_MAX_IMPACT_DISTANCE_METERS := 2500.0

const _MODEL_SUBTYPE_BY_MECH_ID := [
	0, 0, 1, 2, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 4, 5, 5, 6, 7, 8, 8, 9, 9, 9, 10, 10, 11, 11, 12, 12, 13,
	13, 14, 15, 16, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 23, 24, 24, 24, 25, 25, 26, 26, 26, 27,
	27, 28, 28, 28, 29, 30, 30, 30, 30, 30, 30, 31, 31, 31, 32, 33, 33, 33, 34, 35, 35, 35, 35, 36, 37, 37,
	37, 38, 38, 39, 39, 39, 39, 40, 40, 41, 41, 42, 42, 42, 43, 43, 43, 44, 44, 44, 44, 44, 44, 45, 45, 46,
	46, 46, 47, 47, 47, 47, 48, 49, 49, 49, 49, 50, 50, 50, 50, 51, 51, 51, 52, 52, 52, 52, 53, 53, 54, 55,
	55, 55, 55, 55, 56, 56, 57, 57, 58, 59, 59, 59, 59, 60, 60, 60, 61, 61, 61, 61, 62, 63, 63, 64, 65,
]

const _MODEL_ID_BY_SUBTYPE := [
	13, 13, 13, 9, 9, 9, 13, 13, 9, 9, 13, 9, 9, 13, 9, 9, 13, 9, 9, 13, 28, 28, 28, 28, 28, 28, 28, 28, 28,
	28, 30, 28, 30, 28, 28, 30, 28, 28, 28, 51, 51, 30, 51, 43, 51, 51, 51, 61, 61, 51, 43, 51, 51, 61, 61,
	61, 51, 61, 61, 59, 61, 61, 59, 61, 61, 59,
]

const _SHARED_ATTACH_INTERNAL_BY_ID := {
	37: 7,
	1: 4,
	32: 3,
	36: 4,
	18: 2,
	19: 2,
	4: 3,
	5: 3,
	52: 0,
	54: 0,
	55: 0,
	38: 1,
	40: 1,
	41: 1,
	31: 4,
	33: 2,
	34: 6,
	35: 6,
}

const _MODEL_ATTACH_INTERNAL_BY_KEY := {
	"13:52": 5,
	"13:54": 5,
	"13:38": 6,
	"13:40": 6,
	"43:43": 0,
	"43:44": 0,
	"43:57": 0,
	"43:58": 0,
	"43:42": 1,
	"43:56": 1,
}

const _ARMOR_TO_INTERNAL_SECTION := {
	1: 0,
	2: 1,
	4: 4,
	7: 5,
	8: 6,
}


static func build_weapon_range_validity(weapon_type_ids: Array, selected_slot: int, target_distance_meters: float) -> Dictionary:
	var any_known := false
	var any_within := false
	for weapon_type_id_v in weapon_type_ids:
		var long_range := float(MecParser.weapon_long_range_meters(int(weapon_type_id_v)))
		if long_range <= 0.0:
			continue
		any_known = true
		if target_distance_meters <= long_range:
			any_within = true

	var selected_within: Variant = null
	var selected_band_index := -1
	if selected_slot >= 0 and selected_slot < weapon_type_ids.size():
		var selected_long_range := float(MecParser.weapon_long_range_meters(int(weapon_type_ids[selected_slot])))
		selected_band_index = classify_weapon_range_band_index(target_distance_meters, selected_long_range)
		if selected_long_range > 0.0:
			selected_within = target_distance_meters <= selected_long_range

	return {
		"anyWeaponWithinMaxRange": any_within if any_known else null,
		"selectedWithinMaxRange": selected_within,
		"selectedRangeBandIndex": selected_band_index,
	}


static func classify_weapon_range_band_index(distance_meters: float, long_range_meters: float) -> int:
	if long_range_meters <= 0.0:
		return -1
	if distance_meters <= long_range_meters / 3.0:
		return 0
	if distance_meters <= long_range_meters * 2.0 / 3.0:
		return 1
	if distance_meters <= long_range_meters:
		return 2
	return 3


static func target_color_state(has_target: bool, selected_within: Variant, any_within: Variant) -> String:
	if not has_target:
		return "off"
	if selected_within is bool and bool(selected_within):
		return "green"
	if any_within is bool and bool(any_within):
		return "yellow"
	return "red"


static func resolve_attachment_internal_index(mech_id: Variant, attach_id: int, impact_z: float) -> int:
	if attach_id >= 0 and attach_id < 8:
		return attach_id
	if attach_id >= 0x20 and attach_id <= 0x27:
		return attach_id - 0x20

	var model_id := _combat_model_id_for_mech_id(mech_id)
	if model_id >= 0:
		if model_id == 13 and attach_id == 52:
			if impact_z < 500.0:
				return 5
			if impact_z < 2500.0:
				return 6
			return 0

		var model_key := "%d:%d" % [model_id, attach_id]
		if _MODEL_ATTACH_INTERNAL_BY_KEY.has(model_key):
			return int(_MODEL_ATTACH_INTERNAL_BY_KEY[model_key])

	if _SHARED_ATTACH_INTERNAL_BY_ID.has(attach_id):
		return int(_SHARED_ATTACH_INTERNAL_BY_ID[attach_id])
	return -1


static func critical_detail_row_annotation(detail_row_index: int, fixed_row_present: bool = true) -> Dictionary:
	var armor_row_index: Variant = null
	var internal_row_index: Variant = null
	match detail_row_index:
		0, 1:
			armor_row_index = 1
		2, 3:
			if fixed_row_present:
				armor_row_index = 1
		4, 5:
			armor_row_index = 2
		6, 7:
			if fixed_row_present:
				armor_row_index = 2
		8, 9:
			armor_row_index = 7
			internal_row_index = 0
		10, 11:
			armor_row_index = 7
			internal_row_index = 1
		12, 13, 14, 15:
			armor_row_index = 8
		16, 19, 20:
			internal_row_index = 4
	return {
		"armor_row_index": armor_row_index,
		"internal_row_index": internal_row_index,
	}


static func detail_row_to_internal_section_index(detail_row_index: int, fixed_row_present: bool = true) -> int:
	var annotation := critical_detail_row_annotation(detail_row_index, fixed_row_present)
	if annotation.get("internal_row_index", null) is int:
		return int(annotation["internal_row_index"])
	if annotation.get("armor_row_index", null) is int:
		var armor_row_index := int(annotation["armor_row_index"])
		if _ARMOR_TO_INTERNAL_SECTION.has(armor_row_index):
			return int(_ARMOR_TO_INTERNAL_SECTION[armor_row_index])
	return -1


static func cmd69_impact_audio_gate(event_data: Dictionary, fallback_distance_meters: float) -> Dictionary:
	var distance_v: Variant = _first_numeric(event_data, [
		"cmd69ImpactDistanceMeters",
		"impactDistanceMeters",
		"computedImpactDistanceMeters",
	])
	var distance_meters := float(distance_v) if distance_v != null else fallback_distance_meters
	var delay_v: Variant = _first_numeric(event_data, [
		"cmd69ImpactDelayMs",
		"impactDelayMs",
		"impactSoundDelayMs",
	])
	var delay_ms := int(clampi(int(round(float(delay_v))), 0, 1500)) if delay_v != null else 0
	return {
		"playImpact": distance_meters <= CMD69_MAX_IMPACT_DISTANCE_METERS,
		"delayMs": delay_ms,
	}


static func _combat_model_id_for_mech_id(mech_id: Variant) -> int:
	if not (mech_id is int):
		return -1
	var mech_id_int := int(mech_id)
	if mech_id_int < 0 or mech_id_int >= _MODEL_SUBTYPE_BY_MECH_ID.size():
		return -1
	var subtype := int(_MODEL_SUBTYPE_BY_MECH_ID[mech_id_int])
	if subtype < 0 or subtype >= _MODEL_ID_BY_SUBTYPE.size():
		return -1
	return int(_MODEL_ID_BY_SUBTYPE[subtype])


static func _first_numeric(event_data: Dictionary, keys: Array) -> Variant:
	for key_v in keys:
		var key := str(key_v)
		if not event_data.has(key):
			continue
		var value: Variant = event_data[key]
		if value is int or value is float:
			return float(value)
	return null
