extends Control

## Mech Bay — browse and select the player's BattleMech.
##
## Loads the full mech roster from GET /mechs on mpbt-server.
## Saves the selection via PATCH /world/mech/select (X-Username auth).
## Updates AuthSession.character["mech_id"] locally after a successful save.

const MAIN_SCENE := "res://scenes/main/main.tscn"
const MECH_PORTRAIT_ALIASES := {
	"banshee": ["bnc1"],
	"centurion": ["cn91"],
	"catapult": ["cplt"],
	"hunchback": ["hbck"],
	"jenner": ["jenr"],
	"orion": ["orio"],
	"spider": ["sdr1"],
	"stalker": ["stkr"],
}

@onready var _current_mech_label: Label  = $MainVBox/Header/CurrentMechLabel
@onready var _mech_list: ItemList        = $MainVBox/ContentHBox/ListPanel/ListVBox/MechList
@onready var _desig_label: Label         = $MainVBox/ContentHBox/DetailPanel/DetailMargin/DetailVBox/DesigLabel
@onready var _name_label: Label          = $MainVBox/ContentHBox/DetailPanel/DetailMargin/DetailVBox/NameLabel
@onready var _portrait_art: TextureRect  = $MainVBox/ContentHBox/DetailPanel/DetailMargin/DetailVBox/PortraitArt
@onready var _info_label: Label          = $MainVBox/ContentHBox/DetailPanel/DetailMargin/DetailVBox/InfoLabel
@onready var _weap_label: Label          = $MainVBox/ContentHBox/DetailPanel/DetailMargin/DetailVBox/WeapLabel
@onready var _status_label: Label        = $MainVBox/ContentHBox/DetailPanel/DetailMargin/DetailVBox/StatusLabel
@onready var _select_button: Button      = $MainVBox/ContentHBox/DetailPanel/DetailMargin/DetailVBox/SelectButton

var _mech_client: MechClient
var _all_mechs: Array = []
var _filtered_mechs: Array = []
var _selected_mech: Dictionary = {}
var _current_filter: String = "all"
var _using_local_roster: bool = false


func _ready() -> void:
	AudioManager.play_bgm("world")
	_mech_client = MechClient.new()
	add_child(_mech_client)
	_mech_client.mechs_loaded.connect(_on_mechs_loaded)
	_mech_client.mechs_failed.connect(_on_mechs_failed)
	_mech_client.mech_selected.connect(_on_mech_selected)
	_mech_client.mech_failed.connect(_on_mech_failed)

	_update_current_label()
	_clear_detail()
	_status_label.text = "Loading mechs..."

	if ServerBridge.game_api_url.is_empty():
		_load_local_roster("Game server not available")
		return
	_mech_client.fetch_mechs(ServerBridge.game_api_url)


func _update_current_label() -> void:
	var cur_id = AuthSession.character.get("mech_id", null)
	if cur_id == null:
		_current_mech_label.text = "Current: none"
	else:
		# Try to find the typeString from the loaded list.
		var ts := _find_type_string(int(cur_id))
		_current_mech_label.text = "Current: %s" % (ts if ts else "mech #%d" % int(cur_id))


func _find_type_string(mech_id: int) -> String:
	for m in _all_mechs:
		if int(m.get("id", -1)) == mech_id:
			return str(m.get("typeString", ""))
	return ""


func _on_mechs_loaded(mechs: Array) -> void:
	_all_mechs = mechs
	_using_local_roster = false
	_apply_filter()
	_update_current_label()
	# Pre-select the player's current mech if one is set.
	var cur_id = AuthSession.character.get("mech_id", null)
	if cur_id != null:
		_try_preselect(int(cur_id))
	else:
		_status_label.text = "%d mechs available" % mechs.size()


func _on_mechs_failed(reason: String) -> void:
	_load_local_roster("Failed to load server mechs: " + reason)


