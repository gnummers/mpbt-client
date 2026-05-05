extends Control

## ComStar Terminal — private player-to-player messaging inside the same retail
## world-shell chrome used by the world and standings scenes.

const MAIN_SCENE := "res://scenes/main/main.tscn"
const WORLD_SCENE := "res://scenes/world/world.tscn"
const LOGIN_SCENE := "res://scenes/login/login.tscn"
const MECH_SCENE := "res://scenes/mech/mech_select.tscn"
const STANDINGS_SCENE := "res://scenes/standings/standings.tscn"
const SETTINGS_SCENE := "res://scenes/settings/settings.tscn"
const ARENA_SCENE := "res://scenes/arena/ready_room.tscn"
const COMSTAR_REPLY_TAG_LENGTH := 9
const COMSTAR_BODY_CHARS_PER_LINE := 92
const COMSTAR_BODY_LINES_PER_PAGE := 12

var _comstar: Node  # ComstarClient
var _messages: Array = []
var _selected_msg: Dictionary = {}
var _command_texture: Texture2D = null
var _selected_reply_prefix := ""
var _compose_reply_prefix := ""
var _message_body_pages: Array[String] = []
var _message_body_page := 0

@onready var _shell_north: TextureRect = $ShellNorth
@onready var _shell_south: TextureRect = $ShellSouth
@onready var _shell_west: TextureRect = $ShellWest
@onready var _shell_east: TextureRect = $ShellEast
@onready var _message_north: TextureRect = $MainVBox/MessagePanel/MessageNorth
@onready var _message_south: TextureRect = $MainVBox/MessagePanel/MessageSouth
@onready var _message_west: TextureRect = $MainVBox/MessagePanel/MessageWest
@onready var _message_east: TextureRect = $MainVBox/MessagePanel/MessageEast
@onready var _inbox_north: TextureRect = $MainVBox/ContentHBox/InboxShell/InboxNorth
@onready var _inbox_south: TextureRect = $MainVBox/ContentHBox/InboxShell/InboxSouth
@onready var _inbox_west: TextureRect = $MainVBox/ContentHBox/InboxShell/InboxWest
@onready var _inbox_east: TextureRect = $MainVBox/ContentHBox/InboxShell/InboxEast
@onready var _detail_north: TextureRect = $MainVBox/ContentHBox/DetailShell/DetailNorth
@onready var _detail_south: TextureRect = $MainVBox/ContentHBox/DetailShell/DetailSouth
@onready var _detail_west: TextureRect = $MainVBox/ContentHBox/DetailShell/DetailWest
@onready var _detail_east: TextureRect = $MainVBox/ContentHBox/DetailShell/DetailEast

@onready var _status_label: Label = $MainVBox/MessagePanel/MessageMargin/MessageVBox/StatusLabel
@onready var _user_label: Label = $MainVBox/MessagePanel/MessageMargin/MessageVBox/UserLabel
@onready var _help_button: Button = $MainVBox/CommandBar/HelpButton
@onready var _travel_button: Button = $MainVBox/CommandBar/TravelButton
@onready var _mech_button: Button = $MainVBox/CommandBar/MechButton
@onready var _side_button: Button = $MainVBox/CommandBar/SideButton
@onready var _status_button: Button = $MainVBox/CommandBar/StatusButton
@onready var _fight_button: Button = $MainVBox/CommandBar/FightButton
@onready var _comstar_quick_button: Button = $MainVBox/QuickBar/LeftQuickButtons/ComstarQuickButton
@onready var _settings_quick_button: Button = $MainVBox/QuickBar/LeftQuickButtons/SettingsQuickButton
@onready var _mech_quick_button: Button = $MainVBox/QuickBar/RightQuickButtons/MechQuickButton
@onready var _exit_quick_button: Button = $MainVBox/QuickBar/RightQuickButtons/ExitQuickButton

