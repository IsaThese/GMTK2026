extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

const base_dir := Vector2.DOWN

@export var is_player: bool = false
@export var is_static: bool = false

func _ready() -> void:
	sprite.region_rect.position.y = 0.0 if is_player else sprite.region_rect.size.y
	
	if is_player:
		$StaticBody.queue_free()

func _process(_delta: float) -> void:
	var rot := global_rotation_degrees
	if rot > -60 and rot < 60:
		anim.play("move_down")
		sprite.rotation_degrees = 0
	elif rot > 120 or rot < -120:
		anim.play("move_up")
		sprite.rotation_degrees = 180
	elif rot > 0:
		anim.play("move_left")
		sprite.rotation_degrees = -90
	else:
		anim.play("move_right")
		sprite.rotation_degrees = 90
	if is_static:
		get_tree().create_timer(0.1).timeout.connect(anim.pause)
