class_name CombatReticle
extends Control

const LINE_COLOR := Color(0.4, 1.0, 0.6, 0.95)
const OUTLINE_COLOR := Color(0.0, 0.08, 0.04, 0.9)
const CENTER_COLOR := Color(1.0, 0.95, 0.38, 0.95)

var _texture: Texture2D = null


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func set_texture(texture: Texture2D) -> void:
	_texture = texture
	queue_redraw()


func _draw() -> void:
	var center := size * 0.5
	if _texture != null:
		var tex_size := _texture.get_size()
		draw_texture(_texture, center - tex_size * 0.5)
		return

	_draw_line_pair(center, Vector2(0, -18), Vector2(0, -8))
	_draw_line_pair(center, Vector2(0, 8), Vector2(0, 18))
	_draw_line_pair(center, Vector2(-18, 0), Vector2(-8, 0))
	_draw_line_pair(center, Vector2(8, 0), Vector2(18, 0))
	draw_arc(center, 6.0, 0.0, TAU, 24, OUTLINE_COLOR, 3.0)
	draw_arc(center, 6.0, 0.0, TAU, 24, CENTER_COLOR, 1.2)
	draw_circle(center, 1.4, LINE_COLOR)


func _draw_line_pair(center: Vector2, from_delta: Vector2, to_delta: Vector2) -> void:
	draw_line(center + from_delta, center + to_delta, OUTLINE_COLOR, 4.0)
	draw_line(center + from_delta, center + to_delta, LINE_COLOR, 1.5)