@onready var _inbox_list: VBoxContainer = $MainVBox/ContentHBox/InboxShell/InboxMargin/InboxVBox/InboxScroll/InboxList
@onready var _compose_btn: Button = $MainVBox/ContentHBox/InboxShell/InboxMargin/InboxVBox/ComposeButton
@onready var _placeholder_label: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/PlaceholderLabel
@onready var _detail_title: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailTitle
@onready var _detail_view: VBoxContainer = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView
@onready var _det_from: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/FromLabel
@onready var _det_subject: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/SubjectLabel
@onready var _det_date: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/DateLabel
@onready var _det_body: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/BodyLabel
@onready var _reply_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/ActionBar/ReplyButton
@onready var _delete_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/ActionBar/DeleteButton
@onready var _compose_view: VBoxContainer = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView
@onready var _to_field: LineEdit = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/ToRow/ToField
@onready var _subject_row: HBoxContainer = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/SubjectRow
@onready var _subject_field: LineEdit = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/SubjectRow/SubjectField
@onready var _body_field: TextEdit = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/BodyField
@onready var _send_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/ActionBar/SendButton
@onready var _cancel_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/ActionBar/CancelButton


func _ready() -> void:
	AudioManager.play_bgm("menu")
	_apply_retail_shell_art()
	_refresh_command_bar()
	_user_label.text = _user_summary()
	_detail_title.text = "ComStar Message"
	_subject_row.visible = false
	_subject_field.text = ""
	_to_field.placeholder_text = "Display name or 5-char ComStar ID"
	_delete_btn.visible = false

	_comstar = load("res://scripts/net/comstar_client.gd").new()
	add_child(_comstar)
	_comstar.inbox_loaded.connect(_on_inbox_loaded)
	_comstar.inbox_failed.connect(_on_inbox_failed)
	_comstar.message_sent.connect(_on_message_sent)
	_comstar.send_failed.connect(_on_send_failed)
	_comstar.marked_read.connect(_on_marked_read)
	_comstar.mark_failed.connect(_on_mark_failed)
	_comstar.message_deleted.connect(_on_message_deleted)
	_comstar.delete_failed.connect(_on_delete_failed)
	if not WSClient.comstar_message_received.is_connected(_on_comstar_message_received):
		WSClient.comstar_message_received.connect(_on_comstar_message_received)

	_show_detail(false)
	_show_compose(false)
	_compose_btn.disabled = true
	_set_status("Loading inbox...")

	if ServerBridge.is_online and not ServerBridge.game_api_url.is_empty():
		_compose_btn.disabled = false
		_comstar.fetch_inbox(ServerBridge.game_api_url)
	else:
		ServerBridge.server_available.connect(_on_server_available, CONNECT_ONE_SHOT)
		ServerBridge.server_unavailable.connect(_on_server_unavailable, CONNECT_ONE_SHOT)
		ServerBridge.check_config()


func _apply_retail_shell_art() -> void:
	var extracted := ClientConfig.asset_extracted_path()
	if extracted.is_empty():
		return

	_apply_shell_texture(_shell_north, _load_world_ui_texture(extracted, ["fuln"]))
	_apply_shell_texture(_shell_south, _load_world_ui_texture(extracted, ["fuls"]))
	_apply_shell_texture(_shell_west, _load_world_ui_texture(extracted, ["fulw"]))
	_apply_shell_texture(_shell_east, _load_world_ui_texture(extracted, ["fule"]))
	_apply_shell_texture(_message_north, _load_world_ui_texture(extracted, ["radn"]))
	_apply_shell_texture(_message_south, _load_world_ui_texture(extracted, ["rads"]))
	_apply_shell_texture(_message_west, _load_world_ui_texture(extracted, ["radw"]))
	_apply_shell_texture(_message_east, _load_world_ui_texture(extracted, ["rade"]))
	_apply_shell_texture(_inbox_north, _load_world_ui_texture(extracted, ["recn"]))
	_apply_shell_texture(_inbox_south, _load_world_ui_texture(extracted, ["recs"]))
	_apply_shell_texture(_inbox_west, _load_world_ui_texture(extracted, ["recw"]))
	_apply_shell_texture(_inbox_east, _load_world_ui_texture(extracted, ["rece"]))
	_apply_shell_texture(_detail_north, _load_world_ui_texture(extracted, ["dscn"]))
	_apply_shell_texture(_detail_south, _load_world_ui_texture(extracted, ["dscs"]))
	_apply_shell_texture(_detail_west, _load_world_ui_texture(extracted, ["dscw"]))
	_apply_shell_texture(_detail_east, _load_world_ui_texture(extracted, ["dsce"]))

	_command_texture = _load_world_ui_texture(extracted, ["buta", "button"])
	_apply_command_button_art()
	_apply_action_button_art()
	_apply_quick_action_icon(_comstar_quick_button, _load_world_ui_texture(extracted, ["cstr", "comstar"]), "ComStar")
	_apply_quick_action_icon(_settings_quick_button, _load_world_ui_texture(extracted, ["optn", "settings", "options"]), "Settings")
	_apply_quick_action_icon(_mech_quick_button, _load_world_ui_texture(extracted, ["vmec", "mech"]), "Mech Bay")
	_apply_quick_action_icon(_exit_quick_button, _load_world_ui_texture(extracted, ["exit"]), "Menu")


