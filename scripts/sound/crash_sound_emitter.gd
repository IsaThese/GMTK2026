extends Node


#Volume ranges from 0-1
var _volume : float = 1
var _player : PlayerClass
var _midBound : float = .98

func _ready() -> void:
	_player = get_parent() as PlayerClass
	assert(_player != null, "Player cannot be null for CrashSoundEmitter, 
	must be child")
	if(_player.is_bike) : return
	_player.collision_detected.connect(CarCrash)
	
func CarCrash(force: float, player_speed: float) -> void:
#force is between 0 (barely brushed a wall) and 1 (hit head-on)
#player_speed is speed before the collision (between 0 and 1)
	var pitch : float = randf_range(.5, 1)
	if player_speed > 0.1 && player_speed < _midBound:
		SoundManager.PlaySound(Sound.ID.CarCrash, _player, _volume, pitch)
	elif player_speed > _midBound :
		SoundManager.PlaySound(Sound.ID.FastCrash, _player, _volume, pitch)
