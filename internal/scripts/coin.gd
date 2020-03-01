extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StaticBody2D_area_entered(area):
	Global.Score += 1
	SoundControler.play_effect("res://assets/audio/jump-glide.wav")
	self.queue_free()
	pass # Replace with function body.
