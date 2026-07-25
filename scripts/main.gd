extends Node2D

@onready var zone: Node2D = $Zone1
@onready var customer: Node2D = $Customer

func _ready() -> void:
	var customer_positions = zone.get_node("CustomerPositions")
	if customer_positions == null or customer_positions.get_child_count() == 0:
		push_warning("No customer!")
		customer.queue_free()
	else:
		var marker = customer_positions.get_children().pick_random()
		customer.global_position = marker.global_position
