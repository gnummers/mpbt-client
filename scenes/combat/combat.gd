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
const DEFAULT_MECH_SPEED_MS := 17.8       ## Fallback: ~64 kph in m/s.
const MOUSE_SENSITIVITY  := 0.0025
const PITCH_INITIAL      := 0.30          ## radians, slightly above-and-behind view
const PITCH_MIN          := 0.05
const PITCH_MAX          := 0.80
const INPUT_INTERVAL     := 0.1           ## seconds between combat_input sends (10 Hz)
const GRAVITY            := 9.8
const HEAT_DISSIPATION_WINDOW := 3.0      ## Approximate one full sink cycle.
const DEFAULT_HEAT_SINKS := 10
const JUMP_FUEL_MAX := 120.0              ## Retail init seeds actor +0x472 to 0x78.
const JUMP_FUEL_MIN := 50.0               ## Retail start gate requires fuel > 0x32.
const JUMP_FUEL_COST := 70.0
const JUMP_FUEL_RECHARGE_PER_SEC := 35.0
const JUMP_START_THROTTLE := 0.5
const FIRE_BEARING_COS := 0.45
const DEFAULT_EFFECT_RANGE := 300.0
const RADAR_RANGES := [50, 100, 300, 800, 2500]
const POSTURE_NORMAL := 0
const POSTURE_AIRBORNE := 1
const POSTURE_DOWNED := 2
const POSTURE_CRIPPLED := 3
const POSTURE_POSE_LERP_RATE := 8.0
const INTERNAL_SECTION_LABELS := ["LA", "RA", "LT", "RT", "CT", "LL", "RL", "HD"]
const TIC_LABELS := ["A", "B", "C"]
const THROTTLE_STEP_PCT := 10
const THROTTLE_LERP_RATE := 5.0
const TURN_RATE := 1.7
const READOUT_TARGET_BRIEF := "target_brief"
const READOUT_TARGET_DETAIL := "target_detail"
const READOUT_SELF_DETAIL := "self_detail"
const COMBAT_CHAT_ALL := "all"
const COMBAT_CHAT_TEAM := "team"

# ─── Node references (filled by @onready) ─────────────────────────────────────

@onready var _local_mech: CharacterBody3D = $LocalMech
@onready var _local_mech_mesh: Node3D = $LocalMech/MechMesh
@onready var _camera_pivot: Node3D = $LocalMech/CameraPivot
@onready var _camera: Camera3D = $LocalMech/CameraPivot/Camera3D
@onready var _name_tag: Label3D = $LocalMech/NameTag
@onready var _remote_mechs: Node3D = $RemoteMechs
@onready var _effects: Node3D = $Effects
@onready var _radar = $HUD/Radar
@onready var _target_name: Label = $HUD/TargetInfo/TargetBox/TargetName
@onready var _target_range: Label = $HUD/TargetInfo/TargetBox/TargetRange
@onready var _target_status: Label = $HUD/TargetInfo/TargetBox/TargetStatus
@onready var _readout_title: Label = $HUD/ReadoutPanel/ReadoutVBox/ReadoutTitle
@onready var _readout_body: Label = $HUD/ReadoutPanel/ReadoutVBox/ReadoutBody
@onready var _health_bar: ProgressBar = $HUD/BottomPanel/HUDBox/HealthBar
@onready var _heat_bar: ProgressBar = $HUD/BottomPanel/HUDBox/HeatBar
@onready var _speed_value: Label = $HUD/BottomPanel/HUDBox/SpeedValue
@onready var _jump_value: Label = $HUD/BottomPanel/HUDBox/JumpValue
@onready var _posture_value: Label = $HUD/BottomPanel/HUDBox/PostureValue
@onready var _weapon_value: Label = $HUD/BottomPanel/HUDBox/WeaponValue
@onready var _status_label: Label = $HUD/StatusLabel
@onready var _chat_panel: Panel = $HUD/ChatPanel
@onready var _chat_title: Label = $HUD/ChatPanel/ChatVBox/ChatTitle
@onready var _chat_hint: Label = $HUD/ChatPanel/ChatVBox/ChatHint
@onready var _chat_input: LineEdit = $HUD/ChatPanel/ChatVBox/ChatInput
@onready var _chat_status: Label = $HUD/ChatPanel/ChatVBox/ChatStatus
@onready var _result_overlay: PanelContainer = $HUD/ResultOverlay
@onready var _result_title: Label = $HUD/ResultOverlay/ResultVBox/ResultTitle
@onready var _result_desc: Label = $HUD/ResultOverlay/ResultVBox/ResultDesc

# ─── Match state ───────────────────────────────────────────────────────────────

var _arena_id: String = ""
var _username: String = ""
var _mech_id: int = -1
var _mech_type: String = ""
var _mech_speed_ms: float = DEFAULT_MECH_SPEED_MS
var _mech_max_speed_mag: int = 0
var _heat_sinks: int = DEFAULT_HEAT_SINKS
var _heat_capacity: float = 15.0
var _heat_shutdown: bool = false
var _jump_jet_count: int = 0
var _jump_fuel: float = JUMP_FUEL_MAX
var _jump_flags: int = 0
var _jump_start_timer: float = 0.0
var _weapon_type_ids: Array = []
var _weapon_mount_internal_indices: Array = []
var _weapon_damage_states: Array = []
var _weapon_ammo_bin_indices: Array = []
var _ammo_bin_type_ids: Array = []
var _ammo_bin_remaining: Array = []
var _weapon_cooldown_remaining: Array = []
var _internal_state_values: Array = []
var _selected_weapon_slot: int = 0

var _health: int = 100
var _heat: float = 0.0
var _throttle_pct: int = 0

var _pitch: float = PITCH_INITIAL
var _fire_pending: bool = false
var _jump_pending: bool = false
var _input_timer: float = 0.0
var _status_timer: float = 0.0
var _ended: bool = false
var _exit_timer: float = 0.0

var _local_actor_info: Dictionary = {}
var _local_posture_state: int = POSTURE_NORMAL
var _remote_nodes: Dictionary = {}  # username: String -> Node3D
var _remote_targets: Dictionary = {}  # username: String -> { position, heading, posture }
var _remote_actor_info: Dictionary = {}  # username: String -> latest actor dictionary
var _radar_range_index: int = 2
var _selected_target_username: String = ""
var _readout_mode: String = READOUT_TARGET_BRIEF
var _tic_groups: Array = [[], [], []]
var _selected_tic_index: int = -1
var _queued_fire_slots: Array = []
var _combat_chat_mode: String = COMBAT_CHAT_ALL

var _is_mobile:    bool    = false
var _touch_overlay = null  ## TouchOverlay CanvasLayer, or null on desktop


# ─── Lifecycle ─────────────────────────────────────────────────────────────────

func _ready() -> void:
	AudioManager.play_bgm("combat")
	var pm: Dictionary = AuthSession.pending_match
	if pm.is_empty():
		push_warning("CombatScene: no pending_match — returning to menu")
		_return_to_menu_deferred()
		return

	_arena_id = str(pm.get("arenaId", ""))
	_username = str(AuthSession.character.get("display_name", ""))
	_apply_match_mech_identity(pm)

	if _arena_id.is_empty() or _username.is_empty():
		push_warning("CombatScene: missing arenaId or username — returning to menu")
		_return_to_menu_deferred()
		return

	_name_tag.text = _username
	_camera_pivot.rotation.x = _pitch
	_health_bar.modulate = Color(0.25, 0.9, 0.25)
	_heat_bar.modulate = Color(1.0, 0.55, 0.1)
	_apply_retail_mech_runtime()
	_update_heat_hud()
	_update_speed_hud()
	_update_jump_hud()
	_update_posture_hud()
	_update_target_hud()
	_update_weapon_hud()
	_update_readout_panel({})
	_chat_input.text_submitted.connect(_on_chat_text_submitted)

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

	if _chat_input.text_submitted.is_connected(_on_chat_text_submitted):
		_chat_input.text_submitted.disconnect(_on_chat_text_submitted)
	if WSClient.combat_snapshot_received.is_connected(_on_combat_snapshot):
		WSClient.combat_snapshot_received.disconnect(_on_combat_snapshot)
	if WSClient.combat_hit_received.is_connected(_on_combat_hit):
		WSClient.combat_hit_received.disconnect(_on_combat_hit)
	if WSClient.combat_end_received.is_connected(_on_combat_end):
		WSClient.combat_end_received.disconnect(_on_combat_end)
	if WSClient.ws_connected.is_connected(_on_ws_connected):
		WSClient.ws_connected.disconnect(_on_ws_connected)


func _return_to_menu_deferred() -> void:
	get_tree().call_deferred("change_scene_to_file", MAIN_SCENE)


func _apply_match_mech_identity(pm: Dictionary) -> void:
	_mech_id = int(AuthSession.character.get("mech_id", -1))
	_mech_type = str(AuthSession.character.get("mech_type", ""))

	var slots: Array = pm.get("slots", [])
	for slot_v in slots:
		if typeof(slot_v) != TYPE_DICTIONARY:
			continue
		var slot := slot_v as Dictionary
		if str(slot.get("username", "")) != _username:
			continue
		_mech_id = int(slot.get("mechId", _mech_id))
		var slot_type := str(slot.get("typeString", ""))
		if not slot_type.is_empty():
			_mech_type = slot_type
		break


