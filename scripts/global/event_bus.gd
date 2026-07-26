class_name event_bus
extends Node

@warning_ignore("unused_signal")
signal itemCollected(itemName:Item.ID,amount:int)
@warning_ignore("unused_signal")
signal InventoryRegistered(inv:InventoryManager)
@warning_ignore("unused_signal")
signal updateTimer(newTime:int)
@warning_ignore("unused_signal")
signal GameLose()
