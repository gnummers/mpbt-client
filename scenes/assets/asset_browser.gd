extends Control

const MAIN_SCENE := "res://scenes/main/main.tscn"

@onready var path_label: Label       = %PathLabel
@onready var category_option: OptionButton = %CategoryOption
@onready var file_list: ItemList     = %FileList
@onready var image_view: TextureRect = %ImageView
@onready var map_view: RichTextLabel = %MapView
@onready var info_label: Label       = %InfoLabel

var _registry: Dictionary = {}
var _current_files: Array = []


func _ready() -> void:
	var asset_path := ClientConfig.asset_extracted_path()
	if asset_path.is_empty():
		path_label.text = "(asset path not configured)"
		info_label.text = "Set assets.extracted_path in config/local.json — see docs/CONFIG.md"
		return

	_registry = AssetRegistry.scan(asset_path)
	if not _registry.get("ok", false):
		path_label.text = asset_path
		path_label.modulate = Color(1.0, 0.4, 0.4)
		info_label.text = "Scan error: %s" % _registry.get("error", "unknown")
		return

	path_label.text = asset_path
	for cat_name in _registry.get("categories", {}).keys():
		category_option.add_item(cat_name)

	if category_option.item_count > 0:
		_load_category(0)


func _load_category(idx: int) -> void:
	var cats: Dictionary = _registry.get("categories", {})
	var cat_names := cats.keys()
	if idx >= cat_names.size():
		return
	_current_files = cats[cat_names[idx]]
	file_list.clear()
	for fpath: String in _current_files:
		file_list.add_item(fpath.get_file())
	_clear_preview()


func _clear_preview() -> void:
	image_view.texture = null
	image_view.visible = false
	map_view.visible = false
	info_label.text = "Select a file to preview"
	info_label.modulate = Color(0.6, 0.6, 0.6, 1)


func _on_category_selected(idx: int) -> void:
	_load_category(idx)


func _on_file_selected(idx: int) -> void:
	if idx < 0 or idx >= _current_files.size():
		return
	var path: String = _current_files[idx]
	match path.get_extension().to_lower():
		"png", "bmp", "jpg", "jpeg":
			_show_image(path)
		"map":
			_show_map(path)
		_:
			info_label.text = "No preview for .%s files" % path.get_extension()
			info_label.modulate = Color(0.6, 0.6, 0.6, 1)


func _show_image(path: String) -> void:
	var img := Image.load_from_file(path)
	if img == null or img.is_empty():
		info_label.text = "Failed to load: %s" % path.get_file()
		info_label.modulate = Color(1.0, 0.4, 0.4)
		_clear_preview()
		return
	image_view.texture = ImageTexture.create_from_image(img)
	image_view.visible = true
	map_view.visible = false
	info_label.text = "%s  —  %d × %d" % [path.get_file(), img.get_width(), img.get_height()]
	info_label.modulate = Color(0.8, 0.8, 0.8, 1)


func _show_map(path: String) -> void:
	var result := MapParser.parse(path)
	if not result.get("ok", false):
		info_label.text = "Parse error: %s" % result.get("error", "unknown")
		info_label.modulate = Color(1.0, 0.4, 0.4)
		_clear_preview()
		return

	var rooms: Array = result.get("rooms", [])
	var lines := PackedStringArray()
	lines.append("[b]%s[/b]   %d rooms   (picture record at 0x%x)" % [
		path.get_file(), rooms.size(), result.get("next_offset", 0),
	])
	lines.append("")

	# Group by district.
	var by_district: Dictionary = {}
	for r in rooms:
		var dn: String = r.get("district_name", "Unknown")
		if not by_district.has(dn):
			by_district[dn] = []
		by_district[dn].append(r)

	for dist_name in MapParser.DISTRICTS:
		if not by_district.has(dist_name):
			continue
		var dist_rooms: Array = by_district[dist_name]
		# find sector room for terrain
		var terrain := ""
		for r in dist_rooms:
			if r.get("is_sector", false):
				terrain = MapParser.terrain_from_description(r.get("description", ""))
				break
		var header := "[b]%s[/b]" % dist_name
		if terrain.length() > 0:
			header += "  [color=gray](%s)[/color]" % terrain
		lines.append(header)
		for r in dist_rooms:
			if r.get("is_sector", false):
				continue
			var cx := (int(r.get("x1", 0)) + int(r.get("x2", 0))) / 2
			var cy := (int(r.get("y1", 0)) + int(r.get("y2", 0))) / 2
			lines.append("  [b]%s[/b]  [color=gray]map (%d, %d)  label %d×%d[/color]" % [
				r.get("name", ""), cx, cy,
				r.get("label_w", 0), r.get("label_h", 0),
			])
			var desc: String = r.get("description", "")
			if desc.length() > 0:
				lines.append("    [color=#888888]%s[/color]" % desc)
		lines.append("")

	map_view.text = "\n".join(lines)
	map_view.visible = true
	image_view.visible = false
	info_label.text = "%s — %d rooms across %d districts" % [
		path.get_file(), rooms.size(),
		by_district.size(),
	]
	info_label.modulate = Color(0.8, 0.8, 0.8, 1)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)
