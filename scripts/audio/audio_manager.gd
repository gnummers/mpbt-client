extends Node

## AudioManager — global audio controller.  Autoloaded after DiagOverlay.
##
## Manages two AudioStreamPlayer nodes:
##   _bgm_player  — background music (bus: Music)
##   _sfx_player  — one-shot sound effects (bus: SFX)
##
## Volume is stored in dB.  Default buses are created programmatically so no
## external bus-layout asset is needed.
##
## BGM tracks are looked up at:
##   res://assets/audio/bgm/<track>.ogg
## SFX clips are looked up at:
##   res://assets/audio/sfx/<name>.ogg
## If bundled audio is absent, the configured extracted asset path is searched
## for audio/bgm, audio/music, audio/sfx, audio/sounds, music, bgm, sfx, or
## sounds. Missing audio is a no-op.
##
## Looping:  OGG Vorbis BGM streams have their loop flag forced on after load
## so a correctly tagged music file will repeat automatically.

var _bgm_player:         AudioStreamPlayer
var _sfx_player:         AudioStreamPlayer
var _current_bgm_track:  String = ""
var _connected_buttons:  Dictionary = {}
var _audio_cache:        Dictionary = {}


func _ready() -> void:
	_ensure_buses()

	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Music"
	add_child(_bgm_player)

	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = "SFX"
	add_child(_sfx_player)

	apply_from_config()
	call_deferred("_install_ui_sfx_hooks")


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

func play_bgm(track: String) -> void:
	if track == _current_bgm_track and _bgm_player.playing:
		return

	var stream := _load_named_audio(track, "bgm")
	if stream == null:
		return

	_current_bgm_track = track
	_bgm_player.stream = stream
	_bgm_player.play()


func stop_bgm() -> void:
	_current_bgm_track = ""
	_bgm_player.stop()


func play_sfx(sfx_name: String) -> void:
	var stream := _load_named_audio(sfx_name, "sfx")
	if stream == null:
		return
	_sfx_player.stream = stream
	_sfx_player.play()


func set_master_db(db: float) -> void:
	var idx := AudioServer.get_bus_index("Master")
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, db)


func set_music_db(db: float) -> void:
	var idx := AudioServer.get_bus_index("Music")
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, db)


func set_sfx_db(db: float) -> void:
	var idx := AudioServer.get_bus_index("SFX")
	if idx >= 0:
		AudioServer.set_bus_volume_db(idx, db)


func apply_from_config() -> void:
	set_master_db(ClientConfig.master_volume_db())
	set_music_db(ClientConfig.music_volume_db())
	set_sfx_db(ClientConfig.sfx_volume_db())


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

func _ensure_buses() -> void:
	if AudioServer.get_bus_index("Music") < 0:
		AudioServer.add_bus()
		var idx := AudioServer.bus_count - 1
		AudioServer.set_bus_name(idx, "Music")
		AudioServer.set_bus_send(idx, "Master")

	if AudioServer.get_bus_index("SFX") < 0:
		AudioServer.add_bus()
		var idx := AudioServer.bus_count - 1
		AudioServer.set_bus_name(idx, "SFX")
		AudioServer.set_bus_send(idx, "Master")


func _install_ui_sfx_hooks() -> void:
	if get_tree().node_added.is_connected(_on_node_added):
		return
	get_tree().node_added.connect(_on_node_added)
	for node in get_tree().root.get_children():
		_connect_buttons_recursive(node)


func _connect_buttons_recursive(node: Node) -> void:
	_connect_button(node)
	for child in node.get_children():
		_connect_buttons_recursive(child)


func _on_node_added(node: Node) -> void:
	_connect_button(node)


func _connect_button(node: Node) -> void:
	if not (node is BaseButton):
		return
	var button := node as BaseButton
	var id := button.get_instance_id()
	if _connected_buttons.has(id):
		return
	_connected_buttons[id] = true
	button.pressed.connect(_on_button_pressed)
	button.mouse_entered.connect(_on_button_hovered)


func _on_button_pressed() -> void:
	play_sfx("ui_click")


func _on_button_hovered() -> void:
	play_sfx("ui_hover")


func _load_named_audio(track_name: String, kind: String) -> AudioStream:
	var extracted := ClientConfig.asset_extracted_path()
	var cache_key := "%s:%s:%s" % [extracted, kind, track_name]
	if _audio_cache.has(cache_key):
		return _audio_cache[cache_key]

	var bundled := "res://assets/audio/%s/%s.ogg" % [kind, track_name]
	var stream := _load_stream(bundled)
	if stream != null:
		_apply_looping(stream, kind)
		_audio_cache[cache_key] = stream
		return stream

	var external_path := AssetRegistry.find_audio(extracted, track_name, kind)
	stream = _load_stream(external_path)
	if stream != null:
		_apply_looping(stream, kind)
	_audio_cache[cache_key] = stream
	return stream


func _load_stream(path: String) -> AudioStream:
	if path.is_empty():
		return null

	if path.begins_with("res://") or path.begins_with("user://"):
		if ResourceLoader.exists(path):
			return load(path) as AudioStream
		return null

	if not FileAccess.file_exists(path):
		return null

	match path.get_extension().to_lower():
		"ogg":
			return AudioStreamOggVorbis.load_from_file(path)
		"mp3":
			return AudioStreamMP3.load_from_file(path)
		"wav":
			return AudioStreamWAV.load_from_file(path)
		_:
			return null


func _apply_looping(stream: AudioStream, kind: String) -> void:
	if kind != "bgm":
		return
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	elif stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = true
