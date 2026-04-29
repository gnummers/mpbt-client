class_name StandingsClient
extends Node

## Fetches the Solaris VII standings leaderboard from GET /standings.
##
## Usage:
##   var sc := StandingsClient.new()
##   add_child(sc)
##   sc.standings_loaded.connect(_on_standings_loaded)
##   sc.fetch(ServerBridge.game_api_url)

signal standings_loaded(standings: Array)
signal standings_failed(reason: String)

var _http: HTTPRequest


func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 10.0
	add_child(_http)
	_http.request_completed.connect(_on_completed)


func fetch(api_url: String) -> void:
	if _http.get_http_client_status() != HTTPClient.STATUS_DISCONNECTED:
		return
	var err := _http.request(api_url + "/standings")
	if err != OK:
		standings_failed.emit("request error %d" % err)


func _on_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		standings_failed.emit("HTTP %d" % response_code if response_code > 0 else "connection failed")
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.get("ok", false):
		standings_failed.emit("unexpected response")
		return

	standings_loaded.emit(parsed.get("standings", []) as Array)
