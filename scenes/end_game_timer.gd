extends Timer
var currentTime : int

func _ready() -> void:
	var getTime := roundi(self.time_left)
	EventBus.updateTimer.emit(getTime)
	

func _process(delta: float) -> void:
	var getTime := roundi(self.time_left) 
	if(currentTime != getTime) :
		currentTime = getTime
		EventBus.updateTimer.emit(currentTime)
	if(currentTime <= 0):
		EventBus.GameLose.emit()
	
	
