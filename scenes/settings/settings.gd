extends Control

## In-game settings editor inside the same retail shell chrome used by the
## world, standings, and ComStar scenes.

const MAIN_SCENE := "res://scenes/main/main.tscn"
const WORLD_SCENE := "res://scenes/world/world.tscn"
const LOGIN_SCENE := "res://scenes/login/login.tscn"
const MECH_SCENE := "res://scenes/mech/mech_select.tscn"
const STANDINGS_SCENE := "res://scenes/standings/standings.tscn"
const COMSTAR_SCENE := "res://scenes/comstar/comstar.tscn"
const ARENA_SCENE := "res://scenes/arena/ready_room.tscn"

const RESOLUTIONS := ["1280x720", "1920x1080", "2560x1440"]
const RESOLUTION_LABELS := ["1280×720 (default)", "1920×1080", "2560×1440"]
const WINDOW_MODES := ["windowed", "borderless", "fullscreen"]
const WINDOW_LABELS := ["Windowed", "Borderless Fullscreen", "Exclusive Fullscreen"]
const UI_SCALES := [1.0, 1.25, 1.5]
const UI_SCALE_LABELS := ["100% (default)", "125%", "150%"]
const CONTROL_ACTIONS := [
	"move_forward", "move_backward", "stop_movement",
	"move_left", "move_right", "turn_left", "turn_right",
	"fire", "weapon_prev", "weapon_next",
	"jump_jet", "stand_up", "target_cycle",
	"hud_target_detail", "hud_target_brief", "hud_self_detail",
	"radar_range", "radar_zoom_in", "radar_zoom_out",
	"tic_cycle_current", "tic_select_a", "tic_select_b", "tic_select_c",
	"tic_toggle_a", "tic_toggle_b", "tic_toggle_c",
	"tic_fire_a", "tic_fire_b", "tic_fire_c",
	"ui_chat", "ui_team_chat",
]
const CONTROL_LABELS := {
	"move_forward": "Forward / Throttle +",
	"move_backward": "Reverse / Throttle -",
	"stop_movement": "Stop Movement",
	"move_left": "Alt Turn Left",
	"move_right": "Alt Turn Right",
	"turn_left": "Turn Left",
	"turn_right": "Turn Right",
	"fire": "Fire Weapon",
	"weapon_prev": "Prev Weapon",
	"weapon_next": "Next Weapon",
	"jump_jet": "Jump Jets",
	"stand_up": "Stand Up",
	"target_cycle": "Cycle Target",
	"hud_target_detail": "Target Detail",
	"hud_target_brief": "Target Brief",
	"hud_self_detail": "Self Detail",
	"radar_range": "Radar Cycle",
	"radar_zoom_in": "Radar Zoom In",
	"radar_zoom_out": "Radar Zoom Out",
	"tic_cycle_current": "Cycle TIC",
	"tic_select_a": "Select TIC A",
	"tic_select_b": "Select TIC B",
	"tic_select_c": "Select TIC C",
	"tic_toggle_a": "Toggle TIC A",
	"tic_toggle_b": "Toggle TIC B",
	"tic_toggle_c": "Toggle TIC C",
	"tic_fire_a": "Fire TIC A",
	"tic_fire_b": "Fire TIC B",
	"tic_fire_c": "Fire TIC C",
	"ui_chat": "Combat All Chat",
	"ui_team_chat": "Combat Team Chat",
}
const EXISTING_CONTROL_ROWS := {
	"move_forward": "ForwardRow",
	"move_backward": "BackwardRow",
	"move_left": "LeftRow",
	"move_right": "RightRow",
	"turn_left": "TurnLeftRow",
	"turn_right": "TurnRightRow",
	"fire": "FireRow",
	"jump_jet": "JumpRow",
	"radar_range": "RadarRow",
	"ui_chat": "ChatRow",
}

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

