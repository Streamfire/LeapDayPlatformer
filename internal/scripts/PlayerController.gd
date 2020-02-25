extends KinematicBody2D

#moving
#export(float) var moveForce = 5.0
export(float) var maxMoveSpeed = 5.0
#jumping
export(float) var jumpForce=2000.0
export(float) var maxFallSpeed = 5.0
export(float) var gravity=2000.0
export(int) var MaxJumpCount=2
#sliding
const maxWalkableSlope= 60


var jump_count = 0
var inputMotion = Vector2()
var velocity = Vector2()
var motion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Playernode = self
	pass # Replace with function body.


func _process(_delta):
	if jump_count < MaxJumpCount and Input.is_action_just_pressed("Move_Jump"):
		inputMotion.y = -jumpForce
		jump_count += 1
	
	if Input.is_action_pressed("Move_Left"):
		inputMotion.x= -1
	elif Input.is_action_pressed("Move_Right"):
		inputMotion.x= 1
	else:
		inputMotion.x=0



func _physics_process(delta):

	# SPEED
	velocity.x = inputMotion.x * maxMoveSpeed
	velocity.y += gravity
	if velocity.y > maxFallSpeed:
		velocity.y = maxFallSpeed
	
	move_and_slide(velocity*delta)
	pass
