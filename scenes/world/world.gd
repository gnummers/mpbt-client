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

const MAIN_SCENE := "res://scenes/main/main.tscn"
const MECH_SCENE := "res://scenes/mech/mech_select.tscn"
const STANDINGS_SCENE := "res://scenes/standings/standings.tscn"
const COMSTAR_SCENE := "res://scenes/comstar/comstar.tscn"
const ARENA_SCENE := "res://scenes/arena/ready_room.tscn"
const SETTINGS_SCENE := "res://scenes/settings/settings.tscn"

const NAMED_ROOM_MIN_ID := 146
const DISTRICT_THUMB_HINTS := {
	1: ["std0", "ishiyama", "kobe"],
	2: ["std1", "steiner", "silesia"],
	3: ["std2", "factory", "montenegro"],
	4: ["std3", "jungle", "cathay"],
	5: ["std4", "davion", "black hills"],
}
const DIRECTION_VECTORS := {
	"north": Vector2.UP,
	"east": Vector2.RIGHT,
	"south": Vector2.DOWN,
	"west": Vector2.LEFT,
}

var _world_client: WorldClient
var _travel_client: WorldTravelClient
var _cbills_http: HTTPRequest
var _comstar_unread: Node  # ComstarClient (unread-count only)
var _rooms: Array = []
var _selected_id: int = -1
var _current_room_id: int = -1
var _district_thumb_textures: Dictionary = {}
var _command_texture: Texture2D = null

