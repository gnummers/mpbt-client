extends Control

## In-game settings editor.
##
## Reads from ClientConfig (which already merged default + user config),
## presents editable fields, and on Save writes user://mpbt-client.json
## then hot-reloads ClientConfig + ServerBridge + WSClient.
##
## Sections: Server, Assets, Diagnostics, Display, Controls (input rebinding).

const MAIN_SCENE := "res://scenes/main/main.tscn"

const RESOLUTIONS       := ["1280x720", "1920x1080", "2560x1440"]
const RESOLUTION_LABELS := ["1280×720 (default)", "1920×1080", "2560×1440"]
const WINDOW_MODES  := ["windowed", "borderless", "fullscreen"]
const WINDOW_LABELS := ["Windowed", "Borderless Fullscreen", "Exclusive Fullscreen"]
const UI_SCALES       := [1.0, 1.25, 1.5]
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

@onready var _server_url_edit:    LineEdit      = $MainVBox/Scroll/Fields/ServerUrlRow/ServerUrlEdit
@onready var _ws_url_edit:        LineEdit      = $MainVBox/Scroll/Fields/WsUrlRow/WsUrlEdit
@onready var _retail_edit:        LineEdit      = $MainVBox/Scroll/Fields/RetailRow/RetailEdit
@onready var _extracted_edit:     LineEdit      = $MainVBox/Scroll/Fields/ExtractedRow/ExtractedEdit
@onready var _diag_check:         CheckBox      = $MainVBox/Scroll/Fields/DiagRow/DiagCheck
@onready var _status_label:       Label         = $MainVBox/ActionBar/StatusLabel
@onready var _user_path_label:    Label         = $MainVBox/Header/UserPathLabel
@onready var _retail_browse:      Button        = $MainVBox/Scroll/Fields/RetailRow/RetailBrowse
@onready var _extracted_browse:   Button        = $MainVBox/Scroll/Fields/ExtractedRow/ExtractedBrowse
@onready var _retail_dialog:      FileDialog    = $RetailDialog
@onready var _extracted_dialog:   FileDialog    = $ExtractedDialog
@onready var _window_mode_opt:    OptionButton  = $MainVBox/Scroll/Fields/WindowModeRow/WindowModeOption
@onready var _resolution_opt:     OptionButton  = $MainVBox/Scroll/Fields/ResolutionRow/ResolutionOption
@onready var _integer_scale_check: CheckBox     = $MainVBox/Scroll/Fields/IntegerScaleRow/IntegerScaleCheck
@onready var _rebind_modal:       Control       = $RebindModal
@onready var _master_slider:      HSlider       = $MainVBox/Scroll/Fields/MasterRow/MasterSlider
@onready var _music_slider:       HSlider       = $MainVBox/Scroll/Fields/MusicRow/MusicSlider
@onready var _sfx_slider:         HSlider       = $MainVBox/Scroll/Fields/SfxRow/SfxSlider
@onready var _master_val:         Label         = $MainVBox/Scroll/Fields/MasterRow/MasterValueLabel
@onready var _music_val:          Label         = $MainVBox/Scroll/Fields/MusicRow/MusicValueLabel
@onready var _sfx_val:            Label         = $MainVBox/Scroll/Fields/SfxRow/SfxValueLabel
@onready var _ui_scale_opt:       OptionButton  = $MainVBox/Scroll/Fields/UIScaleRow/UIScaleOption

var _key_labels:     Dictionary = {}  ## action_name -> Label
var _rebind_pending: String     = ""


