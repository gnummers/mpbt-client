extends Control

## Solaris World Shell.
##
## Displays the room list (REST /world/rooms or local SOLARIS.MAP fallback),
## a room detail panel with description text, and a mini-map canvas showing
## room positions in the Solaris VII travel-map coordinate space.

var _world_client: WorldClient
var _rooms: Array = []
var _selected_id: int = -1

@onready var _status_label: Label      = $MainVBox/Header/StatusLabel
@onready var _user_label: Label        = $MainVBox/Header/UserLabel
@onready var _room_list: VBoxContainer = $MainVBox/ContentHBox/RoomPanel/RoomVBox/RoomScroll/RoomList
@onready var _room_name: Label         = $MainVBox/ContentHBox/DetailPanel/RoomName
@onready var _room_desc: Label         = $MainVBox/ContentHBox/DetailPanel/RoomDesc
@onready var _map_canvas: SolarisMap   = $MainVBox/ContentHBox/DetailPanel/MapCanvas
@onready var _enter_button: Button     = $MainVBox/ContentHBox/DetailPanel/ActionBar/EnterButton


func _ready() -> void:
	_world_client = WorldClient.new()
	add_child(_world_client)
	_world_client.rooms_loaded.connect(_on_rooms_loaded)
	_world_client.rooms_failed.connect(_on_rooms_failed)

	var char_name: String = AuthSession.character.get("display_name", "")
	if not AuthSession.username.is_empty() and not char_name.is_empty():
		_user_label.text = "%s / %s" % [AuthSession.username, char_name]
	elif not AuthSession.username.is_empty():
		_user_label.text = AuthSession.username

	_set_status("Connecting\u2026")

	if ServerBridge.is_online and not ServerBridge.game_api_url.is_empty():
		_world_client.fetch_rooms(ServerBridge.game_api_url)
	else:
		ServerBridge.server_available.connect(_on_server_available, CONNECT_ONE_SHOT)
		ServerBridge.server_unavailable.connect(_on_server_unavailable, CONNECT_ONE_SHOT)
		ServerBridge.check_config()


func _set_status(text: String) -> void:
	_status_label.text = text


func _on_server_available(_info: Dictionary) -> void:
	_world_client.fetch_rooms(ServerBridge.game_api_url)


func _on_server_unavailable(_reason: String) -> void:
	_try_local_fallback()


func _on_rooms_loaded(rooms: Array) -> void:
	_rooms = rooms
	_set_status("Online (%d rooms)" % rooms.size())
	_populate_room_list()
	_map_canvas.set_rooms(rooms)


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
				_rooms = _normalize_local_rooms(result.rooms)
				_set_status("Offline (%d rooms)" % _rooms.size())
				_populate_room_list()
				_map_canvas.set_rooms(_rooms)
			else:
				_set_status("Offline (map parse error)")
			return

	_set_status("Server offline")


## Normalise MapParser room dicts (snake_case keys, x/y position) to the same
## shape as the REST API WorldRoom so the rest of the scene treats both uniformly.
func _normalize_local_rooms(raw_rooms: Array) -> Array:
	var out: Array = []
	for r in raw_rooms:
		out.append({
			"roomId":      int(r.get("room_id", 0)),
			"name":        str(r.get("name", "")),
			"flags":       int(r.get("flags", 0)),
			"centreX":     float(r.get("x", 0)),
			"centreY":     float(r.get("y", 0)),
			"sceneIndex":  -1,
			"description": str(r.get("description", "")),
		})
	return out


func _populate_room_list() -> void:
	for child in _room_list.get_children():
		child.queue_free()

	for room in _rooms:
		var room_id := int(room.get("roomId", -1))
		var btn := Button.new()
		btn.text = str(room.get("name", "Room %d" % room_id))
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(_on_room_selected.bind(room_id))
		_room_list.add_child(btn)


func _on_room_selected(room_id: int) -> void:
	_selected_id = room_id
	for room in _rooms:
		if int(room.get("roomId", -1)) == room_id:
			_room_name.text = str(room.get("name", ""))
			var desc := str(room.get("description", ""))
			_room_desc.text = desc if not desc.is_empty() else "(No description)"
			_map_canvas.set_selected(room_id)
			return


func _on_enter_pressed() -> void:
	pass  # Travel: M4 Phase 2


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
