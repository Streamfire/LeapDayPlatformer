extends Node

const EffectLayers = 3
var effect:Array = []

var music: AudioStreamPlayer
var loop:bool = true

func _ready() -> void:
	
	music = AudioStreamPlayer.new()
	music.bus = "BGM"
	music.connect("finished",self,"music_finished")
	add_child(music)
	
	for i in range(0,EffectLayers):
		effect.append(AudioStreamPlayer.new())
		effect[i].bus = str("Effects",i)
		effect[i].connect("finished", self, "effect_finished")
		add_child(effect[i])

func play_music(path:String,shouldLoop:bool=true):
	var stream = load(path)
	#AudioServer.set_bus_mute(1, true)
	music.stop()
	music.stream = stream
	music.play()
	loop=shouldLoop

func play_effect(path:String,layer:int=0):
	var stream = load(path)
	#AudioServer.set_bus_mute(1, true)
	effect[layer].stop()
	effect[layer].stream = stream
	effect[layer].play()

func music_finished() -> void:
	#AudioServer.set_bus_mute(1, false)
	if loop :
		music.stop()
		music.play()
	pass

func effect_finished() -> void:
	#AudioServer.set_bus_mute(1, false)
	pass
