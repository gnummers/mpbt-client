class_name AuthClient
extends Node

## Low-level HTTP client for the mpbt-web NestJS auth and character API.
##
## Owned by AuthSession. Handles one request at a time; callers must respect the
## AuthSession._busy guard.  The _op field tracks which operation is in flight so
## _on_request_completed can dispatch to the right handler.

signal login_done(username: String, cookie: String)
signal register_done(username: String)
signal character_fetched(character: Dictionary)
signal character_done(character: Dictionary)
signal failed(op: String, reason: String)

var _http: HTTPRequest
var _op: String = ""


func _ready() -> void:
	_http = HTTPRequest.new()
	_http.timeout = 10.0
	add_child(_http)
	_http.request_completed.connect(_on_request_completed)


func post_login(api_url: String, username: String, password: String) -> void:
	_op = "login"
	var body := JSON.stringify({"username": username, "password": password})
	_send_post(api_url + "/auth/login", body)


func post_register(api_url: String, username: String, password: String, email: String) -> void:
	_op = "register"
	var body := JSON.stringify({"username": username, "password": password, "email": email})
	_send_post(api_url + "/auth/register", body)


func get_character(api_url: String, cookie: String) -> void:
	_op = "character_fetch"
	var headers := PackedStringArray(["Cookie: " + cookie])
	var err := _http.request(api_url + "/characters/me", headers, HTTPClient.METHOD_GET)
	if err != OK:
		failed.emit(_op, "request error %d" % err)


func post_character(
	api_url: String,
	display_name: String,
	allegiance: String,
	cookie: String,
) -> void:
	_op = "character_create"
	var body := JSON.stringify({"displayName": display_name, "allegiance": allegiance})
	var headers := PackedStringArray([
		"Content-Type: application/json",
		"Cookie: " + cookie,
	])
	var err := _http.request(api_url + "/characters", headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		failed.emit(_op, "request error %d" % err)


func _send_post(url: String, body: String) -> void:
	var headers := PackedStringArray(["Content-Type: application/json"])
	var err := _http.request(url, headers, HTTPClient.METHOD_POST, body)
	if err != OK:
		failed.emit(_op, "request error %d" % err)


func _on_request_completed(
	result: int,
	response_code: int,
	headers: PackedStringArray,
	body: PackedByteArray,
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		failed.emit(_op, _connection_reason(result))
		return

	match _op:
		"login":
			_handle_login(response_code, headers, body)
		"register":
			_handle_register(response_code, body)
		"character_fetch":
			_handle_character_fetch(response_code, body)
		"character_create":
			_handle_character_create(response_code, body)


func _handle_login(code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if code != 200:
		failed.emit("login", _parse_message(body) or "HTTP %d" % code)
		return

	var cookie := ""
	for h in headers:
		if h.to_lower().begins_with("set-cookie:"):
			var hval := h.substr(11).strip_edges()
			if hval.begins_with("mpbt_token="):
				cookie = hval.split(";")[0].strip_edges()
				break

	if cookie.is_empty():
		failed.emit("login", "no auth token in response")
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	var username := ""
	if typeof(parsed) == TYPE_DICTIONARY:
		username = str(parsed.get("username", ""))
	login_done.emit(username, cookie)


func _handle_register(code: int, body: PackedByteArray) -> void:
	if code != 201:
		failed.emit("register", _parse_message(body) or "HTTP %d" % code)
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	var username := ""
	if typeof(parsed) == TYPE_DICTIONARY:
		username = str(parsed.get("username", ""))
	register_done.emit(username)


func _handle_character_fetch(code: int, body: PackedByteArray) -> void:
	if code == 404:
		character_fetched.emit({})
		return
	if code != 200:
		failed.emit("character_fetch", "HTTP %d" % code)
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) == TYPE_DICTIONARY:
		character_fetched.emit(parsed)
	else:
		failed.emit("character_fetch", "unexpected response")


func _handle_character_create(code: int, body: PackedByteArray) -> void:
	if code != 201:
		failed.emit("character_create", _parse_message(body) or "HTTP %d" % code)
		return

	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) == TYPE_DICTIONARY:
		character_done.emit(parsed)
	else:
		failed.emit("character_create", "unexpected response")


func _parse_message(body: PackedByteArray) -> String:
	var parsed = JSON.parse_string(body.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return ""
	var msg = parsed.get("message", "")
	if typeof(msg) == TYPE_ARRAY:
		return "; ".join(PackedStringArray(msg))
	return str(msg)


func _connection_reason(result: int) -> String:
	match result:
		HTTPRequest.RESULT_CANT_CONNECT:
			return "server unavailable"
		HTTPRequest.RESULT_TIMEOUT:
			return "timed out"
		_:
			return "connection failed"
