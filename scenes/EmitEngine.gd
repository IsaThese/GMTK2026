extends Node

var Player: PlayerClass
var newVolume : float = .2;
var threshold : float = .4;

func _ready() -> void:
	Player = get_parent() as PlayerClass
	assert(Player != null, "Player was null for EngineSoundEmitter")
	
func _process(_delta: float) -> void:
	var percentage := Player.get_speed_percentage()
	if percentage <= 0:
		SoundManager.StopSound(Sound.ID.EngineRunning)
		return
	var time := Time.get_ticks_msec() * 0.001
	var pitch := maxf(percentage, 1)
	var volume = percentage
	pitch += sin(time * 3.0) * 0.04
	
	SoundManager.PlaySound(
		Sound.ID.EngineRunning,
		Player.global_position,
		volume,
		pitch
	)