func _load_world_ui_texture(extracted_path: String, hints: Array) -> Texture2D:
	var art_path := AssetRegistry.find_image(extracted_path, ["UI"], hints)
	return AssetRegistry.load_image_texture(art_path)


func _apply_shell_texture(node: TextureRect, texture: Texture2D) -> void:
	node.texture = texture
	node.visible = texture != null


func _apply_command_button_art() -> void:
	for button in [_help_button, _travel_button, _mech_button, _side_button, _status_button, _fight_button]:
		_apply_button_art(button)


func _apply_action_button_art() -> void:
	for button in [_compose_btn, _reply_btn, _delete_btn, _send_btn, _cancel_btn]:
		_apply_button_art(button, 13)


func _apply_button_art(button: Button, font_size: int = 14) -> void:
	if _command_texture == null:
		return
	var style := StyleBoxTexture.new()
	style.texture = _command_texture
	button.add_theme_stylebox_override("normal", style)
	button.add_theme_stylebox_override("hover", style)
	button.add_theme_stylebox_override("pressed", style)
	button.add_theme_stylebox_override("disabled", style)
	button.add_theme_font_size_override("font_size", font_size)


func _apply_quick_action_icon(button: Button, texture: Texture2D, tooltip: String) -> void:
	button.tooltip_text = tooltip
	if texture == null:
		return
	button.icon = texture
	button.expand_icon = true
	button.text = ""


func _user_summary() -> String:
	var char_name := AuthSession.character.get("display_name", "") as String
	if not AuthSession.username.is_empty() and not char_name.is_empty():
		return "%s / %s" % [AuthSession.username, char_name]
	if not AuthSession.username.is_empty():
		return AuthSession.username
	return "Guest Access"


func _set_status(text: String, color: Color = Color(0.72, 0.72, 0.72, 1.0)) -> void:
	_status_label.text = text
	_status_label.modulate = color


func _on_server_available(_info: Dictionary) -> void:
	_refresh_command_bar()
	_compose_btn.disabled = false
	_set_status("Loading inbox...")
	_comstar.fetch_inbox(ServerBridge.game_api_url)


func _on_server_unavailable(reason: String) -> void:
	_refresh_command_bar()
	_compose_btn.disabled = true
	_set_status("Server offline - %s" % reason, Color(1.0, 0.45, 0.45))


func _refresh_command_bar() -> void:
	_travel_button.disabled = false
	_mech_button.disabled = not AuthSession.is_logged_in or AuthSession.character.is_empty()
	_side_button.disabled = false
	_status_button.disabled = true
	_fight_button.disabled = (
		not AuthSession.is_logged_in
		or AuthSession.character.is_empty()
		or AuthSession.character.get("mech_id", null) == null
	)
	_comstar_quick_button.disabled = true
	_settings_quick_button.disabled = false
	_mech_quick_button.disabled = _mech_button.disabled
	_exit_quick_button.disabled = false


func _populate_inbox() -> void:
	for child in _inbox_list.get_children():
		child.queue_free()

	if _messages.is_empty():
		var lbl := Label.new()
		lbl.text = "(no messages)"
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_inbox_list.add_child(lbl)
		return

	for msg_v in _messages:
		var msg := msg_v as Dictionary
		var btn := Button.new()
		var from := str(msg.get("from", "?"))
		var code := str(msg.get("fromComstarCode", ""))
		var preview := _visible_comstar_body(str(msg.get("body", "")))
		if preview.is_empty():
			preview = _visible_comstar_body(str(msg.get("preview", "")))
		preview = _build_preview(preview)
		var label := from if code.is_empty() else "%s [%s]" % [from, code]
		btn.text = "%s\n%s" % [label, preview]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(_on_message_selected.bind(msg))
		_inbox_list.add_child(btn)


