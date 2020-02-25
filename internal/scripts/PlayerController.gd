extends KinematicBody2D

#moving
export(float) var MoveSpeed = 50.0
export(float) var Acceleration = 0.2
export(float) var Deacceleration = 0.7
#jumping
export(float) var jumpForce=250.0
export(float) var gravity=200.0


var inputMotion = Vector2()
var velocity = Vector2()



func _ready():
	Global.Playernode = self


func _process(_delta):
	#walking
	if Input.is_action_pressed("Move_Left"):
		inputMotion.x= -1
	elif Input.is_action_pressed("Move_Right"):
		inputMotion.x= 1
	else:
		inputMotion.x=0


func _physics_process(delta):
	if inputMotion.x != 0:
		velocity.x = lerp(velocity.x, inputMotion.x * MoveSpeed, Acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, Deacceleration)
		
	move_and_slide(velocity*delta)
	pass
