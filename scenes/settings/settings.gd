extends Control

## In-game settings editor.
##
## Reads from ClientConfig (which already merged default + user config),
## presents editable fields, and on Save writes user://mpbt-client.json
## then hot-reloads ClientConfig + ServerBridge + WSClient.

const MAIN_SCENE := "res://scenes/main/main.tscn"

@onready var _server_url_edit: LineEdit = $MainVBox/Scroll/Fields/ServerUrlRow/ServerUrlEdit
@onready var _ws_url_edit: LineEdit     = $MainVBox/Scroll/Fields/WsUrlRow/WsUrlEdit
@onready var _retail_edit: LineEdit     = $MainVBox/Scroll/Fields/RetailRow/RetailEdit
@onready var _extracted_edit: LineEdit  = $MainVBox/Scroll/Fields/ExtractedRow/ExtractedEdit
@onready var _diag_check: CheckBox      = $MainVBox/Scroll/Fields/DiagRow/DiagCheck
@onready var _status_label: Label       = $MainVBox/ActionBar/StatusLabel
@onready var _user_path_label: Label    = $MainVBox/Header/UserPathLabel
@onready var _retail_browse:    Button     = $MainVBox/Scroll/Fields/RetailRow/RetailBrowse
@onready var _extracted_browse: Button     = $MainVBox/Scroll/Fields/ExtractedRow/ExtractedBrowse
@onready var _retail_dialog: FileDialog = $RetailDialog
@onready var _extracted_dialog: FileDialog = $ExtractedDialog


func _ready() -> void:
	_user_path_label.text = "Config: %s" % LogHelper.globalize("user://mpbt-client.json")
	_server_url_edit.text = ClientConfig.server_base_url()
	_ws_url_edit.text = ClientConfig.server_websocket_url()
	_retail_edit.text = ClientConfig.retail_asset_path()
	_extracted_edit.text = ClientConfig.asset_extracted_path()
	_diag_check.button_pressed = ClientConfig.diagnostics_enabled()
	var is_mobile := OS.has_feature("android") or OS.has_feature("ios")
	if is_mobile:
		_retail_browse.visible    = false
		_extracted_browse.visible = false


func _on_save_pressed() -> void:
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
	WSClient.reconnect()
	ServerBridge.reset()
	ServerBridge.check_config()

	_set_status("Saved.", Color(0.4, 1.0, 0.4))


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)


func _on_retail_browse_pressed() -> void:
	_retail_dialog.current_dir = _retail_edit.text if not _retail_edit.text.is_empty() else OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	_retail_dialog.popup_centered_ratio(0.75)


func _on_extracted_browse_pressed() -> void:
	_extracted_dialog.current_dir = _extracted_edit.text if not _extracted_edit.text.is_empty() else OS.get_system_dir(OS.SYSTEM_DIR_DESKTOP)
	_extracted_dialog.popup_centered_ratio(0.75)


func _on_retail_dir_selected(dir: String) -> void:
	_retail_edit.text = dir


func _on_extracted_dir_selected(dir: String) -> void:
	_extracted_edit.text = dir


func _set_status(text: String, color: Color = Color(0.7, 0.7, 0.7)) -> void:
	_status_label.text = text
	_status_label.modulate = color
