extends CanvasLayer

## Mobile touch overlay — lives above all game HUD on CanvasLayer 10.
##
## Provides:
##   move_value:   Vector2  — current joystick output, polled by combat.gd
##   fire_pressed: bool     — set true when the fire button is tapped
##   jump_pressed: bool     — set true when the jump button is tapped
##   get_look_delta() -> Vector2  — accumulated look delta, resets on read

@onready var _joystick:  Control = $JoystickAnchor/MoveJoystick
@onready var _look_zone: Control = $LookZone
@onready var _fire_btn:  Button  = $FireButton
@onready var _jump_btn:  Button  = $JumpButton

var move_value:   Vector2 = Vector2.ZERO
var fire_pressed: bool    = false
var jump_pressed: bool    = false
var _look_accum:  Vector2 = Vector2.ZERO


func _ready() -> void:
	_joystick.stick_updated.connect(_on_stick_updated)
	_look_zone.look_delta.connect(_on_look_delta)
	_fire_btn.pressed.connect(_on_fire_pressed)
	_jump_btn.pressed.connect(_on_jump_pressed)


func get_look_delta() -> Vector2:
	var d := _look_accum
	_look_accum = Vector2.ZERO
	return d


func _on_stick_updated(value: Vector2) -> void:
	move_value = value


func _on_look_delta(delta: Vector2) -> void:
	_look_accum += delta


func _on_fire_pressed() -> void:
	fire_pressed = true


func _on_jump_pressed() -> void:
	jump_pressed = true
