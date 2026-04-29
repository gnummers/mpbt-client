class_name MecParser

## Retail .MEC loader ported from mpbt-server/src/data/mechs.ts and
## mpbt-server/RESEARCH.md.
##
## The original v1.29 client derives mech ids from MPBT.MSG lines 0x3AE..0x44E
## and decrypts each .MEC file with a sliding XOR cipher seeded from the
## filename's final four characters.

const VARIANT_BASE_1 := 0x3AE
const VARIANT_LAST_ID := 0xA0

const INTERNAL_STRUCTURE_TABLE := [
	[3, 4, 3, 4],
	[5, 6, 3, 5],
	[6, 8, 4, 6],
	[8, 10, 6, 8],
	[10, 12, 6, 10],
	[11, 13, 7, 11],
	[12, 14, 8, 12],
	[14, 15, 8, 11],
	[15, 15, 8, 12],
	[16, 15, 9, 12],
	[16, 12, 8, 12],
	[18, 13, 9, 13],
	[20, 14, 10, 14],
	[21, 15, 10, 15],
	[22, 15, 11, 15],
	[23, 15, 12, 16],
	[25, 17, 13, 17],
	[27, 18, 14, 18],
	[29, 19, 15, 19],
	[30, 20, 16, 20],
	[31, 21, 17, 21],
]

const WEAPON_NAMES := {
	0: "Flamer",
	1: "Machine Gun",
	2: "Small Laser",
	3: "Medium Laser",
	4: "Large Laser",
	5: "Particle Projector Cannon",
	6: "Autocannon/2",
	7: "Autocannon/5",
	8: "Autocannon/10",
	9: "Autocannon/20",
	10: "SRM-2",
	11: "SRM-4",
	12: "SRM-6",
	13: "LRM-5",
	14: "LRM-10",
	15: "LRM-15",
	16: "LRM-20",
}

const WEAPON_SHORT_NAMES := {
	0: "FLAMER",
	1: "MG",
	2: "S LAS",
	3: "M LAS",
	4: "L LAS",
	5: "PPC",
	6: "AC/2",
	7: "AC/5",
	8: "AC/10",
	9: "AC/20",
	10: "SRM-2",
	11: "SRM-4",
	12: "SRM-6",
	13: "LRM-5",
	14: "LRM-10",
	15: "LRM-15",
	16: "LRM-20",
}

const WEAPON_STARTING_AMMO := {
	1: 200,
	6: 45,
	7: 20,
	8: 10,
	9: 5,
	10: 50,
	11: 25,
	12: 15,
	13: 24,
	14: 12,
	15: 8,
	16: 6,
}

const WEAPON_DAMAGE := {
	0: 3,
	1: 2,
	2: 3,
	3: 5,
	4: 8,
	5: 10,
	6: 2,
	7: 5,
	8: 10,
	9: 20,
	10: 4,
	11: 8,
	12: 12,
	13: 5,
	14: 10,
	15: 15,
	16: 20,
}

const WEAPON_HEAT := {
	0: 3,
	1: 0,
	2: 1,
	3: 3,
	4: 8,
	5: 10,
	6: 1,
	7: 1,
	8: 3,
	9: 7,
	10: 2,
	11: 3,
	12: 4,
	13: 2,
	14: 4,
	15: 5,
	16: 6,
}

const WEAPON_COOLDOWN_MS := {
	0: 3000,
	1: 0,
	2: 1000,
	3: 3000,
	4: 8000,
	5: 10000,
	6: 1000,
	7: 1000,
	8: 3000,
	9: 7000,
	10: 2000,
	11: 3000,
	12: 4000,
	13: 2000,
	14: 4000,
	15: 5000,
	16: 6000,
}

const WEAPON_LONG_RANGE_METERS := {
	0: 90,
	1: 90,
	2: 90,
	3: 270,
	4: 450,
	5: 540,
	6: 720,
	7: 540,
	8: 360,
	9: 270,
	10: 270,
	11: 270,
	12: 270,
	13: 630,
	14: 630,
	15: 630,
	16: 630,
}


