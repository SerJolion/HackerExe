@tool
extends Panel

@export var Title:String = 'Время': set = SetTitle
@export var TitleColor:Color = Color.YELLOW: set = SetTitleColor
@export var MaxValue:int = 100
@export var Value:int = 100: set = SetValue

var TitleLabel:Label
var ValueLabel:Label
var ValueLabelColor:Color
var AnimPlayer:AnimationPlayer

func _ready():
	TitleLabel = $TimerContainer/Title
	TitleLabel.text = Title
	TitleLabel.set('theme_override_colors/font_color', TitleColor)
	ValueLabel = $TimerContainer/Value
	ValueLabel.text = str(Value)
	AnimPlayer = $AnimationPlayer

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
	if ValueLabel != null:
		ValueLabel.text = str(Value)
		var percent = (Value * 100) / MaxValue
		if percent < 25:
			ValueLabel.set('theme_override_colors/font_color', Color.RED)
			AnimPlayer.play('ValueClick')
		elif percent > 25 and percent < 50:
			ValueLabel.set('theme_override_colors/font_color', Color.YELLOW)
		elif percent > 50:
			ValueLabel.set('theme_override_colors/font_color', Color.GREEN)
