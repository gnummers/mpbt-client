class_name SolarisMap
extends Control

## Custom Control that draws a simplified Solaris VII travel-map.
##
## Room positions use the MPBTWIN.EXE pixel coordinate space (≈ 640 × 480).
## Call set_rooms() to supply room data and set_selected() to highlight one.
## The canvas redraws automatically when the control is resized.

const _MAP_W  := 640.0
const _MAP_H  := 480.0
const _DOT_R  := 4.0
const _BG_COLOR  := Color(0.02, 0.03, 0.04, 1.0)
const _DOT_COLOR := Color(1.0, 0.70, 0.12, 1.0)   ## amber
const _SEL_COLOR := Color(0.25, 1.00, 0.35, 1.0)   ## bright green

var _rooms: Array = []
var _selected_id: int = -1


func set_rooms(rooms: Array) -> void:
	_rooms = rooms
	queue_redraw()


func set_selected(room_id: int) -> void:
	_selected_id = room_id
	queue_redraw()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), _BG_COLOR)

	if _rooms.is_empty() or size.x < 1.0 or size.y < 1.0:
		return

	var sx := size.x / _MAP_W
	var sy := size.y / _MAP_H

	for room in _rooms:
		var cx := float(room.get("centreX", 0)) * sx
		var cy := float(room.get("centreY", 0)) * sy
		var color := _SEL_COLOR if int(room.get("roomId", -1)) == _selected_id else _DOT_COLOR
		draw_circle(Vector2(cx, cy), _DOT_R, color)
