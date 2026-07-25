extends Area2D
@export
var Name:Item.ID
@export
var Amount:int = 1

func _ready() -> void:
	area_entered.connect(collectQuery)
	assert(Amount > 0, "Can't set amount to 0 or negative in item")
	
func collectQuery(area:Area2D) -> void:
	var parent := area.get_parent()
	if(parent is not PlayerClass): 
		return
	var player:PlayerClass = parent
	assert(player != null, "Collecting query found player to be null")
	set_deferred("monitoring", false)
	player.inventory.addItem(Name, Amount)
	get_parent().queue_free()
