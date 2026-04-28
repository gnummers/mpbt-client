class_name ArenaClient
extends Node

## REST client for arena queue management.
##
## Calls:
##   GET    /arena/queue              → fetch_queue()
##   POST   /arena/queue (X-Username) → join_queue()  — mech derived server-side
##   DELETE /arena/queue (X-Username) → leave_queue()
##   PATCH  /arena/ready  (X-Username) → set_ready()
##
## All signal callbacks fire on the main thread via await get_tree().process_frame.

signal queue_fetched(slots: Array, pending_match: Variant)
signal queue_fetch_failed(reason: String)
signal queue_joined(slot: Dictionary)
signal queue_failed(reason: String)
signal queue_left
signal leave_failed(reason: String)
signal ready_set(ready: bool, launched: bool, arena_id: String)
signal ready_failed(reason: String)


func fetch_queue(base_url: String) -> void:
	var url := base_url.trim_suffix("/") + "/arena/queue"
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(
		func(result, code, _headers, body):
			http.queue_free()
			if result != HTTPRequest.RESULT_SUCCESS:
				queue_fetch_failed.emit("HTTP error %d" % result)
				return
			var data = JSON.parse_string(body.get_string_from_utf8())
			if data == null or not data.get("ok", false):
				queue_fetch_failed.emit(str(data.get("error", "Unknown error")) if data else "Parse error")
				return
			queue_fetched.emit(data.get("slots", []), data.get("pendingMatch", null))
	)
	http.request(url)


func join_queue(base_url: String, username: String) -> void:
	var url := base_url.trim_suffix("/") + "/arena/queue"
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(
		func(result, code, _headers, body):
			http.queue_free()
			if result != HTTPRequest.RESULT_SUCCESS:
				queue_failed.emit("HTTP error %d" % result)
				return
			var data = JSON.parse_string(body.get_string_from_utf8())
			if data == null or not data.get("ok", false):
				queue_failed.emit(str(data.get("error", "Unknown error")) if data else "Parse error")
				return
			queue_joined.emit(data.get("slot", {}))
	)
	var headers := PackedStringArray(["Content-Type: application/json", "X-Username: " + username])
	http.request(url, headers, HTTPClient.METHOD_POST, "{}")


func leave_queue(base_url: String, username: String) -> void:
	var url := base_url.trim_suffix("/") + "/arena/queue"
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(
		func(result, code, _headers, body):
			http.queue_free()
			if result != HTTPRequest.RESULT_SUCCESS:
				leave_failed.emit("HTTP error %d" % result)
				return
			var data = JSON.parse_string(body.get_string_from_utf8())
			if data == null or not data.get("ok", false):
				leave_failed.emit(str(data.get("error", "Unknown error")) if data else "Parse error")
				return
			queue_left.emit()
	)
	var headers := PackedStringArray(["X-Username: " + username])
	http.request(url, headers, HTTPClient.METHOD_DELETE, "")


func set_ready(base_url: String, username: String, ready: bool) -> void:
	var url := base_url.trim_suffix("/") + "/arena/ready"
	var http := HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(
		func(result, code, _headers, body):
			http.queue_free()
			if result != HTTPRequest.RESULT_SUCCESS:
				ready_failed.emit("HTTP error %d" % result)
				return
			var data = JSON.parse_string(body.get_string_from_utf8())
			if data == null or not data.get("ok", false):
				ready_failed.emit(str(data.get("error", "Unknown error")) if data else "Parse error")
				return
			var launched := bool(data.get("launched", false))
			var arena_id := str(data.get("arenaId", ""))
			ready_set.emit(ready, launched, arena_id)
	)
	var body_str := JSON.stringify({"ready": ready})
	var headers := PackedStringArray(["Content-Type: application/json", "X-Username: " + username])
	http.request(url, headers, HTTPClient.METHOD_PATCH, body_str)
