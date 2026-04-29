extends Control

## Arena Ready Room — stage a match and wait for opponents.
##
## Flow:
##   1. On _ready: gate check (logged-in + character + mech_id). Fetch queue.
##      Re-connect WS signals if needed.
##   2. UI state is always derived from the latest server snapshot:
##      _in_queue  ← username appears in slots
##      _is_ready  ← slot.ready == true
##   3. Join → POST /arena/queue → WS arena_queue_update refreshes display.
##   4. Ready → PATCH /arena/ready {ready:true} → WS update / launch.
##   5. arena_match_launch → store arenaId in AuthSession, change to combat.
##   6. Back: if in queue, await leave first (disables button); then navigate.
##   7. WS disconnect: fall back to REST polling every 5 s.

const MAIN_SCENE   := "res://scenes/main/main.tscn"
const COMBAT_SCENE := "res://scenes/combat/combat.tscn"

@onready var _mech_label:   Label      = $MainVBox/Header/MechLabel
@onready var _slot_list:    VBoxContainer = $MainVBox/ContentHBox/QueuePanel/QueueVBox/SlotList
@onready var _status_label: Label      = $MainVBox/ContentHBox/ActionPanel/ActionMargin/ActionVBox/StatusLabel
@onready var _join_button:  Button     = $MainVBox/ContentHBox/ActionPanel/ActionMargin/ActionVBox/JoinButton
@onready var _ready_button: Button     = $MainVBox/ContentHBox/ActionPanel/ActionMargin/ActionVBox/ReadyButton
@onready var _leave_button: Button     = $MainVBox/ContentHBox/ActionPanel/ActionMargin/ActionVBox/LeaveButton
@onready var _back_button:  Button     = $MainVBox/Header/BackButton
@onready var _poll_timer:   Timer      = $PollTimer

var _arena_client: ArenaClient
var _in_queue: bool = false
var _is_ready: bool = false
var _navigating: bool = false


func _ready() -> void:
	AudioManager.play_bgm("arena")
	_arena_client = ArenaClient.new()
	add_child(_arena_client)
	_arena_client.queue_fetched.connect(_on_queue_fetched)
	_arena_client.queue_fetch_failed.connect(_on_queue_fetch_failed)
	_arena_client.queue_joined.connect(_on_queue_joined)
	_arena_client.queue_failed.connect(_on_queue_failed)
	_arena_client.queue_left.connect(_on_queue_left)
	_arena_client.leave_failed.connect(_on_leave_failed)
	_arena_client.ready_set.connect(_on_ready_set)
	_arena_client.ready_failed.connect(_on_ready_failed)

	WSClient.arena_queue_updated.connect(_on_arena_queue_updated)
	WSClient.arena_match_launched.connect(_on_arena_match_launched)
	WSClient.ws_connected.connect(_on_ws_connected)
	WSClient.ws_disconnected.connect(_on_ws_disconnected)

	# Gate: must be logged in with a character and mech selected.
	if not AuthSession.is_logged_in or AuthSession.character.is_empty():
		get_tree().change_scene_to_file(MAIN_SCENE)
		return
	var mech_id = AuthSession.character.get("mech_id", null)
	if mech_id == null:
		_status_label.text = "Select a mech in the Mech Bay first."
		_join_button.disabled = true
		return

	var mech_type := str(AuthSession.character.get("mech_type", ""))
	if mech_type.is_empty():
		_mech_label.text = "Mech: #%d" % int(mech_id)
	else:
		_mech_label.text = "Mech: %s" % mech_type

	_ready_button.visible = false
	_leave_button.visible = false

	if ServerBridge.game_api_url.is_empty():
		_status_label.text = "Game server not available."
		_join_button.disabled = true
		return

	_status_label.text = "Loading queue..."
	_arena_client.fetch_queue(ServerBridge.game_api_url)


# ── Queue display ─────────────────────────────────────────────────────────────

func _update_queue_display(slots: Array) -> void:
	for child in _slot_list.get_children():
		child.queue_free()

	if slots.is_empty():
		var lbl := Label.new()
		lbl.text = "(empty)"
		_slot_list.add_child(lbl)
		return

	for slot in slots:
		var uname := str(slot.get("username", "?"))
		var ts := str(slot.get("typeString", ""))
		var ready: bool = bool(slot.get("ready", false))
		var lbl := Label.new()
		if ts.is_empty():
			lbl.text = "%s %s" % [uname, "[READY]" if ready else ""]
		else:
			lbl.text = "%s (%s) %s" % [uname, ts, "[READY]" if ready else ""]
		_slot_list.add_child(lbl)


func _derive_local_state(slots: Array) -> void:
	var my_name := str(AuthSession.character.get("display_name", ""))
	_in_queue = false
	_is_ready = false
	for slot in slots:
		if str(slot.get("username", "")) == my_name:
			_in_queue = true
			_is_ready = bool(slot.get("ready", false))
			break
	_update_buttons()


