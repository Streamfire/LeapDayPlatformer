extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Scorelabel.text = str("Score: ",Global.Playernode.velocity.x,"\nTime: ",stepify(Global.Time,0.01))
	pass
