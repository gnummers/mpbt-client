extends Control

## ComStar Terminal — private player-to-player messaging.
##
## Layout:
##   Left  panel — scrollable inbox list + Compose button
##   Right panel — message detail view  OR  compose form
##
## This scene owns its own ComstarClient instance.

var _comstar: Node  # ComstarClient

var _messages: Array = []
var _selected_msg: Dictionary = {}

# ── Header ──────────────────────────────────────────────────────────────────
@onready var _status_label: Label   = $MainVBox/Header/StatusLabel
@onready var _back_btn:     Button  = $MainVBox/Header/BackButton

# ── Left panel (inbox) ───────────────────────────────────────────────────────
@onready var _inbox_list:   VBoxContainer = $MainVBox/ContentHBox/LeftPanel/InboxScroll/InboxList
@onready var _compose_btn:  Button        = $MainVBox/ContentHBox/LeftPanel/ComposeButton

# ── Right panel ──────────────────────────────────────────────────────────────
@onready var _right_panel:  VBoxContainer = $MainVBox/ContentHBox/RightPanel

# Detail view nodes
@onready var _detail_view:  VBoxContainer = $MainVBox/ContentHBox/RightPanel/DetailView
@onready var _det_from:     Label         = $MainVBox/ContentHBox/RightPanel/DetailView/FromLabel
@onready var _det_subject:  Label         = $MainVBox/ContentHBox/RightPanel/DetailView/SubjectLabel
@onready var _det_date:     Label         = $MainVBox/ContentHBox/RightPanel/DetailView/DateLabel
@onready var _det_body:     Label         = $MainVBox/ContentHBox/RightPanel/DetailView/BodyLabel
@onready var _reply_btn:    Button        = $MainVBox/ContentHBox/RightPanel/DetailView/ActionBar/ReplyButton
@onready var _delete_btn:   Button        = $MainVBox/ContentHBox/RightPanel/DetailView/ActionBar/DeleteButton

# Compose view nodes
@onready var _compose_view: VBoxContainer = $MainVBox/ContentHBox/RightPanel/ComposeView
@onready var _to_field:     LineEdit      = $MainVBox/ContentHBox/RightPanel/ComposeView/ToField
@onready var _subject_field:LineEdit      = $MainVBox/ContentHBox/RightPanel/ComposeView/SubjectField
@onready var _body_field:   TextEdit      = $MainVBox/ContentHBox/RightPanel/ComposeView/BodyField
@onready var _send_btn:     Button        = $MainVBox/ContentHBox/RightPanel/ComposeView/ActionBar/SendButton
@onready var _cancel_btn:   Button        = $MainVBox/ContentHBox/RightPanel/ComposeView/ActionBar/CancelButton


func _ready() -> void:
	AudioManager.play_bgm("menu")

	_comstar = load("res://scripts/net/comstar_client.gd").new()
	add_child(_comstar)
	_comstar.inbox_loaded.connect(_on_inbox_loaded)
	_comstar.inbox_failed.connect(_on_inbox_failed)
	_comstar.message_sent.connect(_on_message_sent)
	_comstar.send_failed.connect(_on_send_failed)
	_comstar.marked_read.connect(_on_marked_read)
	_comstar.message_deleted.connect(_on_message_deleted)

	_back_btn.pressed.connect(_on_back_pressed)
	_compose_btn.pressed.connect(_on_compose_pressed)
	_reply_btn.pressed.connect(_on_reply_pressed)
	_delete_btn.pressed.connect(_on_delete_pressed)
	_send_btn.pressed.connect(_on_send_pressed)
	_cancel_btn.pressed.connect(_on_cancel_pressed)

	_show_detail(false)
	_show_compose(false)
	_set_status("Loading\u2026")

	if ServerBridge.is_online and not ServerBridge.game_api_url.is_empty():
		_comstar.fetch_inbox(ServerBridge.game_api_url)
	else:
		_set_status("Server offline")


func _set_status(text: String) -> void:
	_status_label.text = text


## ── Inbox ───────────────────────────────────────────────────────────────────

func _on_inbox_loaded(messages: Array) -> void:
	_messages = messages
	var unread := messages.filter(func(m): return m.get("readAt") == null).size()
	_set_status("Inbox (%d messages, %d unread)" % [messages.size(), unread])
	_populate_inbox()


func _on_inbox_failed(reason: String) -> void:
	_set_status("Failed to load inbox: %s" % reason)


