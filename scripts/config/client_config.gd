extends Node

const DEFAULT_CONFIG_PATH := "res://config/default_client.json"
const LOCAL_CONFIG_PATH := "res://config/local.json"
const USER_CONFIG_PATH := "user://mpbt-client.json"
const DEFAULT_KEY_BINDINGS := {
	"move_forward": [KEY_W, KEY_KP_8],
	"move_backward": [KEY_S, KEY_KP_2],
	"move_left": [KEY_A],
	"move_right": [KEY_D],
	"turn_left": [KEY_Q, KEY_KP_4],
	"turn_right": [KEY_E, KEY_KP_6],
	"stop_movement": [KEY_KP_5],
	"fire": [KEY_SPACE],
	"jump_jet": [KEY_J, KEY_HOME],
	"stand_up": [KEY_F12],
	"target_cycle": [KEY_ENTER, KEY_KP_ENTER],
	"hud_target_detail": [KEY_T],
	"hud_target_brief": [KEY_Y],
	"hud_self_detail": [KEY_U],
	"radar_range": [KEY_R],
	"radar_zoom_in": [KEY_INSERT],
	"radar_zoom_out": [KEY_DELETE],
	"tic_cycle_current": [KEY_O, KEY_KP_0],
	"tic_select_a": [KEY_P],
	"tic_select_b": [KEY_BRACKETLEFT],
	"tic_select_c": [KEY_BRACKETRIGHT],
	"tic_toggle_a": [KEY_L],
	"tic_toggle_b": [KEY_SEMICOLON],
	"tic_toggle_c": [KEY_APOSTROPHE],
	"tic_fire_a": [KEY_NUMLOCK],
	"tic_fire_b": [KEY_KP_DIVIDE],
	"tic_fire_c": [KEY_KP_MULTIPLY],
	"weapon_prev": [KEY_KP_SUBTRACT],
	"weapon_next": [KEY_KP_ADD],
	"ui_chat": [KEY_F8],
	"ui_team_chat": [KEY_F7],
}
const DEFAULT_MOUSE_BINDINGS := {
	"fire": [MOUSE_BUTTON_LEFT],
}

var data: Dictionary = {}


func _ready() -> void:
	load_config()


func load_config() -> void:
	data = _read_json(DEFAULT_CONFIG_PATH)
	data = _merge_dicts(data, _read_json(LOCAL_CONFIG_PATH))
	data = _merge_dicts(data, _read_json(USER_CONFIG_PATH))
	apply_display_settings()
	ensure_input_actions()
	apply_input_remapping()


func server_base_url() -> String:
	var server := _dict_value(data, "server")
	return str(server.get("base_url", "http://127.0.0.1:3000"))


func server_websocket_url() -> String:
	var server := _dict_value(data, "server")
	return str(server.get("websocket_url", "ws://127.0.0.1:3000/ws"))


func retail_asset_path() -> String:
	var assets := _dict_value(data, "assets")
	return str(assets.get("retail_path", ""))


func asset_extracted_path() -> String:
	var assets := _dict_value(data, "assets")
	return str(assets.get("extracted_path", ""))


func diagnostics_enabled() -> bool:
	var diagnostics := _dict_value(data, "diagnostics")
	return bool(diagnostics.get("enabled", false))


func network_logging_enabled() -> bool:
	var diagnostics := _dict_value(data, "diagnostics")
	return bool(diagnostics.get("log_network", false))


func display_window_mode() -> String:
	var display := _dict_value(data, "display")
	if display.has("window_mode"):
		var mode := str(display.get("window_mode", "windowed")).to_lower()
		if mode in ["windowed", "borderless", "fullscreen"]:
			return mode
	# Legacy fallback: old configs stored a bool "fullscreen" key.
	# WINDOW_MODE_FULLSCREEN was borderless, so preserve that mapping.
	if display.get("fullscreen", false):
		return "borderless"
	return "windowed"


func display_fullscreen() -> bool:
	return display_window_mode() != "windowed"


func display_resolution() -> String:
	return str(_dict_value(data, "display").get("resolution", "1280x720"))


func display_integer_scale() -> bool:
	return bool(_dict_value(data, "display").get("integer_scale", false))


