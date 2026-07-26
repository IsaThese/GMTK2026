extends Timer
var currentTime : int
var maxTime : int
var startDingTimes: Array[int] = []
var amountOfDings: int = 4
var _player:PlayerClass

func _ready() -> void:
	var getTime := roundi(self.time_left)
	maxTime = wait_time
	EventBus.updateTimer.emit(getTime)
	for i in range(amountOfDings) :
		startDingTimes.append(maxTime - i)
	_player = get_parent()
	assert(_player != null, "End Game Timer couldn't find player")
	

func _process(delta: float) -> void:
	var getTime := roundi(self.time_left) 
	if(currentTime != getTime) :
		currentTime = getTime
		if(startDingTimes.has(currentTime) && currentTime != maxTime):
			SoundManager.PlaySound(Sound.ID.Ding, get_parent(), .6)
		EventBus.updateTimer.emit(currentTime)
		if(currentTime <= 0):
			EventBus.GameLose.emit()
		
	
	
	
