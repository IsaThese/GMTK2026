extends FmodEventEmitter2D


#Volume ranges from 0-1
var Volume : float = .5
var Player : base_player

func _ready() -> void:
	Player = get_parent();
	assert(Player != null, "Player cannot be null for CrashSoundEmitter, 
	must be child")
	Player.CarCrashed.connect(CarCrash)
	
func CarCrash() -> void:
	volume = Volume
	play(false)
