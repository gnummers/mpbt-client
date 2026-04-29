extends Node

const DEFAULT_CONFIG_PATH := "res://config/default_client.json"
const LOCAL_CONFIG_PATH := "res://config/local.json"
const USER_CONFIG_PATH := "user://mpbt-client.json"

var data: Dictionary = {}


func _ready() -> void:
	load_config()


func load_config() -> void:
	data = _read_json(DEFAULT_CONFIG_PATH)
	data = _merge_dicts(data, _read_json(LOCAL_CONFIG_PATH))
	data = _merge_dicts(data, _read_json(USER_CONFIG_PATH))
	apply_display_settings()
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


func display_fullscreen() -> bool:
	return bool(_dict_value(data, "display").get("fullscreen", false))


func display_resolution() -> String:
	return str(_dict_value(data, "display").get("resolution", "1280x720"))


func apply_display_settings() -> void:
	if not data.has("display"):
		return
	if display_fullscreen():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(_parse_resolution(display_resolution()))


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
