extends Control

const WORLD_SCENE     := "res://scenes/world/world.tscn"
const CHARACTER_SCENE := "res://scenes/character/character.tscn"

enum Mode { LOGIN, REGISTER }

@onready var username_input: LineEdit     = $Content/Form/UsernameInput
@onready var email_row: VBoxContainer     = $Content/Form/EmailRow
@onready var email_input: LineEdit        = $Content/Form/EmailRow/EmailInput
@onready var password_input: LineEdit     = $Content/Form/PasswordInput
@onready var submit_button: Button        = $Content/Form/SubmitButton
@onready var toggle_button: Button        = $Content/ToggleButton
@onready var status_label: Label          = $Content/StatusLabel

var _mode: Mode = Mode.LOGIN


func _ready() -> void:
	AuthSession.login_complete.connect(_on_login_complete)
	AuthSession.login_failed.connect(_on_login_failed)
	_update_mode()

	if AuthSession.is_logged_in:
		_go_after_login()
		return

	if not ServerBridge.is_online:
		submit_button.disabled = true
		_set_status("Connecting\u2026")
		ServerBridge.server_available.connect(_on_bridge_ready, CONNECT_ONE_SHOT)
		ServerBridge.server_unavailable.connect(_on_bridge_unavailable, CONNECT_ONE_SHOT)
		ServerBridge.check_config()


func _go_after_login() -> void:
	if AuthSession.character.is_empty():
		get_tree().change_scene_to_file(CHARACTER_SCENE)
	else:
		get_tree().change_scene_to_file(WORLD_SCENE)


func _set_status(text: String, error: bool = false) -> void:
	status_label.text = text
	status_label.modulate = Color(1.0, 0.45, 0.45) if error else Color(0.65, 0.65, 0.65, 1.0)


func _update_mode() -> void:
	email_row.visible = (_mode == Mode.REGISTER)
	submit_button.text = "Sign In" if _mode == Mode.LOGIN else "Create Account"
	toggle_button.text = (
		"No account? Register" if _mode == Mode.LOGIN else "Already registered? Sign In"
	)
	status_label.text = ""


func _on_bridge_ready(_info: Dictionary) -> void:
	submit_button.disabled = false
	_set_status("")


func _on_bridge_unavailable(reason: String) -> void:
	_set_status("Server offline \u2014 %s" % reason, true)


func _on_submit_pressed() -> void:
	var uname := username_input.text.strip_edges()
	var pw    := password_input.text
	if uname.is_empty() or pw.is_empty():
		_set_status("Username and password required", true)
		return

	submit_button.disabled = true
	_set_status("Please wait\u2026")

	var api_url := ServerBridge.api_url
	if _mode == Mode.LOGIN:
		AuthSession.login(api_url, uname, pw)
	else:
		var email := email_input.text.strip_edges()
		if email.is_empty():
			_set_status("Email address required", true)
			submit_button.disabled = false
			return
		AuthSession.register(api_url, uname, pw, email)


func _on_toggle_pressed() -> void:
	_mode = Mode.REGISTER if _mode == Mode.LOGIN else Mode.LOGIN
	submit_button.disabled = false
	_update_mode()


func _on_login_complete(_has_character: bool) -> void:
	_go_after_login()


func _on_login_failed(reason: String) -> void:
	submit_button.disabled = false
	_set_status(reason, true)
