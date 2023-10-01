extends Node2D

@export var Code = 'введите закодированное сообщение'
@export var CodeChars:PackedStringArray
@export_multiline var WinMessage:String = 'Ты победил'
@export_multiline var FailMessage:String = 'Ты проиграл'

var CharBlockScene:PackedScene
var CodeTable:Dictionary = {}

var PlayerWin = false

var is_drag:bool = false
var DraggingObject = null

var dragable_object:Node2D = null

var StartCharBlock:Node2D
var EndCharBlock:Node2D
var AudioPlayer:AudioStreamPlayer
var TimerPanel:Panel
var ProgressPanel:Panel

func _ready():
	CharBlockScene = load('res://Objects/CharBlock.tscn')
	#PlayTime = Global.GetSetting('Level1Time')
	Global.CurrentScene =  self
	StartCharBlock = $World/StartCharBlock
	EndCharBlock = $World/EndCharBlock
	AudioPlayer = $MusicPlayer
	TimerPanel = $CanvasLayer/Control/Panel/Container/TimerPanel
	TimerPanel.MaxValue = Global.PlayTime
	TimerPanel.SetValue(Global.PlayTime)
	ProgressPanel = $CanvasLayer/Control/Panel/Container/ProgressPanel
	ProgressPanel.MaxValue = len(Code)
	AudioPlayer.volume_db = Global.GetSetting('MusicLevel')
	Global.SetPause(false)
	CodeTable = CreateCodeDict(Code, CodeChars)
	$CanvasLayer/Control/CodeMAssagePanel/VBoxContainer/Label.text = EncodeAString(Code, CodeTable)
	CreateCharBlocks()
	for key in CodeTable.keys():
		var Line = Label.new()
		Line.text = key + ' = ' + CodeTable[key]
		$CanvasLayer/Control/Panel/Container/Panel/VBoxContainer/GridContainer.add_child(Line)

func _process(delta):
	pass

func Drag(Obj):
	if !is_drag:
		is_drag = true
		DraggingObject = Obj
		Obj.Drag()

func Drop():
	if is_drag:
		is_drag = false
		DraggingObject.Drop()
		DraggingObject = null

func reverse_string(s:String):
	var r := ""
	for i in range(s.length()-1, -1, -1):
		r += s[i]
	return r

#Доделать!!!!!!!!!!!!
# Функция получает строку и массив символов, а затем из этих символов создает
# Создает словарь, который содержит код выполняющий условие фано
func CreateCodeDict(Str:String, CodeChars:Array):
	var CodeDict:Dictionary = { }
	var vertex_index = 0
	#---- Выбираем буквы из которых сотоит строка
	for char in Str:
		if not( char in CodeDict.keys()):
			CodeDict[char] = ' '
	#---------------------------------------------
	#---- Генерация графа ------------------------
	var Graph:Dictionary = {}
	var LeafIndexes:Array = []
	Graph[vertex_index] = { }
	LeafIndexes.append(vertex_index)
	vertex_index += 1;
	while LeafIndexes.size() < CodeDict.keys().size():
		var Leaf = LeafIndexes.pop_front()
		var CurrentLeaf:Dictionary = Graph[Leaf]
		for i in CodeChars.size():
			var NewVertex:Dictionary = {Leaf:CodeChars[i]}
			Graph[vertex_index] = NewVertex
			LeafIndexes.append(vertex_index)
			vertex_index += 1
		LeafIndexes.erase(Leaf)
		if LeafIndexes.size() >= CodeDict.keys().size():
			break;
	#-----------------------------------------------------------------
	var LeafIndex = 0
	for char in CodeDict.keys():
		var CodeStr = ''
		var CurrentVertex:Dictionary = Graph[LeafIndexes[LeafIndex]]
		LeafIndex += 1
		while len(CurrentVertex.values()) > 0:
			CodeStr += CurrentVertex.values()[0]
			CurrentVertex = Graph[CurrentVertex.keys()[0]]
		CodeDict[char] = reverse_string(CodeStr)
	#---------------------------------------------
	return CodeDict

#--------- Кодирует строку полученными кодовыми словами из словаря --------
func EncodeAString(Str:String, CodeDict:Dictionary)->String:
	var result:String = ''
	for char in Str:
		if char in CodeDict.keys():
			result += CodeDict[char]
	return result

func ReadTextFromBlock():
	var text:String = ''
	var CurrentCharBlock = StartCharBlock
	while CurrentCharBlock != EndCharBlock:
		if CurrentCharBlock == null:
			break
		if CurrentCharBlock==StartCharBlock:
			CurrentCharBlock = CurrentCharBlock.Child
			continue
		text += CurrentCharBlock.Text
		CurrentCharBlock = CurrentCharBlock.Child
	if CurrentCharBlock == EndCharBlock:
		CheckWin(text)
		print(text)

func CreateCharBlocks():
	var CharBlockArray:Array = []
	var Coords:Vector2 = Vector2(200, 550)
	for char in Code:
		var NewCharBlock:Node2D = CharBlockScene.instantiate()
		$World.add_child(NewCharBlock)
		NewCharBlock.SetText(char)
		CharBlockArray.append(NewCharBlock)
	var Index: = 0
	while  len(CharBlockArray) > 0:
		Index = randi_range(0, len(CharBlockArray)-1)
		CharBlockArray.pop_at(Index).position = Coords
		Coords.x += 70
		

func CheckWin(Text:String):
	var WinStringLength:float = Code.length()
	var CurrentOverlap:float = 0
	for i in Text.length():
		if i < WinStringLength:
			if Text[i] == Code[i]:
				CurrentOverlap += 1
				if CurrentOverlap == WinStringLength:
					#здесь условые выигрыша
					PlayerWin = true
					#$World.hide()
					#$CanvasLayer/Control/Panel.hide()
					#$CanvasLayer/Control/CodeMAssagePanel.hide()
					Global.SetPause(true)
					$CanvasLayer/Control/MassageBox.Message = WinMessage
					$CanvasLayer/Control/MassageBox.show()
	var Test:float = CurrentOverlap/WinStringLength
	UpdateProgress(Test * 100)

func UpdateProgress(value:float):
	ProgressPanel.SetValue(value)

func DisplayTime():
	TimerPanel.SetValue(Global.PlayTime)

func _on_fail_timer_timeout():
	Global.PlayTime -= 1
	if Global.PlayTime <= 0:
		$World.hide()
		$CanvasLayer/Control/Panel.hide()
		$CanvasLayer/Control/CodeMAssagePanel.hide()
		$CanvasLayer/Control/MassageBox.Message = FailMessage
		$CanvasLayer/Control/MassageBox.show()
	DisplayTime()

func _on_massage_box_continue_button_click():
	if PlayerWin:
		Global.SwitchScene(4)
	else:
		Global.SwitchScene(0)

func _on_massage_box_close_button_click():
	pass # Replace with function body.
