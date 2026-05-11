class_name M8BinaryProbe
extends RefCounted

const _MAX_SECTION_ROWS := 64


static func probe_blob(kind: String, bytes: PackedByteArray) -> Dictionary:
	match kind:
		"3dobj":
			return _with_stable_json(_probe_3dobj(bytes))
		"keyframe":
			return _with_stable_json(_probe_keyframe(bytes))
		"terrain":
			return _with_stable_json(_probe_terrain(bytes))
	return _with_stable_json({
		"ok": false,
		"kind": kind,
		"blobSize": bytes.size(),
		"error": "unsupported probe kind",
	})


static func stable_metadata_json(metadata: Variant) -> String:
	return JSON.stringify(metadata, "", true)


static func _with_stable_json(metadata: Dictionary) -> Dictionary:
	return {
		"metadata": metadata,
		"stableJson": stable_metadata_json(metadata),
	}


static func _probe_3dobj(bytes: PackedByteArray) -> Dictionary:
	if bytes.size() < 8:
		return _guard_error("3dobj", bytes.size(), "3dobj probe requires at least 8 bytes")

	var declared_section_count := _read_u32_le(bytes, 4)
	var sections := _probe_u32_sections(bytes, 8, declared_section_count)
	var payload_offset := mini(bytes.size(), 8 + sections.size() * 8)
	var metadata := {
		"ok": true,
		"kind": "3dobj",
		"blobSize": bytes.size(),
		"headerSignatureLe": _read_u32_le(bytes, 0),
		"declaredSectionCount": declared_section_count,
		"sectionTableInBounds": _section_table_fits(bytes.size(), 8, declared_section_count),
		"sections": sections,
		"payloadRecordSizeHypotheses": _build_record_hypotheses(bytes.size() - payload_offset, [12, 16, 20, 24, 28, 32]),
	}

	if not sections.is_empty():
		var first_section: Dictionary = sections[0]
		var section_byte_count: int = int(first_section["size"]) if bool(first_section["inBounds"]) else bytes.size() - payload_offset
		metadata["renderScaffold"] = {
			"vertexSectionIndex": int(first_section["index"]),
			"vertexStrideHypotheses": _build_record_hypotheses(section_byte_count, [12, 16, 20, 24, 32]),
			"indexStrideHypotheses": _build_record_hypotheses(section_byte_count, [2, 4]),
		}
	else:
		metadata["renderScaffold"] = {
			"vertexSectionIndex": null,
			"vertexStrideHypotheses": [],
			"indexStrideHypotheses": [],
		}

	return metadata


static func _probe_keyframe(bytes: PackedByteArray) -> Dictionary:
	if bytes.size() < 8:
		return _guard_error("keyframe", bytes.size(), "keyframe probe requires at least 8 bytes")

	var declared_section_count := _read_u32_le(bytes, 4)
	var sections := _probe_u32_sections(bytes, 8, declared_section_count)
	var payload_offset := mini(bytes.size(), 8 + sections.size() * 8)
	var metadata := {
		"ok": true,
		"kind": "keyframe",
		"blobSize": bytes.size(),
		"headerSignatureLe": _read_u32_le(bytes, 0),
		"declaredSectionCount": declared_section_count,
		"sectionTableInBounds": _section_table_fits(bytes.size(), 8, declared_section_count),
		"sections": sections,
		"payloadRecordSizeHypotheses": _build_record_hypotheses(bytes.size() - payload_offset, [8, 12, 16, 20, 24, 32]),
	}

	if not sections.is_empty():
		var first_section: Dictionary = sections[0]
		var section_byte_count: int = int(first_section["size"]) if bool(first_section["inBounds"]) else bytes.size() - payload_offset
		metadata["animationScaffold"] = {
			"transformSectionIndex": int(first_section["index"]),
			"transformStrideHypotheses": _build_record_hypotheses(section_byte_count, [12, 16, 24, 32, 48]),
			"timingStrideHypotheses": _build_record_hypotheses(section_byte_count, [2, 4, 6, 8]),
		}
	else:
		metadata["animationScaffold"] = {
			"transformSectionIndex": null,
			"transformStrideHypotheses": [],
			"timingStrideHypotheses": [],
		}

	return metadata


