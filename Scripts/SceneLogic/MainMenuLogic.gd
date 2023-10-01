extends Node2D

var isShadet = false

var TextInput:LineEdit
var AudioPlayer:AudioStreamPlayer
var HelpPanel:Panel
var SettingPanel:Control
var LogoAnimator:AnimationPlayer

var JokeButtonClickCount:int = 0
var HasJokeAchivment:bool = false

func _ready():
	Global.CurrentScene =  self
	Global.SetPause(false)
	TextInput = $CanvasLayer/Control/VBoxContainer/LineEdit
	AudioPlayer = $AudioStreamPlayer
	AudioPlayer.volume_db = Global.GetSetting('MusicLevel')
	HelpPanel = $CanvasLayer/Control/HelpPanel
	LogoAnimator = $Sprite2D/AnimationPlayer
	SettingPanel = $CanvasLayer/Control/SettingsPanel
	LogoAnimator.play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var StringArr = TextInput.text.split(" ")
		if StringArr.size() > 1:
			DoCommand(StringArr[0], StringArr[1])
		else:
			DoCommand(StringArr[0])
		TextInput.text = ''

func DoCommand(Comand:String, Argument:String=" "):
	var c = Comand.to_upper()
	var a = Argument.to_upper()
	if c == "EXIT":
		Global.Exit()
	elif c == "START":
		$CanvasLayer/Control.hide()
		$Sprite2D.hide()
		$CanvasLayer/MassageBox.show()
	elif c == 'HELP':
		ShowHelpPanel()
	elif c == 'SOUND':
		if a == 'ON':
			SoundEnable(true)
		elif a == 'OFF':
			SoundEnable(false)
	elif c == 'SETTINGS':
		SettingPanel.show()
	else:
		print(Argument, Comand)

func ShowHelpPanel():
	HelpPanel.show()

func SoundEnable(value:bool):
	if value:
		AudioPlayer.play()
	else:
		AudioPlayer.stop()

func _on_massage_box_continue_button_click():
	Global.SwitchScene(1)

func _on_button_pressed():
	match JokeButtonClickCount:
		0:
			$VoicePlayer.play()
		1:
			$CanvasLayer/Control/Panel/AnimationPlayer.play("First")
			$CanvasLayer/Control/Panel/AnimationPlayer.queue("Second")
		2:
			Global.Exit()
	JokeButtonClickCount += 1
