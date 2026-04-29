class_name SolarisMap
extends Control

## Custom Control that draws the Solaris VII travel-map.
##
## Room positions use the pixel coordinate space from Solaris.map. When the
## extracted retail map background is available, that texture defines the
## canonical coordinate size.
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
var _background: Texture2D = null


func set_background_texture(texture: Texture2D) -> void:
	_background = texture
	queue_redraw()


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

	if _background != null:
		draw_texture_rect(_background, Rect2(Vector2.ZERO, size), false)

	if _rooms.is_empty() or size.x < 1.0 or size.y < 1.0:
		return

	var coord_size := _coordinate_size()
	var sx := size.x / coord_size.x
	var sy := size.y / coord_size.y

	for room in _rooms:
		var cx := float(room.get("centreX", 0)) * sx
		var cy := float(room.get("centreY", 0)) * sy
		var color := _SEL_COLOR if int(room.get("roomId", -1)) == _selected_id else _DOT_COLOR
		var radius := _DOT_R * 1.6 if int(room.get("roomId", -1)) == _selected_id else _DOT_R
		draw_circle(Vector2(cx, cy), radius, color)
		draw_arc(Vector2(cx, cy), radius + 2.0, 0.0, TAU, 24, Color(0, 0, 0, 0.85), 1.5)


func _coordinate_size() -> Vector2:
	if _background != null:
		return Vector2(float(_background.get_width()), float(_background.get_height()))
	return Vector2(_MAP_W, _MAP_H)