static func weapon_name(type_id: int) -> String:
	return str(WEAPON_NAMES.get(type_id, "Weapon %d" % type_id))


static func weapon_short_name(type_id: int) -> String:
	return str(WEAPON_SHORT_NAMES.get(type_id, weapon_name(type_id).to_upper()))


static func weapon_damage(type_id: int) -> int:
	return int(WEAPON_DAMAGE.get(type_id, 0))


static func weapon_heat(type_id: int) -> int:
	return int(WEAPON_HEAT.get(type_id, 0))


static func weapon_cooldown_seconds(type_id: int) -> float:
	return float(int(WEAPON_COOLDOWN_MS.get(type_id, 0))) / 1000.0


static func weapon_long_range_meters(type_id: int) -> int:
	return int(WEAPON_LONG_RANGE_METERS.get(type_id, 0))


static func weapon_starting_ammo(type_id: int) -> int:
	return int(WEAPON_STARTING_AMMO.get(type_id, 0))


static func weapon_uses_ammo(type_id: int) -> bool:
	return weapon_starting_ammo(type_id) > 0


static func mech_internal_state_values(tonnage: int) -> Array:
	var group: int = clampi(int(floor(float(tonnage) / 5.0)), 0, INTERNAL_STRUCTURE_TABLE.size() - 1)
	var row: Array = INTERNAL_STRUCTURE_TABLE[group]
	var ct := int(row[0])
	var leg := int(row[1])
	var arm := int(row[2])
	var side := int(row[3])
	return [arm, arm, side, side, ct, leg, leg, 9]


static func load_roster(retail_path: String) -> Dictionary:
	if retail_path.is_empty():
		return _fail("retail asset path not configured")
	var mech_dir := retail_path.path_join("mechdata")
	var msg_path := retail_path.path_join("MPBT.MSG")
	if not DirAccess.dir_exists_absolute(mech_dir):
		return _fail("mechdata directory not found: %s" % mech_dir)
	if not FileAccess.file_exists(msg_path):
		return _fail("MPBT.MSG not found: %s" % msg_path)

	var id_map_result := _load_variant_id_map(msg_path)
	if not id_map_result.get("ok", false):
		return id_map_result
	var variant_ids: Dictionary = id_map_result.get("ids", {})

	var dir := DirAccess.open(mech_dir)
	if dir == null:
		return _fail("cannot open mechdata directory: %s" % mech_dir)

	var files: Array[String] = []
	dir.list_dir_begin()
	var filename := dir.get_next()
	while filename != "":
		if not dir.current_is_dir() and filename.get_extension().to_lower() == "mec":
			files.append(filename)
		filename = dir.get_next()
	dir.list_dir_end()
	files.sort()

	var mechs: Array = []
	var slot := 0
	for file_name in files:
		var type_string := file_name.get_basename().to_upper()
		if not variant_ids.has(type_string):
			continue
		var fields_result := read_mec_fields(mech_dir.path_join(file_name), type_string.to_lower())
		if not fields_result.get("ok", false):
			continue
		var fields: Dictionary = fields_result.get("fields", {})
		var max_speed_mag := _max_speed_mag_from_mec_speed(int(fields.get("mecSpeed", 0)))
		var jump_jets := int(fields.get("jumpJetCount", 0))
		var weapon_type_ids: Array = fields.get("weaponTypeIds", [])
		var armament := PackedStringArray()
		for type_id_v in weapon_type_ids:
			var type_id := int(type_id_v)
			armament.append(weapon_name(type_id))

		var tonnage := int(fields.get("tonnage", 0))
		mechs.append({
			"id": int(variant_ids[type_string]),
			"mechType": 0,
			"slot": slot,
			"typeString": type_string,
			"variant": "",
			"name": "",
			"weightClass": _weight_class_from_tonnage(tonnage),
			"tonnage": tonnage,
			"walkSpeedMag": _walk_speed_mag_from_mec_speed(int(fields.get("mecSpeed", 0))),
			"maxSpeedMag": max_speed_mag,
			"maxSpeedKph": _speed_mag_to_kph(max_speed_mag),
			"jumpJetCount": jump_jets,
			"jumpMeters": null,
			"heatSinks": int(fields.get("heatSinks", 0)),
			"extraCritCount": int(fields.get("extraCritCount", 0)),
			"armorLikeMaxValues": fields.get("armorLikeMaxValues", []),
			"internalStateMaxValues": mech_internal_state_values(tonnage),
			"weaponTypeIds": weapon_type_ids,
			"weaponMountInternalIndices": fields.get("weaponMountInternalIndices", []),
			"ammoBinCapacities": fields.get("ammoBinCapacities", []),
			"ammoBinTypeIds": fields.get("ammoBinTypeIds", []),
			"armament": Array(armament),
			"source": "local-retail",
		})
		slot += 1

	if mechs.is_empty():
		return _fail("no readable .MEC files found in %s" % mech_dir)
	return { "ok": true, "error": "", "mechs": mechs }


