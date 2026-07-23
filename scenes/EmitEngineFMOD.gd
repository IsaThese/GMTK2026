extends FmodEventEmitter2D

var Player: PlayerClass
var newVolume : float = .2;
var threshold : float = .4;

func _ready() -> void:
	Player = get_parent() as PlayerClass
	assert(Player != null, "Player was null for EngineSoundEmitter")
	
func _physics_process(delta: float) -> void:
	var percentage : float = Player.get_speed_percentage()
	if(percentage < threshold) :
		percentage = 0;
	if(percentage > 0) : 
		set_parameter("Speed", percentage)
		volume = newVolume;
		play(false)
	else :
		volume = newVolume;
		set_parameter("Speed", percentage)
