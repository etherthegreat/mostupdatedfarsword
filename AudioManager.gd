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

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)
	for i in _sfx_pool_size:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_players.append(p)


# ── MUSIC ──────────────────────────────────────────────────────────────────

func play_music(name: String, loop: bool = true) -> void:
	var stream = _load_audio(MUSIC_DIR + name + ".ogg", _music_cache)
	if stream == null:
		push_warning("[AudioManager] music not found: " + name)
		return
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	if stream.has_method("set_loop"):
		stream.loop = loop
	_music_player.play()


func stop_music() -> void:
	_music_player.stop()


# ── SFX ────────────────────────────────────────────────────────────────────

func play_sfx(name: String, volume_db: float = 0.0) -> void:
	var stream = _load_audio(SFX_DIR + name + ".ogg", _sfx_cache)
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
