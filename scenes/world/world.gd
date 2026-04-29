extends Control

## Solaris World Shell.
##
## Displays the room list (REST /world/rooms or local SOLARIS.MAP fallback),
## a room detail panel with description text, and a mini-map canvas showing
## room positions in the Solaris VII travel-map coordinate space.
##
## Presence updates arrive via WebSocket push (WSClient autoload).  When the
## WebSocket is unavailable the scene falls back to polling /world/presence
## every 5 s via WorldTravelClient (REST).  The poll timer stops automatically
## when the WebSocket reconnects and resumes if it drops while the player is
## in a room.

var _world_client: WorldClient
var _travel_client: WorldTravelClient
var _cbills_http: HTTPRequest
var _comstar_unread: Node  # ComstarClient (unread-count only)
var _rooms: Array = []
var _selected_id: int = -1
var _current_room_id: int = -1

@onready var _status_label: Label        = $MainVBox/Header/StatusLabel
@onready var _user_label: Label          = $MainVBox/Header/UserLabel
@onready var _cbills_label: Label        = $MainVBox/Header/CbillsLabel
@onready var _comstar_btn: Button        = $MainVBox/Header/ComStarButton
@onready var _comstar_badge: Label       = $MainVBox/Header/ComStarBadge
@onready var _room_list: VBoxContainer   = $MainVBox/ContentHBox/RoomPanel/RoomVBox/RoomScroll/RoomList
@onready var _room_name: Label           = $MainVBox/ContentHBox/DetailPanel/RoomName
@onready var _room_desc: Label           = $MainVBox/ContentHBox/DetailPanel/RoomDesc
@onready var _presence_panel: VBoxContainer = $MainVBox/ContentHBox/DetailPanel/PresencePanel
@onready var _presence_list: VBoxContainer  = $MainVBox/ContentHBox/DetailPanel/PresencePanel/PresenceList
@onready var _chat_panel: VBoxContainer     = $MainVBox/ContentHBox/DetailPanel/ChatPanel
@onready var _chat_scroll: ScrollContainer  = $MainVBox/ContentHBox/DetailPanel/ChatPanel/ChatScroll
@onready var _chat_log: VBoxContainer       = $MainVBox/ContentHBox/DetailPanel/ChatPanel/ChatScroll/ChatLog
@onready var _chat_input: LineEdit          = $MainVBox/ContentHBox/DetailPanel/ChatPanel/ChatHBox/ChatInput
@onready var _send_button: Button           = $MainVBox/ContentHBox/DetailPanel/ChatPanel/ChatHBox/SendButton
@onready var _map_canvas: SolarisMap     = $MainVBox/ContentHBox/DetailPanel/MapCanvas
@onready var _enter_button: Button       = $MainVBox/ContentHBox/DetailPanel/ActionBar/EnterButton
@onready var _poll_timer: Timer          = $PollTimer


func _ready() -> void:
	AudioManager.play_bgm("world")
	_apply_retail_map_art()
	_world_client = WorldClient.new()
	add_child(_world_client)
	_world_client.rooms_loaded.connect(_on_rooms_loaded)
	_world_client.rooms_failed.connect(_on_rooms_failed)

	_travel_client = WorldTravelClient.new()
	add_child(_travel_client)
	_travel_client.traveled.connect(_on_traveled)
	_travel_client.travel_failed.connect(_on_travel_failed)
	_travel_client.presence_updated.connect(_on_presence_updated)
	_travel_client.chat_sent.connect(_on_chat_sent)
	_travel_client.chat_failed.connect(_on_chat_failed)

	_cbills_http = HTTPRequest.new()
	_cbills_http.timeout = 8.0
	add_child(_cbills_http)
	_cbills_http.request_completed.connect(_on_cbills_fetched)

	_comstar_unread = load("res://scripts/net/comstar_client.gd").new()
	add_child(_comstar_unread)
	_comstar_unread.unread_count_loaded.connect(_on_comstar_unread_loaded)

	_comstar_btn.pressed.connect(_on_comstar_pressed)

	WSClient.presence_updated.connect(_on_presence_updated)
	WSClient.ws_connected.connect(_on_ws_connected)
	WSClient.ws_disconnected.connect(_on_ws_disconnected)
	WSClient.room_chat_received.connect(_on_room_chat_received)
	WSClient.comstar_message_received.connect(_on_comstar_message_received)

	var char_name: String = AuthSession.character.get("display_name", "")
	if not AuthSession.username.is_empty() and not char_name.is_empty():
		_user_label.text = "%s / %s" % [AuthSession.username, char_name]
	elif not AuthSession.username.is_empty():
		_user_label.text = AuthSession.username

	_set_status("Connecting\u2026")

	if ServerBridge.is_online and not ServerBridge.game_api_url.is_empty():
		_world_client.fetch_rooms(ServerBridge.game_api_url)
		_fetch_cbills()
		_fetch_comstar_unread()
	else:
		ServerBridge.server_available.connect(_on_server_available, CONNECT_ONE_SHOT)
		ServerBridge.server_unavailable.connect(_on_server_unavailable, CONNECT_ONE_SHOT)
		ServerBridge.check_config()


