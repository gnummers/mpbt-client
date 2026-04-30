extends Control

## Solaris VII Standings screen.
##
## Fetches GET /standings and renders a scrollable leaderboard table inside the
## same retail shell chrome used by the world scene.

const MAIN_SCENE := "res://scenes/main/main.tscn"
const WORLD_SCENE := "res://scenes/world/world.tscn"
const LOGIN_SCENE := "res://scenes/login/login.tscn"
const MECH_SCENE := "res://scenes/mech/mech_select.tscn"
const COMSTAR_SCENE := "res://scenes/comstar/comstar.tscn"
const SETTINGS_SCENE := "res://scenes/settings/settings.tscn"
const ARENA_SCENE := "res://scenes/arena/ready_room.tscn"

@onready var _shell_north: TextureRect = $ShellNorth
@onready var _shell_south: TextureRect = $ShellSouth
@onready var _shell_west: TextureRect = $ShellWest
@onready var _shell_east: TextureRect = $ShellEast
@onready var _message_north: TextureRect = $MainVBox/MessagePanel/MessageNorth
@onready var _message_south: TextureRect = $MainVBox/MessagePanel/MessageSouth
@onready var _message_west: TextureRect = $MainVBox/MessagePanel/MessageWest
@onready var _message_east: TextureRect = $MainVBox/MessagePanel/MessageEast
@onready var _content_north: TextureRect = $MainVBox/ContentShell/ContentNorth
@onready var _content_south: TextureRect = $MainVBox/ContentShell/ContentSouth
@onready var _content_west: TextureRect = $MainVBox/ContentShell/ContentWest
@onready var _content_east: TextureRect = $MainVBox/ContentShell/ContentEast
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
@onready var _row_container: VBoxContainer = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/RowContainer

var _standings_client: StandingsClient
var _comstar_unread: Node
var _command_texture: Texture2D = null


func _ready() -> void:
	AudioManager.play_bgm("menu")
	_apply_retail_shell_art()
	_refresh_command_bar()
	_user_label.text = _user_summary()

	_standings_client = StandingsClient.new()
	add_child(_standings_client)
	_standings_client.standings_loaded.connect(_on_loaded)
	_standings_client.standings_failed.connect(_on_failed)

	_comstar_unread = load("res://scripts/net/comstar_client.gd").new()
	add_child(_comstar_unread)
	_comstar_unread.unread_count_loaded.connect(_on_comstar_unread_loaded)

	_set_status("Loading standings...")

	if ServerBridge.is_online and not ServerBridge.game_api_url.is_empty():
		_standings_client.fetch(ServerBridge.game_api_url)
		_fetch_comstar_unread()
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
	_apply_shell_texture(_content_north, _load_world_ui_texture(extracted, ["dscn"]))
	_apply_shell_texture(_content_south, _load_world_ui_texture(extracted, ["dscs"]))
	_apply_shell_texture(_content_west, _load_world_ui_texture(extracted, ["dscw"]))
	_apply_shell_texture(_content_east, _load_world_ui_texture(extracted, ["dsce"]))

	_command_texture = _load_world_ui_texture(extracted, ["buta", "button"])
	_apply_command_button_art()
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
	if _command_texture == null:
		return
	for button in [_help_button, _travel_button, _mech_button, _side_button, _status_button, _fight_button]:
		var style := StyleBoxTexture.new()
		style.texture = _command_texture
		button.add_theme_stylebox_override("normal", style)
		button.add_theme_stylebox_override("hover", style)
		button.add_theme_stylebox_override("pressed", style)
		button.add_theme_stylebox_override("disabled", style)
		button.add_theme_font_size_override("font_size", 14)


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
	_standings_client.fetch(ServerBridge.game_api_url)
	_fetch_comstar_unread()


func _on_server_unavailable(reason: String) -> void:
	_refresh_command_bar()
	_set_status("Server offline - %s" % reason, Color(1.0, 0.45, 0.45))


func _on_loaded(standings: Array) -> void:
	_set_status("Leaderboard online (%d pilots)." % standings.size(), Color(0.45, 1.0, 0.35))
	_populate(standings)


func _on_failed(reason: String) -> void:
	_set_status("Failed to load standings: %s" % reason, Color(1.0, 0.45, 0.45))


func _populate(standings: Array) -> void:
	for child in _row_container.get_children():
		child.queue_free()

	if standings.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "No matches played yet. Be the first to fight!"
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		_row_container.add_child(empty_lbl)
		return

	_row_container.add_child(_make_header_row())

	for standing_v in standings:
		_row_container.add_child(_make_standing_row(standing_v as Dictionary))


func _make_header_row() -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)

	for text in ["#", "Pilot", "House", "W/L", "Tier", "Score"]:
		var lbl := Label.new()
		lbl.text = text
		lbl.add_theme_color_override("font_color", Color(0.9, 0.75, 0.25))
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.custom_minimum_size.x = _col_min_width(text)
		row.add_child(lbl)

	var sep := HSeparator.new()
	sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_row_container.add_child(sep)

	return row


func _make_standing_row(s: Dictionary) -> HBoxContainer:
	var rank := int(s.get("overallRank", 0))
	var name_str := str(s.get("displayName", "?"))
	var house := str(s.get("allegiance", ""))
	var ratio := str(s.get("ratioText", "0/0"))
	var tier := str(s.get("tierLabel", ""))
	var score := int(s.get("score", 0))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)

	var is_local: bool = (name_str == AuthSession.character.get("display_name", ""))
	var row_color := Color(0.25, 0.85, 0.25) if is_local else Color(0.85, 0.85, 0.85)

	for value in [
		"#%d" % rank,
		name_str,
		house,
		ratio,
		tier,
		"%d" % score,
	]:
		var lbl := Label.new()
		lbl.text = str(value)
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.custom_minimum_size.x = _col_min_width(str(value))
		lbl.add_theme_color_override("font_color", row_color)
		row.add_child(lbl)

	return row


func _col_min_width(header: String) -> float:
	match header:
		"#":
			return 36
		"Pilot":
			return 160
		"House":
			return 110
		"W/L":
			return 70
		"Tier":
			return 110
		"Score":
			return 70
		_:
			return 60


func _fetch_comstar_unread() -> void:
	if not AuthSession.is_logged_in or ServerBridge.game_api_url.is_empty():
		return
	_comstar_unread.fetch_unread_count(ServerBridge.game_api_url)


func _on_comstar_unread_loaded(count: int) -> void:
	_status_button.text = "Status [%d]" % count if count > 0 else "Status"


func _refresh_command_bar() -> void:
	_travel_button.disabled = false
	_mech_button.disabled = not AuthSession.is_logged_in or AuthSession.character.is_empty()
	_side_button.disabled = true
	_status_button.disabled = not AuthSession.is_logged_in or ServerBridge.game_api_url.is_empty()
	_fight_button.disabled = (
		not AuthSession.is_logged_in
		or AuthSession.character.is_empty()
		or AuthSession.character.get("mech_id", null) == null
	)
	_comstar_quick_button.disabled = _status_button.disabled
	_settings_quick_button.disabled = false
	_mech_quick_button.disabled = _mech_button.disabled
	_exit_quick_button.disabled = false


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
	_set_status("Standings terminal ready.", Color(0.45, 1.0, 0.35))


func _on_status_pressed() -> void:
	if _status_button.disabled:
		_set_status("Status terminal is unavailable.", Color(1.0, 0.45, 0.45))
		return
	get_tree().change_scene_to_file(COMSTAR_SCENE)


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