@onready var _shell_north: TextureRect = $ShellNorth
@onready var _shell_south: TextureRect = $ShellSouth
@onready var _shell_west: TextureRect = $ShellWest
@onready var _shell_east: TextureRect = $ShellEast
@onready var _message_north: TextureRect = $MainVBox/MessagePanel/MessageNorth
@onready var _message_south: TextureRect = $MainVBox/MessagePanel/MessageSouth
@onready var _message_west: TextureRect = $MainVBox/MessagePanel/MessageWest
@onready var _message_east: TextureRect = $MainVBox/MessagePanel/MessageEast
@onready var _status_label: Label        = $MainVBox/MessagePanel/MessageMargin/MessageVBox/StatusLabel
@onready var _user_label: Label          = $MainVBox/MessagePanel/MessageMargin/MessageVBox/InfoRow/UserLabel
@onready var _cbills_label: Label        = $MainVBox/MessagePanel/MessageMargin/MessageVBox/InfoRow/CbillsLabel
@onready var _help_button: Button        = $MainVBox/CommandBar/HelpButton
@onready var _travel_button: Button      = $MainVBox/CommandBar/TravelButton
@onready var _mech_button: Button        = $MainVBox/CommandBar/MechButton
@onready var _side_button: Button        = $MainVBox/CommandBar/SideButton
@onready var _status_button: Button      = $MainVBox/CommandBar/StatusButton
@onready var _fight_button: Button       = $MainVBox/CommandBar/FightButton
@onready var _comstar_quick_button: Button = $MainVBox/QuickBar/LeftQuickButtons/ComstarQuickButton
@onready var _settings_quick_button: Button = $MainVBox/QuickBar/LeftQuickButtons/SettingsQuickButton
@onready var _mech_quick_button: Button = $MainVBox/QuickBar/RightQuickButtons/MechQuickButton
@onready var _exit_quick_button: Button = $MainVBox/QuickBar/RightQuickButtons/ExitQuickButton
@onready var _room_list_north: TextureRect = $MainVBox/ContentHBox/RoomPanel/RoomVBox/RoomListShell/RoomListNorth
@onready var _room_list_south: TextureRect = $MainVBox/ContentHBox/RoomPanel/RoomVBox/RoomListShell/RoomListSouth
@onready var _room_list_west: TextureRect = $MainVBox/ContentHBox/RoomPanel/RoomVBox/RoomListShell/RoomListWest
@onready var _room_list_east: TextureRect = $MainVBox/ContentHBox/RoomPanel/RoomVBox/RoomListShell/RoomListEast
@onready var _room_list: VBoxContainer   = $MainVBox/ContentHBox/RoomPanel/RoomVBox/RoomListShell/RoomListMargin/RoomListVBox/RoomScroll/RoomList
@onready var _travel_art: TextureRect    = $MainVBox/ContentHBox/RoomPanel/RoomVBox/TravelPanel/TravelArt
@onready var _north_preview: TextureButton = $MainVBox/ContentHBox/RoomPanel/RoomVBox/TravelPanel/NorthPreview
@onready var _west_preview: TextureButton = $MainVBox/ContentHBox/RoomPanel/RoomVBox/TravelPanel/WestPreview
@onready var _current_preview: TextureButton = $MainVBox/ContentHBox/RoomPanel/RoomVBox/TravelPanel/CurrentPreview
@onready var _east_preview: TextureButton = $MainVBox/ContentHBox/RoomPanel/RoomVBox/TravelPanel/EastPreview
@onready var _south_preview: TextureButton = $MainVBox/ContentHBox/RoomPanel/RoomVBox/TravelPanel/SouthPreview
@onready var _detail_north: TextureRect = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailNorth
@onready var _detail_south: TextureRect = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailSouth
@onready var _detail_west: TextureRect = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailWest
@onready var _detail_east: TextureRect = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailEast
@onready var _room_name: Label           = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/RoomName
@onready var _room_desc: Label           = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/RoomDesc
@onready var _presence_panel: VBoxContainer = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/PresencePanel
@onready var _presence_list: VBoxContainer  = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/PresencePanel/PresenceList
@onready var _chat_panel: VBoxContainer     = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/ChatPanel
@onready var _chat_scroll: ScrollContainer  = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/ChatPanel/ChatScroll
@onready var _chat_log: VBoxContainer       = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/ChatPanel/ChatScroll/ChatLog
@onready var _chat_input: LineEdit          = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/ChatPanel/ChatHBox/ChatInput
@onready var _send_button: Button           = $MainVBox/ContentHBox/DetailPanel/DetailInfoShell/DetailInfoMargin/DetailInfoVBox/ChatPanel/ChatHBox/SendButton
@onready var _map_frame_art: TextureRect = $MainVBox/ContentHBox/DetailPanel/MapShell/MapFrameArt
@onready var _map_canvas: SolarisMap     = $MainVBox/ContentHBox/DetailPanel/MapShell/MapCanvas
@onready var _enter_button: Button       = $MainVBox/ContentHBox/DetailPanel/ActionBar/EnterButton
@onready var _poll_timer: Timer          = $PollTimer


func _ready() -> void:
	AudioManager.play_bgm("world")
	_apply_retail_map_art()
	_north_preview.pressed.connect(_on_direction_pressed.bind("north"))
	_west_preview.pressed.connect(_on_direction_pressed.bind("west"))
	_current_preview.pressed.connect(_on_current_preview_pressed)
	_east_preview.pressed.connect(_on_direction_pressed.bind("east"))
	_south_preview.pressed.connect(_on_direction_pressed.bind("south"))
	_map_canvas.room_selected.connect(_on_room_selected)
	_refresh_command_bar()
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

	_set_status("Connecting...")

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