func _apply_retail_mech_runtime() -> void:
	var roster := MecParser.load_roster(ClientConfig.retail_asset_path())
	if not roster.get("ok", false):
		return

	for mech_v in roster.get("mechs", []):
		if typeof(mech_v) != TYPE_DICTIONARY:
			continue
		var mech := mech_v as Dictionary
		var id_matches := _mech_id >= 0 and int(mech.get("id", -1)) == _mech_id
		var type_matches := not _mech_type.is_empty() and str(mech.get("typeString", "")) == _mech_type
		if not id_matches and not type_matches:
			continue

		_mech_id = int(mech.get("id", _mech_id))
		_mech_type = str(mech.get("typeString", _mech_type))
		_mech_max_speed_mag = int(mech.get("maxSpeedMag", 0))
		if _mech_max_speed_mag > 0:
			_mech_speed_ms = float(_mech_max_speed_mag) / 100.0
		_heat_sinks = max(1, int(mech.get("heatSinks", DEFAULT_HEAT_SINKS)))
		_heat_capacity = _heat_capacity_for_sinks(_heat_sinks)
		_heat_bar.max_value = _heat_capacity
		_jump_jet_count = max(0, int(mech.get("jumpJetCount", 0)))
		_jump_fuel = JUMP_FUEL_MAX
		_jump_flags = 0
		_jump_start_timer = 0.0
		_weapon_type_ids = mech.get("weaponTypeIds", [])
		_weapon_mount_internal_indices = mech.get("weaponMountInternalIndices", [])
		_weapon_damage_states.resize(_weapon_type_ids.size())
		_weapon_damage_states.fill(0)
		_selected_weapon_slot = int(clamp(_selected_weapon_slot, 0, max(0, _weapon_type_ids.size() - 1)))
		_weapon_cooldown_remaining.resize(_weapon_type_ids.size())
		_weapon_cooldown_remaining.fill(0.0)
		_internal_state_values = mech.get("internalStateMaxValues", MecParser.mech_internal_state_values(int(mech.get("tonnage", 0))))
		_apply_retail_ammo_state(mech)
		_rebuild_default_tics()
		_selected_tic_index = -1
		_throttle_pct = 0
		_name_tag.text = "%s\n%s" % [_username, _mech_type]
		return


func _apply_retail_ammo_state(mech: Dictionary) -> void:
	_weapon_ammo_bin_indices.clear()
	_ammo_bin_type_ids = mech.get("ammoBinTypeIds", [])
	_ammo_bin_remaining.clear()

	for type_id_v in _ammo_bin_type_ids:
		_ammo_bin_remaining.append(MecParser.weapon_starting_ammo(int(type_id_v)))

	for weapon_type_v in _weapon_type_ids:
		_weapon_ammo_bin_indices.append(_find_ammo_bin_for_type(int(weapon_type_v)))


func _rebuild_default_tics() -> void:
	var long_range_slots: Array = []
	var close_range_slots: Array = []
	var all_slots: Array = []
	for slot in _weapon_type_ids.size():
		all_slots.append(slot)
		var max_range := MecParser.weapon_long_range_meters(int(_weapon_type_ids[slot]))
		if max_range > 270:
			long_range_slots.append(slot)
		else:
			close_range_slots.append(slot)
	_tic_groups = [
		long_range_slots.duplicate(),
		close_range_slots.duplicate(),
		all_slots.duplicate(),
	]
	if _tic_groups[0].is_empty():
		_tic_groups[0] = all_slots.duplicate()
	if _tic_groups[1].is_empty():
		_tic_groups[1] = all_slots.duplicate()


func _tic_slots(tic_index: int) -> Array:
	if tic_index < 0 or tic_index >= _tic_groups.size():
		return []
	var slots_v: Variant = _tic_groups[tic_index]
	return slots_v if typeof(slots_v) == TYPE_ARRAY else []


func _tic_label(tic_index: int) -> String:
	if tic_index < 0 or tic_index >= TIC_LABELS.size():
		return "-"
	return TIC_LABELS[tic_index]


func _set_selected_tic(tic_index: int) -> void:
	var slots := _tic_slots(tic_index)
	if slots.is_empty():
		_flash_status("TIC %s empty" % _tic_label(tic_index))
		return
	_selected_tic_index = tic_index
	if not slots.has(_selected_weapon_slot):
		_selected_weapon_slot = int(slots[0])
	_update_weapon_hud()


func _cycle_current_tic() -> void:
	if _weapon_type_ids.is_empty():
		return
	var next_index := (_selected_tic_index + 1) % TIC_LABELS.size()
	_set_selected_tic(next_index)


func _toggle_selected_weapon_on_tic(tic_index: int) -> void:
	if _selected_weapon_slot < 0 or _selected_weapon_slot >= _weapon_type_ids.size():
		return
	if tic_index < 0 or tic_index >= _tic_groups.size():
		return
	var slots := _tic_slots(tic_index).duplicate()
	if slots.has(_selected_weapon_slot):
		slots.erase(_selected_weapon_slot)
		_flash_status("Removed %s from TIC %s" % [MecParser.weapon_short_name(_selected_weapon_type_id()), _tic_label(tic_index)])
	else:
		slots.append(_selected_weapon_slot)
		slots.sort()
		_flash_status("Added %s to TIC %s" % [MecParser.weapon_short_name(_selected_weapon_type_id()), _tic_label(tic_index)])
	_tic_groups[tic_index] = slots
	if _selected_tic_index == tic_index and not slots.is_empty():
		_selected_weapon_slot = int(slots[0]) if not slots.has(_selected_weapon_slot) else _selected_weapon_slot
	_update_weapon_hud()


func _queue_fire_slot(slot: int) -> void:
	if slot < 0 or slot >= _weapon_type_ids.size():
		return
	_queued_fire_slots.append(slot)


func _queue_tic_fire(tic_index: int) -> void:
	var slots := _tic_slots(tic_index)
	if slots.is_empty():
		_flash_status("TIC %s empty" % _tic_label(tic_index))
		return
	for slot_v in slots:
		_queue_fire_slot(int(slot_v))
	_selected_tic_index = tic_index
	_update_weapon_hud()


func _advance_selected_tic(slot: int) -> void:
	var slots := _tic_slots(_selected_tic_index)
	if slots.is_empty():
		return
	var index := slots.find(slot)
	if index < 0:
		return
	_selected_weapon_slot = int(slots[(index + 1) % slots.size()])
	_update_weapon_hud()


func _update_speed_hud() -> void:
	var current_ms := Vector2(_local_mech.velocity.x, _local_mech.velocity.z).length()
	var current_kph := int(round(current_ms * 3.6))
	var max_kph := int(round(_mech_speed_ms * 3.6))
	_speed_value.text = "%d/%d %+d%%" % [current_kph, max_kph, _throttle_pct]


func _update_jump_hud() -> void:
	if _jump_jet_count <= 0:
		_jump_value.text = "--"
		return
	var pct := int(round((_jump_fuel / JUMP_FUEL_MAX) * 100.0))
	var suffix := "AIR" if _jump_flags != 0 else "RDY"
	_jump_value.text = "%dJ %d%% %s" % [_jump_jet_count, pct, suffix]


func _update_posture_hud() -> void:
	_local_posture_state = _current_local_posture_state()
	_posture_value.text = _posture_tag(_local_posture_state)
	_posture_value.add_theme_color_override("font_color", _posture_color(_local_posture_state))


func _current_local_posture_state() -> int:
	var server_state: int = _actor_posture_state(_local_actor_info, _health)
	if server_state == POSTURE_DOWNED or server_state == POSTURE_CRIPPLED:
		return server_state
	if _health <= 0:
		return POSTURE_CRIPPLED
	if not _local_mech.is_on_floor() or (_jump_flags & 0x3) != 0:
		return POSTURE_AIRBORNE
	return server_state


func _actor_posture_state(actor: Dictionary, health_fallback: int = 100) -> int:
	if actor.is_empty():
		return POSTURE_NORMAL
	var posture_text: String = str(actor.get("postureState", actor.get("posture", ""))).to_lower()
	var posture_code: int = int(actor.get("postureCode", actor.get("animState", -1)))
	var jump_flags: int = int(actor.get("jumpFlags", 0))
	var health_value: int = int(actor.get("health", health_fallback))
	if health_value <= 0 or posture_text == "crippled" or posture_text == "destroyed" or posture_code == 3:
		return POSTURE_CRIPPLED
	if bool(actor.get("downed", false)) or bool(actor.get("collapsed", false)):
		return POSTURE_DOWNED
	if posture_text == "downed" or posture_text == "collapse" or posture_text == "collapsed" or posture_code == 8:
		return POSTURE_DOWNED
	if bool(actor.get("airborne", false)) or posture_text == "airborne" or posture_code == 4:
		return POSTURE_AIRBORNE
	if (jump_flags & 0x01) != 0 or (jump_flags & 0x80) != 0:
		return POSTURE_AIRBORNE
	return POSTURE_NORMAL


func _posture_tag(posture_state: int) -> String:
	match posture_state:
		POSTURE_AIRBORNE:
			return "AIR"
		POSTURE_DOWNED:
			return "DOWN"
		POSTURE_CRIPPLED:
			return "CRIP"
		_:
			return "NORM"


func _posture_color(posture_state: int) -> Color:
	match posture_state:
		POSTURE_AIRBORNE:
			return Color(0.95, 0.85, 0.2)
		POSTURE_DOWNED:
			return Color(1.0, 0.55, 0.18)
		POSTURE_CRIPPLED:
			return Color(1.0, 0.22, 0.16)
		_:
			return Color(0.35, 1.0, 0.45)