static func read_mec_fields(mec_path: String, name_lower: String) -> Dictionary:
	var raw := FileAccess.get_file_as_bytes(mec_path)
	if raw.size() < 0x3E:
		return _fail("%s: too short for .MEC fields" % mec_path)
	var buf := raw.duplicate()
	_decrypt_mec(buf, name_lower)

	var weapon_count := _u16(buf, 0x3A)
	var weapon_type_offset := 0x3E
	var weapon_mount_offset := 0x8E
	var entry_bytes := weapon_count * 2
	if not _can_read(buf, weapon_type_offset, entry_bytes):
		return _fail("%s: too short for weapon type ids" % mec_path)
	if not _can_read(buf, weapon_mount_offset, entry_bytes):
		return _fail("%s: too short for weapon mount refs" % mec_path)

	var ammo_count_offset := 0x1EC
	var ammo_capacity_offset := 0x1EE
	var ammo_type_offset := 0x202
	if not _can_read(buf, ammo_count_offset, 2):
		return _fail("%s: too short for ammo bin count" % mec_path)
	var ammo_bin_count := _u16(buf, ammo_count_offset)
	var ammo_bin_bytes := ammo_bin_count * 2
	if ammo_bin_count > 0xFF:
		return _fail("%s: ammo bin count exceeds Cmd72 limit" % mec_path)
	if not _can_read(buf, ammo_capacity_offset, ammo_bin_bytes):
		return _fail("%s: too short for ammo bin capacities" % mec_path)
	if not _can_read(buf, ammo_type_offset, ammo_bin_bytes):
		return _fail("%s: too short for ammo bin type ids" % mec_path)

	var weapon_type_ids: Array = []
	var weapon_mount_indices: Array = []
	for slot in weapon_count:
		weapon_type_ids.append(_u16(buf, weapon_type_offset + slot * 2))
		weapon_mount_indices.append(_u16(buf, weapon_mount_offset + slot * 2))

	var ammo_caps: Array = []
	var ammo_types: Array = []
	for index in ammo_bin_count:
		ammo_caps.append(_u16(buf, ammo_capacity_offset + index * 2))
		ammo_types.append(_u16(buf, ammo_type_offset + index * 2))

	return {
		"ok": true,
		"error": "",
		"fields": {
			"mecSpeed": _u16(buf, 0x16),
			"tonnage": _u16(buf, 0x18),
			"heatSinks": _u16(buf, 0x34),
			"jumpJetCount": _u16(buf, 0x38),
			"extraCritCount": _s16(buf, 0x3C),
			"armorLikeMaxValues": [
				_u16(buf, 0x1A), _u16(buf, 0x1C), _u16(buf, 0x1E),
				_u16(buf, 0x20), _u16(buf, 0x22), _u16(buf, 0x24),
				_u16(buf, 0x26), _u16(buf, 0x28), _u16(buf, 0x2A),
				_u16(buf, 0x2C),
			],
			"weaponTypeIds": weapon_type_ids,
			"weaponMountInternalIndices": weapon_mount_indices,
			"ammoBinCapacities": ammo_caps,
			"ammoBinTypeIds": ammo_types,
		},
	}


