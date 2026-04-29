extends Node3D

## M7 Combat scene.
##
## Reads AuthSession.pending_match on _ready() to bootstrap the match context,
## then drives a live CharacterBody3D mech through WASD + mouse-look with
## 10 Hz position/fire updates sent to the server via WS.
##
## Server → client events handled:
##   combat_snapshot  — updates remote actor nodes; applies health/heat to local HUD.
##   combat_hit       — flashes HUD status text.
##   combat_end       — shows result overlay, releases mouse, exits after 4 s.
##
## Navigation convention:
##   - Forward = -Z (Godot default).  Heading = rotation.y.
##   - The server uses the same convention: forward = (-sin(h), 0, -cos(h)).

const MAIN_SCENE         := "res://scenes/main/main.tscn"
const TOUCH_OVERLAY_SCENE := "res://scenes/ui/touch_overlay.tscn"
const MECH_SPEED_MS      := 17.8          ## ~64 kph in m/s
const MOUSE_SENSITIVITY  := 0.0025
const PITCH_INITIAL      := 0.30          ## radians, slightly above-and-behind view
const PITCH_MIN          := 0.05
const PITCH_MAX          := 0.80
const INPUT_INTERVAL     := 0.1           ## seconds between combat_input sends (10 Hz)
const GRAVITY            := 9.8

# ─── Node references (filled by @onready) ─────────────────────────────────────

@onready var _local_mech: CharacterBody3D = $LocalMech
@onready var _camera_pivot: Node3D = $LocalMech/CameraPivot
@onready var _camera: Camera3D = $LocalMech/CameraPivot/Camera3D
@onready var _name_tag: Label3D = $LocalMech/NameTag
@onready var _remote_mechs: Node3D = $RemoteMechs
@onready var _health_bar: ProgressBar = $HUD/BottomPanel/HUDBox/HealthBar
@onready var _heat_bar: ProgressBar = $HUD/BottomPanel/HUDBox/HeatBar
@onready var _status_label: Label = $HUD/StatusLabel
@onready var _result_overlay: PanelContainer = $HUD/ResultOverlay
@onready var _result_title: Label = $HUD/ResultOverlay/ResultVBox/ResultTitle
@onready var _result_desc: Label = $HUD/ResultOverlay/ResultVBox/ResultDesc

# ─── Match state ───────────────────────────────────────────────────────────────

var _arena_id: String = ""
var _username: String = ""

var _health: int = 100
var _heat: float = 0.0

var _pitch: float = PITCH_INITIAL
var _fire_pending: bool = false
var _input_timer: float = 0.0
var _status_timer: float = 0.0
var _ended: bool = false
var _exit_timer: float = 0.0

var _remote_nodes: Dictionary = {}  # username: String -> Node3D

var _is_mobile:    bool    = false
var _touch_overlay = null  ## TouchOverlay CanvasLayer, or null on desktop


# ─── Lifecycle ─────────────────────────────────────────────────────────────────

func _ready() -> void:
	AudioManager.play_bgm("combat")
	var pm: Dictionary = AuthSession.pending_match
	if pm.is_empty():
		push_warning("CombatScene: no pending_match — returning to menu")
		get_tree().change_scene_to_file(MAIN_SCENE)
		return

	_arena_id = str(pm.get("arenaId", ""))
	_username = str(AuthSession.character.get("display_name", ""))

	if _arena_id.is_empty() or _username.is_empty():
		push_warning("CombatScene: missing arenaId or username — returning to menu")
		get_tree().change_scene_to_file(MAIN_SCENE)
		return

	_name_tag.text = _username
	_camera_pivot.rotation.x = _pitch
	_health_bar.modulate = Color(0.25, 0.9, 0.25)
	_heat_bar.modulate = Color(1.0, 0.55, 0.1)

	WSClient.combat_snapshot_received.connect(_on_combat_snapshot)
	WSClient.combat_hit_received.connect(_on_combat_hit)
	WSClient.combat_end_received.connect(_on_combat_end)
	WSClient.ws_connected.connect(_on_ws_connected)

	_is_mobile = OS.has_feature("android") or OS.has_feature("ios")
	if _is_mobile:
		_touch_overlay = load(TOUCH_OVERLAY_SCENE).instantiate()
		add_child(_touch_overlay)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_send_combat_join()


