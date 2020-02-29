extends KinematicBody2D

onready var groundRay = get_node("RayCast2D")
#moving
export(float) var MoveSpeed = 50.0
export(float) var SlideSpeed = 100.0
export(float) var SlideAcceleration = 0.1
export(float) var SlideDeacceleration = 0.06
export(float) var Acceleration = 0.2
export(float) var Deacceleration = 0.7
#jumping
export(float) var jumpForce=2.0
export(int) var jumpCount=2.0
export(float) var gravity=2.0
export(float) var glidingTime=5.0
export(float) var glidingModifier=1.5

const UP_VECTOR = Vector2(0,-1)

var snap = 3
var stoponSlope = 25
var slideYeetorNeet = false
var didIjustslide = false
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
	if alive :
		inputMotion.x = 0
		if (Input.is_action_pressed("Move_Left") \
		and !Input.is_action_pressed("Move_Slide")) \
		or (Input.is_action_pressed("Move_Left") and !Input.is_action_pressed("Move_Right") and !is_on_floor()):
				inputMotion.x= -1
		
		if (Input.is_action_pressed("Move_Right") \
		and !Input.is_action_pressed("Move_Slide")) \
		or (Input.is_action_pressed("Move_Right") and !Input.is_action_pressed("Move_Left") and !is_on_floor()):
				inputMotion.x= 1
	
		if is_on_ceiling() or is_on_floor():
			velocity.y = 0
				
		if Input.is_action_pressed("Move_Jump") and currentGlideTime<glidingTime and velocity.y>0:
			velocity.y += (gravity*glidingModifier)
			currentGlideTime+=delta
		else:
			velocity.y += gravity
	
		if Input.is_action_just_pressed("Move_Jump") and currentJumpCount<jumpCount:
			velocity.y = -jumpForce
			currentJumpCount+=1
	
		if Input.is_action_pressed("Move_Slide") \
			and groundRay.get_collision_normal() != UP_VECTOR \
			and is_on_floor():
				slideYeetorNeet = true
				didIjustslide = true
				stoponSlope = 0
				snap = 15
		else:
			slideYeetorNeet = false
			stoponSlope = 25
			snap = 3
			
		if Input.is_action_just_released("Move_Slide"):
			didIjustslide = false
	
		groundRay.force_raycast_update()
		#print(groundRay.get_collision_normal())
		#print(slideYeetorNeet)
	
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
		
		if groundRay.get_collision_normal().x > 0 :
			$Flat.rotation = 90.0+45.0
			$SlideBox.rotation=45
		elif groundRay.get_collision_normal().x < 0:
			$Flat.rotation = 90.0-45.0
			$SlideBox.rotation=-45
		else:
			$Flat.rotation = 90.0
			$SlideBox.rotation=0
		
	else:
		Animator.play("Walk")
	
	if velocity.x < 0.1 and velocity.x > -0.1:
		Animator.seek(0)
		Animator.stop()


func _physics_process(delta):
	if(alive):
		if inputMotion.x != 0:
			if (!slideYeetorNeet and abs(velocity.x) < MoveSpeed) or !((inputMotion.x < 0) == (velocity.x < 0)):
				velocity.x = lerp(velocity.x, inputMotion.x * MoveSpeed, Acceleration)
			elif groundRay.get_collision_normal().x > 0 and slideYeetorNeet:
				velocity.x = lerp(velocity.x, SlideSpeed, SlideAcceleration)
			elif groundRay.get_collision_normal().x < 0 and slideYeetorNeet:
				velocity.x = lerp(velocity.x, - SlideSpeed, SlideAcceleration)
		elif inputMotion.x == 0 and is_on_floor():
			if (groundRay.get_collision_normal() == UP_VECTOR or !slideYeetorNeet) and !didIjustslide:
				velocity.x = lerp(velocity.x, 0, Deacceleration)
			elif groundRay.get_collision_normal().x > 0 and slideYeetorNeet:
				velocity.x = lerp(velocity.x, SlideSpeed, SlideAcceleration)
			elif groundRay.get_collision_normal().x < 0 and slideYeetorNeet:
				velocity.x = lerp(velocity.x, - SlideSpeed, SlideAcceleration)
			elif didIjustslide:
				velocity.x = lerp(velocity.x, 0, SlideDeacceleration)
		
		if groundRay.get_collision_normal() != UP_VECTOR:
			move_and_slide_with_snap(velocity*delta, Vector2(0,snap), UP_VECTOR, false, 4, rad2deg(90))
		else:
			move_and_slide(velocity*delta, UP_VECTOR, stoponSlope)
		
		if is_on_floor():
			currentGlideTime=0.0
			currentJumpCount=0
			groundRay.force_raycast_update()


func _on_Hitbox_collision(area):
	pass # Replace with function body.

var canfinish=false
var alive =true
func KILL():
	alive=false
	$AnimatedSprite.play("start")
	$AnimatedSprite.visible=true
	canfinish = true
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	if canfinish:
		get_tree().change_scene("res://internal/scenes/Main.tscn")
		$AnimatedSprite.play("finish")
		canfinish=false
		$AnimatedSprite.visible=false
		alive=true
	pass # Replace with function body.
