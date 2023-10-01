extends Node

var CurrentScene:Node2D
var Scenes:Array = []
var MouseBusy:bool = false

#var Password:='ДЕЗИНТЕГРАЦИЯ'
#var CodeChars = ['@','#','$','%','*','-','!']
var CodeTable:Dictionary = {}

var PlayTime:int = 500
var HitCost:int = 30
var Level1Code:String = ''
var Level2Code:String = ''

var Settings:Dictionary = {'SoundLevel':0,
							'MusicLevel':0,
							'PlayTime':60}

var MessageBoxScene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	MessageBoxScene = load('res://Objects/GUI_Objects/MassageBox.tscn')
	Scenes.append("res://Scenes/MainMenu.tscn")
	Scenes.append("res://Scenes/Level1.tscn")
	Scenes.append("res://Scenes/Level2.tscn")
	Scenes.append("res://Scenes/Level3.tscn")
	Scenes.append('res://Scenes/FinalScene.tscn')

func _process(delta):
	pass

func SwitchScene(Index:int):
	if Index < Scenes.size():
		get_tree().change_scene_to_file(Scenes[Index])

func SetSetting(SettingName:String, Value):
	if SettingName in Settings.keys():
		Settings[SettingName] = Value
	else:
		push_warning('Настройки с именем {0} не существует'.format(SettingName))

func GetSetting(SettingName:String):
	if SettingName in Settings.keys():
		return Settings[SettingName]
	else:
		push_warning('Настройки с именем {0} не существует'.format(SettingName))
		return null

func SetPause(value:bool):
	get_tree().paused = value

func SaveSettings():
	pass

func LoadSettings():
	pass

func Exit():
	get_tree().quit()