func _apply_local_mech_visuals(delta: float) -> void:
	_apply_visual_pose(_local_mech_mesh, null, _local_posture_state, delta, false)


func _apply_remote_mech_visuals(remote: Node3D, posture_state: int, delta: float) -> void:
	var mesh_pivot := remote.get_node_or_null("MeshPivot")
	var name_tag := remote.get_node_or_null("NameTag")
	if not (mesh_pivot is Node3D):
		return
	var label_ref: Label3D = null
	if name_tag is Label3D:
		label_ref = name_tag as Label3D
	_apply_visual_pose(mesh_pivot as Node3D, label_ref, posture_state, delta, true)


func _apply_visual_pose(mesh_node: Node3D, name_tag: Label3D, posture_state: int, delta: float, apply_visual_lift: bool) -> void:
	var target_y: float = 0.0
	var target_label_y: float = 2.2
	var target_pitch: float = 0.0
	var target_roll: float = 0.0
	var phase: float = float(Time.get_ticks_msec()) / 1000.0

	match posture_state:
		POSTURE_AIRBORNE:
			if apply_visual_lift:
				target_y = 0.38 + sin(phase * 9.0) * 0.08
				target_label_y = 2.5
			target_pitch = -0.22
			target_roll = sin(phase * 4.5) * 0.04
		POSTURE_DOWNED:
			if apply_visual_lift:
				target_y = -0.55
				target_label_y = 1.25
			target_pitch = 0.1
			target_roll = 1.18
		POSTURE_CRIPPLED:
			if apply_visual_lift:
				target_y = -0.72
				target_label_y = 1.0
			target_pitch = -0.06
			target_roll = 1.52

	var weight: float = min(1.0, delta * POSTURE_POSE_LERP_RATE)
	if apply_visual_lift:
		mesh_node.position.y = lerpf(mesh_node.position.y, target_y, weight)
		if name_tag != null:
			name_tag.position.y = lerpf(name_tag.position.y, target_label_y, weight)
	mesh_node.rotation.x = lerp_angle(mesh_node.rotation.x, target_pitch, weight)
	mesh_node.rotation.z = lerp_angle(mesh_node.rotation.z, target_roll, weight)


func _refresh_remote_name_tag(remote: Node3D, uname: String, type_str: String, posture_state: int, is_bot: bool) -> void:
	var name_tag := remote.get_node_or_null("NameTag")
	if not (name_tag is Label3D):
		return
	var label := name_tag as Label3D
	var posture_suffix := ""
	if posture_state != POSTURE_NORMAL:
		posture_suffix = " %s" % _posture_tag(posture_state)
	label.text = "%s\n[%s]%s" % [uname, type_str, posture_suffix]
	label.modulate = _posture_color(posture_state) if posture_state != POSTURE_NORMAL else (
		Color(1.0, 0.5, 0.5) if is_bot else Color(0.5, 0.7, 1.0)
	)


func _heat_capacity_for_sinks(heat_sinks: int) -> float:
	return float(max(12, heat_sinks * 1.5))


func _heat_shutdown_clear_threshold() -> float:
	return float(_heat_sinks) * 0.9


func _update_heat_hud() -> void:
	_heat_bar.max_value = _heat_capacity
	_heat_bar.value = clamp(_heat, 0.0, _heat_capacity)
	_heat_bar.modulate = Color(1.0, 0.15, 0.08) if _heat_shutdown else Color(1.0, 0.55, 0.1)


func _update_weapon_hud() -> void:
	if _weapon_type_ids.is_empty():
		_weapon_value.text = "--"
		return
	var type_id: int = _selected_weapon_type_id()
	var text := "%d/%d %s" % [
		_selected_weapon_slot + 1,
		_weapon_type_ids.size(),
		MecParser.weapon_short_name(type_id),
	]
	if MecParser.weapon_uses_ammo(type_id):
		text = "%s AMMO %d" % [text, _selected_weapon_ammo_remaining()]
	var blocked_reason := _selected_weapon_blocked_reason(type_id)
	if _heat_shutdown:
		text = "%s SHDN" % [text]
	elif not blocked_reason.is_empty():
		text = "%s %s" % [text, blocked_reason]
	elif _selected_weapon_cooldown_remaining() > 0.05:
		var cooldown: float = _selected_weapon_cooldown_remaining()
		text = "%s DLY %.1f" % [text, cooldown]
	else:
		text = "%s RDY" % [text]
	if _selected_tic_index >= 0:
		text = "%s TIC %s" % [text, _tic_label(_selected_tic_index)]
	_weapon_value.text = text


func _selected_weapon_type_id() -> int:
	if _weapon_type_ids.is_empty():
		return -1
	return int(_weapon_type_ids[int(clamp(_selected_weapon_slot, 0, _weapon_type_ids.size() - 1))])


func _select_weapon_slot(slot: int) -> void:
	if _weapon_type_ids.is_empty():
		return
	_selected_weapon_slot = int(clamp(slot, 0, _weapon_type_ids.size() - 1))
	_selected_tic_index = _tic_index_for_slot(_selected_weapon_slot)
	_update_weapon_hud()


func _cycle_weapon(delta: int) -> void:
	if _weapon_type_ids.is_empty():
		return
	if _selected_tic_index >= 0:
		var tic_slots := _tic_slots(_selected_tic_index)
		if not tic_slots.is_empty():
			var current_index := tic_slots.find(_selected_weapon_slot)
			if current_index < 0:
				_selected_weapon_slot = int(tic_slots[0])
			else:
				var count := tic_slots.size()
				_selected_weapon_slot = int(tic_slots[(current_index + delta + count) % count])
			_update_weapon_hud()
			return
	var count: int = _weapon_type_ids.size()
	_selected_weapon_slot = (_selected_weapon_slot + delta + count) % count
	_selected_tic_index = _tic_index_for_slot(_selected_weapon_slot)
	_update_weapon_hud()


func _tic_index_for_slot(slot: int) -> int:
	for tic_index in _tic_groups.size():
		if _tic_slots(tic_index).has(slot):
			return tic_index
	return -1


func _selected_weapon_ammo_bin() -> int:
	if _selected_weapon_slot < 0 or _selected_weapon_slot >= _weapon_ammo_bin_indices.size():
		return -1
	return int(_weapon_ammo_bin_indices[_selected_weapon_slot])


func _selected_weapon_ammo_remaining() -> int:
	var ammo_bin := _selected_weapon_ammo_bin()
	if ammo_bin < 0 or ammo_bin >= _ammo_bin_remaining.size():
		return 0
	return int(_ammo_bin_remaining[ammo_bin])


func _selected_weapon_cooldown_remaining() -> float:
	if _selected_weapon_slot < 0 or _selected_weapon_slot >= _weapon_cooldown_remaining.size():
		return 0.0
	return float(_weapon_cooldown_remaining[_selected_weapon_slot])


func _selected_weapon_mount_internal_index() -> int:
	if _selected_weapon_slot < 0 or _selected_weapon_slot >= _weapon_mount_internal_indices.size():
		return -1
	return int(_weapon_mount_internal_indices[_selected_weapon_slot])


func _selected_weapon_blocked_reason(type_id: int) -> String:
	if type_id < 0:
		return "NONE"
	if _selected_weapon_slot >= 0 and _selected_weapon_slot < _weapon_damage_states.size():
		if int(_weapon_damage_states[_selected_weapon_slot]) != 0:
			return "LOST"
	var mount_index := _selected_weapon_mount_internal_index()
	if mount_index >= 0 and mount_index < _internal_state_values.size():
		if int(_internal_state_values[mount_index]) <= 0:
			return "MNT"
	return ""


func _find_ammo_bin_for_type(type_id: int) -> int:
	for index in _ammo_bin_type_ids.size():
		if int(_ammo_bin_type_ids[index]) == type_id and int(_ammo_bin_remaining[index]) > 0:
			return index
	return -1


func _can_fire_selected_weapon() -> bool:
	return _can_fire_weapon_slot(_selected_weapon_slot)


func _can_fire_weapon_slot(slot: int) -> bool:
	if slot < 0 or slot >= _weapon_type_ids.size():
		_flash_status("No weapon selected")
		return false
	var previous_slot := _selected_weapon_slot
	_selected_weapon_slot = slot
	var type_id: int = _selected_weapon_type_id()
	if type_id < 0:
		_selected_weapon_slot = previous_slot
		_flash_status("No weapon selected")
		return false
	if _heat_shutdown:
		_selected_weapon_slot = previous_slot
		_flash_status("Shutdown cooling")
		return false
	var blocked_reason := _selected_weapon_blocked_reason(type_id)
	if not blocked_reason.is_empty():
		_selected_weapon_slot = previous_slot
		_flash_status("%s unavailable" % MecParser.weapon_name(type_id))
		_update_weapon_hud()
		return false
	var cooldown: float = _selected_weapon_cooldown_remaining()
	if cooldown > 0.05:
		_selected_weapon_slot = previous_slot
		_flash_status("%s recharging %.1fs" % [MecParser.weapon_name(type_id), cooldown])
		return false
	if not MecParser.weapon_uses_ammo(type_id):
		_selected_weapon_slot = previous_slot
		return true
	var ammo_bin := _selected_weapon_ammo_bin()
	if ammo_bin >= 0 and ammo_bin < _ammo_bin_remaining.size() and int(_ammo_bin_remaining[ammo_bin]) > 0:
		_selected_weapon_slot = previous_slot
		return true
	_repoint_weapon_ammo_bins(type_id)
	if _selected_weapon_ammo_remaining() > 0:
		_selected_weapon_slot = previous_slot
		return true
	_selected_weapon_slot = previous_slot
	_update_weapon_hud()
	_flash_status("%s empty" % MecParser.weapon_name(type_id))
	return false