func _set_status(text: String) -> void:
	_status_label.text = text


func _on_server_available(_info: Dictionary) -> void:
	_world_client.fetch_rooms(ServerBridge.game_api_url)
	_fetch_cbills()
	_fetch_comstar_unread()


func _on_server_unavailable(_reason: String) -> void:
	_try_local_fallback()


func _fetch_cbills() -> void:
	var display_name := AuthSession.character.get("display_name", "") as String
	if display_name.is_empty() or ServerBridge.game_api_url.is_empty():
		return
	var headers := PackedStringArray(["X-Username: " + display_name])
	_cbills_http.request(ServerBridge.game_api_url + "/world/character", headers)


func _on_cbills_fetched(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		_cbills_label.text = "C —"
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.get("ok", false):
		_cbills_label.text = "C —"
		return
	var cbills: int = int(parsed.get("cbills", 0))
	AuthSession.character["cbills"] = cbills
	_cbills_label.text = "C %s" % _comma_format(cbills)


func _comma_format(n: int) -> String:
	var s := str(abs(n))
	var result := ""
	for i in s.length():
		if i > 0 and (s.length() - i) % 3 == 0:
			result += ","
		result += s[i]
	return ("-" if n < 0 else "") + result


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
		var x := float(r.get("x", 0))
		var y := float(r.get("y", 0))
		var label_w := float(r.get("label_w", 0))
		var label_h := float(r.get("label_h", 0))
		out.append({
			"roomId":      int(r.get("room_id", 0)),
			"name":        str(r.get("name", "")),
			"flags":       int(r.get("flags", 0)),
			"centreX":     x + (label_w * 0.5),
			"centreY":     y + (label_h * 0.5),
			"sceneIndex":  -1,
			"description": str(r.get("description", "")),
		})
	return out


func _apply_retail_map_art() -> void:
	var extracted := ClientConfig.asset_extracted_path()
	var map_path := AssetRegistry.find_image(extracted, ["Maps"], [
		"solaris_background",
		"solaris",
	])
	var texture := AssetRegistry.load_image_texture(map_path)
	if texture != null:
		_map_canvas.set_background_texture(texture)


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
			_update_enter_button()
			return


func _update_enter_button() -> void:
	if _selected_id < 0:
		_enter_button.text = "Enter Room"
		_enter_button.disabled = true
	elif _selected_id == _current_room_id:
		_enter_button.text = "Already Here"
		_enter_button.disabled = true
	else:
		_enter_button.text = "Enter Room"
		_enter_button.disabled = ServerBridge.game_api_url.is_empty()


func _on_enter_pressed() -> void:
	if _selected_id < 0 or ServerBridge.game_api_url.is_empty():
		return

	_enter_button.disabled = true
	_set_status("Traveling\u2026")
	_travel_client.travel(
		ServerBridge.game_api_url,
		AuthSession.username,
		_selected_id,
	)


func _on_traveled(room: Dictionary) -> void:
	_current_room_id = _selected_id
	_update_enter_button()

	var room_name := str(room.get("name", "Room %d" % _current_room_id))
	_set_status("In: %s" % room_name)

	_presence_panel.visible = true
	_chat_panel.visible = true
	_send_button.disabled = false
	_clear_chat_log()

	if WSClient.is_ws_connected:
		# Server will have already broadcast presence_update via WebSocket.
		pass
	else:
		_poll_timer.start()
		_travel_client.fetch_presence(ServerBridge.game_api_url)


func _on_travel_failed(reason: String) -> void:
	_set_status("Travel failed: %s" % reason)
	_update_enter_button()


func _on_ws_connected() -> void:
	# Real-time push is available; stop any REST fallback polling.
	_poll_timer.stop()


func _on_ws_disconnected() -> void:
	# WebSocket dropped; fall back to REST polling if the player is in a room.
	if _current_room_id >= 0:
		_poll_timer.start()
		if not ServerBridge.game_api_url.is_empty():
			_travel_client.fetch_presence(ServerBridge.game_api_url)


func _on_poll_timer_timeout() -> void:
	if WSClient.is_ws_connected:
		_poll_timer.stop()
		return
	if not ServerBridge.game_api_url.is_empty():
		_travel_client.fetch_presence(ServerBridge.game_api_url)


func _on_presence_updated(rooms: Array) -> void:
	for child in _presence_list.get_children():
		child.queue_free()

	for room_entry in rooms:
		if int(room_entry.get("roomId", -1)) == _current_room_id:
			var occupants: Array = room_entry.get("occupants", [])
			if occupants.is_empty():
				var lbl := Label.new()
				lbl.text = "(empty)"
				_presence_list.add_child(lbl)
			else:
				for name_str in occupants:
					var lbl := Label.new()
					lbl.text = str(name_str)
					_presence_list.add_child(lbl)
			return

	# No entry for current room means it's empty server-side
	var lbl := Label.new()
	lbl.text = "(empty)"
	_presence_list.add_child(lbl)


## ── ComStar badge ────────────────────────────────────────────────────────────

func _fetch_comstar_unread() -> void:
	if ServerBridge.game_api_url.is_empty():
		return
	_comstar_unread.fetch_unread_count(ServerBridge.game_api_url)


func _on_comstar_unread_loaded(count: int) -> void:
	if count > 0:
		_comstar_badge.text = "[%d]" % count
		_comstar_badge.visible = true
	else:
		_comstar_badge.visible = false


func _on_comstar_message_received() -> void:
	_fetch_comstar_unread()


func _on_comstar_pressed() -> void:
	_poll_timer.stop()
	get_tree().change_scene_to_file("res://scenes/comstar/comstar.tscn")


func _on_back_pressed() -> void:
	_poll_timer.stop()
	_send_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


## ── Chat ──────────────────────────────────────────────────────────────────────

func _on_send_pressed() -> void:
	_submit_chat()


func _on_chat_submitted(_text: String) -> void:
	_submit_chat()


func _submit_chat() -> void:
	var text := _chat_input.text.strip_edges()
	if text.is_empty() or _current_room_id < 0 or ServerBridge.game_api_url.is_empty():
		return
	_send_button.disabled = true
	_chat_input.editable = false
	_travel_client.send_chat(ServerBridge.game_api_url, AuthSession.username, _current_room_id, text)


func _on_chat_sent() -> void:
	_chat_input.clear()
	_chat_input.editable = true
	_send_button.disabled = false


func _on_chat_failed(reason: String) -> void:
	_set_status("Chat failed: %s" % reason)
	_chat_input.editable = true
	_send_button.disabled = false


func _on_room_chat_received(room_id: int, username: String, text: String) -> void:
	if room_id != _current_room_id:
		return
	var lbl := Label.new()
	lbl.text = "[%s] %s" % [username, text]
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_chat_log.add_child(lbl)
	await get_tree().process_frame
	_chat_scroll.scroll_vertical = 999999


func _clear_chat_log() -> void:
	for child in _chat_log.get_children():
		child.queue_free()
