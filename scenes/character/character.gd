extends Control

const WORLD_SCENE := "res://scenes/world/world.tscn"
const LOGIN_SCENE := "res://scenes/login/login.tscn"
const ALLEGIANCES := ["Davion", "Steiner", "Liao", "Marik", "Kurita"]

@onready var name_input:     LineEdit     = $Content/Form/NameInput
@onready var allegiance_opt: OptionButton = $Content/Form/AllegianceOption
@onready var submit_button:  Button       = $Content/Form/SubmitButton
@onready var status_label:   Label        = $Content/StatusLabel


func _ready() -> void:
	AudioManager.play_bgm("menu")
	AuthSession.character_created.connect(_on_character_created)
	AuthSession.creation_failed.connect(_on_creation_failed)

	for a in ALLEGIANCES:
		allegiance_opt.add_item(a)

	# Safety: if a character already exists (e.g. direct navigation), skip creation.
	if not AuthSession.character.is_empty():
		get_tree().change_scene_to_file(WORLD_SCENE)


func _set_status(text: String, error: bool = false) -> void:
	status_label.text = text
	status_label.modulate = Color(1.0, 0.45, 0.45) if error else Color(0.65, 0.65, 0.65, 1.0)


func _on_submit_pressed() -> void:
	var display_name := name_input.text.strip_edges()
	if display_name.length() < 2:
		_set_status("Name must be at least 2 characters", true)
		return

	submit_button.disabled = true
	_set_status("Creating character\u2026")

	var allegiance: String = ALLEGIANCES[allegiance_opt.selected]
	AuthSession.create_character(ServerBridge.api_url, display_name, allegiance)


func _on_character_created(_character: Dictionary) -> void:
	get_tree().change_scene_to_file(WORLD_SCENE)


func _on_creation_failed(reason: String) -> void:
	submit_button.disabled = false
	_set_status(reason, true)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(LOGIN_SCENE)
