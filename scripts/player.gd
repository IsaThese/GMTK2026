class_name PlayerClass extends CharacterBody2D

# Settings
@export var UseSteeringControls := false
@export_range(0, 1, 0.05) var TurningManeuverability := 0.8

const ACCELERATION = 400
const DECELERATION = 300
const MAX_SPEED = 300 
const MAX_TURN_SPEED = PI

# Setting 1 Acc 250 Dec 300 Max 650 Turn pi*7 - isaac, Skillful Drifting to stop and move
#Setting 2 Acc 400 Dec 300 Max 300 Turn Pi - zeroji
#setting 3 Acc 340 Dec 100 Max 800 Turn pi*2 - Isaac, Faster, Harder to control
#Setting 4 Acc 120 Dec 700 Max 1000 Turn pi*14 - Skillful Stopping and Drifing, Fastest


# Signal emitted when crashing against something
signal collision_detected(impact_force: float, player_speed: float)

# Members
var facing := Vector2.LEFT


func _init() -> void:
	velocity = Vector2.ZERO


func _get_turning_speed() -> float:
	if UseSteeringControls:
		return PI / 2
	else:
		if velocity.length_squared() < 1:
			return INF
		return lerp(MAX_TURN_SPEED, deg_to_rad(240), inverse_lerp(0, MAX_SPEED, velocity.length()))


func _physics_process(delta: float) -> void:
	## Read basic player inputs
	var direction := Input.get_vector("left", "right", "up", "down")
	var braking_hard := Input.is_action_pressed("brake")

	var current_forward_velocity = velocity.length() * velocity.dot(facing)

	var forward_vel: float = 0  # Added forward velocity
	var reverse_vel: float = 0  # Added reverse velocity
	var braking_vel: float = 0  # Added velocity against current velocity direction
	var turning_rad: float = 0  # Turning angle in radians

	## Translate inputs into different velocities depending on controls

	if UseSteeringControls:
		# Steering controls use separate controls for steering and accelerating/reversing
		var steering = Input.get_axis("steer_left", "steer_right")
		turning_rad = steering * MAX_TURN_SPEED * delta
		$Debug/TargetDirection.points[1] = facing.rotated(turning_rad / delta) * 80

		forward_vel += Input.get_action_strength("steer_drive") * ACCELERATION * delta

		if current_forward_velocity > 0:
			reverse_vel += Input.get_action_strength("steer_reverse") * DECELERATION * delta
			if direction.length_squared() == 0:  # No input pressed
				braking_vel += DECELERATION * delta
		if braking_hard:
			braking_vel += DECELERATION * delta

		$Debug/InputDirectionForward.points[1] = facing * forward_vel
		$Debug/InputDirectionSide.points[1] = facing.rotated(steering * PI / 2) * 40
	else:
		# WASD controls split the inputs into forward and sideways vectors
		var direction_forward = direction.project(facing)
		var direction_sideways = direction - direction_forward
		$Debug/InputDirectionForward.points[1] = direction_forward * 20
		$Debug/InputDirectionSide.points[1] = direction_sideways * 20

		var target_facing = (direction if direction_sideways.length_squared() < 0.1 else direction_sideways)
		if target_facing.length_squared() == 0 and velocity.length() > 10:
			target_facing = velocity.normalized()
		$Debug/TargetDirection.points[1] = target_facing * 80

		var rotation_to_apply = facing.angle_to(target_facing)
		if target_facing.length() > 0 and (velocity.length_squared() < 1 or abs(rotation_to_apply) < deg_to_rad(135)):
			turning_rad = sign(rotation_to_apply) * min(abs(rotation_to_apply), _get_turning_speed() * delta)

		if braking_hard:
			braking_vel += DECELERATION * delta
		if current_forward_velocity > 0 and ((direction.dot(facing) < 0) or (direction_forward.length() == 0)):
			if direction.dot(facing) < 0:
				reverse_vel += DECELERATION * delta
			if direction_forward.length() == 0:
				braking_vel += DECELERATION * delta
		else:
			forward_vel += direction_forward.length() * ACCELERATION * delta

	## Apply player inputs

	facing = facing.rotated(turning_rad)
	# Redirect velocity towards facing direction
	var velocity_delta_angle = velocity.angle_to(facing)
	var velocity_adjustment = sign(velocity_delta_angle) * min(abs(velocity_delta_angle), MAX_TURN_SPEED * delta * TurningManeuverability)
	velocity = velocity.rotated(velocity_adjustment)

	forward_vel = min(forward_vel, ACCELERATION)

	var braking_vec = -velocity.normalized() * abs(braking_vel)

	$Debug/BrakeDirection.points[1] = braking_vec.normalized() * 80

	if braking_vel > velocity.length():
		velocity = Vector2.ZERO
	if current_forward_velocity > 0 and reverse_vel > current_forward_velocity:
		velocity = Vector2.ZERO
	elif current_forward_velocity < 0 and forward_vel > abs(current_forward_velocity):
		velocity = Vector2.ZERO
	else:
		var delta_vel = facing * (forward_vel - reverse_vel) + braking_vec
		# TODO: do we need the velocity limit prioritizing inputs?
		velocity = (velocity + delta_vel).limit_length(MAX_SPEED)

	# Move character and detect collisions
	var collision = move_and_collide(velocity * delta)
	if collision:
		var head_on = velocity.normalized().dot(-collision.get_normal())
		emit_signal("collision_detected", abs(head_on), get_speed_percentage())
		# kill velocity if head on
		velocity *= (1 - abs(head_on))
		var hit_angle = velocity.angle_to(collision.get_normal().rotated(PI / 2))
		var deviation = 2 * hit_angle
		velocity = velocity.rotated(deviation)
		#This is for managing crash sound
		#print(collision.get_normal())
		#position = collision.get_position()


func _process(_delta: float) -> void:
	$Debug/Direction.points[1] = facing * 40
	$Debug/VelDirection.points[1] = velocity
	$CollisionShape2D.rotation = Vector2.UP.angle_to(facing)
	$Sprite2D.rotation = Vector2.LEFT.angle_to(facing)


func get_speed_percentage() -> float:
	return velocity.length() / MAX_SPEED
