class_name CombatRadar
extends Control

const RING_COLOR := Color(0.15, 0.75, 0.35, 0.45)
const BLIP_COLOR := Color(1.0, 0.25, 0.15, 0.95)
const SELF_COLOR := Color(0.35, 1.0, 0.45, 0.95)
const HEADING_COLOR := Color(0.6, 1.0, 0.7, 0.8)
const AIRBORNE_COLOR := Color(0.95, 0.85, 0.2, 0.95)
const DOWNED_COLOR := Color(1.0, 0.55, 0.18, 0.95)
const CRIPPLED_COLOR := Color(1.0, 0.22, 0.16, 0.95)

const POSTURE_NORMAL := 0
const POSTURE_AIRBORNE := 1
const POSTURE_DOWNED := 2
const POSTURE_CRIPPLED := 3

var _local_position := Vector3.ZERO
var _local_heading := 0.0
var _actors: Array = []
var _range_meters := 300


func set_state(local_position: Vector3, local_heading: float, actors: Array, range_meters: int) -> void:
	_local_position = local_position
	_local_heading = local_heading
	_actors = actors
	_range_meters = max(1, range_meters)
	queue_redraw()


func _draw() -> void:
	var center: Vector2 = size * 0.5
	var radius: float = min(size.x, size.y) * 0.46
	draw_arc(center, radius, 0.0, TAU, 96, RING_COLOR, 2.0)
	draw_arc(center, radius * 0.5, 0.0, TAU, 96, RING_COLOR, 1.0)
	draw_line(center + Vector2(-radius, 0), center + Vector2(radius, 0), RING_COLOR, 1.0)
	draw_line(center + Vector2(0, -radius), center + Vector2(0, radius), RING_COLOR, 1.0)
	draw_line(center, center + Vector2(0, -radius), HEADING_COLOR, 2.0)
	draw_circle(center, 3.5, SELF_COLOR)

	var sin_h: float = sin(_local_heading)
	var cos_h: float = cos(_local_heading)
	for actor_v in _actors:
		if typeof(actor_v) != TYPE_DICTIONARY:
			continue
		var actor := actor_v as Dictionary
		var pos: Vector3 = actor.get("position", Vector3.ZERO)
		var delta: Vector3 = pos - _local_position
		var forward_m: float = -delta.x * sin_h - delta.z * cos_h
		var right_m: float = delta.x * cos_h - delta.z * sin_h
		var dist: float = Vector2(right_m, forward_m).length()
		if dist > float(_range_meters):
			continue
		var scaled: Vector2 = Vector2(right_m, -forward_m) * (radius / float(_range_meters))
		var posture_state: int = int(actor.get("posture", POSTURE_NORMAL))
		var blip_color := BLIP_COLOR
		var blip_radius := 3.5
		match posture_state:
			POSTURE_AIRBORNE:
				blip_color = AIRBORNE_COLOR
				blip_radius = 4.0
			POSTURE_DOWNED:
				blip_color = DOWNED_COLOR
			POSTURE_CRIPPLED:
				blip_color = CRIPPLED_COLOR
				blip_radius = 4.5
		draw_circle(center + scaled, blip_radius, blip_color)
