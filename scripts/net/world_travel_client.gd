class_name WorldTravelClient
extends Node

## Handles POST /world/travel, GET /world/presence, and POST /world/chat.
##
## Usage:
##   var tc := WorldTravelClient.new()
##   add_child(tc)
##   tc.traveled.connect(_on_traveled)
##   tc.travel(ServerBridge.game_api_url, AuthSession.username, room_id)

signal traveled(room: Dictionary)
signal travel_failed(reason: String)
signal presence_updated(rooms: Array)
signal presence_failed(reason: String)
signal chat_sent
signal chat_failed(reason: String)

var _travel_http: HTTPRequest
var _presence_http: HTTPRequest
var _chat_http: HTTPRequest


func _ready() -> void:
	_travel_http = HTTPRequest.new()
	_travel_http.timeout = 8.0
	add_child(_travel_http)
	_travel_http.request_completed.connect(_on_travel_completed)

	_presence_http = HTTPRequest.new()
	_presence_http.timeout = 8.0
	add_child(_presence_http)
	_presence_http.request_completed.connect(_on_presence_completed)

	_chat_http = HTTPRequest.new()
	_chat_http.timeout = 8.0
	add_child(_chat_http)
	_chat_http.request_completed.connect(_on_chat_completed)


func travel(api_url: String, username: String, room_id: int) -> void:
	if _travel_http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return

	var body := JSON.stringify({"roomId": room_id})
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"X-Username: " + username,
	])
	var err := _travel_http.request(
		api_url + "/world/travel",
		headers,
		HTTPClient.METHOD_POST,
		body,
	)
	if err != OK:
		travel_failed.emit("request error %d" % err)


func fetch_presence(api_url: String) -> void:
	if _presence_http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return

	var err := _presence_http.request(api_url + "/world/presence")
	if err != OK:
		presence_failed.emit("request error %d" % err)


func _on_travel_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		var reason := "HTTP %d" % response_code if response_code > 0 else "connection failed"
		travel_failed.emit(reason)
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.get("ok", false):
		travel_failed.emit("unexpected response")
		return

	traveled.emit(parsed.get("room", {}) as Dictionary)


func _on_presence_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		presence_failed.emit("HTTP %d" % response_code if response_code > 0 else "connection failed")
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.get("ok", false):
		presence_failed.emit("unexpected response")
		return

	presence_updated.emit(parsed.get("rooms", []) as Array)


func send_chat(api_url: String, username: String, room_id: int, text: String) -> void:
	if _chat_http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return

	var body := JSON.stringify({"roomId": room_id, "text": text})
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"X-Username: " + username,
	])
	var err := _chat_http.request(
		api_url + "/world/chat",
		headers,
		HTTPClient.METHOD_POST,
		body,
	)
	if err != OK:
		chat_failed.emit("request error %d" % err)


func _on_chat_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	_body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		chat_failed.emit("HTTP %d" % response_code if response_code > 0 else "connection failed")
		return
	chat_sent.emit()