func _update_buttons() -> void:
	_join_button.visible  = not _in_queue
	_leave_button.visible = _in_queue
	_ready_button.visible = _in_queue
	_ready_button.text = "Cancel Ready" if _is_ready else "Ready"
	if _in_queue:
		_join_button.disabled = true


# ── REST callbacks ────────────────────────────────────────────────────────────

func _on_queue_fetched(slots: Array, _pending_match: Variant) -> void:
	_update_queue_display(slots)
	_derive_local_state(slots)
	_status_label.text = "Queue: %d player%s" % [slots.size(), "s" if slots.size() != 1 else ""]


func _on_queue_fetch_failed(reason: String) -> void:
	_status_label.text = "Failed to load queue: %s" % reason


func _on_queue_joined(_slot: Dictionary) -> void:
	# WS arena_queue_update will refresh display; local optimistic state:
	_status_label.text = "In queue — set Ready when prepared to fight."


func _on_queue_failed(reason: String) -> void:
	_status_label.text = "Could not join: %s" % reason
	_join_button.disabled = false


func _on_queue_left() -> void:
	_in_queue = false
	_is_ready = false
	_update_buttons()
	_status_label.text = "Left queue."
	if _navigating:
		get_tree().change_scene_to_file(MAIN_SCENE)


func _on_leave_failed(_reason: String) -> void:
	# Best-effort: navigate anyway so the player isn't stuck.
	if _navigating:
		get_tree().change_scene_to_file(MAIN_SCENE)


func _on_ready_set(ready: bool, launched: bool, _arena_id: String) -> void:
	if launched:
		# The arena_match_launched WS event handles the actual scene transition.
		_status_label.text = "Match launching..."
		return
	_is_ready = ready
	_update_buttons()
	_status_label.text = "Ready! Waiting for all players..." if ready else "Ready cancelled."


func _on_ready_failed(reason: String) -> void:
	_status_label.text = "Ready failed: %s" % reason


# ── WebSocket callbacks ───────────────────────────────────────────────────────

func _on_arena_queue_updated(slots: Array) -> void:
	_update_queue_display(slots)
	_derive_local_state(slots)
	_status_label.text = "Queue: %d player%s" % [slots.size(), "s" if slots.size() != 1 else ""]


func _on_arena_match_launched(data: Dictionary) -> void:
	var arena_id := str(data.get("arenaId", ""))
	var mode := str(data.get("mode", "pvp"))
	var slots: Array = data.get("slots", [])

	# Check if this player is in the launched match.
	var my_name := str(AuthSession.character.get("display_name", ""))
	var in_match := false
	for slot in slots:
		if str(slot.get("username", "")) == my_name:
			in_match = true
			break
	if not in_match:
		return

	# Persist launch context before changing scenes.
	AuthSession.pending_match = {
		"arenaId": arena_id,
		"mode": mode,
		"slots": slots,
	}

	_status_label.text = "Match launching! (%s)" % ("Solo vs Bot" if mode == "solo" else "PvP")
	get_tree().change_scene_to_file(COMBAT_SCENE)


func _on_ws_connected() -> void:
	_poll_timer.stop()


func _on_ws_disconnected() -> void:
	if not _navigating and not ServerBridge.game_api_url.is_empty():
		_poll_timer.start()


# ── Button handlers ───────────────────────────────────────────────────────────

func _on_join_pressed() -> void:
	if ServerBridge.game_api_url.is_empty():
		return
	_join_button.disabled = true
	_status_label.text = "Joining queue..."
	var username := str(AuthSession.character.get("display_name", ""))
	_arena_client.join_queue(ServerBridge.game_api_url, username)


func _on_leave_pressed() -> void:
	if ServerBridge.game_api_url.is_empty():
		return
	_leave_button.disabled = true
	_status_label.text = "Leaving queue..."
	var username := str(AuthSession.character.get("display_name", ""))
	_arena_client.leave_queue(ServerBridge.game_api_url, username)


func _on_ready_pressed() -> void:
	if ServerBridge.game_api_url.is_empty():
		return
	_ready_button.disabled = true
	var username := str(AuthSession.character.get("display_name", ""))
	_arena_client.set_ready(ServerBridge.game_api_url, username, not _is_ready)


func _on_back_pressed() -> void:
	if _navigating:
		return
	_navigating = true
	_back_button.disabled = true

	if _in_queue and not ServerBridge.game_api_url.is_empty():
		# Await leave before navigating; _on_queue_left / _on_leave_failed will navigate.
		var username := str(AuthSession.character.get("display_name", ""))
		_arena_client.leave_queue(ServerBridge.game_api_url, username)
	else:
		get_tree().change_scene_to_file(MAIN_SCENE)


# ── Poll timer (WS fallback) ──────────────────────────────────────────────────

func _on_poll_timer_timeout() -> void:
	if WSClient.is_ws_connected:
		_poll_timer.stop()
		return
	if not ServerBridge.game_api_url.is_empty():
		_arena_client.fetch_queue(ServerBridge.game_api_url)