func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	AuthSession.pending_match = {}

	if WSClient.combat_snapshot_received.is_connected(_on_combat_snapshot):
		WSClient.combat_snapshot_received.disconnect(_on_combat_snapshot)
	if WSClient.combat_hit_received.is_connected(_on_combat_hit):
		WSClient.combat_hit_received.disconnect(_on_combat_hit)
	if WSClient.combat_end_received.is_connected(_on_combat_end):
		WSClient.combat_end_received.disconnect(_on_combat_end)
	if WSClient.ws_connected.is_connected(_on_ws_connected):
		WSClient.ws_connected.disconnect(_on_ws_connected)


# ─── Input ─────────────────────────────────────────────────────────────────────

func _unhandled_input(event: InputEvent) -> void:
	if _ended:
		if event.is_action_pressed("ui_cancel"):
			get_tree().change_scene_to_file(MAIN_SCENE)
		return

	if event.is_action_pressed("ui_cancel"):
		_surrender()
		return

	if not _is_mobile:
		if event is InputEventMouseMotion:
			var motion := event as InputEventMouseMotion
			_local_mech.rotation.y -= motion.relative.x * MOUSE_SENSITIVITY
			_pitch = clamp(_pitch - motion.relative.y * MOUSE_SENSITIVITY, PITCH_MIN, PITCH_MAX)
			_camera_pivot.rotation.x = _pitch

		if event.is_action_pressed("fire"):
			_fire_pending = true


# ─── Physics / frame loop ──────────────────────────────────────────────────────

func _physics_process(delta: float) -> void:
	if _ended:
		if _exit_timer > 0.0:
			_exit_timer -= delta
			if _exit_timer <= 0.0:
				get_tree().change_scene_to_file(MAIN_SCENE)
		return

	# --- Camera tracks mech mid-torso ---
	var look_at_pos := _local_mech.global_position + Vector3(0, 1.4, 0)
	if not _camera.global_position.is_equal_approx(look_at_pos):
		_camera.look_at(look_at_pos, Vector3.UP)

	# --- Movement ---
	var forward := -_local_mech.global_transform.basis.z
	var right   := _local_mech.global_transform.basis.x

	var fwd_axis := Input.get_axis("move_backward", "move_forward")
	var str_axis := Input.get_axis("move_left", "move_right")

	if _touch_overlay != null:
		var tv: Vector2 = _touch_overlay.move_value
		fwd_axis = clamp(fwd_axis + tv.y, -1.0, 1.0)
		str_axis = clamp(str_axis + tv.x, -1.0, 1.0)
		var ld: Vector2 = _touch_overlay.get_look_delta()
		_local_mech.rotation.y -= ld.x * MOUSE_SENSITIVITY
		_pitch = clamp(_pitch - ld.y * MOUSE_SENSITIVITY, PITCH_MIN, PITCH_MAX)
		_camera_pivot.rotation.x = _pitch
		if _touch_overlay.fire_pressed:
			_touch_overlay.fire_pressed = false
			_fire_pending = true

	var move_dir := (forward * fwd_axis) + (right * str_axis)
	if move_dir.length_squared() > 0.01:
		move_dir = move_dir.normalized()

	if not _local_mech.is_on_floor():
		_local_mech.velocity.y -= GRAVITY * delta
	else:
		_local_mech.velocity.y = 0.0

	_local_mech.velocity.x = move_dir.x * MECH_SPEED_MS
	_local_mech.velocity.z = move_dir.z * MECH_SPEED_MS
	_local_mech.move_and_slide()

	# --- Network input (10 Hz) ---
	_input_timer += delta
	if _input_timer >= INPUT_INTERVAL:
		_input_timer = 0.0
		_send_combat_input()
		if _fire_pending:
			_fire_pending = false
			WSClient.send_message({
				"type": "combat_fire",
				"arenaId": _arena_id,
				"username": _username,
			})

	# --- Status flash expiry ---
	if _status_timer > 0.0:
		_status_timer -= delta
		if _status_timer <= 0.0:
			_status_label.text = ""


# ─── WS helpers ────────────────────────────────────────────────────────────────

func _send_combat_join() -> void:
	WSClient.send_message({
		"type": "combat_join",
		"arenaId": _arena_id,
		"username": _username,
	})


func _on_ws_connected() -> void:
	if not _ended:
		_send_combat_join()


