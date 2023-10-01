extends Node2D

@export var Index:int = 0
@export var Data:String = '[0]'

var IndexLabel:Label
var DataLabel:Label

func _ready():
	IndexLabel = $Panel/VBoxContainer/IndexLabel
	DataLabel = $Panel/VBoxContainer/DataLabel

func GetData():
	return Data

func SetIndex(value):
	Index = value
	IndexLabel.text = str(value)

func SetData(value):
	Data = str(value)
	DataLabel.text = '[{0}]'.format([Data]) 
