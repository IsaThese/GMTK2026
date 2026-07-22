extends FmodEventEmitter2D

var Player:base_player
var newVolume : float = .2;
func _ready() -> void:
	Player = get_parent()
	
func _physics_process(delta: float) -> void:
	var velocity : float = Player.velocity.length()
	
	var percentage : float = velocity / Player.MAX_SPEED
	if(percentage < .4) :
		percentage = 0;
	if(velocity > 0) : 
		set_parameter("Speed", percentage)
		volume = newVolume;
		play(false)
	else :
		volume = newVolume;
		set_parameter("Speed", percentage)
