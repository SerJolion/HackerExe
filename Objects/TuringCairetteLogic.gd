extends Node2D

@export var Data:String

var DataLabel:Label

func _ready():
	DataLabel = $Bacground/DataLabel

func SetData(value:String)->void:
	Data = value
	DataLabel.text = '[{0}]'.format([Data])

func GetData()->String:
	return Data
