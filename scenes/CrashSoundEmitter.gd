extends Node


#Volume ranges from 0-1
var Volume : float = 1
var Player : PlayerClass
var midBound : float = .98

func _ready() -> void:
	Player = get_parent() as PlayerClass
	assert(Player != null, "Player cannot be null for CrashSoundEmitter, 
	must be child")
	Player.collision_detected.connect(CarCrash)
	
func CarCrash(force: float, player_speed: float) -> void:
	 #force is between 0 (barely brushed a wall) and 1 (hit head-on)
	 #player_speed is speed before the collision (between 0 and 1)
	var pitch : float = randf_range(.5, 1)
	if player_speed > 0.1 && player_speed < midBound:
		SoundManager.PlaySound(Sound.ID.CarCrash, Player.global_position, Volume, pitch)
	elif player_speed > midBound :
		SoundManager.PlaySound(Sound.ID.FastCrash, Player.global_position, Volume, pitch)