func _populate_detail(msg: Dictionary) -> void:
	var from := str(msg.get("from", "?"))
	var code := str(msg.get("fromComstarCode", ""))
	var body_parts := _extract_reply_prefix_tags(str(msg.get("body", "")))
	_selected_reply_prefix = str(body_parts.get("reply_prefix", ""))
	_det_from.text = "From: %s" % from
	_det_subject.visible = not code.is_empty()
	_det_subject.text = "ComStar ID: %s" % code
	_det_date.text = "Sent: %s" % _format_date(str(msg.get("sentAt", "")))
	_set_message_body_pages(str(body_parts.get("body", "")))


func _extract_reply_prefix_tags(body: String) -> Dictionary:
	var visible := ""
	var reply_prefix := ""
	var i := 0
	while i < body.length():
		if _is_reply_prefix_tag_at(body, i):
			reply_prefix += body.substr(i, COMSTAR_REPLY_TAG_LENGTH)
			i += COMSTAR_REPLY_TAG_LENGTH
			continue
		visible += body.substr(i, 1)
		i += 1
	return {"body": visible, "reply_prefix": reply_prefix}


func _visible_comstar_body(body: String) -> String:
	return str(_extract_reply_prefix_tags(body).get("body", ""))


func _is_reply_prefix_tag_at(body: String, index: int) -> bool:
	if index + COMSTAR_REPLY_TAG_LENGTH > body.length():
		return false
	if body.substr(index, 1) != "[" or body.substr(index + 8, 1) != "]":
		return false
	var kind := body.substr(index + 1, 1).to_lower()
	if kind != "p" and kind != "r":
		return false
	for i in range(index + 2, index + 8):
		var code := body.unicode_at(i)
		var is_digit := code >= 48 and code <= 57
		var is_upper := code >= 65 and code <= 90
		var is_lower := code >= 97 and code <= 122
		if not is_digit and not is_upper and not is_lower:
			return false
	return true


func _build_preview(body: String) -> String:
	for line in body.split("\n", true):
		var trimmed := str(line).strip_edges()
		if not trimmed.is_empty():
			return trimmed.substr(0, 84)
	return ""


func _set_message_body_pages(body: String) -> void:
	_message_body_pages.clear()
	_message_body_page = 0
	var wrapped_lines := _wrap_message_body_lines(body)
	if wrapped_lines.is_empty():
		_message_body_pages.append("")
	else:
		var line_index := 0
		while line_index < wrapped_lines.size():
			var page_lines := wrapped_lines.slice(line_index, line_index + COMSTAR_BODY_LINES_PER_PAGE)
			_message_body_pages.append("\n".join(page_lines))
			line_index += COMSTAR_BODY_LINES_PER_PAGE
	_render_message_body_page()


func _wrap_message_body_lines(body: String) -> Array[String]:
	var lines: Array[String] = []
	var normalized := body.replace("\r\n", "\n").replace("\r", "\n")
	for raw_line_v in normalized.split("\n", true):
		var raw_line := str(raw_line_v)
		if raw_line.is_empty():
			lines.append("")
			continue
		var line := raw_line
		while line.length() > COMSTAR_BODY_CHARS_PER_LINE:
			var cut := line.rfind(" ", COMSTAR_BODY_CHARS_PER_LINE)
			if cut < 40:
				cut = COMSTAR_BODY_CHARS_PER_LINE
			lines.append(line.substr(0, cut))
			line = line.substr(cut).strip_edges(true, false)
		lines.append(line)
	return lines


func _render_message_body_page() -> void:
	if _message_body_pages.is_empty():
		_det_body.text = ""
		return
	_message_body_page = clampi(_message_body_page, 0, _message_body_pages.size() - 1)
	_det_body.text = _message_body_pages[_message_body_page]


