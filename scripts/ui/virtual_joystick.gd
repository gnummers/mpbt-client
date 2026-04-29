extends Control
class_name VirtualJoystick

## On-screen virtual joystick for touch/mobile input.
##
## Handles InputEventScreenTouch and InputEventScreenDrag.  The joystick base
## repositions to wherever the finger first touches within this control.
## Emits stick_updated(value) while a finger is active; emits with
## Vector2.ZERO when the finger lifts.  Dead zone is applied before emit.

signal stick_updated(value: Vector2)

const DEAD_ZONE     := 0.15
const BASE_RADIUS   := 80.0
const HANDLE_RADIUS := 28.0
const BASE_COLOR    := Color(1.0, 1.0, 1.0, 0.18)
const HANDLE_COLOR  := Color(1.0, 1.0, 1.0, 0.55)

var _touch_index: int     = -1
var _base_pos:    Vector2 = Vector2.ZERO
var _handle_pos:  Vector2 = Vector2.ZERO
var _value:       Vector2 = Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _draw() -> void:
	var center := _base_pos if _touch_index >= 0 else size * 0.5
	var handle := _handle_pos if _touch_index >= 0 else center
	draw_circle(center, BASE_RADIUS, BASE_COLOR)
	draw_arc(center, BASE_RADIUS, 0.0, TAU, 48, Color(1.0, 1.0, 1.0, 0.35), 2.0)
	draw_circle(handle, HANDLE_RADIUS, HANDLE_COLOR)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _touch_index < 0:
			var local_pos := get_global_transform().affine_inverse() * touch.position
			if Rect2(Vector2.ZERO, size).has_point(local_pos):
				_touch_index = touch.index
				_base_pos    = local_pos
				_handle_pos  = local_pos
				get_viewport().set_input_as_handled()
		elif not touch.pressed and touch.index == _touch_index:
			_touch_index = -1
			_value       = Vector2.ZERO
			_handle_pos  = Vector2.ZERO
			stick_updated.emit(_value)
			queue_redraw()
			get_viewport().set_input_as_handled()

	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _touch_index:
			var offset  := (get_global_transform().affine_inverse() * drag.position) - _base_pos
			var clamped := offset.limit_length(BASE_RADIUS)
			_handle_pos = _base_pos + clamped
			var raw     := clamped / BASE_RADIUS
			_value = raw if raw.length() > DEAD_ZONE else Vector2.ZERO
			stick_updated.emit(_value)
			queue_redraw()
			get_viewport().set_input_as_handled()


func get_value() -> Vector2:
	return _value
