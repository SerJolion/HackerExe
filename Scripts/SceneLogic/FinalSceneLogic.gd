extends Node2D

var Exit:bool = false
var CountOfMistaces:int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.CurrentScene =  self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_anything_pressed():
		if Input.is_action_just_pressed("ui_accept"):
			if CountOfMistaces > 0:
				Exit = true
				$VoicePlayer.stream = load('res://Sounds/Voice3.mp3')
				$VoicePlayer.play()
			else:
				Global.Exit()
		else:
			if $VoicePlayer.playing == false:
				$VoicePlayer.play()
			CountOfMistaces += 1

func _on_voice_player_finished():
	if Exit:
		Global.Exit()
