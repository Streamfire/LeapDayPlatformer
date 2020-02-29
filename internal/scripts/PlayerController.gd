extends KinematicBody2D

onready var groundRay = get_node("RayCast2D")
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

var stoponSlope = 25
var slideYeetorNeet = 1
var inputMotion = Vector2()
var velocity = Vector2()

onready var Animator = $PlayerAnimator
onready var walkSprite = $Hitbox/walk
onready var slideSprite = $SlideBox/slide

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
	
	if Input.is_action_pressed("Move_Slide") \
		and !Input.is_action_pressed("Move_Left") \
		and !Input.is_action_pressed("Move_Right") \
		and !Input.is_action_pressed("Move_Jump") and is_on_floor():
			slideYeetorNeet = lerp(slideYeetorNeet, 10, Acceleration)
			stoponSlope = 0
	else:
		slideYeetorNeet = 1
		stoponSlope = 25
	
	groundRay.force_raycast_update()
	print(groundRay.get_collision_normal())
	
	Animate()

func Animate():
	if inputMotion.x >0:
			walkSprite.flip_h = false
			slideSprite.flip_h = false
	elif inputMotion.x <0:
			walkSprite.flip_h = true
			slideSprite.flip_h = true
	
	if(Input.is_action_pressed("Move_Slide")):
		Animator.play("Slide")
	else:
		Animator.play("Walk")
	
	if velocity.x < 0.1 and velocity.x > -0.1:
		Animator.seek(0)
		Animator.stop()


func _physics_process(delta):
	
	if inputMotion.x != 0:
		velocity.x = lerp(velocity.x, inputMotion.x * MoveSpeed, Acceleration)
	elif inputMotion.x == 0 and is_on_floor():
		velocity.x = lerp(velocity.x, 0, Deacceleration)
	
	if groundRay.get_collision_normal() != UP_VECTOR:
		move_and_slide_with_snap(velocity*delta*slideYeetorNeet, Vector2(0,3), UP_VECTOR, false, 4, rad2deg(90))
	else:
		move_and_slide(velocity*delta*slideYeetorNeet, UP_VECTOR, stoponSlope)
	
	if is_on_floor():
		currentGlideTime=0.0
		currentJumpCount=0
	pass


func _on_Hitbox_collision(area):
	print("AU!")
	#print(groundRay.get_collision_normal())
	
	pass # Replace with function body.
