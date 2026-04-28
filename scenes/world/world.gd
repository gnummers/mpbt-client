extends Control

## Solaris World scene.
##
## On _ready(), waits for ServerBridge (or uses its cached api_url if already
## online), fetches rooms via WorldClient REST, and falls back to a local
## SOLARIS.MAP parse when the server is unavailable or the fetch fails.

var _world_client: WorldClient


func _ready() -> void:
	_world_client = WorldClient.new()
	add_child(_world_client)
	_world_client.rooms_loaded.connect(_on_rooms_loaded)
	_world_client.rooms_failed.connect(_on_rooms_failed)

	_set_status("Connecting\u2026")

	if ServerBridge.is_online and not ServerBridge.api_url.is_empty():
		_world_client.fetch_rooms(ServerBridge.api_url)
	else:
		ServerBridge.server_available.connect(_on_server_available, CONNECT_ONE_SHOT)
		ServerBridge.server_unavailable.connect(_on_server_unavailable, CONNECT_ONE_SHOT)
		ServerBridge.check_config()


func _set_status(text: String) -> void:
	$Content/Status.text = text


func _on_server_available(_info: Dictionary) -> void:
	_world_client.fetch_rooms(ServerBridge.api_url)


func _on_server_unavailable(_reason: String) -> void:
	_try_local_fallback()


func _on_rooms_loaded(rooms: Array) -> void:
	_set_status("Online (%d rooms)" % rooms.size())


func _on_rooms_failed(_reason: String) -> void:
	_try_local_fallback()


func _try_local_fallback() -> void:
	var extracted := ClientConfig.asset_extracted_path()
	var retail := ClientConfig.retail_asset_path()

	var candidates: Array[String] = []
	if not extracted.is_empty():
		candidates.append(extracted + "/misc/Solaris.map")
	if not retail.is_empty():
		candidates.append(retail + "/Solaris.map")

	for candidate in candidates:
		if FileAccess.file_exists(candidate):
			var result := MapParser.parse(candidate)
			if result.ok:
				_set_status("Offline (%d rooms)" % result.rooms.size())
			else:
				_set_status("Offline (map parse error)")
			return

	_set_status("Server offline")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
