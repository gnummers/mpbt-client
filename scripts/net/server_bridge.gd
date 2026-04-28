extends Node

## Fetches /api/client-config from mpbt-web on demand and emits status signals.
##
## The response provides the real API URL and game server address — the same
## discovery pattern used by the Tauri launcher.
##
## Usage:
##   Connect server_available / server_unavailable before calling check_config().
##   Does NOT auto-check on _ready() — call check_config() from your scene after
##   connecting signals to avoid racing the signal handler.

signal server_available(info: Dictionary)
signal server_unavailable(reason: String)

## True once a successful /api/client-config response has been received.
var is_online: bool = false

## Resolved NestJS REST API base URL, e.g. "http://host:3001"
var api_url: String = ""

## Resolved mpbt-server game REST API base URL, e.g. "http://host:3002"
var game_api_url: String = ""

## Resolved ARIES game server address, e.g. "host:2000"
var game_server: String = ""

## Web version string from the config response, e.g. "0.1.0"
var web_version: String = ""

var _http: HTTPRequest


func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 5.0
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)


func check_config() -> void:
	if _http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return

	var url := ClientConfig.server_base_url() + "/api/client-config"
	var err := _http.request(url)
	if err != OK:
		is_online = false
		api_url = ""
		game_api_url = ""
		game_server = ""
		web_version = ""
		server_unavailable.emit("request failed (err %d)" % err)


func _on_request_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		is_online = false
		api_url = ""
		game_api_url = ""
		game_server = ""
		web_version = ""
		server_unavailable.emit(_error_reason(result, response_code))
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.has("gameServer"):
		is_online = false
		api_url = ""
		game_api_url = ""
		game_server = ""
		web_version = ""
		server_unavailable.emit("unexpected response")
		return

	is_online = true
	api_url = str(parsed.get("apiUrl", ""))
	game_api_url = str(parsed.get("gameApiUrl", ""))
	game_server = str(parsed.get("gameServer", ""))
	web_version = str(parsed.get("version", ""))
	server_available.emit(parsed)


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
