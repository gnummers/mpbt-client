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
## If the file is absent the call is a no-op (silence is acceptable until the
## user provides retail assets or open-licensed replacements).
##
## Looping:  OGG Vorbis BGM streams have their loop flag forced on after load
## so a correctly tagged music file will repeat automatically.

var _bgm_player:         AudioStreamPlayer
var _sfx_player:         AudioStreamPlayer
var _current_bgm_track:  String = ""


func _ready() -> void:
	_ensure_buses()

	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = "Music"
	add_child(_bgm_player)

	_sfx_player = AudioStreamPlayer.new()
	_sfx_player.bus = "SFX"
	add_child(_sfx_player)

	apply_from_config()


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

func play_bgm(track: String) -> void:
	if track == _current_bgm_track and _bgm_player.playing:
		return  # Already playing this track — no-op

	var path := "res://assets/audio/bgm/%s.ogg" % track
	if not ResourceLoader.exists(path):
		return  # Leave current BGM playing; missing track is not an error

	_current_bgm_track = track
	var stream := load(path) as AudioStream
	if stream is AudioStreamOggVorbis:
		(stream as AudioStreamOggVorbis).loop = true
	_bgm_player.stream = stream
	_bgm_player.play()


func stop_bgm() -> void:
	_current_bgm_track = ""
	_bgm_player.stop()


func play_sfx(sfx_name: String) -> void:
	var path := "res://assets/audio/sfx/%s.ogg" % sfx_name
	if not ResourceLoader.exists(path):
		return
	_sfx_player.stream = load(path)
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