func _ready() -> void:
	_user_path_label.text = "Config: %s" % LogHelper.globalize("user://mpbt-client.json")
	_server_url_edit.text = ClientConfig.server_base_url()
	_ws_url_edit.text     = ClientConfig.server_websocket_url()
	_retail_edit.text     = ClientConfig.retail_asset_path()
	_extracted_edit.text  = ClientConfig.asset_extracted_path()
	_diag_check.button_pressed = ClientConfig.diagnostics_enabled()

	var is_mobile := OS.has_feature("android") or OS.has_feature("ios")
	if is_mobile:
		_retail_browse.visible    = false
		_extracted_browse.visible = false

	# Display section
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

	# Accessibility section
	for i in UI_SCALE_LABELS.size():
		_ui_scale_opt.add_item(UI_SCALE_LABELS[i], i)
	var cur_scale := ClientConfig.ui_scale()
	var scale_idx := UI_SCALES.find(cur_scale)
	_ui_scale_opt.selected = scale_idx if scale_idx >= 0 else 0

	# Controls section
	_setup_control_rows()

	# Audio section — connect AFTER setting values to avoid spurious callbacks
	_master_slider.value = ClientConfig.master_volume_db()
	_music_slider.value  = ClientConfig.music_volume_db()
	_sfx_slider.value    = ClientConfig.sfx_volume_db()
	_master_val.text = _db_label(_master_slider.value)
	_music_val.text  = _db_label(_music_slider.value)
	_sfx_val.text    = _db_label(_sfx_slider.value)
	_master_slider.value_changed.connect(_on_master_changed)
	_music_slider.value_changed.connect(_on_music_changed)
	_sfx_slider.value_changed.connect(_on_sfx_changed)


func _setup_control_rows() -> void:
	var fields: VBoxContainer = $MainVBox/Scroll/Fields
	var audio_label := fields.get_node("AudioSectionLabel")
	for action in CONTROL_ACTIONS:
		var row: HBoxContainer = _ensure_control_row(fields, audio_label, action)
		var key_lbl: Label = row.get_node("KeyLabel") as Label
		var rebind_btn: Button = row.get_node("RebindBtn") as Button
		key_lbl.text = _key_label_for_action(action)
		_key_labels[action] = key_lbl
		if not rebind_btn.pressed.is_connected(_on_rebind_pressed.bind(action)):
			rebind_btn.pressed.connect(_on_rebind_pressed.bind(action))


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
	action_label.custom_minimum_size = Vector2(140, 0)
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
	rebind_btn.custom_minimum_size = Vector2(80, 0)
	rebind_btn.text = "Rebind"
	row.add_child(rebind_btn)

	return row


func _input(event: InputEvent) -> void:
	if _rebind_pending.is_empty():
		return
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_ESCAPE:
			_rebind_pending       = ""
			_rebind_modal.visible = false
		else:
			_apply_rebind(event as InputEventKey)
		get_viewport().set_input_as_handled()


func _on_window_mode_changed(idx: int) -> void:
	_resolution_opt.disabled = idx != 0


func _on_rebind_pressed(action_name: String) -> void:
	_rebind_pending       = action_name
	_rebind_modal.visible = true
	get_viewport().gui_release_focus()


func _apply_rebind(event: InputEventKey) -> void:
	var action := _rebind_pending
	_rebind_pending       = ""
	_rebind_modal.visible = false

	# Build fresh key event (avoid holding shared references)
	var new_ev := InputEventKey.new()
	new_ev.physical_keycode = event.physical_keycode

	# Preserve non-keyboard bindings (e.g. MouseButton1 for fire)
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
			"base_url":      _server_url_edit.text.strip_edges(),
			"websocket_url": _ws_url_edit.text.strip_edges(),
		},
		"assets": {
			"retail_path":    _retail_edit.text.strip_edges(),
			"extracted_path": _extracted_edit.text.strip_edges(),
		},
		"diagnostics": {
			"enabled":     _diag_check.button_pressed,
			"log_network": false,
		},
		"display": {
			"window_mode":   wm_str,
			"resolution":    res_str,
			"integer_scale": _integer_scale_check.button_pressed,
		},
		"controls": controls_dict,
		"audio": {
			"master_db": int(_master_slider.value),
			"music_db":  int(_music_slider.value),
			"sfx_db":    int(_sfx_slider.value),
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

	_set_status("Saved.", Color(0.4, 1.0, 0.4))


func _on_back_pressed() -> void:
	# Revert live audio preview since slider changes are applied immediately
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


func _set_status(text: String, color: Color = Color(0.7, 0.7, 0.7)) -> void:
	_status_label.text     = text
	_status_label.modulate = color


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