func _consume_selected_weapon_ammo() -> Dictionary:
	var type_id: int = _selected_weapon_type_id()
	var ammo_bin := _selected_weapon_ammo_bin()
	var remaining := 0
	if MecParser.weapon_uses_ammo(type_id) and ammo_bin >= 0 and ammo_bin < _ammo_bin_remaining.size():
		remaining = max(0, int(_ammo_bin_remaining[ammo_bin]) - 1)
		_ammo_bin_remaining[ammo_bin] = remaining
		if remaining <= 0:
			_repoint_weapon_ammo_bins(type_id)
	else:
		ammo_bin = -1
	_update_weapon_hud()
	return {
		"ammoBin": ammo_bin,
		"ammoRemaining": remaining,
	}


func _start_selected_weapon_cooldown() -> void:
	if _selected_weapon_slot < 0 or _selected_weapon_slot >= _weapon_cooldown_remaining.size():
		return
	var type_id: int = _selected_weapon_type_id()
	_weapon_cooldown_remaining[_selected_weapon_slot] = MecParser.weapon_cooldown_seconds(type_id)
	_update_weapon_hud()


func _apply_selected_weapon_heat() -> void:
	var type_id: int = _selected_weapon_type_id()
	if type_id < 0:
		return
	_heat = min(_heat_capacity, _heat + float(MecParser.weapon_heat(type_id)))
	if _heat >= _heat_capacity:
		_heat_shutdown = true
		_flash_status("Shutdown")
	_update_heat_hud()
	_update_weapon_hud()


func _process_fire_queue() -> void:
	if _queued_fire_slots.is_empty():
		if _fire_pending:
			_fire_pending = false
			_queue_fire_slot(_selected_weapon_slot)
	if _queued_fire_slots.is_empty():
		return
	var slot := int(_queued_fire_slots.pop_front())
	_fire_weapon_slot(slot)


func _fire_weapon_slot(slot: int) -> void:
	var previous_slot := _selected_weapon_slot
	_selected_weapon_slot = slot
	if not _can_fire_selected_weapon():
		_selected_weapon_slot = previous_slot
		_update_weapon_hud()
		return

	AudioManager.play_sfx("weapon_fire")
	var weapon_type_id: int = _selected_weapon_type_id()
	var ammo_state := _consume_selected_weapon_ammo()
	_start_selected_weapon_cooldown()
	_apply_selected_weapon_heat()
	var mount_internal_index: int = _selected_weapon_mount_internal_index()
	var effect_path := _spawn_local_weapon_effect(weapon_type_id)
	WSClient.send_message({
		"type": "combat_fire",
		"arenaId": _arena_id,
		"username": _username,
		"weaponSlot": _selected_weapon_slot,
		"sourceAttach": int(effect_path.get("sourceAttach", mount_internal_index)),
		"target": str(effect_path.get("target", _selected_target_username)),
		"targetAttach": int(effect_path.get("targetAttach", -1)),
		"weaponTypeId": weapon_type_id,
		"weaponName": MecParser.weapon_name(weapon_type_id) if weapon_type_id >= 0 else "",
		"weaponDamage": MecParser.weapon_damage(weapon_type_id),
		"weaponHeat": MecParser.weapon_heat(weapon_type_id),
		"weaponCooldownMs": int(round(MecParser.weapon_cooldown_seconds(weapon_type_id) * 1000.0)),
		"weaponLongRangeMeters": MecParser.weapon_long_range_meters(weapon_type_id),
		"weaponMountInternalIndex": mount_internal_index,
		"weaponDamageState": int(_weapon_damage_states[_selected_weapon_slot]) if _selected_weapon_slot < _weapon_damage_states.size() else 0,
		"mountedInternalRemaining": int(_internal_state_values[mount_internal_index]) if mount_internal_index >= 0 and mount_internal_index < _internal_state_values.size() else -1,
		"ammoBin": int(ammo_state.get("ammoBin", -1)),
		"ammoRemaining": int(ammo_state.get("ammoRemaining", 0)),
		"heat": _heat,
		"heatSinks": _heat_sinks,
		"heatShutdown": _heat_shutdown,
		"impactX": effect_path.get("impactX", 0.0),
		"impactY": effect_path.get("impactY", 0.0),
		"impactZ": effect_path.get("impactZ", 0.0),
	})
	_advance_selected_tic(slot)
	_update_weapon_hud()


func _cool_heat(delta: float) -> void:
	if _heat <= 0.0:
		return
	var was_shutdown := _heat_shutdown
	_heat = max(0.0, _heat - (float(_heat_sinks) * delta / HEAT_DISSIPATION_WINDOW))
	if _heat_shutdown and _heat <= _heat_shutdown_clear_threshold():
		_heat_shutdown = false
		_flash_status("Reactor online")
	_update_heat_hud()
	if was_shutdown != _heat_shutdown:
		_update_weapon_hud()


func _try_start_jump() -> void:
	if _jump_jet_count <= 0:
		_flash_status("No jump jets")
		return
	if _heat_shutdown:
		_flash_status("Shutdown cooling")
		return
	if not _local_mech.is_on_floor():
		return
	if _jump_start_timer > 0.0:
		return
	if _jump_flags & 0x3 != 0:
		return
	if _jump_fuel <= JUMP_FUEL_MIN:
		_flash_status("Jump fuel low")
		return

	_jump_fuel = max(0.0, _jump_fuel - JUMP_FUEL_COST)
	_jump_flags |= 0x3
	_jump_start_timer = JUMP_START_THROTTLE
	var impulse: float = 7.0 + min(float(_jump_jet_count), 8.0) * 0.35
	_local_mech.velocity.y = impulse
	_update_jump_hud()
	_send_combat_action(4)


func _complete_jump_landing() -> void:
	_jump_flags = 0
	_update_jump_hud()
	_send_combat_action(6)


func _tick_jump_state(delta: float) -> void:
	if _jump_start_timer > 0.0:
		_jump_start_timer = max(0.0, _jump_start_timer - delta)
	if _local_mech.is_on_floor() and _jump_fuel < JUMP_FUEL_MAX:
		_jump_fuel = min(JUMP_FUEL_MAX, _jump_fuel + JUMP_FUEL_RECHARGE_PER_SEC * delta)
		_update_jump_hud()


func _tick_weapon_cooldowns(delta: float) -> void:
	var hud_changed: bool = false
	for slot in _weapon_cooldown_remaining.size():
		var remaining := float(_weapon_cooldown_remaining[slot])
		if remaining <= 0.0:
			continue
		remaining = max(0.0, remaining - delta)
		_weapon_cooldown_remaining[slot] = remaining
		if slot == _selected_weapon_slot:
			hud_changed = true
	if hud_changed:
		_update_weapon_hud()


func _repoint_weapon_ammo_bins(type_id: int) -> void:
	var replacement: int = _find_ammo_bin_for_type(type_id)
	for slot in _weapon_type_ids.size():
		if int(_weapon_type_ids[slot]) == type_id and slot < _weapon_ammo_bin_indices.size():
			_weapon_ammo_bin_indices[slot] = replacement


func _apply_local_combat_state(actor: Dictionary) -> void:
	_apply_int_array_state(actor, ["internalValues", "internalStateValues", "internalStateBytes"], _internal_state_values)
	_apply_int_array_state(actor, ["weaponStates", "weaponDamageStates"], _weapon_damage_states)
	_apply_int_array_state(actor, ["ammoStateValues", "ammoValues"], _ammo_bin_remaining)
	_update_weapon_hud()


func _apply_int_array_state(actor: Dictionary, keys: Array, target: Array) -> void:
	for key_v in keys:
		var key := str(key_v)
		if not actor.has(key):
			continue
		var values_v: Variant = actor.get(key)
		if typeof(values_v) != TYPE_ARRAY:
			return
		var values := values_v as Array
		var count: int = min(target.size(), values.size())
		for index in count:
			target[index] = int(values[index])
		return


func _apply_damage_code_value(damage_code: int, damage_value: int) -> void:
	if damage_code >= 0x20 and damage_code <= 0x27:
		var internal_index := damage_code - 0x20
		if internal_index >= 0 and internal_index < _internal_state_values.size():
			_internal_state_values[internal_index] = damage_value
			_apply_weapon_loss_for_destroyed_internal(internal_index)
	elif damage_code >= 0x28 and damage_code < 0x28 + _weapon_damage_states.size():
		_weapon_damage_states[damage_code - 0x28] = damage_value
	_update_weapon_hud()


func _apply_weapon_loss_for_destroyed_internal(internal_index: int) -> void:
	if internal_index < 0 or internal_index >= _internal_state_values.size():
		return
	if int(_internal_state_values[internal_index]) > 0:
		return
	for slot in _weapon_mount_internal_indices.size():
		if int(_weapon_mount_internal_indices[slot]) == internal_index and slot < _weapon_damage_states.size():
			_weapon_damage_states[slot] = max(1, int(_weapon_damage_states[slot]))


func _spawn_local_weapon_effect(weapon_type_id: int) -> Dictionary:
	var source_attach: int = _selected_weapon_mount_internal_index()
	var path: Dictionary = _resolve_weapon_effect_path(_local_mech, weapon_type_id, _selected_weapon_slot, source_attach)
	var origin: Vector3 = path.get("origin", _fallback_muzzle_position(_local_mech, _selected_weapon_slot))
	var impact: Vector3 = path.get("impact", origin)
	_spawn_weapon_effect(origin, impact, weapon_type_id)
	return {
		"sourceAttach": int(path.get("sourceAttach", source_attach)),
		"target": str(path.get("target", "")),
		"targetAttach": int(path.get("targetAttach", -1)),
		"impactX": impact.x,
		"impactY": impact.y,
		"impactZ": impact.z,
	}


