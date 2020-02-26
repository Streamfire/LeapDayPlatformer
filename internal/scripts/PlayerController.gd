extends KinematicBody2D

#moving
export(float) var MoveSpeed = 50.0
export(float) var Acceleration = 0.2
export(float) var Deacceleration = 0.7
#jumping
export(float) var jumpForce=2.0
export(int) var jumpCount=2.0
export(float) var gravity=2.0
export(float) var glidingTime=5.0
export(float) var glidingModifier=1.5

const UP_VECTOR = Vector2(0,-1)


var inputMotion = Vector2()
var velocity = Vector2()

onready var Animator = $PlayerAnimator
onready var walkSprite = $walk

var currentGlideTime=0.0
var currentJumpCount=0

func _ready():
	Global.Playernode = self


func _process(delta):
	#walking
	inputMotion.x = 0
	if Input.is_action_pressed("Move_Left"):
		inputMotion.x= -1
	elif Input.is_action_pressed("Move_Right"):
		inputMotion.x= 1
	
	if is_on_ceiling() or is_on_floor():
		velocity.y = 0
	
	if Input.is_action_pressed("Move_Jump") and currentGlideTime<glidingTime:
		velocity.y += (gravity/glidingModifier)
		currentGlideTime+=delta
	else:
		velocity.y += gravity
	
	if Input.is_action_just_pressed("Move_Jump") and currentJumpCount<jumpCount:
		velocity.y = -jumpForce
		currentJumpCount+=1
	
	Animate()

func Animate():
	if is_on_floor():
		if inputMotion.x >0:
			Animator.play("Walk")
			walkSprite.flip_h = false
		elif inputMotion.x <0:
			Animator.play("Walk")
			walkSprite.flip_h = true
		else:
			Animator.seek(0)
			Animator.stop()

func _physics_process(delta):
	
	if inputMotion.x != 0:
		velocity.x = lerp(velocity.x, inputMotion.x * MoveSpeed, Acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, Deacceleration)
	
	move_and_slide(velocity*delta, UP_VECTOR)
	if is_on_floor():
		currentGlideTime=0.0
		currentJumpCount=0
	pass


func _on_Hitbox_collision(area):
	print("AU!")
	pass # Replace with function body.
