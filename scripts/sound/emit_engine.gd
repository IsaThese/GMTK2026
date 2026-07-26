extends Node

var _player: PlayerClass
var _is_car : bool
#var newVolume : float = .2; Not used calculated by speed

func _ready() -> void:
	_player = get_parent() as PlayerClass
	assert(_player != null, "Player was null for EngineSounds")
	_is_car = !_player.is_bike
	
func _process(_delta: float) -> void:
	if(!_is_car) : SoundManager.StopSound(Sound.ID.EngineRunning); return;
	var percentage := _player.get_speed_percentage()
	if percentage <= 0:
		SoundManager.StopSound(Sound.ID.EngineRunning)
		return
	var time := Time.get_ticks_msec() * 0.001
	var pitch := maxf(percentage, 1)
	var volume = percentage
	pitch += sin(time * 3.0) * 0.04
	
	SoundManager.PlaySound(
		Sound.ID.EngineRunning,
		_player,
		volume,
		pitch
	)
