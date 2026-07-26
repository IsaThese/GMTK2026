class_name sound_manager
#Don't rename to SoundManager
extends Node

#Enum Sound.ID Is possible to not be initialized
var sounds: Dictionary[Sound.ID, SoundData] = {}
var loaded_streams: Array[AudioStream] = []
var sound_nodes: Dictionary[Sound.ID, AudioStreamPlayer2D] = {}


class SoundData:
	var path_base: String
	var extension: String
	var path: String
	var amountOfNoises: int
	var currentNoise : int
	var hasParameter : bool
	var parameterValue : float
	var pausible : bool
	
	var loaded_streams : Array[AudioStream] = []
	
	func _init(resource_path: String, amount_of_noises: int = 1, canPause:bool = false, chooseNoise : int = 1,
	makeParameter : bool = false, setParameter : float = -1) -> void:
		self.path = resource_path
		self.hasParameter = makeParameter
		self.parameterValue = setParameter
		assert(amount_of_noises > 0, "Can't set amount of noises to less than 1")
		self.amountOfNoises = amount_of_noises
		assert(chooseNoise > 0, "Can't set chosen noise to less than 1")
		self.currentNoise = chooseNoise
		
		self.path_base = resource_path.get_basename()
		self.extension = resource_path.get_extension()
		self.pausible = canPause
		
		for i in range(1, amount_of_noises + 1) :
			var full_path := path_base + str(i) + "." + extension
			var stream = load(full_path)
			loaded_streams.append(stream)
		
		
		

	
	func playNextNoise() -> void:
		if(currentNoise >= amountOfNoises) :
			self.currentNoise = 1
			return
		if(currentNoise < amountOfNoises):
			self.currentNoise += 1
			return
	
		
	
		

#THE FILE MUST START END WITHOUT THE NUMBER
func _ready() -> void:
	sounds[Sound.ID.EngineStart] = SoundData.new("res://assets/sfx/Engine/EngineStart.wav")
	sounds[Sound.ID.EngineRunning] = SoundData.new("res://assets/sfx/Engine/EngineRunning.wav", true)
	sounds[Sound.ID.EngineEnd] = SoundData.new("res://assets/sfx/Engine/EngineEnd.wav")
	sounds[Sound.ID.CarCrash] = SoundData.new("res://assets/sfx/Car_crash/Crash.wav")
	sounds[Sound.ID.FastCrash] = SoundData.new("res://assets/sfx/Car_crash/FastCrash.wav")
	sounds[Sound.ID.Ding] = SoundData.new("res://assets/sfx/Ding/Ding.wav", 3)
	sounds[Sound.ID.Ticking] = SoundData.new("res://assets/sfx/Ticking/Ticking.wav", 1, true)
	sounds[Sound.ID.Pickup] = SoundData.new("res://assets/sfx/PickUp/PickUp.wav", 4)
	sounds[Sound.ID.BikePedal] = SoundData.new("res://assets/sfx/BikePedal/BikePedal.wav")
	sounds[Sound.ID.Alarm] = SoundData.new("res://assets/sfx/Alarm/Alarm.wav")
	
func getSoundDataFromID(id: int) -> SoundData:
	if sounds.has(id):
		return sounds[id]
	push_warning("Sound.ID: " + Sound.ID.keys()[id] + " has no data assigned")
	return null

func register() -> void:
	pass

# Volume varies from 0-1, MUST ADD NUMBER SUFFIX!, The name of the node is 
#Sound.ID to string
func PlaySound(id: Sound.ID, parent: Node2D, volume: float = 1.0,
pitch: float = 1,
parameter: float = 0.0, _playIfAlreadyPlaying: bool = false) -> void:
	assert(parent != null, "Parent for sound shouldn't be null!")
	var sound_data: SoundData = getSoundDataFromID(id)
	if sound_data == null:
		return 
	if(sound_data.hasParameter) :
		sound_data.parameterValue = parameter
	## Nodes don't get deleted or something properly when reloading game
	if sound_nodes.has(id) && !_playIfAlreadyPlaying:
		var stream = sound_nodes.get(id)
		if(stream == null) : 
			sound_nodes.erase(id)
			return;
		stream.pitch_scale = pitch
		stream.volume_db = linear_to_db(volume)
		return;
	
	
	var newSoundInstance := AudioStreamPlayer2D.new()
	newSoundInstance.name = str(id)
	newSoundInstance.bus = "SFX"
	if(!sound_data.pausible) or (id == Sound.ID.Alarm):
		newSoundInstance.process_mode = Node.PROCESS_MODE_ALWAYS
	var base_path: String = sound_data.path.get_basename() 
	var extension: String = sound_data.path.get_extension() 
	var soundPath: String = base_path + str(sound_data.currentNoise) + "." + extension
	
	assert(ResourceLoader.exists(soundPath), "SoundPath was set incorrectly, make sure 
	it follows name convention: [Sound.ID][Number]" )
	var stream_to_play := sound_data.loaded_streams[sound_data.currentNoise - 1]
	newSoundInstance.stream = stream_to_play
	sound_data.playNextNoise() #Shuffling may be an option, but idc
	newSoundInstance.volume_db = linear_to_db(volume)
	newSoundInstance.pitch_scale = pitch
	parent.add_child(newSoundInstance)
	sound_nodes.set(id, newSoundInstance)
	newSoundInstance.finished.connect(StopSound.bind(id))
	newSoundInstance.play()
	
func StopSound(id: Sound.ID) -> void:
	if sound_nodes.has(id):
		var node_to_stop = sound_nodes.get(id)
		if is_instance_valid(node_to_stop):
			var audio_node :=  node_to_stop as AudioStreamPlayer2D
			audio_node.queue_free()
		sound_nodes.erase(id)
		