@onready var _fields: VBoxContainer = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields
@onready var _server_url_edit: LineEdit = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/ServerUrlRow/ServerUrlEdit
@onready var _ws_url_edit: LineEdit = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/WsUrlRow/WsUrlEdit
@onready var _retail_edit: LineEdit = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/RetailRow/RetailEdit
@onready var _extracted_edit: LineEdit = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/ExtractedRow/ExtractedEdit
@onready var _diag_check: CheckBox = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/DiagRow/DiagCheck
@onready var _user_path_label: Label = $MainVBox/ContentShell/ContentMargin/ContentVBox/ContentHeader/UserPathLabel
@onready var _retail_browse: Button = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/RetailRow/RetailBrowse
@onready var _extracted_browse: Button = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/ExtractedRow/ExtractedBrowse
@onready var _retail_dialog: FileDialog = $RetailDialog
@onready var _extracted_dialog: FileDialog = $ExtractedDialog
@onready var _window_mode_opt: OptionButton = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/WindowModeRow/WindowModeOption
@onready var _resolution_opt: OptionButton = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/ResolutionRow/ResolutionOption
@onready var _integer_scale_check: CheckBox = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/IntegerScaleRow/IntegerScaleCheck
@onready var _rebind_modal: Control = $RebindModal
@onready var _master_slider: HSlider = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/MasterRow/MasterSlider
@onready var _music_slider: HSlider = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/MusicRow/MusicSlider
@onready var _sfx_slider: HSlider = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/SfxRow/SfxSlider
@onready var _master_val: Label = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/MasterRow/MasterValueLabel
@onready var _music_val: Label = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/MusicRow/MusicValueLabel
@onready var _sfx_val: Label = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/SfxRow/SfxValueLabel
@onready var _ui_scale_opt: OptionButton = $MainVBox/ContentShell/ContentMargin/ContentVBox/Scroll/Fields/UIScaleRow/UIScaleOption
@onready var _save_button: Button = $MainVBox/ContentShell/ContentMargin/ContentVBox/ActionBar/SaveButton
@onready var _cancel_button: Button = $MainVBox/ContentShell/ContentMargin/ContentVBox/ActionBar/CancelButton

var _key_labels: Dictionary = {}
var _rebind_pending: String = ""
var _command_texture: Texture2D = null


func _ready() -> void:
	AudioManager.play_bgm("menu")
	_apply_retail_shell_art()
	_refresh_command_bar()
	_user_label.text = _user_summary()
	_user_path_label.text = "Config: %s" % LogHelper.globalize("user://mpbt-client.json")
	_server_url_edit.text = ClientConfig.server_base_url()
	_ws_url_edit.text = ClientConfig.server_websocket_url()
	_retail_edit.text = ClientConfig.retail_asset_path()
	_extracted_edit.text = ClientConfig.asset_extracted_path()
	_diag_check.button_pressed = ClientConfig.diagnostics_enabled()

	var is_mobile := OS.has_feature("android") or OS.has_feature("ios")
	if is_mobile:
		_retail_browse.visible = false
		_extracted_browse.visible = false

	for i in WINDOW_LABELS.size():
		_window_mode_opt.add_item(WINDOW_LABELS[i], i)
	var wm_idx := WINDOW_MODES.find(ClientConfig.display_window_mode())
	_window_mode_opt.selected = wm_idx if wm_idx >= 0 else 0
	_window_mode_opt.item_selected.connect(_on_window_mode_changed)

	for i in RESOLUTION_LABELS.size():
		_resolution_opt.add_item(RESOLUTION_LABELS[i], i)
	_resolution_opt.disabled = _window_mode_opt.selected != 0
	var res_idx := RESOLUTIONS.find(ClientConfig.display_resolution())
	_resolution_opt.selected = res_idx if res_idx >= 0 else 0

	_integer_scale_check.button_pressed = ClientConfig.display_integer_scale()

	for i in UI_SCALE_LABELS.size():
		_ui_scale_opt.add_item(UI_SCALE_LABELS[i], i)
	var cur_scale := ClientConfig.ui_scale()
	var scale_idx := UI_SCALES.find(cur_scale)
	_ui_scale_opt.selected = scale_idx if scale_idx >= 0 else 0

	_setup_control_rows()
	_apply_settings_button_art()

	_master_slider.value = ClientConfig.master_volume_db()
	_music_slider.value = ClientConfig.music_volume_db()
	_sfx_slider.value = ClientConfig.sfx_volume_db()
	_master_val.text = _db_label(_master_slider.value)
	_music_val.text = _db_label(_music_slider.value)
	_sfx_val.text = _db_label(_sfx_slider.value)
	_master_slider.value_changed.connect(_on_master_changed)
	_music_slider.value_changed.connect(_on_music_changed)
	_sfx_slider.value_changed.connect(_on_sfx_changed)

	_set_status("Adjust settings and save when ready.")


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


