extends Node2D

@onready var zone: Node2D = $Zone2
@onready var customer: Node2D = $Customer

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
	
	SoundManager.PlaySound(Sound.ID.Ticking, $Player)
func _game_lose() -> void:
	Paused = true
	get_tree().paused = Paused
	SoundManager.StopSound(Sound.ID.Ticking)
	SoundManager.PlaySound(Sound.ID.Alarm, $Player)
	$CanvasLayer/Control.visible = !Paused
	$CanvasLayer/MiniMap.visible = !Paused
	$CanvasLayer/PauseMenu.visible = Paused
	
func _restart_game() -> void:
	Paused = false;
	get_tree().paused = Paused;
	get_tree().reload_current_scene()
	$CanvasLayer/Control.visible = Paused
	$CanvasLayer/MiniMap.visible = Paused
	$CanvasLayer/PauseMenu.visible = !Paused
	
func _unhandled_input(event: InputEvent) -> void:
	if(Paused && event.is_action_pressed("restartGame", false, true)):
		_restart_game()
	