static func _probe_terrain(bytes: PackedByteArray) -> Dictionary:
	if bytes.size() < 4:
		return _guard_error("terrain", bytes.size(), "terrain probe requires at least 4 bytes")

	var chunk_count := _read_u16_le(bytes, 0)
	var chunk_sections := _probe_u32_sections(bytes, 2, chunk_count)
	var chunk_fits_blob := _section_table_fits(bytes.size(), 2, chunk_count)

	var hypotheses: Array = [{
		"kind": "chunk_table_hypothesis",
		"structurallyValid": chunk_fits_blob,
		"declaredRecordCount": chunk_count,
		"consumedBytes": mini(bytes.size(), 2 + chunk_sections.size() * 8),
		"note": "u16 count + [offset,size] pairs as a table hypothesis",
		"sections": chunk_sections,
	}]

	var width := _read_u16_le(bytes, 0)
	var height := _read_u16_le(bytes, 2)
	var cell_count := width * height
	if width > 0 and height > 0:
		var expected_bytes := 4 + cell_count * 2
		var structurally_valid := expected_bytes <= bytes.size()
		var consumed_bytes := mini(expected_bytes, bytes.size())
		var payload_bytes := maxi(0, consumed_bytes - 4)
		hypotheses.append({
			"kind": "height_grid_16bit_hypothesis",
			"structurallyValid": structurally_valid,
			"declaredRecordCount": cell_count,
			"consumedBytes": consumed_bytes,
			"note": "u16 width/height + 16-bit payload as a grid hypothesis",
			"sections": [{
				"index": 0,
				"offset": 4,
				"size": payload_bytes,
				"inBounds": structurally_valid,
			}],
		})
	else:
		hypotheses.append({
			"kind": "height_grid_16bit_hypothesis",
			"structurallyValid": false,
			"declaredRecordCount": 0,
			"consumedBytes": 4,
			"note": "invalid width/height for 16-bit grid hypothesis",
			"sections": [],
		})

	return {
		"ok": true,
		"kind": "terrain",
		"blobSize": bytes.size(),
		"headerSignatureLe": _read_u32_le(bytes, 0),
		"hypotheses": hypotheses,
		"payloadRecordSizeHypotheses": _build_record_hypotheses(bytes.size() - 4, [2, 4, 8, 16, 32]),
	}


static func _probe_u32_sections(bytes: PackedByteArray, section_table_offset: int, declared_section_count: int) -> Array:
	var max_entries_by_size := 0
	if section_table_offset <= bytes.size():
		max_entries_by_size = int((bytes.size() - section_table_offset) / 8)

	var probe_count := mini(_MAX_SECTION_ROWS, mini(declared_section_count, max_entries_by_size))
	var sections: Array = []
	for index in range(probe_count):
		var entry_offset := section_table_offset + index * 8
		var section_offset := _read_u32_le(bytes, entry_offset)
		var section_size := _read_u32_le(bytes, entry_offset + 4)
		var in_bounds := section_offset <= bytes.size() and section_size <= (bytes.size() - section_offset)
		sections.append({
			"index": index,
			"offset": section_offset,
			"size": section_size,
			"inBounds": in_bounds,
		})
	return sections


static func _section_table_fits(byte_count: int, section_table_offset: int, declared_section_count: int) -> bool:
	if section_table_offset > byte_count:
		return false
	return declared_section_count <= int((byte_count - section_table_offset) / 8)


static func _build_record_hypotheses(byte_count: int, candidates: Array) -> Array:
	var hypotheses: Array = []
	for candidate_v in candidates:
		var candidate := int(candidate_v)
		if candidate <= 0:
			continue
		hypotheses.append({
			"recordSize": candidate,
			"fullRecordCount": int(byte_count / candidate),
			"trailingBytes": int(byte_count % candidate),
			"exactFit": int(byte_count % candidate) == 0,
		})
	return hypotheses


static func _read_u16_le(bytes: PackedByteArray, offset: int) -> int:
	if offset + 1 >= bytes.size():
		return -1
	return int(bytes[offset]) | int(bytes[offset + 1]) << 8


static func _read_u32_le(bytes: PackedByteArray, offset: int) -> int:
	if offset + 3 >= bytes.size():
		return -1
	return int(bytes[offset]) | (int(bytes[offset + 1]) << 8) | (int(bytes[offset + 2]) << 16) | (int(bytes[offset + 3]) << 24)


static func _guard_error(kind: String, blob_size: int, reason: String) -> Dictionary:
	return {
		"ok": false,
		"kind": kind,
		"blobSize": blob_size,
		"error": reason,
	}
