extends Node

var sounds: Dictionary = {}

enum SoundID {
	Bomb,
	Boom,
	Click,
	UiClick,
	Poof,
	Bike
}

func _ready() -> void:
	sounds[SoundID.Bomb] = "res://sounds/bomb.ogg"
	sounds[SoundID.Click] = "res://sounds/click.wav"


func register() -> void:
	pass
