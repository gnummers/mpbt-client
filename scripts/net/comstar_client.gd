extends Node

## ComStar REST client.
##
## Add as a child node to any scene that needs ComStar access.  Each
## operation uses its own HTTPRequest child so calls can overlap without
## queuing.
##
## Signals:
##   inbox_loaded(messages: Array)          — GET /comstar succeeded
##   inbox_failed(reason: String)           — GET /comstar failed
##   unread_count_loaded(count: int)        — GET /comstar/unread succeeded
##   unread_count_failed(reason: String)    — GET /comstar/unread failed
##   message_sent                           — POST /comstar succeeded
##   send_failed(reason: String)            — POST /comstar failed
##   marked_read(message_id: int)           — PATCH /comstar/:id/read succeeded
##   mark_failed(reason: String)            — PATCH failed
##   message_deleted(message_id: int)       — DELETE /comstar/:id succeeded
##   delete_failed(reason: String)          — DELETE failed

signal inbox_loaded(messages: Array)
signal inbox_failed(reason: String)
signal unread_count_loaded(count: int)
signal unread_count_failed(reason: String)
signal message_sent
signal send_failed(reason: String)
signal marked_read(message_id: int)
signal mark_failed(reason: String)
signal message_deleted(message_id: int)
signal delete_failed(reason: String)

var _inbox_http:   HTTPRequest
var _unread_http:  HTTPRequest
var _send_http:    HTTPRequest
var _read_http:    HTTPRequest
var _delete_http:  HTTPRequest

var _pending_read_id:   int = -1
var _pending_delete_id: int = -1


func _ready() -> void:
	_inbox_http  = _make_http(); _inbox_http.request_completed.connect(_on_inbox)
	_unread_http = _make_http(); _unread_http.request_completed.connect(_on_unread)
	_send_http   = _make_http(); _send_http.request_completed.connect(_on_sent)
	_read_http   = _make_http(); _read_http.request_completed.connect(_on_read)
	_delete_http = _make_http(); _delete_http.request_completed.connect(_on_deleted)


func _make_http() -> HTTPRequest:
	var h := HTTPRequest.new()
	h.timeout = 10.0
	add_child(h)
	return h


func _display_name() -> String:
	return str(AuthSession.character.get("display_name", ""))


func _auth_headers() -> PackedStringArray:
	return PackedStringArray(["X-Username: " + _display_name()])


## Fetch the full inbox (max 50 messages).
func fetch_inbox(base_url: String) -> void:
	_inbox_http.request(base_url + "/comstar", _auth_headers())


## Fetch only the unread count (lightweight).
func fetch_unread_count(base_url: String) -> void:
	_unread_http.request(base_url + "/comstar/unread", _auth_headers())


## Send a ComStar message.
func send_message(base_url: String, to: String, subject: String, body: String) -> void:
	var payload := JSON.stringify({"to": to, "subject": subject, "body": body})
	var headers := PackedStringArray([
		"X-Username: " + _display_name(),
		"Content-Type: application/json",
	])
	_send_http.request(
		base_url + "/comstar",
		headers,
		HTTPClient.METHOD_POST,
		payload,
	)


## Mark a message read.
func mark_read(base_url: String, message_id: int) -> void:
	_pending_read_id = message_id
	_read_http.request(
		base_url + "/comstar/%d/read" % message_id,
		_auth_headers(),
		HTTPClient.METHOD_PATCH,
	)


## Soft-delete a message.
func delete_message(base_url: String, message_id: int) -> void:
	_pending_delete_id = message_id
	_delete_http.request(
		base_url + "/comstar/%d" % message_id,
		_auth_headers(),
		HTTPClient.METHOD_DELETE,
	)


## ── Internal handlers ──────────────────────────────────────────────────────

func _on_inbox(
	result: int, code: int, _h: PackedStringArray, body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		inbox_failed.emit("HTTP %d" % code)
		return
	var data = JSON.parse_string(body.get_string_from_utf8())
	if typeof(data) != TYPE_DICTIONARY or not data.get("ok", false):
		inbox_failed.emit("parse error")
		return
	inbox_loaded.emit(data.get("messages", []))


func _on_unread(
	result: int, code: int, _h: PackedStringArray, body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		unread_count_failed.emit("HTTP %d" % code)
		return
	var data = JSON.parse_string(body.get_string_from_utf8())
	if typeof(data) != TYPE_DICTIONARY or not data.get("ok", false):
		unread_count_failed.emit("parse error")
		return
	unread_count_loaded.emit(int(data.get("count", 0)))


func _on_sent(
	result: int, code: int, _h: PackedStringArray, body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		var reason := _error_text(code, body)
		send_failed.emit(reason)
		return
	message_sent.emit()


func _on_read(
	result: int, code: int, _h: PackedStringArray, _body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or (code != 200 and code != 404):
		mark_failed.emit("HTTP %d" % code)
		return
	if code == 404:
		mark_failed.emit("not found")
		return
	marked_read.emit(_pending_read_id)


func _on_deleted(
	result: int, code: int, _h: PackedStringArray, _body: PackedByteArray
) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or (code != 200 and code != 404):
		delete_failed.emit("HTTP %d" % code)
		return
	if code == 404:
		delete_failed.emit("not found")
		return
	message_deleted.emit(_pending_delete_id)


func _error_text(code: int, body: PackedByteArray) -> String:
	var data = JSON.parse_string(body.get_string_from_utf8())
	if typeof(data) == TYPE_DICTIONARY:
		var err := str(data.get("error", ""))
		if not err.is_empty():
			return err
	return "HTTP %d" % code