static func _load_variant_id_map(msg_path: String) -> Dictionary:
	var file := FileAccess.open(msg_path, FileAccess.READ)
	if file == null:
		return _fail("cannot open MPBT.MSG: %s" % msg_path)
	var lines := file.get_as_text().split("\n", false)
	if lines.size() < VARIANT_BASE_1 + VARIANT_LAST_ID:
		return _fail("MPBT.MSG too short for variant id table")

	var ids := {}
	for id in VARIANT_LAST_ID + 1:
		var line := str(lines[VARIANT_BASE_1 + id - 1]).strip_edges().to_upper()
		if not line.is_empty():
			ids[line] = id
	return { "ok": true, "error": "", "ids": ids }


static func _decrypt_mec(buf: PackedByteArray, name_lower: String) -> void:
	var state := _mec_seed(name_lower)
	var limit := buf.size() - 3
	for i in limit:
		state = _mec_lcg_step(state)
		var word := _u32(buf, i)
		_put_u32(buf, i, _u32_mask(word ^ state))


static func _mec_seed(name_lower: String) -> int:
	var n := name_lower.length()
	if n < 4:
		return 0
	var b0 := name_lower.unicode_at(n - 1) & 0xFF
	var b1 := name_lower.unicode_at(n - 2) & 0xFF
	var b2 := name_lower.unicode_at(n - 3) & 0xFF
	var b3 := name_lower.unicode_at(n - 4) & 0xFF
	return _u32_mask(b0 | (b1 << 8) | (b2 << 16) | (b3 << 24))


static func _mec_lcg_step(state: int) -> int:
	var temp := _u32_mask(state * 0xF0F1 + 1)
	var rotated := _u32_mask((temp << 16) | (temp >> 16))
	return _u32_mask(temp + rotated)


static func _walk_speed_mag_from_mec_speed(mec_speed: int) -> int:
	return mec_speed * 300


static func _max_speed_mag_from_mec_speed(mec_speed: int) -> int:
	var run_mp_times_10 := mec_speed * 15
	var run_mp := int(floor(float(run_mp_times_10) / 10.0))
	if run_mp_times_10 % 10 >= 5:
		run_mp += 1
	return run_mp * 300


static func _speed_mag_to_kph(speed_mag: int) -> int:
	if speed_mag <= 0:
		return 0
	return int(round(float(speed_mag) * 16.2 / 450.0))


static func _weight_class_from_tonnage(tonnage: int) -> String:
	if tonnage <= 35:
		return "light"
	if tonnage <= 55:
		return "medium"
	if tonnage <= 75:
		return "heavy"
	return "assault"


static func _can_read(buf: PackedByteArray, offset: int, byte_length: int) -> bool:
	return offset >= 0 and byte_length >= 0 and offset + byte_length <= buf.size()


static func _u16(buf: PackedByteArray, offset: int) -> int:
	return int(buf[offset]) | (int(buf[offset + 1]) << 8)


static func _s16(buf: PackedByteArray, offset: int) -> int:
	var value := _u16(buf, offset)
	return value - 0x10000 if value & 0x8000 else value


static func _u32(buf: PackedByteArray, offset: int) -> int:
	return _u32_mask(
		int(buf[offset])
		| (int(buf[offset + 1]) << 8)
		| (int(buf[offset + 2]) << 16)
		| (int(buf[offset + 3]) << 24)
	)


static func _put_u32(buf: PackedByteArray, offset: int, value: int) -> void:
	var v := _u32_mask(value)
	buf[offset] = v & 0xFF
	buf[offset + 1] = (v >> 8) & 0xFF
	buf[offset + 2] = (v >> 16) & 0xFF
	buf[offset + 3] = (v >> 24) & 0xFF


static func _u32_mask(value: int) -> int:
	return value & 0xFFFFFFFF


static func _fail(msg: String) -> Dictionary:
	return { "ok": false, "error": msg, "mechs": [], "ids": {}, "fields": {} }
