extends Node

## WebSocket client Autoload.
##
## Maintains a persistent connection to mpbt-server (/ws on the game API port)
## for real-time push events.  Automatically reconnects after a disconnect.
##
## Signals:
##   presence_updated(rooms: Array) — rooms snapshot from server push
##   ws_connected                   — emitted when the connection opens
##   ws_disconnected                — emitted when the connection closes / drops

signal presence_updated(rooms: Array)
signal ws_connected
signal ws_disconnected
signal room_chat_received(room_id: int, username: String, text: String)
signal arena_queue_updated(slots: Array)
signal arena_match_launched(data: Dictionary)

const _RECONNECT_DELAY := 5.0

## Public read-only: true when the WebSocket is in the OPEN state.
var is_ws_connected: bool = false

var _ws := WebSocketPeer.new()
var _ws_url := ""
var _reconnect_timer := 0.0


func _ready() -> void:
	if ServerBridge.is_online and not ServerBridge.game_api_url.is_empty():
		_connect_ws()
	else:
		ServerBridge.server_available.connect(_on_server_available, CONNECT_ONE_SHOT)


func _on_server_available(_info: Dictionary) -> void:
	_connect_ws()


func _connect_ws() -> void:
	_ws_url = (ServerBridge.game_api_url
		.replace("http://", "ws://")
		.replace("https://", "wss://")
		.trim_suffix("/")
		+ "/ws")
	var err := _ws.connect_to_url(_ws_url)
	if err != OK:
		push_warning("WSClient: connect_to_url returned error %d for %s" % [err, _ws_url])


func _process(delta: float) -> void:
	if _ws_url.is_empty():
		return

	_ws.poll()

	var state := _ws.get_ready_state()
	match state:
		WebSocketPeer.STATE_OPEN:
			if not is_ws_connected:
				is_ws_connected = true
				_reconnect_timer = 0.0
				ws_connected.emit()
			while _ws.get_available_packet_count() > 0:
				var pkt := _ws.get_packet()
				_handle_message(pkt.get_string_from_utf8())

		WebSocketPeer.STATE_CLOSED:
			if is_ws_connected:
				is_ws_connected = false
				ws_disconnected.emit()
			_reconnect_timer += delta
			if _reconnect_timer >= _RECONNECT_DELAY:
				_reconnect_timer = 0.0
				_ws = WebSocketPeer.new()
				_connect_ws()


func _handle_message(text: String) -> void:
	var data = JSON.parse_string(text)
	if data == null or typeof(data) != TYPE_DICTIONARY:
		return
	match str(data.get("type", "")):
		"presence_update":
			presence_updated.emit(data.get("rooms", []))
		"room_chat":
			var room_id := int(data.get("roomId", -1))
			var username := str(data.get("username", ""))
			var msg_text := str(data.get("text", ""))
			room_chat_received.emit(room_id, username, msg_text)
		"arena_queue_update":
			arena_queue_updated.emit(data.get("slots", []))
		"arena_match_launch":
			arena_match_launched.emit(data)
