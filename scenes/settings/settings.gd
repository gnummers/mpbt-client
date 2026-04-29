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
const CONTROL_ACTIONS   := ["move_forward", "move_backward", "move_left", "move_right", "fire"]
const CONTROL_ROW_NAMES := ["ForwardRow", "BackwardRow", "LeftRow", "RightRow", "FireRow"]

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
@onready var _fullscreen_check:   CheckBox      = $MainVBox/Scroll/Fields/FullscreenRow/FullscreenCheck
@onready var _resolution_opt:     OptionButton  = $MainVBox/Scroll/Fields/ResolutionRow/ResolutionOption
@onready var _rebind_modal:       Control       = $RebindModal
@onready var _master_slider:      HSlider       = $MainVBox/Scroll/Fields/MasterRow/MasterSlider
@onready var _music_slider:       HSlider       = $MainVBox/Scroll/Fields/MusicRow/MusicSlider
@onready var _sfx_slider:         HSlider       = $MainVBox/Scroll/Fields/SfxRow/SfxSlider
@onready var _master_val:         Label         = $MainVBox/Scroll/Fields/MasterRow/MasterValueLabel
@onready var _music_val:          Label         = $MainVBox/Scroll/Fields/MusicRow/MusicValueLabel
@onready var _sfx_val:            Label         = $MainVBox/Scroll/Fields/SfxRow/SfxValueLabel

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
	for i in RESOLUTION_LABELS.size():
		_resolution_opt.add_item(RESOLUTION_LABELS[i], i)
	_fullscreen_check.button_pressed = ClientConfig.display_fullscreen()
	_resolution_opt.disabled = _fullscreen_check.button_pressed
	var res_idx := RESOLUTIONS.find(ClientConfig.display_resolution())
	_resolution_opt.selected = res_idx if res_idx >= 0 else 0
	_fullscreen_check.toggled.connect(_on_fullscreen_toggled)

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
	for i in CONTROL_ACTIONS.size():
		var action: String    = CONTROL_ACTIONS[i]
		var row_name: String  = CONTROL_ROW_NAMES[i]
		var row: HBoxContainer = fields.get_node(row_name) as HBoxContainer
		var key_lbl:    Label  = row.get_node("KeyLabel")  as Label
		var rebind_btn: Button = row.get_node("RebindBtn") as Button
		key_lbl.text = _key_label_for_action(action)
		_key_labels[action] = key_lbl
		rebind_btn.pressed.connect(_on_rebind_pressed.bind(action))


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


func _on_fullscreen_toggled(checked: bool) -> void:
	_resolution_opt.disabled = checked


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
	var res_str := RESOLUTIONS[_resolution_opt.selected] \
		if _resolution_opt.selected >= 0 else RESOLUTIONS[0]
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
			"fullscreen": _fullscreen_check.button_pressed,
			"resolution": res_str,
		},
		"controls": controls_dict,
		"audio": {
			"master_db": int(_master_slider.value),
			"music_db":  int(_music_slider.value),
			"sfx_db":    int(_sfx_slider.value),
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
