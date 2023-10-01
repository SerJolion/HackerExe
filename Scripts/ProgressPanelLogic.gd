@tool
extends Panel

@export var Title:String = 'Прогресс': set = SetTitle
@export var TitleColor:Color = Color.YELLOW: set = SetTitleColor
@export var MaxValue:int = 100
@export var Value:int = 0: set = SetValue

var TitleLabel:Label
var Progrerss:ProgressBar

func _ready():
	TitleLabel = $Container/Title
	Progrerss = $Container/Progress
	Progrerss.max_value = MaxValue
	Progrerss.min_value = 0

func SetTitle(value:String):
	Title = value
	if TitleLabel != null:
		TitleLabel.text = value

func SetTitleColor(value:Color):
	TitleColor = value
	if TitleLabel != null:
		TitleLabel.set('theme_override_colors/font_color', value)

func SetValue(value:int):
	Value = clamp(value, 0, MaxValue)
	if Progrerss != null:
		Progrerss.value = Value
