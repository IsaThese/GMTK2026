extends Node2D

@onready var zone: Node2D = $Game/Zone2
@onready var customer: Node2D = $Game/Customer

const hint_texts := [
	"Bike City has been unlocked!",
	"This place sure has a lot of traffic",
	"Go back to title screen just in case...",
	"If only there were fewer cars!",
	"I wonder how things could be better...",
	"There has to be a better way...",
]

var Paused:bool

func _enter_tree() -> void:
	EventBus.GameLose.connect(_game_lose)

func _ready() -> void:
	# Change clear color to sidewalk
	RenderingServer.set_default_clear_color(Color("#949494"))
	
	var customer_positions = zone.get_node("CustomerPositions")
	if customer_positions == null or customer_positions.get_child_count() == 0:
		push_warning("No customer!")
		customer.queue_free()
	else:
		var marker = customer_positions.get_children().pick_random()
		customer.global_position = marker.global_position
	
	SoundManager.PlaySound(Sound.ID.Ticking, $Game/Player)
func _game_lose() -> void:
	Paused = true
	get_tree().paused = Paused
	SoundManager.StopSound(Sound.ID.EngineRunning)
	SoundManager.StopSound(Sound.ID.Ticking)
	SoundManager.PlaySound(Sound.ID.Alarm, $Game/Player)
	$CanvasLayer/Control.visible = !Paused
	$CanvasLayer/MiniMap.visible = !Paused
	$CanvasLayer/GameOverMenu.visible = Paused
	Controls.TotalFails += 1
	if Controls.TotalFails >= Controls.BikeUnlock:
		var index = (Controls.TotalFails - Controls.BikeUnlock) % len(hint_texts)
		$CanvasLayer/GameOverMenu/HintLabel.text = hint_texts[index]
		$CanvasLayer/GameOverMenu/HintLabel.show()
	
	
func _restart_game() -> void:
	Paused = false;
	get_tree().paused = Paused;
	get_tree().reload_current_scene()
	$CanvasLayer/Control.visible = Paused
	$CanvasLayer/MiniMap.visible = Paused
	$CanvasLayer/GameOverMenu.visible = !Paused
	
func _unhandled_input(event: InputEvent) -> void:
	if(Paused && event.is_action_pressed("restartGame", false, true)):
		_restart_game()
		
