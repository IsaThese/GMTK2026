extends Node2D

func _ready() -> void:
	for vehicle in get_children():
		vehicle.is_static = true
