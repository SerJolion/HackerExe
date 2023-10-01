@tool
extends Node2D

@export var color:Color = Color.GREEN : set = SetColor
@export var speed:float = 5 : set = SetSpeed

var Line:Line2D

func _ready():
	Line = $Line2D

func SetColor(value:Color):
	color = value
	if Line != null:
		Line.material.set("shader_parameter/color", color)

func SetSpeed(Value:float):
	speed = Value
	if Line != null:
		Line.material.set('shader_parameter/speed', speed)

func SetTo(Vector:Vector2):
	Line.set_point_position(1,Vector)
