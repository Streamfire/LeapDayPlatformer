extends Node2D

export(float) var moveSpeed = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.Playernode = self
	pass # Replace with function body.


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement = Vector2(0,0)
	
	if(Input.is_action_pressed("Move_Left")):
		movement=Vector2(-1,0)
	
	if(Input.is_action_pressed("Move_Right")):
		movement=Vector2(1,0)
	
	self.translate(movement.normalized()*delta*moveSpeed)
	pass