func ui_scale() -> float:
	var val := float(_dict_value(data, "ui").get("scale", 1.0))
	if val >= 1.5:
		return 1.5
	elif val >= 1.25:
		return 1.25
	return 1.0


func apply_display_settings() -> void:
	if not data.has("display"):
		return
	match display_window_mode():
		"fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		"borderless":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(_parse_resolution(display_resolution()))

	var root := get_tree().root
	root.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_INTEGER \
		if display_integer_scale() else Window.CONTENT_SCALE_STRETCH_FRACTIONAL
	ThemeDB.fallback_base_scale = ui_scale()


func saved_controls() -> Dictionary:
	return _dict_value(data, "controls")


func apply_input_remapping() -> void:
	for action in saved_controls():
		if not InputMap.has_action(action):
			continue
		var new_keycode := int(saved_controls()[action])
		if new_keycode <= 0:
			continue
		var non_key := InputMap.action_get_events(action).filter(
			func(e: InputEvent) -> bool: return not (e is InputEventKey)
		)
		InputMap.action_erase_events(action)
		for ev in non_key:
			InputMap.action_add_event(action, ev)
		var ev := InputEventKey.new()
		ev.physical_keycode = new_keycode
		InputMap.action_add_event(action, ev)


func ensure_input_actions() -> void:
	for action in DEFAULT_KEY_BINDINGS.keys():
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for keycode_v in DEFAULT_KEY_BINDINGS[action]:
			_ensure_key_binding(action, int(keycode_v))
	if not saved_controls().has("ui_chat"):
		_remove_key_binding("ui_chat", KEY_T)
		_remove_key_binding("ui_chat", KEY_C)

	for action in DEFAULT_MOUSE_BINDINGS.keys():
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		for button_v in DEFAULT_MOUSE_BINDINGS[action]:
			_ensure_mouse_binding(action, int(button_v))


func _ensure_key_binding(action: String, keycode: int) -> void:
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			var key_ev := ev as InputEventKey
			if key_ev.keycode == keycode or key_ev.physical_keycode == keycode:
				return
	var event := InputEventKey.new()
	event.keycode = keycode
	InputMap.action_add_event(action, event)


func _ensure_mouse_binding(action: String, button_index: int) -> void:
	for ev in InputMap.action_get_events(action):
		if ev is InputEventMouseButton and (ev as InputEventMouseButton).button_index == button_index:
			return
	var event := InputEventMouseButton.new()
	event.button_index = button_index
	InputMap.action_add_event(action, event)


func _remove_key_binding(action: String, keycode: int) -> void:
	var events := InputMap.action_get_events(action).duplicate()
	for ev in events:
		if not (ev is InputEventKey):
			continue
		var key_ev := ev as InputEventKey
		if key_ev.keycode == keycode or key_ev.physical_keycode == keycode:
			InputMap.action_erase_event(action, ev)


func master_volume_db() -> float:
	return float(_dict_value(data, "audio").get("master_db", 0.0))


func music_volume_db() -> float:
	return float(_dict_value(data, "audio").get("music_db", -10.0))


func sfx_volume_db() -> float:
	return float(_dict_value(data, "audio").get("sfx_db", 0.0))


func _parse_resolution(res_str: String) -> Vector2i:
	var parts := res_str.split("x")
	if parts.size() == 2:
		return Vector2i(int(parts[0]), int(parts[1]))
	return Vector2i(1280, 720)


func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Could not open client config: %s" % path)
		return {}

	var parsed = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_warning("Client config is not a JSON object: %s" % path)
		return {}

	return parsed


func _merge_dicts(base: Dictionary, overlay: Dictionary) -> Dictionary:
	var merged := base.duplicate(true)
	for key in overlay:
		if merged.has(key) and typeof(merged[key]) == TYPE_DICTIONARY and typeof(overlay[key]) == TYPE_DICTIONARY:
			merged[key] = _merge_dicts(merged[key], overlay[key])
		else:
			merged[key] = overlay[key]
	return merged


func _dict_value(source: Dictionary, key: String) -> Dictionary:
	var value = source.get(key, {})
	if typeof(value) == TYPE_DICTIONARY:
		return value
	return {}