func _spawn_hit_event_effect(data: Dictionary) -> void:
	var attacker := str(data.get("source", data.get("attacker", "")))
	var target := str(data.get("target", ""))
	var weapon_type_id := int(data.get("weaponTypeId", data.get("weaponType", 7)))
	var attacker_node := _actor_node_for_username(attacker)
	var target_node := _actor_node_for_username(target)
	if attacker_node == null or target_node == null:
		return

	var weapon_slot: int = int(data.get("weaponSlot", 0))
	var source_attach_hint: Variant = data.get("sourceAttach", data.get("weaponMountInternalIndex", -1))
	var origin: Vector3 = _muzzle_position(attacker_node, weapon_slot, source_attach_hint)
	var impact: Vector3 = _effect_impact_position(target_node, data, origin)
	_spawn_weapon_effect(origin, impact, weapon_type_id)


func _actor_node_for_username(username: String) -> Node3D:
	if username == _username:
		return _local_mech
	if _remote_nodes.has(username):
		var node_v: Variant = _remote_nodes[username]
		if node_v is Node3D:
			return node_v as Node3D
	return null


func _resolve_weapon_effect_path(source: Node3D, weapon_type_id: int, weapon_slot: int, source_attach_hint: Variant = -1) -> Dictionary:
	var source_attach: int = _attachment_hint_to_internal_index(source_attach_hint)
	var origin: Vector3 = _muzzle_position(source, weapon_slot, source_attach)
	var source_anchor: Node3D = _effect_anchor_node(source)
	var forward: Vector3 = -source_anchor.global_transform.basis.z.normalized()
	var max_range: float = float(MecParser.weapon_long_range_meters(weapon_type_id))
	if max_range <= 0.0:
		max_range = DEFAULT_EFFECT_RANGE

	var best_pos: Vector3 = origin + forward * min(max_range, DEFAULT_EFFECT_RANGE)
	var best_dist: float = INF
	var best_target: String = ""
	var best_target_attach: int = -1
	if not _selected_target_username.is_empty() and _remote_nodes.has(_selected_target_username):
		var selected_v: Variant = _remote_nodes.get(_selected_target_username)
		if selected_v is Node3D:
			var selected_node := selected_v as Node3D
			var selected_attach := _best_target_attach_for_node(selected_node, origin)
			var selected_pos := _attachment_world_position(selected_node, selected_attach, -1, true)
			var to_selected := selected_pos - origin
			var selected_dist := to_selected.length()
			if selected_dist > 0.01 and selected_dist <= max_range:
				var selected_dot := forward.dot(to_selected / selected_dist)
				if selected_dot >= FIRE_BEARING_COS:
					best_dist = selected_dist
					best_pos = selected_pos
					best_target = _selected_target_username
					best_target_attach = selected_attach
	for uname_v in _remote_nodes.keys():
		var uname: String = str(uname_v)
		var remote_v: Variant = _remote_nodes[uname]
		if not (remote_v is Node3D):
			continue
		var node := remote_v as Node3D
		var target_attach: int = _best_target_attach_for_node(node, origin)
		var target_pos: Vector3 = _attachment_world_position(node, target_attach, -1, true)
		var to_target: Vector3 = target_pos - origin
		var dist: float = to_target.length()
		if dist <= 0.01 or dist > max_range:
			continue
		var dot: float = forward.dot(to_target / dist)
		if dot < FIRE_BEARING_COS:
			continue
		if dist < best_dist:
			best_dist = dist
			best_pos = target_pos
			best_target = uname
			best_target_attach = target_attach
	return {
		"origin": origin,
		"impact": best_pos,
		"sourceAttach": source_attach,
		"target": best_target,
		"targetAttach": best_target_attach,
	}


func _muzzle_position(source: Node3D, weapon_slot: int, attach_hint: Variant = -1) -> Vector3:
	var attach_index: int = _attachment_hint_to_internal_index(attach_hint)
	if attach_index < 0 and source == _local_mech:
		if weapon_slot == _selected_weapon_slot:
			attach_index = _selected_weapon_mount_internal_index()
	if attach_index >= 0:
		return _attachment_world_position(source, attach_index, weapon_slot, false)
	return _fallback_muzzle_position(source, weapon_slot)


func _fallback_muzzle_position(source: Node3D, weapon_slot: int) -> Vector3:
	var anchor: Node3D = _effect_anchor_node(source)
	var side: float = -0.55 if weapon_slot % 2 == 0 else 0.55
	var height: float = 1.05 + float(weapon_slot % 3) * 0.18
	return anchor.to_global(Vector3(side, height, -1.0))


func _effect_anchor_node(actor_node: Node3D) -> Node3D:
	if actor_node == _local_mech:
		return _local_mech_mesh
	var mesh_pivot := actor_node.get_node_or_null("MeshPivot")
	if mesh_pivot is Node3D:
		return mesh_pivot as Node3D
	return actor_node


func _attachment_world_position(actor_node: Node3D, attach_hint: Variant, weapon_slot: int = -1, for_impact: bool = false) -> Vector3:
	var attach_index: int = _attachment_hint_to_internal_index(attach_hint)
	if attach_index < 0:
		if for_impact:
			return actor_node.global_position + Vector3(0, 1.4, 0)
		return _fallback_muzzle_position(actor_node, weapon_slot)
	var anchor: Node3D = _effect_anchor_node(actor_node)
	var offset: Vector3 = _attachment_local_offset(attach_index, for_impact)
	return anchor.to_global(offset)


func _attachment_local_offset(attach_index: int, for_impact: bool = false) -> Vector3:
	var torso_z: float = 0.12 if for_impact else 0.48
	var arm_z: float = 0.18 if for_impact else 0.42
	var side_torso_z: float = 0.1 if for_impact else 0.34
	match attach_index:
		0:
			return Vector3(-0.9, 1.18, arm_z)
		1:
			return Vector3(0.9, 1.18, arm_z)
		2:
			return Vector3(-0.48, 1.34, side_torso_z)
		3:
			return Vector3(0.48, 1.34, side_torso_z)
		4:
			return Vector3(0.0, 1.42, torso_z)
		5:
			return Vector3(-0.36, 0.42, 0.06)
		6:
			return Vector3(0.36, 0.42, 0.06)
		7:
			return Vector3(0.0, 2.04, 0.04)
		_:
			return Vector3(0.0, 1.4, 0.12)


func _attachment_hint_to_internal_index(attach_hint: Variant) -> int:
	match typeof(attach_hint):
		TYPE_INT, TYPE_FLOAT:
			var raw: int = int(attach_hint)
			if raw >= 0x20 and raw <= 0x27:
				return raw - 0x20
			if raw >= 0 and raw < INTERNAL_SECTION_LABELS.size():
				return raw
		TYPE_STRING:
			var text := str(attach_hint).to_lower().strip_edges().replace("-", "_").replace(" ", "_")
			match text:
				"la", "left_arm", "larm":
					return 0
				"ra", "right_arm", "rarm":
					return 1
				"lt", "left_torso", "ltorso":
					return 2
				"rt", "right_torso", "rtorso":
					return 3
				"ct", "center_torso", "centre_torso", "torso", "core":
					return 4
				"ll", "left_leg", "lleg":
					return 5
				"rl", "right_leg", "rleg":
					return 6
				"hd", "head", "cockpit":
					return 7
	return -1


func _best_target_attach_for_node(target_node: Node3D, source_position: Vector3) -> int:
	var anchor: Node3D = _effect_anchor_node(target_node)
	var local_source: Vector3 = anchor.to_local(source_position)
	if local_source.y > 1.8:
		return 7
	if local_source.y < 0.75:
		return 5 if local_source.x < 0.0 else 6
	if absf(local_source.x) > 0.75:
		return 0 if local_source.x < 0.0 else 1
	if local_source.x < -0.24:
		return 2
	if local_source.x > 0.24:
		return 3
	return 4


func _impact_attach_hint(data: Dictionary) -> Variant:
	if data.has("targetAttach"):
		return data.get("targetAttach")
	if data.has("impactAttach"):
		return data.get("impactAttach")
	if data.has("damageCode"):
		return data.get("damageCode")
	return -1


func _effect_impact_position(target_node: Node3D, data: Dictionary, source_position: Vector3) -> Vector3:
	if data.has("impactX") and data.has("impactZ"):
		var fallback_y: float = target_node.global_position.y + 1.4
		return Vector3(
			float(data.get("impactX")),
			float(data.get("impactY", fallback_y)),
			float(data.get("impactZ"))
		)
	var attach_hint: Variant = _impact_attach_hint(data)
	if _attachment_hint_to_internal_index(attach_hint) < 0:
		attach_hint = _best_target_attach_for_node(target_node, source_position)
	return _attachment_world_position(target_node, attach_hint, -1, true)


func _impact_section_label(data: Dictionary) -> String:
	var attach_index: int = _attachment_hint_to_internal_index(_impact_attach_hint(data))
	if attach_index < 0 or attach_index >= INTERNAL_SECTION_LABELS.size():
		return ""
	return str(INTERNAL_SECTION_LABELS[attach_index])


