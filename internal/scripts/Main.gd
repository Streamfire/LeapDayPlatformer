extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.running=true
	Global.Time=0.0
	Global.Score=0
	
	if(Global.Checkpoint!= Vector2()):
		$Player.global_position=Vector2(Global.Checkpoint.x,Global.Checkpoint.y-20)
		Global.Time=Global.CheckpointTime
#		$Player/Camera2D.position=$Player.position
#		$Player/RayCast2D.position=$Player.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
