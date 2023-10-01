@tool
extends Control

@export var TitleText:String = 'Заголовок': set = SetTitle
@export_multiline var Message:String = 'Текст окна': set = SetMessageText
@export var ShowCharTime:float = 0.05
@export_file('*.mp3') var CharSound = 'res://Sounds/BlockClick.mp3':set = SetCharSound

signal CloseButtonClick
signal ContinueButtonClick

var Title:Label
var CloseButton:Button
var ContinueButton:Button
var MainContainer:VBoxContainer
var MessageText:RichTextLabel
var AudioPlayer:AudioStreamPlayer

var isShowText:bool = false
var CurrentCharTime:float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Title = $Panel/MarginContainer/MainContainer/HBoxContainer/Title
	CloseButton = $Panel/MarginContainer/MainContainer/HBoxContainer/CloseButton
	MessageText = $Panel/MarginContainer/MainContainer/RichTextLabel
	MainContainer = $Panel/MarginContainer/MainContainer
	ContinueButton = $Panel/MarginContainer/MainContainer/ContinueButton
	AudioPlayer = $AudioStreamPlayer
	Title.text = TitleText
	MessageText.text = Message
	#Global.SetPause(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isShowText:
		CurrentCharTime += delta
		if CurrentCharTime >= ShowCharTime:
			MessageText.visible_characters += 1
			AudioPlayer.play()
			CurrentCharTime = 0
			if MessageText.visible_ratio == 1:
				AudioPlayer.stop()
				isShowText = false

func SetTitle(value:String):
	TitleText = value
	if Title != null:
		Title.text = value

func SetMessageText(Text:String):
	Message = Text
	if MessageText != null:
		MessageText.text = Text

func SetCharSound(value:String):
	CharSound = value
	if AudioPlayer != null:
		AudioPlayer.stream = load(CharSound)

func ShowText():
	MessageText.visible_ratio = 0
	isShowText = true

func ShowAllText():
	isShowText = false
	AudioPlayer.stop()
	MessageText.visible_ratio = 1

func _on_button_pressed():
	#Global.SetPause(false)
	emit_signal('CloseButtonClick')
	queue_free()

func _on_continue_pressed():
	#Global.SetPause(false)
	isShowText = false
	MessageText.visible_ratio = 1
	emit_signal('ContinueButtonClick')

func _on_draw():
	ShowText()

func _on_panel_gui_input(event):
	if event is InputEventMouseButton:
		ShowAllText()
