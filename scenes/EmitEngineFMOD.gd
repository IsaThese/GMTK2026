extends FmodEventEmitter2D

var Player:base_player
var newVolume : float = .2;
var threshold : float = .4;

func _ready() -> void:
	Player = get_parent()
	assert(Player != null, "Player was null for EngineSoundEmitter")
	
func _physics_process(delta: float) -> void:
	var velocity : float = Player.velocity.length()
	var percentage : float = velocity / Player.MAX_SPEED
	if(percentage < threshold) :
		percentage = 0;
	if(velocity > 0) : 
		set_parameter("Speed", percentage)
		volume = newVolume;
		play(false)
	else :
		volume = newVolume;
		set_parameter("Speed", percentage)