func _load_local_roster(prefix: String) -> void:
	var result := MecParser.load_roster(ClientConfig.retail_asset_path())
	if not result.get("ok", false):
		_status_label.text = "%s; local retail roster unavailable: %s" % [
			prefix,
			result.get("error", "unknown"),
		]
		return
	_all_mechs = result.get("mechs", [])
	_using_local_roster = true
	_apply_filter()
	_update_current_label()
	var cur_id = AuthSession.character.get("mech_id", null)
	if cur_id != null:
		_try_preselect(int(cur_id))
	_status_label.text = "%s; loaded %d local retail mechs" % [prefix, _all_mechs.size()]


func _apply_filter() -> void:
	_filtered_mechs.clear()
	_mech_list.clear()
	for m in _all_mechs:
		var wc: String = m.get("weightClass", "")
		if _current_filter != "all" and wc != _current_filter:
			continue
		_filtered_mechs.append(m)
		var designation: String = m.get("typeString", "?")
		var chassis: String = m.get("name", "")
		var label := "%s  %s" % [designation, chassis] if not chassis.is_empty() else designation
		_mech_list.add_item(label)
	_selected_mech = {}
	_clear_detail()


func _clear_detail() -> void:
	_desig_label.text = "Select a mech from the list"
	_name_label.text = ""
	_portrait_art.texture = null
	_portrait_art.visible = false
	_info_label.text = ""
	_weap_label.text = ""
	_select_button.disabled = true
	_select_button.text = "Select This Mech"


func _try_preselect(mech_id: int) -> void:
	for i in _filtered_mechs.size():
		if int(_filtered_mechs[i].get("id", -1)) == mech_id:
			_mech_list.select(i)
			_on_item_selected(i)
			return


func _show_mech(m: Dictionary) -> void:
	_selected_mech = m
	_desig_label.text = str(m.get("typeString", "?"))

	var chassis: String = m.get("name", "")
	_name_label.text = chassis if not chassis.is_empty() else "(unknown)"

	var wc: String = str(m.get("weightClass", "")).capitalize()
	var tonnage = m.get("tonnage", null)
	var speed   = m.get("maxSpeedKph", null)
	var armor   = m.get("armor", null)
	var jump    = m.get("jumpMeters", null)
	var jump_jets := int(m.get("jumpJetCount", 0))
	var heat_sinks := int(m.get("heatSinks", 0))
	var armor_values: Array = m.get("armorLikeMaxValues", [])

	var lines: Array[String] = []
	lines.append("Class:    " + wc)
	lines.append("Tonnage:  " + ("%d t" % int(tonnage) if tonnage != null else "--"))
	lines.append("Speed:    " + ("%d kph" % int(speed) if speed != null else "--"))
	lines.append("Armor:    " + (str(armor).capitalize() if armor != null else "--"))
	if jump != null:
		lines.append("Jump:     %d m" % int(jump))
	elif jump_jets > 0:
		lines.append("Jump:     %d jets" % jump_jets)
	else:
		lines.append("Jump:     --")
	if heat_sinks > 0:
		lines.append("Heat:     %d sinks" % heat_sinks)
	if not armor_values.is_empty():
		lines.append("Armor Max: " + _compact_int_array(armor_values))
	_info_label.text = "\n".join(PackedStringArray(lines))

	var armament: Array = m.get("armament", [])
	if armament.is_empty():
		_weap_label.text = "Weapons: --"
	else:
		_weap_label.text = "Weapons:\n" + "\n".join(PackedStringArray(armament))
	_apply_portrait_art(m)

	var cur_id = AuthSession.character.get("mech_id", null)
	var is_current: bool = cur_id != null and int(cur_id) == int(m.get("id", -1))
	_select_button.disabled = is_current
	_select_button.text = "Already Selected" if is_current else "Select This Mech"
	_status_label.text = ""


