extends Node
var Player:PlayerClass
var _isBike:bool

func _ready() -> void:
	Player = get_parent() as PlayerClass
	assert(Player != null, "bike sounds couldn't find player as parent")
	_isBike = Player.is_bike
	
func _process(delta: float) -> void:
	if(!_isBike) : SoundManager.StopSound(Sound.ID.BikePedal); return; 
	var speed = Player.get_speed_percentage()
	if(speed <= 0):
		SoundManager.StopSound(Sound.ID.BikePedal)
	else:
		SoundManager.PlaySound(Sound.ID.BikePedal, Player, speed)

	
