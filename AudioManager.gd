extends Node

## AudioManager — register as AutoLoad "AudioManager" in Project Settings.
##
## Buses expected in the AudioServer (Project → Project Settings → Audio):
##   Master → Music
##              → SFX
##              → Ambient
##
## call AudioManager.play_sfx("end_turn") from anywhere.
## call AudioManager.play_music("menu_theme") to swap background music.

const SFX_DIR    = "res://audio/sfx/"
const MUSIC_DIR  = "res://audio/music/"

var _music_player: AudioStreamPlayer
var _sfx_players: Array[AudioStreamPlayer] = []
var _sfx_pool_size: int = 8   # concurrent SFX slots

var _sfx_cache:   Dictionary = {}
var _music_cache: Dictionary = {}

# ── Music track / playlist ──────────────────────────────────────────────────
# Add more song filenames (no extension) to MAIN_TRACK. They play in order, then
# loop back to the first. A single-song track loops that one song gaplessly.
const MAIN_TRACK: Array = ["la foret"]
var _playlist: Array = []
var _playlist_index: int = 0

# Button click SFX — four custom clicks by ZIBLING (sound artist; credit for record-keeping).
# One is chosen at random on every button press.
const BUTTON_CLICKS: Array = ["DartboardClick1", "DartboardClick2", "DartboardClick3", "DartboardClick4"]

func _ready() -> void:
	_ensure_buses()
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music" if AudioServer.get_bus_index("Music") != -1 else "Master"
	add_child(_music_player)
	for i in _sfx_pool_size:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX" if AudioServer.get_bus_index("SFX") != -1 else "Master"
		add_child(p)
		_sfx_players.append(p)
	# Global: give every button a click sound + remove the sticky focus highlight
	get_tree().node_added.connect(_on_node_added)
	# Apply saved volumes to the buses (created above if missing)
	apply_saved_volumes()


# -- BUSES / VOLUME ----------------------------------------------------------
func _ensure_buses() -> void:
	for bus_name in ["Music", "SFX", "Ambient"]:
		if AudioServer.get_bus_index(bus_name) == -1:
			var idx := AudioServer.bus_count
			AudioServer.add_bus(idx)
			AudioServer.set_bus_name(idx, bus_name)
			AudioServer.set_bus_send(idx, "Master")


func set_bus_volume_pct(bus_name: String, pct: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		idx = AudioServer.get_bus_index("Master")
	if idx == -1:
		return
	pct = clampf(pct, 0.0, 100.0)
	if pct <= 0.0:
		AudioServer.set_bus_mute(idx, true)
	else:
		AudioServer.set_bus_mute(idx, false)
		AudioServer.set_bus_volume_db(idx, linear_to_db(pct / 100.0))


func apply_saved_volumes() -> void:
	set_bus_volume_pct("Master",  float(LibraryData.get_setting("master_volume", 80)))
	set_bus_volume_pct("Music",   float(LibraryData.get_setting("music_volume", 70)))
	set_bus_volume_pct("SFX",     float(LibraryData.get_setting("sfx_volume", 90)))
	set_bus_volume_pct("Ambient", float(LibraryData.get_setting("ambient_volume", 60)))


# ── MUSIC ──────────────────────────────────────────────────────────────────

func play_music(name: String, loop: bool = true) -> void:
	var stream = _load_music(name)
	if stream == null:
		push_warning("[AudioManager] music not found: " + name)
		return
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	# AudioStreamMP3 / OggVorbis expose `loop` as a property, not a method
	if "loop" in stream:
		stream.loop = loop
	_music_player.play()


# Finds res://audio/music/<name>.{ogg,mp3,wav} — whichever the file actually is
func _load_music(name: String) -> AudioStream:
	return _load_audio_any(MUSIC_DIR, name, _music_cache)


# Resolves <dir>/<name>.{ogg,mp3,wav} to whichever file actually exists
func _load_audio_any(dir: String, name: String, cache: Dictionary) -> AudioStream:
	for ext in [".ogg", ".mp3", ".wav"]:
		var path = dir + name + ext
		if cache.has(path):
			return cache[path]
		if ResourceLoader.exists(path):
			var stream = load(path)
			cache[path] = stream
			return stream
	return null


func play_main_track() -> void:
	play_playlist(MAIN_TRACK)


func play_playlist(songs: Array, start_index: int = 0) -> void:
	_playlist = songs
	_playlist_index = start_index
	if not _music_player.finished.is_connected(_on_music_finished):
		_music_player.finished.connect(_on_music_finished)
	_play_current_playlist_song()


func _play_current_playlist_song() -> void:
	if _playlist.is_empty():
		return
	var stream = _load_music(_playlist[_playlist_index])
	if stream == null:
		push_warning("[AudioManager] playlist song not found: " + str(_playlist[_playlist_index]))
		return
	# Single-song track loops gaplessly; multi-song track advances on `finished`.
	if "loop" in stream:
		stream.loop = (_playlist.size() == 1)
	_music_player.stream = stream
	_music_player.play()


func _on_music_finished() -> void:
	# Fires only for non-looping streams (multi-song tracks) — advance and wrap around.
	if _playlist.is_empty():
		return
	_playlist_index = (_playlist_index + 1) % _playlist.size()
	_play_current_playlist_song()


func stop_music() -> void:
	_music_player.stop()


# ── SFX ────────────────────────────────────────────────────────────────────

func play_sfx(name: String, volume_db: float = 0.0) -> void:
	var stream = _load_audio_any(SFX_DIR, name, _sfx_cache)
	if stream == null:
		push_warning("[AudioManager] sfx not found: " + name)
		return
	var player = _get_free_sfx_player()
	if player == null:
		return
	player.stream     = stream
	player.volume_db  = volume_db
	player.play()


func stop_sfx(name: String) -> void:
	var stream = _sfx_cache.get(name)
	if stream == null:
		return
	for p in _sfx_players:
		if p.stream == stream and p.playing:
			p.stop()



# ── BUTTONS (global) ────────────────────────────────────────────────────────

func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.focus_mode = Control.FOCUS_NONE   # no lingering highlight after a click
		if not node.pressed.is_connected(_play_button_click):
			node.pressed.connect(_play_button_click)


func _play_button_click() -> void:
	if BUTTON_CLICKS.is_empty():
		return
	play_sfx(BUTTON_CLICKS[randi() % BUTTON_CLICKS.size()])


# ── INTERNAL ───────────────────────────────────────────────────────────────

func _load_audio(path: String, cache: Dictionary) -> AudioStream:
	if cache.has(path):
		return cache[path]
	if not ResourceLoader.exists(path):
		return null
	var stream = load(path)
	cache[path] = stream
	return stream


func _get_free_sfx_player() -> AudioStreamPlayer:
	for p in _sfx_players:
		if not p.playing:
			return p
	# All slots busy — steal the oldest (first in list)
	return _sfx_players[0]
