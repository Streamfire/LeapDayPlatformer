extends Node

var Playernode = null
var Score = 0
var Time = 0.0
var running=false

func _ready():
	
	SoundControler.play_music("res://assets/audio/theme-1.wav",true)
	pass

func _process(delta):
	if running:
		Time+=delta