func _on_item_selected(index: int) -> void:
	if index < 0 or index >= _filtered_mechs.size():
		_clear_detail()
		return
	_show_mech(_filtered_mechs[index])


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)


func _on_filter_all() -> void:
	_current_filter = "all"
	_apply_filter()


func _on_filter_light() -> void:
	_current_filter = "light"
	_apply_filter()


func _on_filter_medium() -> void:
	_current_filter = "medium"
	_apply_filter()


func _on_filter_heavy() -> void:
	_current_filter = "heavy"
	_apply_filter()


func _on_filter_assault() -> void:
	_current_filter = "assault"
	_apply_filter()


func _on_select_pressed() -> void:
	if _selected_mech.is_empty():
		return
	var mech_id: int = int(_selected_mech.get("id", -1))
	var type_string := str(_selected_mech.get("typeString", ""))
	if _using_local_roster or ServerBridge.game_api_url.is_empty():
		AuthSession.character["mech_id"] = mech_id
		AuthSession.character["mech_type"] = type_string
		_update_current_label()
		_status_label.text = "Selected locally: %s" % type_string
		_select_button.text = "Already Selected"
		_select_button.disabled = true
		return
	var username: String = str(AuthSession.character.get("display_name", ""))
	if username.is_empty():
		_status_label.text = "Not authenticated"
		return
	_select_button.disabled = true
	_status_label.text = "Saving..."
	_mech_client.select_mech(ServerBridge.game_api_url, mech_id, username)


func _on_mech_selected(mech_id: int, type_string: String) -> void:
	AuthSession.character["mech_id"] = mech_id
	AuthSession.character["mech_type"] = type_string
	_update_current_label()
	_status_label.text = "Selected: " + type_string
	_select_button.text = "Already Selected"
	_select_button.disabled = true


func _on_mech_failed(reason: String) -> void:
	_status_label.text = "Selection failed: " + reason
	_select_button.disabled = false


func _compact_int_array(values: Array) -> String:
	var parts := PackedStringArray()
	for value in values:
		parts.append(str(int(value)))
	return "/".join(parts)


func _apply_portrait_art(mech: Dictionary) -> void:
	var extracted := ClientConfig.asset_extracted_path()
	if extracted.is_empty():
		_portrait_art.texture = null
		_portrait_art.visible = false
		return

	var portrait_path := AssetRegistry.find_image(extracted, ["UI"], _portrait_hints_for_mech(mech))
	var portrait_texture := AssetRegistry.load_image_texture(portrait_path)
	if portrait_texture == null:
		_portrait_art.texture = null
		_portrait_art.visible = false
		return
	_portrait_art.texture = portrait_texture
	_portrait_art.visible = true


func _portrait_hints_for_mech(mech: Dictionary) -> Array:
	var hints: Array = []
	var type_string := str(mech.get("typeString", "")).to_lower()
	var chassis_name := str(mech.get("name", "")).to_lower()
	var normalized_type := _normalize_portrait_hint(type_string)
	var normalized_name := _normalize_portrait_hint(chassis_name)

	if not type_string.is_empty():
		hints.append(type_string)
	if not normalized_type.is_empty():
		hints.append(normalized_type)
		if normalized_type.length() >= 4:
			hints.append(normalized_type.substr(0, 4))
		if normalized_type.length() >= 3:
			hints.append(normalized_type.substr(0, 3))
	if not chassis_name.is_empty():
		hints.append(chassis_name)
	if not normalized_name.is_empty():
		hints.append(normalized_name)
		var aliases: Array = MECH_PORTRAIT_ALIASES.get(normalized_name, [])
		hints.append_array(aliases)
	return hints


func _normalize_portrait_hint(text: String) -> String:
	var result := ""
	for i in text.length():
		var ch := text.substr(i, 1)
		var code := ch.unicode_at(0)
		var is_digit := code >= 48 and code <= 57
		var is_lower := code >= 97 and code <= 122
		if is_digit or is_lower:
			result += ch
	return result