func _spawn_weapon_effect(origin: Vector3, impact: Vector3, weapon_type_id: int) -> void:
	if _is_missile_weapon(weapon_type_id):
		_spawn_missile_volley(origin, impact, weapon_type_id)
	elif _is_energy_weapon(weapon_type_id):
		_spawn_beam_effect(origin, impact, _weapon_effect_color(weapon_type_id), _beam_width_for_weapon(weapon_type_id), 0.16)
	else:
		_spawn_projectile_effect(origin, impact, _weapon_effect_color(weapon_type_id), _projectile_size_for_weapon(weapon_type_id), 0.22)


func _spawn_beam_effect(origin: Vector3, impact: Vector3, color: Color, width: float, lifetime: float) -> void:
	var beam: MeshInstance3D = MeshInstance3D.new()
	var mesh: BoxMesh = BoxMesh.new()
	var distance: float = origin.distance_to(impact)
	mesh.size = Vector3(width, width, max(0.1, distance))
	beam.mesh = mesh
	beam.material_override = _effect_material(color)
	beam.global_position = origin.lerp(impact, 0.5)
	beam.look_at(impact, Vector3.UP)
	_effects.add_child(beam)
	_spawn_impact_flash(impact, color, width * 4.0, lifetime * 1.4)
	_fade_and_free(beam, lifetime)


func _spawn_projectile_effect(origin: Vector3, impact: Vector3, color: Color, radius: float, travel_time: float) -> void:
	var projectile: MeshInstance3D = MeshInstance3D.new()
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	projectile.mesh = mesh
	projectile.material_override = _effect_material(color)
	projectile.global_position = origin
	_effects.add_child(projectile)

	var tween: Tween = create_tween()
	tween.tween_property(projectile, "global_position", impact, travel_time)
	tween.tween_callback(func() -> void:
		_spawn_impact_flash(impact, color, radius * 5.0, 0.18)
		if is_instance_valid(projectile):
			projectile.queue_free()
	)


func _spawn_missile_volley(origin: Vector3, impact: Vector3, weapon_type_id: int) -> void:
	var count: int = _missile_count_for_weapon(weapon_type_id)
	for index in count:
		var offset: Vector3 = Vector3(
			float((index % 3) - 1) * 0.45,
			float(index % 2) * 0.28,
			float(index / 3) * 0.12
		)
		var target_offset: Vector3 = Vector3(
			float((index % 5) - 2) * 0.35,
			float(index % 3) * 0.18,
			float((index % 4) - 1) * 0.25
		)
		_spawn_projectile_effect(origin + offset, impact + target_offset, _weapon_effect_color(weapon_type_id), 0.09, 0.28 + float(index % 4) * 0.025)


func _spawn_impact_flash(position: Vector3, color: Color, radius: float, lifetime: float) -> void:
	var flash: MeshInstance3D = MeshInstance3D.new()
	var mesh: SphereMesh = SphereMesh.new()
	mesh.radius = max(0.08, radius)
	mesh.height = max(0.16, radius * 2.0)
	flash.mesh = mesh
	flash.material_override = _effect_material(Color(color.r, color.g, color.b, 0.75))
	flash.global_position = position
	_effects.add_child(flash)
	_fade_and_free(flash, lifetime)


func _fade_and_free(node: Node3D, lifetime: float) -> void:
	var tween: Tween = create_tween()
	tween.tween_interval(lifetime)
	tween.tween_callback(func() -> void:
		if is_instance_valid(node):
			node.queue_free()
	)


func _effect_material(color: Color) -> StandardMaterial3D:
	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.emission_enabled = true
	mat.emission = color
	mat.emission_energy_multiplier = 2.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return mat


func _is_energy_weapon(type_id: int) -> bool:
	return type_id == 0 or (type_id >= 2 and type_id <= 5)


func _is_missile_weapon(type_id: int) -> bool:
	return type_id >= 10 and type_id <= 16


func _missile_count_for_weapon(type_id: int) -> int:
	match type_id:
		10:
			return 2
		11:
			return 4
		12:
			return 6
		13:
			return 5
		14:
			return 10
		15:
			return 15
		16:
			return 20
		_:
			return 1


func _beam_width_for_weapon(type_id: int) -> float:
	match type_id:
		0, 2:
			return 0.05
		3:
			return 0.07
		4:
			return 0.1
		5:
			return 0.14
		_:
			return 0.08


func _projectile_size_for_weapon(type_id: int) -> float:
	match type_id:
		1:
			return 0.06
		6, 7:
			return 0.08
		8:
			return 0.12
		9:
			return 0.18
		_:
			return 0.08


func _weapon_effect_color(type_id: int) -> Color:
	match type_id:
		0:
			return Color(1.0, 0.35, 0.08, 0.8)
		2, 3:
			return Color(1.0, 0.1, 0.05, 0.85)
		4:
			return Color(0.15, 0.8, 1.0, 0.85)
		5:
			return Color(0.65, 0.35, 1.0, 0.85)
		1, 6, 7, 8, 9:
			return Color(1.0, 0.85, 0.25, 0.9)
		_:
			return Color(1.0, 0.45, 0.12, 0.85)


func _cycle_radar_range() -> void:
	_step_radar_range(1)


func _step_radar_range(delta: int) -> void:
	_radar_range_index = (_radar_range_index + delta + RADAR_RANGES.size()) % RADAR_RANGES.size()
	_flash_status("Radar %dm" % _current_radar_range())
	_update_target_hud()


func _current_radar_range() -> int:
	return int(RADAR_RANGES[_radar_range_index])


func _update_target_hud() -> void:
	var actors := _radar_actor_entries()
	_radar.set_state(_local_mech.global_position, _local_mech.rotation.y, actors, _current_radar_range())

	var target := _current_target_actor(actors)
	if target.is_empty():
		_selected_target_username = ""
		_target_name.text = "NO TARGET"
		_target_range.text = "RNG --"
		_target_status.text = "RADAR %dm" % _current_radar_range()
		_target_status.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
		_update_readout_panel({})
		return

	var target_name := str(target.get("username", "TARGET"))
	var distance := float(target.get("distance", 0.0))
	var bearing := float(target.get("bearing", 0.0))
	var health := int(target.get("health", -1))
	var posture_state := int(target.get("posture", POSTURE_NORMAL))
	_target_name.text = target_name
	_target_range.text = "RNG %dm  BRG %+d" % [int(round(distance)), int(round(rad_to_deg(bearing)))]
	var status := _target_range_band(distance)
	if posture_state != POSTURE_NORMAL:
		status = "%s  %s" % [status, _posture_tag(posture_state)]
	if health >= 0:
		status = "%s  HP %d" % [status, health]
	if target_name == _selected_target_username:
		status = "%s  LOCK" % status
	_target_status.text = status
	var status_color := _posture_color(posture_state)
	if posture_state == POSTURE_NORMAL:
		status_color = Color(1.0, 0.35, 0.2) if status.begins_with("OUT") else Color(0.35, 1.0, 0.45)
	_target_status.add_theme_color_override("font_color", status_color)
	_update_readout_panel(target)


func _radar_actor_entries() -> Array:
	var actors: Array = []
	for uname in _remote_nodes.keys():
		if not _remote_nodes.has(uname):
			continue
		var node_v: Variant = _remote_nodes[uname]
		if not (node_v is Node3D):
			continue
		var node := node_v as Node3D
		var info: Dictionary = _remote_actor_info.get(uname, {})
		actors.append({
			"username": str(uname),
			"position": node.global_position,
			"heading": node.rotation.y,
			"health": int(info.get("health", -1)),
			"posture": _actor_posture_state(info, int(info.get("health", 100))),
		})
	return actors


func _nearest_radar_actor(actors: Array) -> Dictionary:
	var best: Dictionary = {}
	var best_dist := INF
	var forward := -_local_mech.global_transform.basis.z.normalized()
	for actor_v in actors:
		if typeof(actor_v) != TYPE_DICTIONARY:
			continue
		var actor := actor_v as Dictionary
		var pos: Vector3 = actor.get("position", Vector3.ZERO)
		var delta := pos - _local_mech.global_position
		var flat := Vector2(delta.x, delta.z)
		var distance := flat.length()
		if distance <= 0.01 or distance > float(_current_radar_range()):
			continue
		if distance < best_dist:
			var heading_vec := Vector2(forward.x, forward.z).normalized()
			var target_vec := flat.normalized()
			var bearing := atan2(
				heading_vec.x * target_vec.y - heading_vec.y * target_vec.x,
				heading_vec.dot(target_vec)
			)
			best_dist = distance
			best = actor.duplicate()
			best["distance"] = distance
			best["bearing"] = bearing
	return best


func _current_target_actor(actors: Array) -> Dictionary:
	if not _selected_target_username.is_empty():
		var found_selected := false
		for actor_v in actors:
			if typeof(actor_v) != TYPE_DICTIONARY:
				continue
			var actor := actor_v as Dictionary
			if str(actor.get("username", "")) != _selected_target_username:
				continue
			found_selected = true
			var pos: Vector3 = actor.get("position", Vector3.ZERO)
			var delta := pos - _local_mech.global_position
			var flat := Vector2(delta.x, delta.z)
			var distance := flat.length()
			if distance > float(_current_radar_range()) or distance <= 0.01:
				break
			var forward := -_local_mech.global_transform.basis.z.normalized()
			var heading_vec := Vector2(forward.x, forward.z).normalized()
			var target_vec := flat.normalized()
			var bearing := atan2(
				heading_vec.x * target_vec.y - heading_vec.y * target_vec.x,
				heading_vec.dot(target_vec)
			)
			var selected := actor.duplicate()
			selected["distance"] = distance
			selected["bearing"] = bearing
			return selected
		if not found_selected:
			_selected_target_username = ""
	return _nearest_radar_actor(actors)