func _populate_inbox() -> void:
	for child in _inbox_list.get_children():
		child.queue_free()

	if _messages.is_empty():
		var lbl := Label.new()
		lbl.text = "(no messages)"
		_inbox_list.add_child(lbl)
		return

	for msg in _messages:
		var btn := Button.new()
		var prefix := "" if msg.get("readAt") != null else "[NEW] "
		var from := str(msg.get("from", "?"))
		var subj := str(msg.get("subject", "(no subject)"))
		btn.text = "%s%s\n%s" % [prefix, from, subj]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(_on_message_selected.bind(msg))
		_inbox_list.add_child(btn)


func _on_message_selected(msg: Dictionary) -> void:
	_selected_msg = msg
	_show_compose(false)
	_populate_detail(msg)
	_show_detail(true)

	if msg.get("readAt") == null and not ServerBridge.game_api_url.is_empty():
		_comstar.mark_read(ServerBridge.game_api_url, int(msg.get("id", -1)))


func _populate_detail(msg: Dictionary) -> void:
	_det_from.text    = "From: %s" % str(msg.get("from", "?"))
	_det_subject.text = "Subject: %s" % str(msg.get("subject", "(no subject)"))
	_det_date.text    = "Sent: %s" % _format_date(str(msg.get("sentAt", "")))
	_det_body.text    = str(msg.get("body", ""))


func _format_date(iso: String) -> String:
	if iso.is_empty():
		return ""
	# Trim sub-seconds and Z: "2026-04-28T21:42:30.284Z" → "2026-04-28 21:42"
	var trimmed := iso.replace("T", " ").split(".")[0]
	return trimmed.substr(0, 16)


## ── Compose ─────────────────────────────────────────────────────────────────

func _on_compose_pressed() -> void:
	_show_detail(false)
	_to_field.text      = ""
	_subject_field.text = ""
	_body_field.text    = ""
	_show_compose(true)
	_to_field.grab_focus()


func _on_reply_pressed() -> void:
	var from := str(_selected_msg.get("from", ""))
	var orig_subject := str(_selected_msg.get("subject", ""))
	var re_subject := orig_subject if orig_subject.begins_with("Re: ") else "Re: " + orig_subject
	_show_detail(false)
	_to_field.text      = from
	_subject_field.text = re_subject
	_body_field.text    = ""
	_show_compose(true)
	_body_field.grab_focus()


func _on_cancel_pressed() -> void:
	_show_compose(false)
	if not _selected_msg.is_empty():
		_show_detail(true)


func _on_send_pressed() -> void:
	var to      := _to_field.text.strip_edges()
	var subject := _subject_field.text.strip_edges()
	var body    := _body_field.text.strip_edges()

	if to.is_empty():
		_set_status("Error: 'To' field is required")
		return
	if body.is_empty():
		_set_status("Error: message body is required")
		return
	if subject.length() > 100:
		_set_status("Error: subject must be 100 characters or fewer")
		return
	if body.length() > 1000:
		_set_status("Error: message must be 1000 characters or fewer")
		return
	if ServerBridge.game_api_url.is_empty():
		_set_status("Server offline")
		return

	_send_btn.disabled = true
	_set_status("Sending\u2026")
	_comstar.send_message(ServerBridge.game_api_url, to, subject, body)


func _on_message_sent() -> void:
	_send_btn.disabled = false
	_show_compose(false)
	_set_status("Message sent.")
	if not ServerBridge.game_api_url.is_empty():
		_comstar.fetch_inbox(ServerBridge.game_api_url)


func _on_send_failed(reason: String) -> void:
	_send_btn.disabled = false
	_set_status("Send failed: %s" % reason)


## ── Delete ──────────────────────────────────────────────────────────────────

func _on_delete_pressed() -> void:
	if _selected_msg.is_empty() or ServerBridge.game_api_url.is_empty():
		return
	_delete_btn.disabled = true
	_comstar.delete_message(ServerBridge.game_api_url, int(_selected_msg.get("id", -1)))


func _on_message_deleted(message_id: int) -> void:
	_delete_btn.disabled = false
	_show_detail(false)
	_selected_msg = {}
	_messages = _messages.filter(func(m): return int(m.get("id", -1)) != message_id)
	_populate_inbox()
	_set_status("Message deleted.")


## ── mark-read callback ──────────────────────────────────────────────────────

func _on_marked_read(message_id: int) -> void:
	for i in _messages.size():
		if int(_messages[i].get("id", -1)) == message_id:
			_messages[i] = _messages[i].duplicate()
			_messages[i]["readAt"] = "now"
			break
	_populate_inbox()


## ── Visibility helpers ───────────────────────────────────────────────────────

func _show_detail(visible: bool) -> void:
	_detail_view.visible = visible


func _show_compose(visible: bool) -> void:
	_compose_view.visible = visible


## ── Navigation ───────────────────────────────────────────────────────────────

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
