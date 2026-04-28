class_name WorldClient
extends Node

## Fetches room data from the mpbt-server REST API.
##
## Usage:
##   var wc := WorldClient.new()
##   add_child(wc)
##   wc.rooms_loaded.connect(_on_rooms_loaded)
##   wc.rooms_failed.connect(_on_rooms_failed)
##   wc.fetch_rooms(ServerBridge.api_url)
##
## WorldClient is a plain scene-owned node, not an Autoload.

signal rooms_loaded(rooms: Array)
signal rooms_failed(reason: String)

var _http: HTTPRequest


func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 10.0
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)


func fetch_rooms(api_url: String) -> void:
	if api_url.is_empty():
		rooms_failed.emit("no api_url")
		return

	if _http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return

	var err := _http.request(api_url + "/world/rooms")
	if err != OK:
		rooms_failed.emit("request error %d" % err)


func _on_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		rooms_failed.emit(_error_reason(result, response_code))
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.get("ok", false):
		rooms_failed.emit("unexpected response")
		return

	var rooms = parsed.get("rooms", [])
	if typeof(rooms) != TYPE_ARRAY:
		rooms_failed.emit("missing rooms array")
		return

	rooms_loaded.emit(rooms)


func _error_reason(result: int, code: int) -> String:
	match result:
		HTTPRequest.RESULT_CANT_CONNECT:
			return "server unavailable"
		HTTPRequest.RESULT_TIMEOUT:
			return "timed out"
		_:
			if code > 0:
				return "HTTP %d" % code
			return "connection failed"
