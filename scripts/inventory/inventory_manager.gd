class_name InventoryManager
extends Node


var inventory: Dictionary[Item.ID, int] = {}


func _ready() -> void:
	for item_id in Item.ID.values():
		inventory[item_id] = 0
	var player := get_parent() as PlayerClass
	assert(player!=null, "Inventory Manager couldn't find player")
	player.inventory = self;
	EventBus.InventoryRegistered.emit(self)

#Maybe there should be a cap size?
func addItem(itemName:Item.ID, amount:int) -> void:
	checkForNegatives(itemName, amount)
	inventory[itemName] += amount
	EventBus.itemCollected.emit(itemName, amount) 
	
func removeItem(itemName:Item.ID, amount:int) -> void:
	checkForNegatives(itemName, amount)
	var previous : int = inventory[itemName]
	var total : int = min(previous - amount, 0)
	inventory[itemName] = total


func getItemAmount(itemName:Item.ID) -> int:
	return inventory[itemName]

## There would be a setItem function, but don't need to be in-depth
	
func checkForNegatives(itemName:Item.ID, amount:int):
	assert(amount > 0, "Can't use add/remove function with negative or 0 numbers")
	assert(inventory.has(itemName), "Item registration failed, in _ready of inv manager")
