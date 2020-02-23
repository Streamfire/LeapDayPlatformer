extends Node

var effect:AudioStreamPlayer


func _ready() -> void:
	effect = AudioStreamPlayer.new()
	effect.bus = "Effects"
	effect.connect("finished", self, "effect_finished")
	add_child(effect)

func play_effect(path:String):
	var stream = load(path)
	#AudioServer.set_bus_mute(1, true)
	effect.stop()
	effect.stream = stream
	effect.play()

func effect_finished() -> void:
	#AudioServer.set_bus_mute(1, false)
	pass
