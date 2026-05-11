extends SceneTree

const M6Parity := preload("res://scripts/combat/m6_parity.gd")


func _init() -> void:
	var failures: Array[String] = []
	_test_weapon_range_boundary(failures)
	_test_model13_attachment_52_z_strata(failures)
	_test_damage_detail_row_annotations(failures)

	if failures.is_empty():
		print("m6_parity_slice_smoke passed")
		quit(0)
		return

	for failure in failures:
		push_error(failure)
	quit(1)


func _test_weapon_range_boundary(failures: Array[String]) -> void:
	var at_boundary := M6Parity.build_weapon_range_validity([0, 4, 99], 0, 90.0)
	if at_boundary.get("selectedWithinMaxRange", null) != true:
		failures.append("flamer 90m should remain within selected max range")
	if at_boundary.get("anyWeaponWithinMaxRange", null) != true:
		failures.append("90m should remain within at least one weapon max range")
	if int(at_boundary.get("selectedRangeBandIndex", -1)) != 2:
		failures.append("flamer 90m should classify as long range")

	var beyond_boundary := M6Parity.build_weapon_range_validity([0, 4, 99], 0, 91.0)
	if beyond_boundary.get("selectedWithinMaxRange", null) != false:
		failures.append("flamer 91m should exceed selected max range")
	if beyond_boundary.get("anyWeaponWithinMaxRange", null) != true:
		failures.append("91m should still remain within loadout-wide max range via large laser")


func _test_model13_attachment_52_z_strata(failures: Array[String]) -> void:
	if M6Parity.resolve_attachment_internal_index(31, 52, 0.0) != 5:
		failures.append("model-13 attach 52 at z=0 should map to left-leg/internal 5")
	if M6Parity.resolve_attachment_internal_index(31, 52, 500.0) != 6:
		failures.append("model-13 attach 52 at z=500 should map to right-leg/internal 6")
	if M6Parity.resolve_attachment_internal_index(31, 52, 5000.0) != 0:
		failures.append("model-13 attach 52 at z=5000 should map to left-arm/internal 0")


func _test_damage_detail_row_annotations(failures: Array[String]) -> void:
	var left_leg := M6Parity.critical_detail_row_annotation(8)
	if left_leg.get("armor_row_index", null) != 7 or left_leg.get("internal_row_index", null) != 0:
		failures.append("detail row 8 should map to armor 7 and internal 0")

	var right_leg := M6Parity.critical_detail_row_annotation(12)
	if right_leg.get("armor_row_index", null) != 8:
		failures.append("detail row 12 should map to armor 8")
	if right_leg.get("internal_row_index", null) != null:
		failures.append("detail row 12 should not map to an internal row")

	for row in [16, 19, 20]:
		var annotation := M6Parity.critical_detail_row_annotation(row)
		if annotation.get("internal_row_index", null) != 4:
			failures.append("detail row %d should map to CT internal row 4" % row)
