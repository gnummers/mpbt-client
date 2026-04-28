class_name MechClient
extends Node

## Lightweight REST client for the mech catalog and mech selection endpoints
## on mpbt-server (port 3002).
##
## Usage:
##   var mc := MechClient.new(); add_child(mc)
##   mc.mechs_loaded.connect(...)
##   mc.fetch_mechs(ServerBridge.game_api_url)
##   mc.mech_selected.connect(...)
##   mc.select_mech(ServerBridge.game_api_url, mech_id, username)

signal mechs_loaded(mechs: Array)
signal mechs_failed(reason: String)
signal mech_selected(mech_id: int, type_string: String)
signal mech_failed(reason: String)

var _fetch_http: HTTPRequest
var _select_http: HTTPRequest


func _ready() -> void:
	_fetch_http = HTTPRequest.new()
	_fetch_http.timeout = 10.0
	add_child(_fetch_http)
	_fetch_http.request_completed.connect(_on_fetch_completed)

	_select_http = HTTPRequest.new()
	_select_http.timeout = 10.0
	add_child(_select_http)
	_select_http.request_completed.connect(_on_select_completed)


func fetch_mechs(game_api_url: String) -> void:
	var err := _fetch_http.request(game_api_url.trim_suffix("/") + "/mechs")
	if err != OK:
		mechs_failed.emit("request error %d" % err)


func select_mech(game_api_url: String, mech_id: int, username: String) -> void:
	var url := game_api_url.trim_suffix("/") + "/world/mech/select"
	var body := JSON.stringify({"mechId": mech_id})
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"X-Username: " + username,
	])
	var err := _select_http.request(url, headers, HTTPClient.METHOD_PATCH, body)
	if err != OK:
		mech_failed.emit("request error %d" % err)


func _on_fetch_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		mechs_failed.emit("connection failed")
		return
	if response_code != 200:
		mechs_failed.emit("HTTP %d" % response_code)
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not parsed.get("ok", false):
		mechs_failed.emit("unexpected response")
		return
	mechs_loaded.emit(parsed.get("mechs", []))


func _on_select_completed(
	result: int,
	response_code: int,
	_headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		mech_failed.emit("connection failed")
		return
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if response_code != 200:
		var msg: String
		if typeof(parsed) == TYPE_DICTIONARY:
			msg = str(parsed.get("error", "HTTP %d" % response_code))
		else:
			msg = "HTTP %d" % response_code
		mech_failed.emit(msg)
		return
	if typeof(parsed) == TYPE_DICTIONARY and parsed.get("ok", false):
		mech_selected.emit(int(parsed.get("mechId", 0)), str(parsed.get("typeString", "")))
	else:
		mech_failed.emit("unexpected response")
