extends RigidBody2D

export(float) var moveForce = 5.0
export(float) var maxSpeed = 5.0
export(float) var jumpForce=20.0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Playernode = self
	pass # Replace with function body.


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var movement = Vector2(0,0)
	
	if(Input.is_action_pressed("Move_Left")):
		movement=Vector2(-1,0)
	
	if(Input.is_action_pressed("Move_Right")):
		movement=Vector2(1,0)
	
	if(Input.is_action_just_pressed("Move_Jump")):
		apply_impulse(Vector2(),Vector2(0,jumpForce))
	
	add_force(Vector2(),movement.normalized()*delta*moveForce)
	pass