func _send_combat_input() -> void:
	WSClient.send_message({
		"type": "combat_input",
		"arenaId": _arena_id,
		"username": _username,
		"x": _local_mech.position.x,
		"z": _local_mech.position.z,
		"heading": _local_mech.rotation.y,
	})


func _surrender() -> void:
	WSClient.send_message({
		"type": "combat_leave",
		"arenaId": _arena_id,
		"username": _username,
	})
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file(MAIN_SCENE)


# ─── WS event handlers ─────────────────────────────────────────────────────────

func _on_combat_snapshot(data: Dictionary) -> void:
	if data.get("arenaId", "") != _arena_id:
		return

	var actors: Array = data.get("actors", [])
	for actor_v: Variant in actors:
		if typeof(actor_v) != TYPE_DICTIONARY:
			continue
		var actor := actor_v as Dictionary
		var uname := str(actor.get("username", ""))

		if uname == _username:
			# Server is authoritative for health and heat only.
			# Local position is driven by client physics — ignore server's copy.
			_health = int(actor.get("health", _health))
			_heat = float(actor.get("heat", _heat))
			_health_bar.value = float(_health)
			_heat_bar.value = _heat
		else:
			_update_remote_actor(actor)


func _update_remote_actor(actor: Dictionary) -> void:
	var uname := str(actor.get("username", ""))
	if uname.is_empty():
		return

	var x := float(actor.get("x", 0.0))
	var z := float(actor.get("z", 0.0))
	var heading := float(actor.get("heading", 0.0))
	var is_bot: bool = bool(actor.get("isBot", false))
	var type_str := str(actor.get("typeString", "?"))

	if not _remote_nodes.has(uname):
		var node := _create_remote_mech_node(uname, is_bot, type_str)
		_remote_mechs.add_child(node)
		_remote_nodes[uname] = node

	var remote: Node3D = _remote_nodes[uname]
	remote.position = Vector3(x, 1.6, z)
	remote.rotation.y = heading


func _create_remote_mech_node(uname: String, is_bot: bool, type_str: String) -> Node3D:
	var root := Node3D.new()
	root.name = "Remote_" + uname

	var mesh_inst := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(1.8, 3.2, 1.2)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.75, 0.18, 0.12) if is_bot else Color(0.2, 0.3, 0.8)
	mat.roughness = 0.7
	mat.metallic = 0.2
	mesh_inst.mesh = box
	mesh_inst.set_surface_override_material(0, mat)
	root.add_child(mesh_inst)

	var label := Label3D.new()
	label.text = "%s\n[%s]" % [uname, type_str]
	label.position = Vector3(0, 2.2, 0)
	label.pixel_size = 0.008
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.font_size = 20
	label.modulate = Color(1.0, 0.5, 0.5) if is_bot else Color(0.5, 0.7, 1.0)
	root.add_child(label)

	return root


func _on_combat_hit(data: Dictionary) -> void:
	if data.get("arenaId", "") != _arena_id:
		return

	var target := str(data.get("target", ""))
	var attacker := str(data.get("attacker", ""))
	var damage := int(data.get("damage", 0))
	var health := int(data.get("health", 0))

	if target == _username:
		_health = health
		_health_bar.value = float(_health)
		_status_label.text = "⚠ HIT by %s  –%d dmg  HP: %d" % [attacker, damage, _health]
		_status_label.add_theme_color_override("font_color", Color(1.0, 0.25, 0.15))
		_status_timer = 2.5
	elif attacker == _username:
		_status_label.text = "✓ HIT %s  –%d  HP: %d" % [target, damage, health]
		_status_label.add_theme_color_override("font_color", Color(0.25, 1.0, 0.3))
		_status_timer = 1.5


func _on_combat_end(data: Dictionary) -> void:
	if data.get("arenaId", "") != _arena_id:
		return
	if _ended:
		return
	_ended = true
	_exit_timer = 4.0

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var winner := str(data.get("winner", ""))
	var loser := str(data.get("loser", ""))
	var local_won := (winner == _username)

	_result_title.text = "VICTORY" if local_won else "DEFEAT"
	_result_title.add_theme_color_override(
		"font_color",
		Color(0.2, 1.0, 0.3) if local_won else Color(1.0, 0.2, 0.15),
	)
	_result_desc.text = "%s destroyed!" % loser if local_won else "Destroyed by %s." % winner
	_result_overlay.visible = true
	_status_label.text = ""

