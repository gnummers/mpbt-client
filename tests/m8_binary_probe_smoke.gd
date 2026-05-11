extends SceneTree

const M8BinaryProbe := preload("res://scripts/research/m8_binary_probe.gd")


func _init() -> void:
	var failures: Array[String] = []
	_test_3dobj_probe_determinism(failures)
	_test_keyframe_and_terrain_hypotheses(failures)
	_test_probe_guards(failures)

	if failures.is_empty():
		print("m8_binary_probe_smoke passed")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)


func _test_3dobj_probe_determinism(failures: Array[String]) -> void:
	var fixture := _build_3dobj_fixture()
	var first := M8BinaryProbe.probe_blob("3dobj", fixture)
	var second := M8BinaryProbe.probe_blob("3dobj", fixture)
	var first_json := str(first.get("stableJson", ""))
	var second_json := str(second.get("stableJson", ""))
	if first_json == "" or first_json != second_json:
		failures.append("3dobj probe output should be deterministic across repeated runs")
		return

	var metadata: Dictionary = first.get("metadata", {})
	if metadata.get("ok", null) != true:
		failures.append("3dobj probe should mark synthetic fixture as valid")
	if int(metadata.get("declaredSectionCount", -1)) != 2:
		failures.append("3dobj probe should decode synthetic section count")
	var sections: Array = metadata.get("sections", [])
	if sections.size() != 2:
		failures.append("3dobj probe should decode both synthetic sections")
	var render_scaffold: Dictionary = metadata.get("renderScaffold", {})
	if render_scaffold.get("vertexSectionIndex", null) != 0:
		failures.append("3dobj scaffold should anchor vertex section index to section 0")
	if not _has_exact_fit(render_scaffold.get("vertexStrideHypotheses", []), 12):
		failures.append("3dobj scaffold should include 12-byte exact-fit hypothesis")


func _test_keyframe_and_terrain_hypotheses(failures: Array[String]) -> void:
	var keyframe_probe: Dictionary = M8BinaryProbe.probe_blob("keyframe", _build_keyframe_fixture()).get("metadata", {})
	if keyframe_probe.get("ok", null) != true:
		failures.append("keyframe probe should mark synthetic fixture as valid")
	var animation_scaffold: Dictionary = keyframe_probe.get("animationScaffold", {})
	if animation_scaffold.get("transformSectionIndex", null) != 0:
		failures.append("keyframe scaffold should anchor transform section index to section 0")
	if not _has_exact_fit(animation_scaffold.get("transformStrideHypotheses", []), 16):
		failures.append("keyframe scaffold should include 16-byte transform exact-fit hypothesis")

	var terrain_probe: Dictionary = M8BinaryProbe.probe_blob("terrain", _build_terrain_chunk_fixture()).get("metadata", {})
	if terrain_probe.get("ok", null) != true:
		failures.append("terrain probe should mark synthetic fixture as valid")
	var hypotheses: Array = terrain_probe.get("hypotheses", [])
	if hypotheses.size() != 2:
		failures.append("terrain probe should emit chunk-table and height-grid hypotheses")
	elif hypotheses[0].get("kind", "") != "chunk_table_hypothesis":
		failures.append("terrain hypothesis[0] should remain chunk-table scoped")


func _test_probe_guards(failures: Array[String]) -> void:
	var short_blob := PackedByteArray([0x01, 0x02, 0x03])
	for kind in ["3dobj", "keyframe", "terrain"]:
		var metadata: Dictionary = M8BinaryProbe.probe_blob(kind, short_blob).get("metadata", {})
		if metadata.get("ok", null) != false:
			failures.append("%s guard should reject short fixture" % kind)
		if not str(metadata.get("error", "")).contains("requires at least"):
			failures.append("%s guard should return explicit minimum-byte reason" % kind)

	var unsupported: Dictionary = M8BinaryProbe.probe_blob("unknown", PackedByteArray([0, 1, 2, 3])).get("metadata", {})
	if unsupported.get("ok", null) != false:
		failures.append("unsupported kind should return a guard error")


func _has_exact_fit(hypotheses: Array, expected_record_size: int) -> bool:
	for hypothesis_v in hypotheses:
		var hypothesis: Dictionary = hypothesis_v
		if int(hypothesis.get("recordSize", -1)) == expected_record_size and bool(hypothesis.get("exactFit", false)):
			return true
	return false


func _append_u16_le(bytes: PackedByteArray, value: int) -> PackedByteArray:
	bytes.append(value & 0xFF)
	bytes.append((value >> 8) & 0xFF)
	return bytes


func _append_u32_le(bytes: PackedByteArray, value: int) -> PackedByteArray:
	bytes.append(value & 0xFF)
	bytes.append((value >> 8) & 0xFF)
	bytes.append((value >> 16) & 0xFF)
	bytes.append((value >> 24) & 0xFF)
	return bytes


func _build_3dobj_fixture() -> PackedByteArray:
	var bytes := PackedByteArray()
	bytes = _append_u32_le(bytes, 0x334A424F)  # "OBJ3"
	bytes = _append_u32_le(bytes, 2)
	bytes = _append_u32_le(bytes, 24)
	bytes = _append_u32_le(bytes, 12)
	bytes = _append_u32_le(bytes, 36)
	bytes = _append_u32_le(bytes, 8)
	for value in range(1, 21):
		bytes.append(value)
	return bytes


func _build_keyframe_fixture() -> PackedByteArray:
	var bytes := PackedByteArray()
	bytes = _append_u32_le(bytes, 0x59454B46)  # "FKEY"
	bytes = _append_u32_le(bytes, 1)
	bytes = _append_u32_le(bytes, 16)
	bytes = _append_u32_le(bytes, 16)
	for value in range(0xA0, 0xB0):
		bytes.append(value)
	return bytes


func _build_terrain_chunk_fixture() -> PackedByteArray:
	var bytes := PackedByteArray()
	bytes = _append_u16_le(bytes, 2)
	bytes = _append_u32_le(bytes, 18)
	bytes = _append_u32_le(bytes, 4)
	bytes = _append_u32_le(bytes, 22)
	bytes = _append_u32_le(bytes, 2)
	bytes.append_array(PackedByteArray([0xAA, 0xBB, 0xCC, 0xDD, 0x11, 0x22]))
	return bytes
