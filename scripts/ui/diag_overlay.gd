extends CanvasLayer

## F3-togglable diagnostics HUD overlay.  Autoloaded as DiagOverlay.
##
## Shows: FPS, WebSocket state, server availability, active scene name.
## Press F3 to toggle.  Visible by default if ClientConfig.diagnostics_enabled().
## Designed to be always-on for developers; transparent to regular players.

var _panel:       PanelContainer
var _fps_label:   Label
var _ws_label:    Label
var _srv_label:   Label
var _scene_label: Label


func _ready() -> void:
	layer = 100
	_build_ui()
	_panel.visible = ClientConfig.diagnostics_enabled()


func _build_ui() -> void:
	_panel = PanelContainer.new()
	_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_panel.grow_horizontal = Control.GROW_DIRECTION_BEGIN

	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.04, 0.04, 0.82)
	style.set_content_margin_all(8.0)
	style.corner_radius_top_left = 4
	style.corner_radius_bottom_left = 4
	_panel.add_theme_stylebox_override("panel", style)
	add_child(_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	_panel.add_child(vbox)

	_fps_label   = _make_label("FPS: —")
	_ws_label    = _make_label("WS:  —")
	_srv_label   = _make_label("SRV: —")
	_scene_label = _make_label("Scene: —")
	for lbl: Label in [_fps_label, _ws_label, _srv_label, _scene_label]:
		vbox.add_child(lbl)


func _make_label(default_text: String) -> Label:
	var lbl := Label.new()
	lbl.text = default_text
	lbl.add_theme_font_size_override("font_size", 12)
	lbl.add_theme_color_override("font_color", Color(0.85, 0.98, 0.60))
	return lbl


func _process(_delta: float) -> void:
	if not _panel.visible:
		return

	_fps_label.text = "FPS: %d" % Engine.get_frames_per_second()

	var ws_on: bool = WSClient.is_ws_connected
	_ws_label.text = "WS:  %s" % ("● connected" if ws_on else "○ offline")
	_ws_label.add_theme_color_override(
		"font_color",
		Color(0.30, 1.0, 0.40) if ws_on else Color(1.0, 0.40, 0.30),
	)

	var srv_on: bool = ServerBridge.is_online
	_srv_label.text = "SRV: %s" % ("online" if srv_on else "offline")
	_srv_label.add_theme_color_override(
		"font_color",
		Color(0.30, 1.0, 0.40) if srv_on else Color(1.0, 0.40, 0.30),
	)

	var cs: Node = get_tree().current_scene
	_scene_label.text = "Scene: %s" % (cs.name if cs != null else "—")


func _input(event: InputEvent) -> void:
	if event is InputEventKey \
			and event.physical_keycode == KEY_F3 \
			and event.pressed \
			and not event.echo:
		_panel.visible = not _panel.visible
		get_viewport().set_input_as_handled()
