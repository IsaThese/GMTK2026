extends Label

func _enter_tree() -> void:
	EventBus.updateTimer.connect(_update_time_text)
	
func _update_time_text(newTime:int) -> void:
	self.text = "Time Left: " + str(newTime)
	