func _on_server_available(info: Dictionary) -> void:
	_refresh_command_bar()
	var version := str(info.get("version", ""))
	_set_status("Welcome to the game world.%s" % (" (Server v%s)" % version if not version.is_empty() else ""))
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
		_cbills_label.text = "C --"
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.get("ok", false):
		_cbills_label.text = "C --"
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
	_set_status("Travel network online (%d rooms)." % rooms.size())
	_populate_room_list()
	_map_canvas.set_rooms(rooms)
	_select_initial_room()


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
				_set_status("Travel network offline (%d rooms cached)." % _rooms.size())
				_populate_room_list()
				_map_canvas.set_rooms(_rooms)
				_select_initial_room()
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
	if extracted.is_empty():
		return

	_apply_shell_texture(_shell_north, _load_world_ui_texture(extracted, ["fuln"]))
	_apply_shell_texture(_shell_south, _load_world_ui_texture(extracted, ["fuls"]))
	_apply_shell_texture(_shell_west, _load_world_ui_texture(extracted, ["fulw"]))
	_apply_shell_texture(_shell_east, _load_world_ui_texture(extracted, ["fule"]))
	_apply_shell_texture(_message_north, _load_world_ui_texture(extracted, ["radn"]))
	_apply_shell_texture(_message_south, _load_world_ui_texture(extracted, ["rads"]))
	_apply_shell_texture(_message_west, _load_world_ui_texture(extracted, ["radw"]))
	_apply_shell_texture(_message_east, _load_world_ui_texture(extracted, ["rade"]))
	_apply_shell_texture(_room_list_north, _load_world_ui_texture(extracted, ["recn"]))
	_apply_shell_texture(_room_list_south, _load_world_ui_texture(extracted, ["recs"]))
	_apply_shell_texture(_room_list_west, _load_world_ui_texture(extracted, ["recw"]))
	_apply_shell_texture(_room_list_east, _load_world_ui_texture(extracted, ["rece"]))
	_apply_shell_texture(_detail_north, _load_world_ui_texture(extracted, ["dscn"]))
	_apply_shell_texture(_detail_south, _load_world_ui_texture(extracted, ["dscs"]))
	_apply_shell_texture(_detail_west, _load_world_ui_texture(extracted, ["dscw"]))
	_apply_shell_texture(_detail_east, _load_world_ui_texture(extracted, ["dsce"]))
	var map_path := AssetRegistry.find_image(extracted, ["Maps"], [
		"solaris_background",
		"solaris",
	])
	var texture := AssetRegistry.load_image_texture(map_path)
	if texture != null:
		_map_canvas.set_background_texture(texture)

	_travel_art.texture = _load_world_ui_texture(extracted, ["mov1", "travel", "move"])
	_travel_art.visible = _travel_art.texture != null

	_map_frame_art.texture = _load_world_ui_texture(extracted, ["mov2", "map"])
	_map_frame_art.visible = _map_frame_art.texture != null

	_command_texture = _load_world_ui_texture(extracted, ["buta", "button"])
	_apply_command_button_art()
	_apply_action_button_art()
	_apply_quick_action_icon(_comstar_quick_button, _load_world_ui_texture(extracted, ["cstr", "comstar"]), "ComStar")
	_apply_quick_action_icon(_settings_quick_button, _load_world_ui_texture(extracted, ["optn", "settings", "options"]), "Settings")
	_apply_quick_action_icon(_mech_quick_button, _load_world_ui_texture(extracted, ["vmec", "mech"]), "Mech Bay")
	_apply_quick_action_icon(_exit_quick_button, _load_world_ui_texture(extracted, ["exit"]), "Menu")

	_district_thumb_textures.clear()
	for district_v in DISTRICT_THUMB_HINTS.keys():
		var district := int(district_v)
		_district_thumb_textures[district] = _load_world_ui_texture(
			extracted,
			DISTRICT_THUMB_HINTS[district],
		)


func _load_world_ui_texture(extracted_path: String, hints: Array) -> Texture2D:
	var art_path := AssetRegistry.find_image(extracted_path, ["UI"], hints)
	return AssetRegistry.load_image_texture(art_path)


func _apply_shell_texture(node: TextureRect, texture: Texture2D) -> void:
	node.texture = texture
	node.visible = texture != null


func _apply_command_button_art() -> void:
	for button in [_help_button, _travel_button, _mech_button, _side_button, _status_button, _fight_button]:
		_apply_button_art(button)


func _apply_action_button_art() -> void:
	for button in [_send_button, _enter_button]:
		_apply_button_art(button, 13)


func _apply_button_art(button: Button, font_size: int = 14) -> void:
	if _command_texture == null:
		return
	var style := StyleBoxTexture.new()
	style.texture = _command_texture
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", style)
	button.add_theme_stylebox_override("pressed", style)
	button.add_theme_stylebox_override("disabled", style)
	button.add_theme_font_size_override("font_size", font_size)


