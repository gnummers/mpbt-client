extends Control
class_name TouchLookZone

## Right-half transparent touch zone that converts finger drag into camera
## look deltas for the combat scene.
##
## Anchored to the right half of the viewport via layout (set in .tscn).
## Emits look_delta(delta: Vector2) on each drag update; combat.gd accumulates
## these and applies them with MOUSE_SENSITIVITY.

signal look_delta(delta: Vector2)

var _touch_index: int     = -1
var _last_pos:    Vector2 = Vector2.ZERO


func _ready() -> void:
	modulate = Color(1.0, 1.0, 1.0, 0.0)  ## fully transparent
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed and _touch_index < 0:
			var local_pos := get_global_transform().affine_inverse() * touch.position
			if Rect2(Vector2.ZERO, size).has_point(local_pos):
				_touch_index = touch.index
				_last_pos    = touch.position
				get_viewport().set_input_as_handled()
		elif not touch.pressed and touch.index == _touch_index:
			_touch_index = -1
			get_viewport().set_input_as_handled()

	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if drag.index == _touch_index:
			look_delta.emit(drag.position - _last_pos)
			_last_pos = drag.position
			get_viewport().set_input_as_handled()