func _apply_command_button_art() -> void:
	for button in [_help_button, _travel_button, _mech_button, _side_button, _status_button, _fight_button]:
		_apply_button_art(button)


func _apply_settings_button_art() -> void:
	for button in [_retail_browse, _extracted_browse, _save_button, _cancel_button]:
		_apply_button_art(button, 13)


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


func _setup_control_rows() -> void:
	var audio_label := _fields.get_node("AudioSectionLabel")
	for action in CONTROL_ACTIONS:
		var row: HBoxContainer = _ensure_control_row(_fields, audio_label, action)
		var key_lbl: Label = row.get_node("KeyLabel") as Label
		var rebind_btn: Button = row.get_node("RebindBtn") as Button
		key_lbl.text = _key_label_for_action(action)
		_key_labels[action] = key_lbl
		if not rebind_btn.pressed.is_connected(_on_rebind_pressed.bind(action)):
			rebind_btn.pressed.connect(_on_rebind_pressed.bind(action))
		_apply_button_art(rebind_btn, 12)


func _ensure_control_row(fields: VBoxContainer, audio_label: Node, action: String) -> HBoxContainer:
	var row_name := str(EXISTING_CONTROL_ROWS.get(action, ""))
	var row: HBoxContainer = null
	if not row_name.is_empty() and fields.has_node(row_name):
		row = fields.get_node(row_name) as HBoxContainer
	else:
		row = _build_control_row(action)
		var insert_index := audio_label.get_index()
		fields.add_child(row)
		fields.move_child(row, insert_index)

	var action_label_text := str(CONTROL_LABELS.get(action, action.capitalize()))
	var action_label := row.get_child(0) as Label
	action_label.text = action_label_text
	return row


func _build_control_row(action: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "%sRow" % action.to_pascal_case()
	row.add_theme_constant_override("separation", 8)

	var action_label := Label.new()
	action_label.custom_minimum_size = Vector2(160, 0)
	action_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	action_label.text = str(CONTROL_LABELS.get(action, action))
	row.add_child(action_label)

	var key_label := Label.new()
	key_label.name = "KeyLabel"
	key_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	key_label.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0, 1.0))
	row.add_child(key_label)

	var rebind_btn := Button.new()
	rebind_btn.name = "RebindBtn"
	rebind_btn.custom_minimum_size = Vector2(92, 0)
	rebind_btn.text = "Rebind"
	row.add_child(rebind_btn)

	return row


func _input(event: InputEvent) -> void:
	if _rebind_pending.is_empty():
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_ESCAPE:
			_rebind_pending = ""
			_rebind_modal.visible = false
		else:
			_apply_rebind(event as InputEventKey)
		get_viewport().set_input_as_handled()


func _on_window_mode_changed(idx: int) -> void:
	_resolution_opt.disabled = idx != 0


func _on_rebind_pressed(action_name: String) -> void:
	_rebind_pending = action_name
	_rebind_modal.visible = true
	get_viewport().gui_release_focus()


func _apply_rebind(event: InputEventKey) -> void:
	var action := _rebind_pending
	_rebind_pending = ""
	_rebind_modal.visible = false

	var new_ev := InputEventKey.new()
	new_ev.physical_keycode = event.physical_keycode

	var non_key := InputMap.action_get_events(action).filter(
		func(e: InputEvent) -> bool: return not (e is InputEventKey)
	)
	InputMap.action_erase_events(action)
	for ev in non_key:
		InputMap.action_add_event(action, ev)
	InputMap.action_add_event(action, new_ev)

	if _key_labels.has(action):
		_key_labels[action].text = _key_label_for_action(action)


