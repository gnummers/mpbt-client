extends Control

const WORLD_SCENE         := "res://scenes/world/world.tscn"
const COMBAT_SCENE        := "res://scenes/combat/combat.tscn"
const ASSET_BROWSER_SCENE := "res://scenes/assets/asset_browser.tscn"
const LOGIN_SCENE         := "res://scenes/login/login.tscn"
const MECH_SELECT_SCENE   := "res://scenes/mech/mech_select.tscn"
const ARENA_SCENE         := "res://scenes/arena/ready_room.tscn"
const STANDINGS_SCENE     := "res://scenes/standings/standings.tscn"
const SETTINGS_SCENE      := "res://scenes/settings/settings.tscn"

@onready var server_value: Label = %ServerValue
@onready var websocket_value: Label = %WebSocketValue
@onready var status_label: Label = %StatusLabel
@onready var background_art: TextureRect = %BackgroundArt
@onready var title_art: TextureRect = %TitleArt


func _ready() -> void:
	AudioManager.play_bgm("menu")
	_apply_retail_art()
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

	_check_first_run()


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


func _on_arena_pressed() -> void:
	if not AuthSession.is_logged_in:
		get_tree().change_scene_to_file(LOGIN_SCENE)
	elif AuthSession.character.is_empty():
		status_label.text = "Create a character first to access the Arena"
		status_label.modulate = Color(1.0, 0.8, 0.3)
	elif AuthSession.character.get("mech_id", null) == null:
		status_label.text = "Select a mech in the Mech Bay before entering the Arena"
		status_label.modulate = Color(1.0, 0.8, 0.3)
	else:
		get_tree().change_scene_to_file(ARENA_SCENE)


func _on_standings_pressed() -> void:
	get_tree().change_scene_to_file(STANDINGS_SCENE)


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file(SETTINGS_SCENE)


func _check_first_run() -> void:
	if not FileAccess.file_exists("user://mpbt-client.json"):
		status_label.text = "First run — configure your server and asset paths in Settings"
		status_label.modulate = Color(0.9, 0.75, 0.25)


func _apply_retail_art() -> void:
	var extracted := ClientConfig.asset_extracted_path()
	if extracted.is_empty():
		return

	var bg_path := AssetRegistry.find_image(extracted, ["UI", "Scenes"], [
		"menu",
		"main",
		"title",
		"splash",
		"opening",
		"background",
	])
	var bg_texture := AssetRegistry.load_image_texture(bg_path)
	if bg_texture != null:
		background_art.texture = bg_texture
		background_art.visible = true

	var title_path := AssetRegistry.find_image(extracted, ["UI"], [
		"logo",
		"title",
		"mpbt",
		"battle",
		"solaris",
	])
	var title_texture := AssetRegistry.load_image_texture(title_path)
	if title_texture != null:
		title_art.texture = title_texture
		title_art.visible = true
