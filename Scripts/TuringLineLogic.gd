extends Node2D

@export var StartElements:Array[String] = []
@export var CarriageSpeed:float = 0.1

@export_file('*.tscn') var TuringElementScenePath:String

var CurrentIndex = 0
var Elements:Array = []
var Line:Node2D

var Carriage:Node2D
var NewCarriagePosition:Vector2
var CarriageMove:bool = false

var TuringElementScene:PackedScene
var NewElementPos:Vector2
var NewElementOffset:Vector2

signal ActionEnded
signal ActionError(ErrorName:String)

# Called when the node enters the scene tree for the first time.
func _ready():
	NewElementPos = position
	NewElementOffset = Vector2(100,0)
	Carriage = $TuringCairette
	Line = $Line
	TuringElementScene = load(TuringElementScenePath)
	for data in StartElements:
		AddElement(StartElements.find(data), data)
	Carriage.SetData(' ')
	CarrigeSetPosition(0)
#	for child in Line.get_children():
#		Elements.append(child)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if CarriageMove:
		var x = lerp(Carriage.position.x, NewCarriagePosition.x, CarriageSpeed)
		var y = Carriage.position.y
		var NewPosition = Vector2(x,y)
		Carriage.position = NewPosition
		if x >= NewCarriagePosition.x - CarriageSpeed and x<= NewCarriagePosition.x + CarriageSpeed:
			CarriageMove = false
			emit_signal("ActionEnded")
#		var MinPos = Vector2(NewCarriagePosition.x - CarriageSpeed, NewCarriagePosition.y)
#		var MaxPos = Vector2(NewCarriagePosition.x + CarriageSpeed, NewCarriagePosition.y)
#		if Carriage.position in range(MinPos, MaxPos):
#			Carriage.position = NewCarriagePosition
#			CarriageMove = false
#			emit_signal("ActionEnded")
#		if test1 and test2:
#			Carriage.position = NewCarriagePosition
#			CarriageMove = false
#			emit_signal("ActionEnded")
#	if Input.is_action_just_pressed("ui_left"):
#		CarrigeMove(CurrentIndex-1)
#	if Input.is_action_just_pressed("ui_right"):
#		CarrigeMove(CurrentIndex+1)
#	if Input.is_action_just_pressed("ui_up"):
#		CarrigeTake()
#	if Input.is_action_just_pressed("ui_down"):
#		CarrigePut()

func AddElement(Index:int, data:String):
	var NewElement:Node2D = TuringElementScene.instantiate()
	Line.add_child(NewElement)
	NewElement.SetIndex(Index)
	NewElement.SetData(data)
	Elements.append(NewElement)
	NewElement.position = NewElementPos
	NewElementPos += NewElementOffset

func RemoveElemen(index:int):
	pass

func GetCurrentData()->Array:
	var Data:Array = []
	for i in Line.get_child_count():
		Data.append(Line.get_child(i).GetData())
	return Data

func CarrigeSetPosition(index:int):
	if index < 0:
		PushError('Каретка вышла за левый индекс')
	elif index > len(Elements)-1:
		PushError('Каретка вышла за провый индекс')
	CurrentIndex = clamp(index, 0, len(Elements)-1)
	var NewPosition:Vector2 = Elements[CurrentIndex].position
	NewPosition.y -= 5
	CarriageMove = false
	Carriage.position = NewPosition

func CarrigeMove(index:int):
	if index < 0:
		PushError('Каретка вышла за левый индекс')
	elif index > len(Elements)-1:
		PushError('Каретка вышла за провый индекс')
	CurrentIndex = clamp(index, 0, len(Elements)-1)
	var NewPosition:Vector2 = Elements[CurrentIndex].position
	NewPosition.y -= 5
	NewCarriagePosition = NewPosition
	CarriageMove = true
	#Carriage.position = NewPosition

func CarrigeMoveLeft():
	CarrigeSetPosition(CurrentIndex - 1)
	#CarrigeMove(CurrentIndex-1)

func CarrigeMoveRight():
	CarrigeSetPosition(CurrentIndex + 1)
	#CarrigeMove(CurrentIndex+1)

func CarrigeMoveToStart():
	CarrigeSetPosition(0)
	#CarrigeMove(0)

func CarrigeMoveToEnd():
	CarrigeSetPosition(len(Elements)-1)
	#CarrigeMove(len(Elements)-1)

func CarrigeTake():
	var CurrentElement = Elements[CurrentIndex]
	if CurrentElement.GetData() != ' ':
		if Carriage.GetData() == ' ':
			Carriage.SetData(CurrentElement.GetData())
			CurrentElement.SetData(' ')
		else:
			PushError('Каретка заполнена')
	else:
		PushError('Ячейка: {0} пуста'.format([CurrentIndex]))
	emit_signal("ActionEnded")

func CarrigePut():
	var CurrentElement = Elements[CurrentIndex]
	if CurrentElement.GetData() == ' ':
		if Carriage.GetData() != ' ':
			CurrentElement.SetData(Carriage.GetData())
			Carriage.SetData(' ')
		else:
			PushError('Каретка пуста')
	else:
		PushError('Ячейка: {0} уже зполнена'.format([CurrentIndex]))
	emit_signal("ActionEnded")

func CarrigeIsEpmty()->bool:
	return Carriage.GetData() == ' '

func PushError(ErrorName:String):
	emit_signal("ActionError", ErrorName)

func ClearLine():
	for child in Line.get_children():
		child.queue_free()

func Reset():
	for i in len(StartElements):
		Line.get_child(i).SetData(StartElements[i])
	Carriage.SetData(' ')
	CarrigeSetPosition(0)
