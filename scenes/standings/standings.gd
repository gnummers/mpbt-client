extends Control

## Solaris VII Standings screen.
##
## Fetches GET /standings and renders a scrollable leaderboard table.
## Waits for ServerBridge if the game API URL isn't yet resolved.

const MAIN_SCENE := "res://scenes/main/main.tscn"

@onready var _status_label: Label = $MainVBox/Header/StatusLabel
@onready var _row_container: VBoxContainer = $MainVBox/Scroll/RowContainer

var _standings_client: StandingsClient


func _ready() -> void:
	_standings_client = StandingsClient.new()
	add_child(_standings_client)
	_standings_client.standings_loaded.connect(_on_loaded)
	_standings_client.standings_failed.connect(_on_failed)

	_set_status("Loading standings…")

	if ServerBridge.is_online and not ServerBridge.game_api_url.is_empty():
		_standings_client.fetch(ServerBridge.game_api_url)
	else:
		ServerBridge.server_available.connect(_on_server_available, CONNECT_ONE_SHOT)
		ServerBridge.server_unavailable.connect(_on_server_unavailable, CONNECT_ONE_SHOT)
		ServerBridge.check_config()


func _set_status(text: String) -> void:
	_status_label.text = text


func _on_server_available(_info: Dictionary) -> void:
	_standings_client.fetch(ServerBridge.game_api_url)


func _on_server_unavailable(reason: String) -> void:
	_set_status("Server offline — %s" % reason)


func _on_loaded(standings: Array) -> void:
	_set_status("")
	_populate(standings)


func _on_failed(reason: String) -> void:
	_set_status("Failed to load standings: %s" % reason)


func _populate(standings: Array) -> void:
	for child in _row_container.get_children():
		child.queue_free()

	if standings.is_empty():
		var empty_lbl := Label.new()
		empty_lbl.text = "No matches played yet. Be the first to fight!"
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_lbl.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
		_row_container.add_child(empty_lbl)
		return

	_row_container.add_child(_make_header_row())

	for i in standings.size():
		var s: Dictionary = standings[i] as Dictionary
		_row_container.add_child(_make_standing_row(s))


func _make_header_row() -> Control:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)

	for text in ["#", "Pilot", "House", "W/L", "Tier", "Score"]:
		var lbl := Label.new()
		lbl.text = text
		lbl.add_theme_color_override("font_color", Color(0.9, 0.75, 0.25))
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.custom_minimum_size.x = _col_min_width(text)
		row.add_child(lbl)

	var sep := HSeparator.new()
	sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_row_container.add_child(sep)  # separator after header goes to container directly

	return row


func _make_standing_row(s: Dictionary) -> HBoxContainer:
	var rank     := int(s.get("overallRank", 0))
	var name_str := str(s.get("displayName", "?"))
	var house    := str(s.get("allegiance", ""))
	var ratio    := str(s.get("ratioText", "0/0"))
	var tier     := str(s.get("tierLabel", ""))
	var score    := int(s.get("score", 0))

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 0)

	var is_local := (name_str == AuthSession.character.get("display_name", ""))
	var row_color := Color(0.25, 0.85, 0.25) if is_local else Color(0.85, 0.85, 0.85)

	for pair: Array in [
		["#%d" % rank, rank],
		[name_str, name_str],
		[house, house],
		[ratio, ratio],
		[tier, tier],
		["%d" % score, score],
	]:
		var lbl := Label.new()
		lbl.text = str(pair[0])
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		lbl.custom_minimum_size.x = _col_min_width(str(pair[0]))
		if is_local:
			lbl.add_theme_color_override("font_color", row_color)
		row.add_child(lbl)

	return row


func _col_min_width(header: String) -> float:
	match header:
		"#":       return 36
		"Pilot":   return 160
		"House":   return 110
		"W/L":     return 70
		"Tier":    return 110
		"Score":   return 70
		_:         return 60


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCENE)
