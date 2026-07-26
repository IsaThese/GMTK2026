extends Label
var inventory:InventoryManager

func _enter_tree() -> void:
	EventBus.itemCollected.connect(collectItem)
	EventBus.InventoryRegistered.connect(registerInventory)
	#not grabbing actual value for convenience, but should be 0
	
func _ready() -> void:
	updateUI()

func registerInventory(inv:InventoryManager):
	assert(inv != null, "Inventory was null when registering in EventBus")
	if(inventory == null):
		inventory = inv
	
func collectItem(itemName:Item.ID, amount:int) -> void:
	if(!is_visible_in_tree()):
		visible = true
	updateUI()
	

func updateUI() -> void:
	var emptyText := ""
	for item in inventory.inventory.keys():
		var item_name = Item.ID.keys()[item]
		var amount := inventory.inventory[item]
		emptyText += item_name + ": " + str(amount)
	self.text = emptyText
