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

var _comstar: Node  # ComstarClient
var _messages: Array = []
var _selected_msg: Dictionary = {}
var _command_texture: Texture2D = null

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
@onready var _detail_view: VBoxContainer = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView
@onready var _det_from: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/FromLabel
@onready var _det_subject: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/SubjectLabel
@onready var _det_date: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/DateLabel
@onready var _det_body: Label = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/BodyLabel
@onready var _reply_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/ActionBar/ReplyButton
@onready var _delete_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/DetailView/ActionBar/DeleteButton
@onready var _compose_view: VBoxContainer = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView
@onready var _to_field: LineEdit = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/ToRow/ToField
@onready var _subject_field: LineEdit = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/SubjectRow/SubjectField
@onready var _body_field: TextEdit = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/BodyField
@onready var _send_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/ActionBar/SendButton
@onready var _cancel_btn: Button = $MainVBox/ContentHBox/DetailShell/DetailMargin/DetailVBox/ComposeView/ActionBar/CancelButton


func _ready() -> void:
	AudioManager.play_bgm("menu")
	_apply_retail_shell_art()
	_refresh_command_bar()
	_user_label.text = _user_summary()

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
		var prefix := "" if msg.get("readAt") != null else "[NEW] "
		var from := str(msg.get("from", "?"))
		var subj := str(msg.get("subject", "(no subject)"))
		btn.text = "%s%s\n%s" % [prefix, from, subj]
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(_on_message_selected.bind(msg))
		_inbox_list.add_child(btn)


func _populate_detail(msg: Dictionary) -> void:
	_det_from.text = "From: %s" % str(msg.get("from", "?"))
	_det_subject.text = "Subject: %s" % str(msg.get("subject", "(no subject)"))
	_det_date.text = "Sent: %s" % _format_date(str(msg.get("sentAt", "")))
	_det_body.text = str(msg.get("body", ""))


func _format_date(iso: String) -> String:
	if iso.is_empty():
		return ""
	var trimmed := iso.replace("T", " ").split(".")[0]
	return trimmed.substr(0, 16)


func _show_detail(visible: bool) -> void:
	_detail_view.visible = visible
	_refresh_right_panel_visibility()
	_refresh_detail_actions()


func _show_compose(visible: bool) -> void:
	_compose_view.visible = visible
	_refresh_right_panel_visibility()
	_refresh_detail_actions()


func _refresh_right_panel_visibility() -> void:
	_placeholder_label.visible = not _detail_view.visible and not _compose_view.visible


func _refresh_detail_actions() -> void:
	var can_manage := not _selected_msg.is_empty() and not ServerBridge.game_api_url.is_empty()
	_reply_btn.disabled = not can_manage
	_delete_btn.disabled = not can_manage


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
	_to_field.text = ""
	_subject_field.text = ""
	_body_field.text = ""
	_show_compose(true)
	_to_field.grab_focus()


func _on_reply_pressed() -> void:
	if _selected_msg.is_empty():
		return
	var from := str(_selected_msg.get("from", ""))
	var orig_subject := str(_selected_msg.get("subject", ""))
	var re_subject := orig_subject if orig_subject.begins_with("Re: ") else "Re: " + orig_subject
	_show_detail(false)
	_to_field.text = from
	_subject_field.text = re_subject
	_body_field.text = ""
	_show_compose(true)
	_body_field.grab_focus()


func _on_cancel_pressed() -> void:
	_show_compose(false)
	if not _selected_msg.is_empty():
		_show_detail(true)


func _on_send_pressed() -> void:
	var to := _to_field.text.strip_edges()
	var subject := _subject_field.text.strip_edges()
	var body := _body_field.text.strip_edges()

	if to.is_empty():
		_set_status("Error: 'To' field is required", Color(1.0, 0.45, 0.45))
		return
	if body.is_empty():
		_set_status("Error: message body is required", Color(1.0, 0.45, 0.45))
		return
	if subject.length() > 100:
		_set_status("Error: subject must be 100 characters or fewer", Color(1.0, 0.45, 0.45))
		return
	if body.length() > 1000:
		_set_status("Error: message must be 1000 characters or fewer", Color(1.0, 0.45, 0.45))
		return
	if ServerBridge.game_api_url.is_empty():
		_set_status("Server offline", Color(1.0, 0.45, 0.45))
		return

	_send_btn.disabled = true
	_set_status("Sending...")
	_comstar.send_message(ServerBridge.game_api_url, to, subject, body)


func _on_message_sent() -> void:
	_send_btn.disabled = false
	_show_compose(false)
	_set_status("Message sent.", Color(0.45, 1.0, 0.35))
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
	_messages = _messages.filter(func(m): return int(m.get("id", -1)) != message_id)
	_populate_inbox()
	_set_status("Message deleted.", Color(0.45, 1.0, 0.35))


func _on_delete_failed(reason: String) -> void:
	_delete_btn.disabled = false
	_set_status("Delete failed: %s" % reason, Color(1.0, 0.45, 0.45))


func _on_marked_read(message_id: int) -> void:
	for i in _messages.size():
		if int(_messages[i].get("id", -1)) == message_id:
			_messages[i] = _messages[i].duplicate()
			_messages[i]["readAt"] = "now"
			break
	_populate_inbox()


func _on_mark_failed(reason: String) -> void:
	_set_status("Mark read failed: %s" % reason, Color(1.0, 0.45, 0.45))


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