func _cycle_target() -> void:
	var actors := _radar_actor_entries()
	if actors.is_empty():
		_selected_target_username = ""
		_flash_status("No targets")
		_update_target_hud()
		return
	var visible: Array = []
	for actor_v in actors:
		if typeof(actor_v) != TYPE_DICTIONARY:
			continue
		var actor := actor_v as Dictionary
		var pos: Vector3 = actor.get("position", Vector3.ZERO)
		var distance := Vector2(pos.x - _local_mech.global_position.x, pos.z - _local_mech.global_position.z).length()
		if distance <= float(_current_radar_range()):
			var entry := actor.duplicate()
			entry["distance"] = distance
			visible.append(entry)
	if visible.is_empty():
		_selected_target_username = ""
		_flash_status("No targets in range")
		_update_target_hud()
		return
	visible.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("distance", INF)) < float(b.get("distance", INF))
	)
	var current_index := -1
	for index in visible.size():
		if str((visible[index] as Dictionary).get("username", "")) == _selected_target_username:
			current_index = index
			break
	var next_target := visible[(current_index + 1) % visible.size()] as Dictionary
	_selected_target_username = str(next_target.get("username", ""))
	_flash_status("Target %s" % _selected_target_username)
	_update_target_hud()


func _target_range_band(distance: float) -> String:
	var type_id := _selected_weapon_type_id()
	var long_range := float(MecParser.weapon_long_range_meters(type_id))
	if long_range <= 0.0:
		return "RADAR %dm" % _current_radar_range()
	if distance <= long_range / 3.0:
		return "SHORT"
	if distance <= long_range * 2.0 / 3.0:
		return "MED"
	if distance <= long_range:
		return "LONG"
	return "OUT RNG"


func _update_readout_panel(target: Dictionary) -> void:
	match _readout_mode:
		READOUT_TARGET_DETAIL:
			_readout_title.text = "TARGET DETAIL"
			_readout_body.text = _target_readout_text(target, true)
		READOUT_SELF_DETAIL:
			_readout_title.text = "SELF DETAIL"
			_readout_body.text = _self_readout_text()
		_:
			_readout_title.text = "TARGET BRIEF"
			_readout_body.text = _target_readout_text(target, false)


func _target_readout_text(target: Dictionary, detailed: bool) -> String:
	if target.is_empty():
		return "No target"
	var target_name := str(target.get("username", "TARGET"))
	var posture_state := int(target.get("posture", POSTURE_NORMAL))
	var health := int(target.get("health", -1))
	var distance := int(round(float(target.get("distance", 0.0))))
	var lines := [
		"ID %s" % target_name,
		"RANGE %dm" % distance,
		"STATE %s" % _posture_tag(posture_state),
	]
	if health >= 0:
		lines.append("HEALTH %d%%" % health)
	if detailed:
		var actor_info: Dictionary = _remote_actor_info.get(target_name, {})
		lines.append("CLASS %s" % str(actor_info.get("typeString", "?")))
		lines.append("BEARING %+d" % int(round(rad_to_deg(float(target.get("bearing", 0.0))))))
		lines.append("WINDOW %s" % _target_range_band(float(target.get("distance", 0.0))))
	return "\n".join(lines)


func _self_readout_text() -> String:
	return "\n".join([
		"MECH %s" % _mech_type,
		"HP %d%%" % _health,
		"HEAT %d/%d" % [int(round(_heat)), int(round(_heat_capacity))],
		"THROTTLE %+d%%" % _throttle_pct,
		"POSTURE %s" % _posture_tag(_local_posture_state),
		"TIC %s" % (_tic_label(_selected_tic_index) if _selected_tic_index >= 0 else "-"),
	])


func _flash_status(text: String) -> void:
	_status_label.text = text
	_status_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	_status_timer = 1.2


func _open_combat_chat(mode: String) -> void:
	_combat_chat_mode = mode
	_jump_pending = false
	_fire_pending = false
	_queued_fire_slots.clear()
	_chat_title.text = "TEAM CHAT" if mode == COMBAT_CHAT_TEAM else "ALL CHAT"
	_chat_hint.text = "Combat chat is not supported by the current server yet."
	_chat_status.text = "Type a draft if needed; Enter will show the server limitation."
	_chat_panel.visible = true
	_chat_input.grab_focus()
	_chat_input.caret_column = _chat_input.text.length()
	if not _is_mobile and not _ended:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _close_combat_chat() -> void:
	_chat_panel.visible = false
	_chat_status.text = "Enter drafts only; Esc closes."
	_chat_input.release_focus()
	if not _is_mobile and not _ended:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _submit_combat_chat() -> void:
	var scope := "Team chat" if _combat_chat_mode == COMBAT_CHAT_TEAM else "All-chat"
	_chat_status.text = "%s cannot be sent because the current server does not support combat chat yet." % scope
	_flash_status("Combat chat is not supported by the current server yet")


func _on_chat_text_submitted(_text: String) -> void:
	_submit_combat_chat()


# ─── Input ─────────────────────────────────────────────────────────────────────

func _unhandled_input(event: InputEvent) -> void:
	if _ended:
		if event.is_action_pressed("ui_cancel"):
			get_tree().change_scene_to_file(MAIN_SCENE)
		return

	if _chat_panel.visible:
		if event.is_action_pressed("ui_cancel"):
			_close_combat_chat()
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_chat"):
			_open_combat_chat(COMBAT_CHAT_ALL)
			get_viewport().set_input_as_handled()
			return
		if event.is_action_pressed("ui_team_chat"):
			_open_combat_chat(COMBAT_CHAT_TEAM)
			get_viewport().set_input_as_handled()
			return
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

		if event is InputEventMouseButton:
			var mouse_button := event as InputEventMouseButton
			if mouse_button.pressed and mouse_button.button_index == MOUSE_BUTTON_WHEEL_UP:
				_cycle_weapon(-1)
			elif mouse_button.pressed and mouse_button.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_cycle_weapon(1)

		if event is InputEventKey:
			var key := event as InputEventKey
			if key.pressed and not key.echo and key.physical_keycode >= KEY_1 and key.physical_keycode <= KEY_9:
				_select_weapon_slot(int(key.physical_keycode - KEY_1))

		if event.is_action_pressed("fire"):
			_queue_fire_slot(_selected_weapon_slot)

		if event.is_action_pressed("jump_jet"):
			_jump_pending = true

		if event.is_action_pressed("ui_chat"):
			_open_combat_chat(COMBAT_CHAT_ALL)
			return

		if event.is_action_pressed("ui_team_chat"):
			_open_combat_chat(COMBAT_CHAT_TEAM)
			return

		if event.is_action_pressed("stop_movement"):
			_throttle_pct = 0
			_flash_status("Throttle 0%")

		if event.is_action_pressed("stand_up") and _local_posture_state == POSTURE_DOWNED:
			_send_combat_action(0)
			_flash_status("Stand up")

		if event.is_action_pressed("target_cycle"):
			_cycle_target()

		if event.is_action_pressed("hud_target_detail"):
			_readout_mode = READOUT_TARGET_DETAIL
			_update_target_hud()

		if event.is_action_pressed("hud_target_brief"):
			_readout_mode = READOUT_TARGET_BRIEF
			_update_target_hud()

		if event.is_action_pressed("hud_self_detail"):
			_readout_mode = READOUT_SELF_DETAIL
			_update_target_hud()

		if event.is_action_pressed("radar_range"):
			_cycle_radar_range()
		if event.is_action_pressed("radar_zoom_in"):
			_step_radar_range(-1)
		if event.is_action_pressed("radar_zoom_out"):
			_step_radar_range(1)
		if event.is_action_pressed("weapon_prev"):
			_cycle_weapon(-1)
		if event.is_action_pressed("weapon_next"):
			_cycle_weapon(1)
		if event.is_action_pressed("tic_cycle_current"):
			_cycle_current_tic()
		if event.is_action_pressed("tic_select_a"):
			_set_selected_tic(0)
		if event.is_action_pressed("tic_select_b"):
			_set_selected_tic(1)
		if event.is_action_pressed("tic_select_c"):
			_set_selected_tic(2)
		if event.is_action_pressed("tic_toggle_a"):
			_toggle_selected_weapon_on_tic(0)
		if event.is_action_pressed("tic_toggle_b"):
			_toggle_selected_weapon_on_tic(1)
		if event.is_action_pressed("tic_toggle_c"):
			_toggle_selected_weapon_on_tic(2)
		if event.is_action_pressed("tic_fire_a"):
			_queue_tic_fire(0)
		if event.is_action_pressed("tic_fire_b"):
			_queue_tic_fire(1)
		if event.is_action_pressed("tic_fire_c"):
			_queue_tic_fire(2)


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
	var chat_active := _chat_panel.visible
	var throttle_axis := 0.0 if chat_active else Input.get_axis("move_backward", "move_forward")
	var turn_axis := 0.0 if chat_active else Input.get_axis("turn_left", "turn_right")
	if not chat_active:
		turn_axis += Input.get_axis("move_left", "move_right")

	if _touch_overlay != null and not chat_active:
		var tv: Vector2 = _touch_overlay.move_value
		throttle_axis = clamp(throttle_axis + tv.y, -1.0, 1.0)
		turn_axis = clamp(turn_axis + tv.x, -1.0, 1.0)
		var ld: Vector2 = _touch_overlay.get_look_delta()
		_local_mech.rotation.y -= ld.x * MOUSE_SENSITIVITY
		_pitch = clamp(_pitch - ld.y * MOUSE_SENSITIVITY, PITCH_MIN, PITCH_MAX)
		_camera_pivot.rotation.x = _pitch
		if _touch_overlay.fire_pressed:
			_touch_overlay.fire_pressed = false
			_queue_fire_slot(_selected_weapon_slot)
		if _touch_overlay.jump_pressed:
			_touch_overlay.jump_pressed = false
			_jump_pending = true

	if absf(throttle_axis) > 0.2:
		_throttle_pct = int(clamp(_throttle_pct + int(sign(throttle_axis)) * THROTTLE_STEP_PCT, -100, 100))
	if absf(turn_axis) > 0.05:
		_local_mech.rotation.y += turn_axis * TURN_RATE * delta

	if not _local_mech.is_on_floor():
		_local_mech.velocity.y -= GRAVITY * delta
	else:
		if _jump_flags != 0:
			_complete_jump_landing()
		_local_mech.velocity.y = 0.0

	if _jump_pending and not chat_active:
		_jump_pending = false
		_try_start_jump()

	var throttle_ratio := clamp(float(_throttle_pct) / 100.0, -1.0, 1.0)
	var target_velocity := forward * (_mech_speed_ms * throttle_ratio)
	_local_mech.velocity.x = lerpf(_local_mech.velocity.x, target_velocity.x, clamp(delta * THROTTLE_LERP_RATE, 0.0, 1.0))
	_local_mech.velocity.z = lerpf(_local_mech.velocity.z, target_velocity.z, clamp(delta * THROTTLE_LERP_RATE, 0.0, 1.0))
	_local_mech.move_and_slide()
	_tick_weapon_cooldowns(delta)
	_cool_heat(delta)
	_tick_jump_state(delta)
	if not chat_active:
		_process_fire_queue()
	_update_posture_hud()
	_apply_local_mech_visuals(delta)
	_update_speed_hud()
	_update_target_hud()
	_update_remote_actors(delta)

	# --- Network input (10 Hz) ---
	_input_timer += delta
	if _input_timer >= INPUT_INTERVAL:
		_input_timer = 0.0
		_send_combat_input()

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