func _apply_quick_action_icon(button: Button, texture: Texture2D, tooltip: String) -> void:
	button.tooltip_text = tooltip
	if texture == null:
		return
	button.icon = texture
	button.expand_icon = true
	button.text = ""


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
			_update_directional_travel_ui()
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
	_set_status("Traveling...")
	_travel_client.travel(
		ServerBridge.game_api_url,
		AuthSession.username,
		_selected_id,
	)


func _on_traveled(room: Dictionary) -> void:
	_current_room_id = _selected_id
	_update_enter_button()
	_update_directional_travel_ui()

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
	_status_button.text = "Status [%d]" % count if count > 0 else "Status"


func _on_comstar_message_received() -> void:
	_fetch_comstar_unread()


func _on_comstar_pressed() -> void:
	_poll_timer.stop()
	get_tree().change_scene_to_file(COMSTAR_SCENE)


func _on_back_pressed() -> void:
	_poll_timer.stop()
	_send_button.disabled = true
	get_tree().change_scene_to_file(MAIN_SCENE)


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


func _select_initial_room() -> void:
	if _rooms.is_empty():
		_update_directional_travel_ui()
		return
	if _selected_id >= 0 and not _room_for_id(_selected_id).is_empty():
		_update_directional_travel_ui()
		return

	var chosen_id := _current_room_id
	if _room_for_id(chosen_id).is_empty():
		chosen_id = _default_room_id()

	if chosen_id >= 0:
		_on_room_selected(chosen_id)
	else:
		_update_directional_travel_ui()


func _default_room_id() -> int:
	for room in _rooms:
		var room_id := int(room.get("roomId", -1))
		if room_id >= NAMED_ROOM_MIN_ID:
			return room_id
	if _rooms.is_empty():
		return -1
	return int((_rooms[0] as Dictionary).get("roomId", -1))


func _room_for_id(room_id: int) -> Dictionary:
	if room_id < 0:
		return {}
	for room_v in _rooms:
		var room := room_v as Dictionary
		if int(room.get("roomId", -1)) == room_id:
			return room
	return {}


func _movement_origin_room() -> Dictionary:
	var room := _room_for_id(_selected_id)
	if room.is_empty():
		room = _room_for_id(_current_room_id)
	if room.is_empty():
		room = _room_for_id(_default_room_id())
	return room


func _on_direction_pressed(direction: String) -> void:
	var origin := _movement_origin_room()
	if origin.is_empty():
		return
	var candidate := _find_directional_room(origin, direction)
	if candidate.is_empty():
		return
	_on_room_selected(int(candidate.get("roomId", -1)))


func _on_current_preview_pressed() -> void:
	var origin := _movement_origin_room()
	if origin.is_empty():
		return
	_on_room_selected(int(origin.get("roomId", -1)))


func _find_directional_room(origin: Dictionary, direction: String) -> Dictionary:
	var axis := DIRECTION_VECTORS.get(direction, Vector2.ZERO) as Vector2
	if axis == Vector2.ZERO:
		return {}

	var origin_id := int(origin.get("roomId", -1))
	var origin_pos := Vector2(float(origin.get("centreX", 0)), float(origin.get("centreY", 0)))
	var best_score := -INF
	var best: Dictionary = {}

	for room_v in _rooms:
		var room := room_v as Dictionary
		var room_id := int(room.get("roomId", -1))
		if room_id == origin_id or room_id < NAMED_ROOM_MIN_ID:
			continue

		var delta := Vector2(
			float(room.get("centreX", 0)) - origin_pos.x,
			float(room.get("centreY", 0)) - origin_pos.y,
		)
		var distance := delta.length()
		if distance <= 0.001:
			continue

		var alignment := axis.dot(delta / distance)
		if alignment < 0.25:
			continue

		var score := (alignment * 1000.0) - distance
		if score > best_score:
			best_score = score
			best = room
	return best


