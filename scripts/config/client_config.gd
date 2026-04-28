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
