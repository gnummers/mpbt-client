class_name AssetRegistry

## Scans a pre-organized MPBT extracted-asset directory and returns a
## categorized file catalog.
##
## Expected layout under base_path:
##   combat/   *.png  — combat HUD sprites
##   icons/    *.png  — weapon and mech icons
##   maps/     *.png  — visual map backgrounds
##   misc/     *.map  — binary room-record files (e.g. Solaris.map)
##   scenes/   *.png  — scene art (victory, defeat, drop zone)
##   ui/       *.png  — UI elements and title art
##
## Returns:
##   { ok: bool, error: String, categories: Dictionary }
##   categories maps category name -> Array of absolute file paths (sorted).

const IMAGE_EXTS := [".png", ".bmp", ".jpg", ".jpeg"]
const MAP_EXTS   := [".map"]


static func scan(base_path: String) -> Dictionary:
	if base_path.is_empty():
		return _fail("asset path not configured")
	if not DirAccess.dir_exists_absolute(base_path):
		return _fail("directory not found: %s" % base_path)

	var map_imgs := _scan_dir(base_path.path_join("maps"),  IMAGE_EXTS)
	var map_bins := _scan_dir(base_path.path_join("misc"),  MAP_EXTS)
	var maps_combined: Array = map_imgs.duplicate()
	maps_combined.append_array(map_bins)

	var categories := {
		"UI":     _scan_dir(base_path.path_join("ui"),     IMAGE_EXTS),
		"Combat": _scan_dir(base_path.path_join("combat"), IMAGE_EXTS),
		"Icons":  _scan_dir(base_path.path_join("icons"),  IMAGE_EXTS),
		"Maps":   maps_combined,
		"Scenes": _scan_dir(base_path.path_join("scenes"), IMAGE_EXTS),
	}

	return { "ok": true, "error": "", "categories": categories }


static func _fail(msg: String) -> Dictionary:
	return { "ok": false, "error": msg, "categories": {} }


static func _scan_dir(path: String, exts: Array) -> Array:
	var files: Array = []
	var dir := DirAccess.open(path)
	if dir == null:
		return files
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if not dir.current_is_dir():
			var ext := "." + name.get_extension().to_lower()
			if ext in exts:
				files.append(path.path_join(name))
		name = dir.get_next()
	dir.list_dir_end()
	files.sort()
	return files