func _on_save_pressed() -> void:
	var res_str: String = RESOLUTIONS[_resolution_opt.selected] \
		if _resolution_opt.selected >= 0 else RESOLUTIONS[0]
	var wm_str: String = WINDOW_MODES[_window_mode_opt.selected] \
		if _window_mode_opt.selected >= 0 else WINDOW_MODES[0]
	var scale_val: float = UI_SCALES[_ui_scale_opt.selected] \
		if _ui_scale_opt.selected >= 0 else 1.0
	var controls_dict := {}
	for action in CONTROL_ACTIONS:
		controls_dict[action] = _get_key_for_action(action)

	var cfg := {
		"schema": 1,
		"server": {
			"base_url": _server_url_edit.text.strip_edges(),
			"websocket_url": _ws_url_edit.text.strip_edges(),
		},
		"assets": {
			"retail_path": _retail_edit.text.strip_edges(),
			"extracted_path": _extracted_edit.text.strip_edges(),
		},
		"diagnostics": {
			"enabled": _diag_check.button_pressed,
			"log_network": false,
		},
		"display": {
			"window_mode": wm_str,
			"resolution": res_str,
			"integer_scale": _integer_scale_check.button_pressed,
		},
		"controls": controls_dict,
		"audio": {
			"master_db": int(_master_slider.value),
			"music_db": int(_music_slider.value),
			"sfx_db": int(_sfx_slider.value),
		},
		"ui": {
			"scale": scale_val,
		},
	}

	var file := FileAccess.open("user://mpbt-client.json", FileAccess.WRITE)
	if file == null:
		_set_status("Error: could not write to %s (err %d)" % [
			LogHelper.globalize("user://mpbt-client.json"),
			FileAccess.get_open_error(),
		], Color(1.0, 0.4, 0.4))
		return

	file.store_string(JSON.stringify(cfg, "\t"))
	file.close()

	ClientConfig.load_config()
	AudioManager.apply_from_config()
	WSClient.reconnect()
	ServerBridge.reset()
	ServerBridge.check_config()
	_refresh_command_bar()

	_set_status("Saved.", Color(0.4, 1.0, 0.4))


func _on_back_pressed() -> void:
	AudioManager.apply_from_config()
	get_tree().change_scene_to_file(MAIN_SCENE)


func _on_retail_browse_pressed() -> void:
	_retail_dialog.current_dir = _retail_edit.text \
		if not _retail_edit.text.is_empty() else OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	_retail_dialog.popup_centered_ratio(0.75)


func _on_extracted_browse_pressed() -> void:
	_extracted_dialog.current_dir = _extracted_edit.text \
		if not _extracted_edit.text.is_empty() else OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	_extracted_dialog.popup_centered_ratio(0.75)


func _on_retail_dir_selected(dir: String) -> void:
	_retail_edit.text = dir


func _on_extracted_dir_selected(dir: String) -> void:
	_extracted_edit.text = dir


func _key_label_for_action(action: String) -> String:
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			var kc: Key = (ev as InputEventKey).physical_keycode
			return OS.get_keycode_string(kc if kc != KEY_NONE else (ev as InputEventKey).keycode)
	return "?"


func _get_key_for_action(action: String) -> int:
	for ev in InputMap.action_get_events(action):
		if ev is InputEventKey:
			var kc: Key = (ev as InputEventKey).physical_keycode
			return kc if kc != KEY_NONE else (ev as InputEventKey).keycode
	return 0


func _on_master_changed(value: float) -> void:
	_master_val.text = _db_label(value)
	AudioManager.set_master_db(value)


func _on_music_changed(value: float) -> void:
	_music_val.text = _db_label(value)
	AudioManager.set_music_db(value)


func _on_sfx_changed(value: float) -> void:
	_sfx_val.text = _db_label(value)
	AudioManager.set_sfx_db(value)


func _db_label(db: float) -> String:
	return "%d dB" % int(db)


func _refresh_command_bar() -> void:
	_travel_button.disabled = false
	_mech_button.disabled = not AuthSession.is_logged_in or AuthSession.character.is_empty()
	_side_button.disabled = false
	_status_button.disabled = not AuthSession.is_logged_in or ServerBridge.game_api_url.is_empty()
	_fight_button.disabled = (
		not AuthSession.is_logged_in
		or AuthSession.character.is_empty()
		or AuthSession.character.get("mech_id", null) == null
	)
	_comstar_quick_button.disabled = _status_button.disabled
	_settings_quick_button.disabled = true
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
	get_tree().change_scene_to_file(STANDINGS_SCENE)


func _on_status_pressed() -> void:
	if _status_button.disabled:
		_set_status("ComStar terminal is unavailable.", Color(1.0, 0.45, 0.45))
		return
	get_tree().change_scene_to_file(COMSTAR_SCENE)


func _on_settings_pressed() -> void:
	_set_status("Settings terminal ready.", Color(0.45, 1.0, 0.35))


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