func _advance_message_body_page(delta: int) -> void:
	if _message_body_pages.size() <= 1:
		return
	_message_body_page = clampi(_message_body_page + delta, 0, _message_body_pages.size() - 1)
	_render_message_body_page()


func _format_date(iso: String) -> String:
	if iso.is_empty():
		return ""
	var trimmed := iso.replace("T", " ").split(".")[0]
	return trimmed.substr(0, 16)


func _show_detail(visible: bool) -> void:
	_detail_view.visible = visible
	if not visible:
		_message_body_pages.clear()
		_message_body_page = 0
		_selected_reply_prefix = ""
	_refresh_right_panel_visibility()
	_refresh_detail_actions()


func _show_compose(visible: bool) -> void:
	_compose_view.visible = visible
	if not visible:
		_compose_reply_prefix = ""
	_refresh_right_panel_visibility()
	_refresh_detail_actions()


func _refresh_right_panel_visibility() -> void:
	_placeholder_label.visible = not _detail_view.visible and not _compose_view.visible


func _refresh_detail_actions() -> void:
	var can_reply := (
		not _selected_msg.is_empty()
		and not ServerBridge.game_api_url.is_empty()
		and int(_selected_msg.get("replyTargetId", 0)) != 0
	)
	_reply_btn.disabled = not can_reply
	_delete_btn.disabled = true


func _on_inbox_loaded(messages: Array) -> void:
	_messages = messages
	var unread := messages.filter(func(m): return m.get("readAt") == null).size()
	_compose_btn.disabled = false
	_set_status("Inbox (%d messages, %d unread)" % [messages.size(), unread], Color(0.45, 1.0, 0.35))
	_populate_inbox()


func _on_inbox_failed(reason: String) -> void:
	_set_status("Failed to load inbox: %s" % reason, Color(1.0, 0.45, 0.45))


func _on_message_selected(msg: Dictionary) -> void:
	_selected_msg = msg
	_show_compose(false)
	_populate_detail(msg)
	_show_detail(true)

	if msg.get("readAt") == null and not ServerBridge.game_api_url.is_empty():
		_comstar.mark_read(ServerBridge.game_api_url, int(msg.get("id", -1)))


func _on_compose_pressed() -> void:
	_show_detail(false)
	_compose_reply_prefix = ""
	_to_field.text = ""
	_body_field.text = ""
	_show_compose(true)
	_to_field.grab_focus()


func _on_reply_pressed() -> void:
	if _selected_msg.is_empty():
		return
	var reply_to := str(_selected_msg.get("fromComstarCode", ""))
	if reply_to.is_empty():
		reply_to = str(_selected_msg.get("from", ""))
	_compose_reply_prefix = _selected_reply_prefix
	_show_detail(false)
	_to_field.text = reply_to
	_body_field.text = ""
	_show_compose(true)
	_body_field.grab_focus()


func _on_cancel_pressed() -> void:
	_show_compose(false)
	if not _selected_msg.is_empty():
		_show_detail(true)


func _on_send_pressed() -> void:
	var to := _to_field.text.strip_edges()
	var body := _body_field.text.strip_edges()

	if to.is_empty():
		_set_status("Error: 'To' field is required", Color(1.0, 0.45, 0.45))
		return
	if body.is_empty():
		_set_status("Error: message body is required", Color(1.0, 0.45, 0.45))
		return
	if ServerBridge.game_api_url.is_empty():
		_set_status("Server offline", Color(1.0, 0.45, 0.45))
		return

	_send_btn.disabled = true
	_set_status("Sending...")
	_comstar.send_message(ServerBridge.game_api_url, to, _compose_reply_prefix + body)


func _on_message_sent() -> void:
	_send_btn.disabled = false
	_show_compose(false)
	_compose_reply_prefix = ""
	_to_field.text = ""
	_body_field.text = ""
	_set_status("ComStar message queued.", Color(0.45, 1.0, 0.35))
	if not ServerBridge.game_api_url.is_empty():
		_comstar.fetch_inbox(ServerBridge.game_api_url)


func _on_send_failed(reason: String) -> void:
	_send_btn.disabled = false
	_set_status("Send failed: %s" % reason, Color(1.0, 0.45, 0.45))


