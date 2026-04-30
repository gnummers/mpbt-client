extends Node

## AudioManager — global audio controller.  Autoloaded after DiagOverlay.
##
## Manages one BGM player and a small pool of one-shot SFX players:
##   _bgm_player   — background music (bus: Music)
##   _sfx_players  — one-shot sound effects (bus: SFX)
##
## Volume is stored in dB.  Default buses are created programmatically so no
## external bus-layout asset is needed.
##
## BGM tracks are looked up at:
##   res://assets/audio/bgm/<track>.ogg
## SFX clips are looked up at:
##   res://assets/audio/sfx/<name>.ogg
## If bundled audio is absent, the configured extracted asset path is searched
## for audio/bgm, audio/music, audio/sfx, audio/sound, audio/sounds, music,
## bgm, sfx, sound, or sounds. For SFX, logical client names can also fall back
## to common retail MPBT filenames. Extracted retail sound banks should prefer
## converted .wav files; raw .pcm remains a manual fallback and is treated as
## unsigned 8-bit mono samples at a guessed 11025 Hz mix rate. Missing audio is
## a no-op.
##
## Looping:  OGG Vorbis BGM streams have their loop flag forced on after load
## so a correctly tagged music file will repeat automatically.

var _bgm_player:         AudioStreamPlayer
var _sfx_players:        Array = []
var _sfx_player_cursor:  int = 0
var _current_bgm_track:  String = ""
var _connected_buttons:  Dictionary = {}
var _audio_cache:        Dictionary = {}  # cache_key -> { path: String, stream: AudioStream }
var _variant_cursors:    Dictionary = {}

const RETAIL_SFX_HINTS := {
	"ui_click": ["button", "button2", "gclick", "lever"],
	"ui_hover": ["button2", "gclick", "lever", "radar"],
	"weapon_fire": ["lasrfire", "mgunfire", "mislfire", "ppcfire", "acanfire", "flamer"],
	"weapon_hit": ["hit1", "hit2", "hit3", "expld1", "expld2", "expld3", "expld4", "aexpld", "collide", "blwpart"],
}
const SFX_PLAYER_POOL_SIZE := 6
const RETAIL_PCM_SAMPLE_RATE := 11025


func _ready() -> void:
	_ensure_buses()

	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Music"
	add_child(_bgm_player)

	for i in SFX_PLAYER_POOL_SIZE:
		var sfx_player := AudioStreamPlayer.new()
		sfx_player.bus = "SFX"
		sfx_player.name = "SFXPlayer%d" % i
		add_child(sfx_player)
		_sfx_players.append(sfx_player)

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


func load_sfx_stream(sfx_name: String) -> AudioStream:
	return _load_named_audio(sfx_name, "sfx")


func load_weapon_fire_sfx_stream(type_id: int) -> AudioStream:
	return _first_available_sfx_stream(_weapon_fire_cue_names(type_id))


func load_weapon_hit_sfx_stream(type_id: int, damage: int = 0) -> AudioStream:
	return _load_sfx_variant_stream(_weapon_hit_cue_names(type_id, damage))


func load_engine_movement_sfx_stream(speed_ratio: float) -> AudioStream:
	if speed_ratio >= 0.75:
		return _load_sfx_variant_stream(["engine3", "engine2"])
	elif speed_ratio >= 0.35:
		return _load_sfx_variant_stream(["engine2", "engine"])
	return load_sfx_stream("engine")


func load_step_sfx_stream(speed_ratio: float) -> AudioStream:
	if speed_ratio >= 0.65:
		return _load_sfx_variant_stream(["step", "actuator"])
	return load_sfx_stream("step")


func load_actuator_sfx_stream() -> AudioStream:
	return _load_sfx_variant_stream(["actuator", "torso"])


func play_sfx(sfx_name: String) -> void:
	var stream := load_sfx_stream(sfx_name)
	if stream == null:
		return
	_play_stream_on_sfx_player(stream)


func play_weapon_fire_sfx(type_id: int) -> void:
	var stream := load_weapon_fire_sfx_stream(type_id)
	if stream == null:
		return
	_play_stream_on_sfx_player(stream)


func play_weapon_hit_sfx(type_id: int, damage: int = 0) -> void:
	var stream := load_weapon_hit_sfx_stream(type_id, damage)
	if stream == null:
		return
	_play_stream_on_sfx_player(stream)


func _weapon_fire_cue_names(type_id: int) -> Array:
	match type_id:
		0:
			return ["flamer"]
		1:
			return ["mgunfire"]
		2, 3, 4:
			return ["lasrfire"]
		5:
			return ["ppcfire"]
		6, 7, 8, 9:
			return ["acanfire"]
		10, 11, 12:
			return ["mislfire"]
		13, 14, 15, 16:
			return ["mislfire"]
		_:
			return ["weapon_fire"]


