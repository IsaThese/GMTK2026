class_name VehicleSpawner extends Path2D

@export_range(1, 10, .5) var spawn_interval = 2.

const BikeScene = preload("uid://berks61lodc3y")
const CarScene = preload("uid://bt2wa67uj3t8")

const BikeSpeed = 50
const CarSpeed = 100


func _ready() -> void:
	_on_timer_timeout()
	$Timer.wait_time = spawn_interval
	$Timer.start()

func _on_timer_timeout() -> void:
	var sprite = (BikeScene if Controls.BikeCity else CarScene).instantiate()
	var node = PathFollow2D.new()
	sprite.rotation_degrees = -90
	node.rotates = true
	node.loop = false
	node.add_child(sprite)
	add_child(node)

func _physics_process(delta: float) -> void:
	var speed = BikeSpeed if Controls.BikeCity else CarSpeed
	for child in get_children():
		if child is PathFollow2D:
			child.progress += speed * delta
			if child.progress_ratio >= 1.0:
				child.queue_free()