func _send_combat_action(action: int) -> void:
	WSClient.send_message({
		"type": "combat_action",
		"arenaId": _arena_id,
		"username": _username,
		"action": action,
		"jumpJetCount": _jump_jet_count,
		"jumpFuel": _jump_fuel,
		"jumpFlags": _jump_flags,
	})


func _send_combat_input() -> void:
	WSClient.send_message({
		"type": "combat_input",
		"arenaId": _arena_id,
		"username": _username,
		"x": _local_mech.position.x,
		"z": _local_mech.position.z,
		"heading": _local_mech.rotation.y,
		"mechId": _mech_id,
		"typeString": _mech_type,
		"speedMag": _mech_max_speed_mag,
		"heat": _heat,
		"heatSinks": _heat_sinks,
		"heatShutdown": _heat_shutdown,
		"jumpJetCount": _jump_jet_count,
		"jumpFuel": _jump_fuel,
		"jumpFlags": _jump_flags,
		"airborne": not _local_mech.is_on_floor(),
		"throttlePct": _throttle_pct,
		"selectedTarget": _selected_target_username,
		"selectedTic": _selected_tic_index,
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
			_local_actor_info = actor.duplicate()
			_health = int(actor.get("health", _health))
			if actor.has("retailHeat"):
				_heat = float(actor.get("retailHeat", _heat))
			elif actor.has("heat") and float(actor.get("heat", 0.0)) > _heat:
				_heat = min(_heat_capacity, float(actor.get("heat", _heat)))
			if actor.has("heatShutdown"):
				_heat_shutdown = bool(actor.get("heatShutdown", _heat_shutdown))
			if actor.has("throttlePct"):
				_throttle_pct = int(actor.get("throttlePct", _throttle_pct))
			_health_bar.value = float(_health)
			_update_heat_hud()
			_apply_local_combat_state(actor)
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
	var posture_state := _actor_posture_state(actor, int(actor.get("health", 100)))
	_remote_actor_info[uname] = actor.duplicate()

	if not _remote_nodes.has(uname):
		var node := _create_remote_mech_node(uname, is_bot, type_str)
		_remote_mechs.add_child(node)
		_remote_nodes[uname] = node
		node.position = Vector3(x, 1.6, z)
		node.rotation.y = heading

	var remote: Node3D = _remote_nodes[uname]
	_refresh_remote_name_tag(remote, uname, type_str, posture_state, is_bot)
	_remote_targets[uname] = {
		"position": Vector3(x, 1.6, z),
		"heading": heading,
		"posture": posture_state,
	}


func _update_remote_actors(delta: float) -> void:
	var weight: float = clamp(delta * 10.0, 0.0, 1.0)
	for uname in _remote_targets.keys():
		if not _remote_nodes.has(uname):
			continue
		var remote: Node3D = _remote_nodes[uname]
		var target: Dictionary = _remote_targets[uname]
		var target_pos: Vector3 = target.get("position", remote.position)
		var target_heading := float(target.get("heading", remote.rotation.y))
		var posture_state := int(target.get("posture", POSTURE_NORMAL))
		remote.position = remote.position.lerp(target_pos, weight)
		remote.rotation.y = lerp_angle(remote.rotation.y, target_heading, weight)
		_apply_remote_mech_visuals(remote, posture_state, delta)


func _create_remote_mech_node(uname: String, is_bot: bool, type_str: String) -> Node3D:
	var root := Node3D.new()
	root.name = "Remote_" + uname

	var mesh_pivot := Node3D.new()
	mesh_pivot.name = "MeshPivot"
	root.add_child(mesh_pivot)

	var mesh_inst := MeshInstance3D.new()
	mesh_inst.name = "MechMesh"
	var box := BoxMesh.new()
	box.size = Vector3(1.8, 3.2, 1.2)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.75, 0.18, 0.12) if is_bot else Color(0.2, 0.3, 0.8)
	mat.roughness = 0.7
	mat.metallic = 0.2
	mesh_inst.mesh = box
	mesh_inst.set_surface_override_material(0, mat)
	mesh_pivot.add_child(mesh_inst)

	var label := Label3D.new()
	label.name = "NameTag"
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
	var attacker := str(data.get("source", data.get("attacker", "")))
	var damage := int(data.get("damage", 0))
	var health := int(data.get("health", 0))
	var section_label: String = _impact_section_label(data)

	if target == _username:
		_apply_damage_updates_from_event(data)
		_spawn_hit_event_effect(data)
		_health = health
		_health_bar.value = float(_health)
		AudioManager.play_sfx("weapon_hit")
		var hit_text := "⚠ HIT"
		if not section_label.is_empty():
			hit_text = "%s %s" % [hit_text, section_label]
		_status_label.text = "%s by %s  -%d dmg  HP: %d" % [hit_text, attacker, damage, _health]
		_status_label.add_theme_color_override("font_color", Color(1.0, 0.25, 0.15))
		_status_timer = 2.5
	elif attacker == _username:
		if not data.has("impactX"):
			var target_node := _actor_node_for_username(target)
			if target_node != null:
				var origin: Vector3 = _muzzle_position(_local_mech, int(data.get("weaponSlot", _selected_weapon_slot)), data.get("sourceAttach", _selected_weapon_mount_internal_index()))
				var impact: Vector3 = _effect_impact_position(target_node, data, origin)
				_spawn_impact_flash(impact, Color(1.0, 0.7, 0.2, 0.8), 0.35, 0.2)
		AudioManager.play_sfx("weapon_hit")
		var attack_text := "✓ HIT %s" % target
		if not section_label.is_empty():
			attack_text = "%s %s" % [attack_text, section_label]
		_status_label.text = "%s  -%d  HP: %d" % [attack_text, damage, health]
		_status_label.add_theme_color_override("font_color", Color(0.25, 1.0, 0.3))
		_status_timer = 1.5


func _apply_damage_updates_from_event(data: Dictionary) -> void:
	if data.has("damageCode") and data.has("damageValue"):
		_apply_damage_code_value(int(data.get("damageCode")), int(data.get("damageValue")))
	if not data.has("damageUpdates"):
		return
	var updates_v: Variant = data.get("damageUpdates")
	if typeof(updates_v) != TYPE_ARRAY:
		return
	for update_v in updates_v as Array:
		if typeof(update_v) != TYPE_DICTIONARY:
			continue
		var update := update_v as Dictionary
		if update.has("damageCode") and update.has("damageValue"):
			_apply_damage_code_value(int(update.get("damageCode")), int(update.get("damageValue")))


func _on_combat_end(data: Dictionary) -> void:
	if data.get("arenaId", "") != _arena_id:
		return
	if _ended:
		return
	_ended = true
	_exit_timer = 4.0

	_close_combat_chat()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var winner := str(data.get("winner", ""))
	var loser := str(data.get("loser", ""))
	var local_won := (winner == _username)
	AudioManager.play_sfx("victory" if local_won else "defeat")

	_result_title.text = "VICTORY" if local_won else "DEFEAT"
	_result_title.add_theme_color_override(
		"font_color",
		Color(0.2, 1.0, 0.3) if local_won else Color(1.0, 0.2, 0.15),
	)
	_result_desc.text = "%s destroyed!" % loser if local_won else "Destroyed by %s." % winner
	_result_overlay.visible = true
	_status_label.text = ""