func _on_delete_pressed() -> void:
	if _selected_msg.is_empty() or ServerBridge.game_api_url.is_empty():
		return
	_delete_btn.disabled = true
	_comstar.delete_message(ServerBridge.game_api_url, int(_selected_msg.get("id", -1)))


func _on_message_deleted(message_id: int) -> void:
	_delete_btn.disabled = false
	_show_detail(false)
	_selected_msg = {}
	_selected_reply_prefix = ""
	_messages = _messages.filter(func(m): return int(m.get("id", -1)) != message_id)
	_populate_inbox()
	_set_status("Message dismissed.", Color(0.45, 1.0, 0.35))


func _on_delete_failed(reason: String) -> void:
	_delete_btn.disabled = false
	_set_status("Dismiss failed: %s" % reason, Color(1.0, 0.45, 0.45))


func _on_marked_read(message_id: int) -> void:
	_messages = _messages.filter(func(m): return int(m.get("id", -1)) != message_id)
	_populate_inbox()


func _unhandled_key_input(event: InputEvent) -> void:
	if not (event is InputEventKey):
		return
	var key_event := event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	var focus := get_viewport().gui_get_focus_owner()
	if focus is LineEdit or focus is TextEdit:
		if key_event.keycode == KEY_ESCAPE and _compose_view.visible:
			_on_cancel_pressed()
			get_viewport().set_input_as_handled()
		return
	if _compose_view.visible:
		if key_event.keycode == KEY_ESCAPE:
			_on_cancel_pressed()
			get_viewport().set_input_as_handled()
		return
	if not _detail_view.visible:
		return
	match key_event.keycode:
		KEY_R:
			if not _reply_btn.disabled:
				_on_reply_pressed()
				get_viewport().set_input_as_handled()
		KEY_SPACE, KEY_M, KEY_PAGEDOWN:
			_advance_message_body_page(1)
			get_viewport().set_input_as_handled()
		KEY_PAGEUP:
			_advance_message_body_page(-1)
			get_viewport().set_input_as_handled()
		KEY_TAB:
			if key_event.shift_pressed:
				_advance_message_body_page(-1)
				get_viewport().set_input_as_handled()
		KEY_ESCAPE, KEY_ENTER, KEY_KP_ENTER:
			_show_detail(false)
			_selected_msg = {}
			get_viewport().set_input_as_handled()


func _on_mark_failed(reason: String) -> void:
	_set_status("Mark read failed: %s" % reason, Color(1.0, 0.45, 0.45))


func _on_comstar_message_received() -> void:
	if ServerBridge.game_api_url.is_empty():
		return
	_set_status("New ComStar message received.", Color(0.45, 1.0, 0.35))
	_comstar.fetch_inbox(ServerBridge.game_api_url)


func _on_help_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)


func _on_travel_pressed() -> void:
	if AuthSession.is_logged_in:
		get_tree().change_scene_to_file(WORLD_SCENE)
	else:
		get_tree().change_scene_to_file(LOGIN_SCENE)


func _on_mech_pressed() -> void:
	if not AuthSession.is_logged_in:
		get_tree().change_scene_to_file(LOGIN_SCENE)
		return
	if AuthSession.character.is_empty():
		_set_status("Create a character first to access the Mech Bay.", Color(1.0, 0.8, 0.3))
		return
	get_tree().change_scene_to_file(MECH_SCENE)


func _on_side_pressed() -> void:
	get_tree().change_scene_to_file(STANDINGS_SCENE)


func _on_status_pressed() -> void:
	_set_status("ComStar terminal ready.", Color(0.45, 1.0, 0.35))


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(SETTINGS_SCENE)


func _on_fight_pressed() -> void:
	if not AuthSession.is_logged_in:
		get_tree().change_scene_to_file(LOGIN_SCENE)
		return
	if AuthSession.character.is_empty():
		_set_status("Create a character first to access the Arena.", Color(1.0, 0.8, 0.3))
		return
	if AuthSession.character.get("mech_id", null) == null:
		_set_status("Select a mech in the Mech Bay before entering the Arena.", Color(1.0, 0.8, 0.3))
		return
	get_tree().change_scene_to_file(ARENA_SCENE)