func _update_directional_travel_ui() -> void:
	var origin := _movement_origin_room()
	if origin.is_empty():
		_apply_preview(_current_preview, {}, {}, "Current")
		_apply_preview(_north_preview, {}, {}, "North")
		_apply_preview(_east_preview, {}, {}, "East")
		_apply_preview(_south_preview, {}, {}, "South")
		_apply_preview(_west_preview, {}, {}, "West")
		return
	_apply_preview(_current_preview, origin, origin, "Current")
	_apply_preview(_north_preview, origin, _find_directional_room(origin, "north"), "North")
	_apply_preview(_east_preview, origin, _find_directional_room(origin, "east"), "East")
	_apply_preview(_south_preview, origin, _find_directional_room(origin, "south"), "South")
	_apply_preview(_west_preview, origin, _find_directional_room(origin, "west"), "West")


func _apply_preview(button: TextureButton, origin: Dictionary, room: Dictionary, label: String) -> void:
	var texture := _thumbnail_texture_for_room(room)
	button.texture_normal = texture
	button.disabled = room.is_empty() or texture == null
	button.modulate = Color(1, 1, 1, 1) if not button.disabled else Color(0.45, 0.45, 0.45, 0.9)

	if room.is_empty():
		button.tooltip_text = "%s: unavailable" % label
		return

	var room_name := str(room.get("name", "Room"))
	var suffix := ""
	if not origin.is_empty() and int(origin.get("roomId", -1)) == int(room.get("roomId", -1)):
		suffix = " (focus)"
	button.tooltip_text = "%s: %s%s" % [label, room_name, suffix]


func _thumbnail_texture_for_room(room: Dictionary) -> Texture2D:
	if room.is_empty():
		return null
	var district := int(room.get("flags", 0)) & 0xFF
	return _district_thumb_textures.get(district, null) as Texture2D


func _refresh_command_bar() -> void:
	_travel_button.disabled = false
	_mech_button.disabled = not AuthSession.is_logged_in or AuthSession.character.is_empty()
	_side_button.disabled = false
	_status_button.disabled = not AuthSession.is_logged_in or ServerBridge.game_api_url.is_empty()
	_fight_button.disabled = (
		not AuthSession.is_logged_in
		or AuthSession.character.is_empty()
		or AuthSession.character.get("mech_id", null) == null
	)
	_comstar_quick_button.disabled = _status_button.disabled
	_settings_quick_button.disabled = false
	_mech_quick_button.disabled = _mech_button.disabled
	_exit_quick_button.disabled = false


func _on_help_pressed() -> void:
	_on_back_pressed()


func _on_travel_nav_pressed() -> void:
	if _rooms.is_empty():
		return
	_select_initial_room()
	_set_status("Travel terminal ready.")


func _on_mech_pressed() -> void:
	if not AuthSession.is_logged_in:
		_on_back_pressed()
		return
	if AuthSession.character.is_empty():
		_set_status("Create a character first to access the Mech Bay.")
		return
	_poll_timer.stop()
	get_tree().change_scene_to_file(MECH_SCENE)


func _on_side_pressed() -> void:
	_poll_timer.stop()
	get_tree().change_scene_to_file(STANDINGS_SCENE)


func _on_status_pressed() -> void:
	if not AuthSession.is_logged_in or ServerBridge.game_api_url.is_empty():
		_set_status("Status terminal is unavailable.")
		return
	_on_comstar_pressed()


func _on_settings_pressed() -> void:
	_poll_timer.stop()
	get_tree().change_scene_to_file(SETTINGS_SCENE)


func _on_fight_pressed() -> void:
	if not AuthSession.is_logged_in:
		_on_back_pressed()
		return
	if AuthSession.character.is_empty():
		_set_status("Create a character first to access the Arena.")
		return
	if AuthSession.character.get("mech_id", null) == null:
		_set_status("Select a mech in the Mech Bay before entering the Arena.")
		return
	_poll_timer.stop()
	get_tree().change_scene_to_file(ARENA_SCENE)
