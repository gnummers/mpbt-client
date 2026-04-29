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
const AUDIO_EXTS := [".ogg", ".wav", ".mp3"]
const MAP_EXTS   := [".map"]

const CATEGORY_DIRS := {
	"UI": ["ui"],
	"Combat": ["combat"],
	"Icons": ["icons"],
	"Maps": ["maps", "misc"],
	"Scenes": ["scenes"],
}


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


static func find_image(base_path: String, categories: Array, hints: Array) -> String:
	if base_path.is_empty() or not DirAccess.dir_exists_absolute(base_path):
		return ""

	var files: Array = []
	for category_v in categories:
		var category := str(category_v)
		for dir_path in _category_paths(base_path, category):
			files.append_array(_scan_dir_recursive(dir_path, IMAGE_EXTS))

	return _best_match(files, hints)


static func load_image_texture(path: String) -> Texture2D:
	if path.is_empty():
		return null
	var img := Image.load_from_file(path)
	if img == null or img.is_empty():
		return null
	return ImageTexture.create_from_image(img)


static func find_audio(base_path: String, track_name: String, kind: String) -> String:
	if base_path.is_empty() or not DirAccess.dir_exists_absolute(base_path):
		return ""

	var dirs: Array = []
	if kind == "bgm":
		dirs = [
			base_path.path_join("audio/bgm"),
			base_path.path_join("audio/music"),
			base_path.path_join("music"),
			base_path.path_join("bgm"),
		]
	else:
		dirs = [
			base_path.path_join("audio/sfx"),
			base_path.path_join("audio/sounds"),
			base_path.path_join("sfx"),
			base_path.path_join("sounds"),
		]

	var files: Array = []
	for dir_path: String in dirs:
		files.append_array(_scan_dir_recursive(dir_path, AUDIO_EXTS))

	return _best_match(files, [track_name])


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


static func _category_paths(base_path: String, category: String) -> Array:
	var dirs: Array = []
	for dir_name in CATEGORY_DIRS.get(category, [category.to_lower()]):
		dirs.append(base_path.path_join(str(dir_name)))
	return dirs


static func _scan_dir_recursive(path: String, exts: Array) -> Array:
	var files: Array = []
	var dir := DirAccess.open(path)
	if dir == null:
		return files

	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		var child_path := path.path_join(name)
		if dir.current_is_dir():
			if not name.begins_with("."):
				files.append_array(_scan_dir_recursive(child_path, exts))
		else:
			var ext := "." + name.get_extension().to_lower()
			if ext in exts:
				files.append(child_path)
		name = dir.get_next()
	dir.list_dir_end()
	files.sort()
	return files


static func _best_match(files: Array, hints: Array) -> String:
	if files.is_empty():
		return ""

	var best_path := str(files[0])
	var best_score := -1
	for file_v in files:
		var path := str(file_v)
		var name := path.get_file().get_basename().to_lower()
		var score := 0
		for i in hints.size():
			var hint := str(hints[i]).strip_edges().to_lower()
			if hint.is_empty():
				continue
			if name == hint:
				score += 1000
			elif name.begins_with(hint):
				score += 300
			elif name.contains(hint):
				score += 100 - i
		if score > best_score:
			best_score = score
			best_path = path

	return best_path
