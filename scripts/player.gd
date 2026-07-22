extends CharacterBody2D

const VELOCITY = 40
const ACCELERATION = 120
const DECELERATION = 200
const MAX_SPEED = 250
const MAX_TURN_SPEED = PI / 2

var facing := Vector2.LEFT

# var velocity := Vector2.ZERO

func _init() -> void:
	velocity = Vector2.ZERO

func get_turning_speed() -> float:
	if self.velocity.length_squared() < 1:
		return INF
	return lerp(MAX_TURN_SPEED, deg_to_rad(30), inverse_lerp(0, MAX_SPEED, self.velocity.length()))

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var braking := Input.is_action_pressed("brake")
	
	#if direction.x < -0.7 and direction.y > 0.7 and self.velocity.length_squared() < 1:
		#breakpoint

	var dot = direction.dot(self.facing)
	
	var direction_forward = direction.project(self.facing)
	var direction_sideways = direction - direction_forward
	$Debug/InputDirectionForward.points[1] = direction_forward * 20
	$Debug/InputDirectionSide.points[1] = direction_sideways * 20
	
	var is_forward_input := direction.length_squared() > 0 and ((direction_forward.length_squared() > 0 and dot > 0) or self.velocity.length_squared() < 1)
	
	var target_facing = (direction if direction_sideways.length_squared() < 0.1 else direction_sideways)
	if target_facing.length_squared() == 0 and velocity.length() > 10:
		target_facing = velocity.normalized()
	$Debug/TargetDirection.points[1] = target_facing * 80
	
	var rotation_to_apply = self.facing.angle_to(target_facing)
	if target_facing.length() > 0 and (self.velocity.length_squared() < 1 or abs(rotation_to_apply) < deg_to_rad(135)):
		var actual_rotation = sign(rotation_to_apply) * min(abs(rotation_to_apply), get_turning_speed() * delta)
		self.facing = self.facing.rotated(actual_rotation)
	
	var velocity_change := Vector2.ZERO
	
	$Debug/BrakeDirection.points[1] = Vector2.ZERO
	#if is_forward_input:
	if braking or (direction_forward.length() == 0) or (dot < 0):
		$Debug/BrakeDirection.points[1] = -self.velocity.normalized() * 40
		velocity_change = (-self.velocity.normalized()) * DECELERATION * delta
	else:
		velocity_change += (direction_forward * ACCELERATION * delta)
	velocity_change += (direction_sideways * DECELERATION * delta)
		#self.velocity = self.velocity.limit_length(MAX_SPEED)
	#else:
		# Regular deceleration
		#velocity_change = (-self.velocity.normalized()) * DECELERATION * delta
		#if amount.length() > self.velocity.length():
			#self.velocity = Vector2.ZERO
		#else:
			#self.velocity += amount
	velocity_change = velocity_change.limit_length(max(ACCELERATION, DECELERATION) * delta)
	
	if velocity_change.dot(self.velocity) < -0.99 and velocity_change.length_squared() > self.velocity.length_squared():
		self.velocity = Vector2.ZERO
	elif (self.velocity + velocity_change).length() > MAX_SPEED:
		var no_vel = velocity_change.length()
		var full_vel = (self.velocity + velocity_change).length()
		var limit = inverse_lerp(no_vel, full_vel, MAX_SPEED)
		self.velocity = velocity * limit + velocity_change
	else:
		self.velocity += velocity_change
	
	#self.position += self.velocity
	#print(self.velocity, self.position)
	#move_and_slide() # self.velocity * delta)
	var collision = move_and_collide(self.velocity * delta)
	if collision:
		var head_on = self.velocity.normalized().dot(-collision.get_normal())
		# kill velocity if head on
		self.velocity *= (1 - abs(head_on))
		var hit_angle = self.velocity.angle_to(collision.get_normal().rotated(PI / 2))
		var deviation = 2 * hit_angle
		self.velocity = self.velocity.rotated(deviation)
		#print(collision.get_normal())
		#self.position = collision.get_position()
	
func _process(delta: float) -> void:
	$Debug/Direction.points[1] = self.facing * 40
	$Debug/VelDirection.points[1] = self.velocity
	$CollisionShape2D.rotation = Vector2.UP.angle_to(self.facing)
	$Sprite2D.rotation = Vector2.LEFT.angle_to(self.facing)
