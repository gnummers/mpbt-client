extends Control

const WORLD_SCENE         := "res://scenes/world/world.tscn"
const COMBAT_SCENE        := "res://scenes/combat/combat.tscn"
const ASSET_BROWSER_SCENE := "res://scenes/assets/asset_browser.tscn"
const LOGIN_SCENE         := "res://scenes/login/login.tscn"
const MECH_SELECT_SCENE   := "res://scenes/mech/mech_select.tscn"

@onready var server_value: Label = %ServerValue
@onready var websocket_value: Label = %WebSocketValue
@onready var status_label: Label = %StatusLabel


func _ready() -> void:
	server_value.text = ClientConfig.server_base_url()
	websocket_value.text = ClientConfig.server_websocket_url()

	ServerBridge.server_available.connect(_on_server_available)
	ServerBridge.server_unavailable.connect(_on_server_unavailable)

	# Apply current state if ServerBridge already resolved before we connected.
	if ServerBridge.is_online:
		_on_server_available({
			"version": ServerBridge.web_version,
			"gameServer": ServerBridge.game_server,
		})
	else:
		ServerBridge.check_config()


func _on_server_available(info: Dictionary) -> void:
	var gs: String = info.get("gameServer", "?")
	var ver: String = info.get("version", "")
	status_label.text = "Game server: %s%s" % [gs, " (v%s)" % ver if ver else ""]
	status_label.modulate = Color(0.4, 1.0, 0.4)


func _on_server_unavailable(reason: String) -> void:
	status_label.text = "Server offline — %s" % reason
	status_label.modulate = Color(1.0, 0.45, 0.45)


func _on_world_pressed() -> void:
	if AuthSession.is_logged_in:
		get_tree().change_scene_to_file(WORLD_SCENE)
	else:
		get_tree().change_scene_to_file(LOGIN_SCENE)


func _on_combat_pressed() -> void:
	get_tree().change_scene_to_file(COMBAT_SCENE)


func _on_assets_pressed() -> void:
	get_tree().change_scene_to_file(ASSET_BROWSER_SCENE)


func _on_mech_bay_pressed() -> void:
	if not AuthSession.is_logged_in:
		get_tree().change_scene_to_file(LOGIN_SCENE)
	elif AuthSession.character.is_empty():
		status_label.text = "Create a character first to access the Mech Bay"
		status_label.modulate = Color(1.0, 0.8, 0.3)
	else:
		get_tree().change_scene_to_file(MECH_SELECT_SCENE)