func _weapon_hit_cue_names(type_id: int, damage: int = 0) -> Array:
	match type_id:
		0:
			return ["hit1", "hit2"]
		1:
			return ["hit1", "hit2", "hit3"]
		2, 3, 4:
			return ["hit2", "hit3"]
		5:
			return ["expld3", "expld4"]
		6, 7, 8, 9:
			return ["collide", "expld1", "blwpart"]
		10, 11, 12:
			return ["expld1", "expld2"]
		13, 14, 15, 16:
			return ["expld2", "expld3"]
		_:
			if damage >= 15:
				return ["aexpld", "expld4"]
			elif damage >= 8:
				return ["expld2", "expld3"]
			return ["hit1", "hit2", "hit3"]


func play_jump_start_sfx() -> void:
	play_sfx("jump")


func play_jump_land_sfx() -> void:
	play_sfx("landing")


func play_radar_ping_sfx() -> void:
	play_sfx("radar")


func play_target_lock_sfx() -> void:
	play_sfx("locked")


func play_engine_movement_sfx(speed_ratio: float) -> void:
	var stream := load_engine_movement_sfx_stream(speed_ratio)
	if stream == null:
		return
	_play_stream_on_sfx_player(stream)


func play_step_sfx(speed_ratio: float) -> void:
	var stream := load_step_sfx_stream(speed_ratio)
	if stream == null:
		return
	_play_stream_on_sfx_player(stream)


func play_actuator_sfx() -> void:
	var stream := load_actuator_sfx_stream()
	if stream == null:
		return
	_play_stream_on_sfx_player(stream)


func play_stand_up_sfx() -> void:
	play_sfx("getup")


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


func clear_audio_cache() -> void:
	_audio_cache.clear()


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
	var resolved_path := _resolve_audio_path(track_name, kind, extracted)
	var cached_value: Variant = _audio_cache.get(cache_key, {})
	if typeof(cached_value) == TYPE_DICTIONARY:
		var cached_entry := cached_value as Dictionary
		if str(cached_entry.get("path", "")) == resolved_path:
			return cached_entry.get("stream", null) as AudioStream

	if resolved_path.is_empty():
		_audio_cache.erase(cache_key)
		return null

	var stream := _load_stream(resolved_path)
	if stream != null:
		_apply_looping(stream, kind)
	_audio_cache[cache_key] = {
		"path": resolved_path,
		"stream": stream,
	}
	return stream


func _resolve_audio_path(track_name: String, kind: String, extracted: String) -> String:
	var bundled := "res://assets/audio/%s/%s.ogg" % [kind, track_name]
	if ResourceLoader.exists(bundled):
		return bundled

	var extra_hints: Array = []
	if kind == "sfx":
		var retail_hints_value: Variant = RETAIL_SFX_HINTS.get(track_name, [])
		if retail_hints_value is Array:
			extra_hints = retail_hints_value

	return AssetRegistry.find_audio(extracted, track_name, kind, extra_hints)


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
		"pcm":
			return _load_retail_pcm_stream(path)
		_:
			return null


func _load_retail_pcm_stream(path: String) -> AudioStreamWAV:
	var data := FileAccess.get_file_as_bytes(path)
	if data.is_empty():
		return null

	var stream := AudioStreamWAV.new()
	stream.data = data
	stream.format = AudioStreamWAV.FORMAT_8_BITS
	stream.mix_rate = RETAIL_PCM_SAMPLE_RATE
	stream.stereo = false
	return stream


func _play_sfx_variant(cue_names: Array) -> void:
	var stream := _load_sfx_variant_stream(cue_names)
	if stream == null:
		return
	_play_stream_on_sfx_player(stream)


func _first_available_sfx_stream(cue_names: Array) -> AudioStream:
	for cue_v in cue_names:
		var stream := load_sfx_stream(str(cue_v))
		if stream != null:
			return stream
	return null


func _load_sfx_variant_stream(cue_names: Array) -> AudioStream:
	if cue_names.is_empty():
		return null

	var key_parts: PackedStringArray = []
	for cue_v in cue_names:
		key_parts.append(str(cue_v))
	var key := "|".join(key_parts)
	var start_index := int(_variant_cursors.get(key, 0)) % cue_names.size()
	_variant_cursors[key] = start_index + 1

	for offset in cue_names.size():
		var name := str(cue_names[(start_index + offset) % cue_names.size()])
		var stream := load_sfx_stream(name)
		if stream != null:
			return stream
	return null


func _play_stream_on_sfx_player(stream: AudioStream) -> void:
	var player := _next_sfx_player()
	if player == null:
		return
	player.stream = stream
	player.play()


func _next_sfx_player() -> AudioStreamPlayer:
	if _sfx_players.is_empty():
		return null

	for i in _sfx_players.size():
		var index := (_sfx_player_cursor + i) % _sfx_players.size()
		var player := _sfx_players[index] as AudioStreamPlayer
		if player == null:
			continue
		if not player.playing:
			_sfx_player_cursor = (index + 1) % _sfx_players.size()
			return player

	var fallback := _sfx_players[_sfx_player_cursor] as AudioStreamPlayer
	_sfx_player_cursor = (_sfx_player_cursor + 1) % _sfx_players.size()
	return fallback


func _apply_looping(stream: AudioStream, kind: String) -> void:
	if kind != "bgm":
		return
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	elif stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = true
