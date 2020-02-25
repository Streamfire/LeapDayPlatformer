extends KinematicBody2D

export(float) var moveForce = 5.0
export(float) var maxSpeed = 5.0
export(float) var maxFallSpeed = 5.0
export(float) var jumpForce=2000.0
export(float) var gravity=2000.0
export(int) var MaxJumpCount=2

const maxWalkableSlope= 60
const slideCancelThreshold = 1.0

var jump_count = 0
var velocity = Vector2()
var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	Global.Playernode = self
	pass # Replace with function body.

#per event reacten is faster
func _input(event):
	if jump_count < MaxJumpCount and event.is_action_pressed("Move_Jump"):
		velocity.y = -jumpForce
		jump_count += 1


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#direction
	var inputDirection = 0
	if Input.is_action_pressed("Move_Right"):
		inputDirection= 1
	elif Input.is_action_pressed("Move_Left"):
		inputDirection=-1

	
	# SPEED
	velocity.x = inputDirection * maxSpeed
	velocity.y += gravity * delta
	if velocity.y > maxFallSpeed:
		velocity.y = maxFallSpeed
	
	# We move the character to see if it's colliding or not
	motion = Vector2(velocity.x * delta, velocity.y * delta)
	var motion_remainder = move_and_collide(motion)

	if motion_remainder:
		var normal = motion_remainder.normal
		# If it collides, we use the dot product to get the angle of the slope
		var slope_angle = rad2deg(acos(normal.dot(Vector2(0, -1))))

		# If the slope is < 45 deg, we landed on the ground, so we reset the jump count
		if slope_angle < maxWalkableSlope:
			jump_count = 0
			# If the ground is not horizontal...
			var motion_last = Vector2()
			if slope_angle > 0:
				# ...we have to revert the motion, and slide along the collider instead
				move_and_slide(-motion)
				velocity.y = 0.0
				# However because of the gravity, if we don't add some kind of friction,
				# the character will slowly move down the slope. 
				# If he moves a little bit and there's no player input,
				# we stop him (set the motion_remainder to (0, 0))
				if motion_remainder.travel.length() < slideCancelThreshold and velocity.x == 0:
					motion_last = Vector2()
				else:
					motion_last = motion_remainder.remainder
			# The Vector2.slide method projects the vector along the other vector rotated by 90 degrees
			# In other words, it projects the motion on the slope, so we can move without colliding the same way
			var final_movement = normal.slide(motion_last)
			final_movement = move_and_slide(final_movement)
	pass
