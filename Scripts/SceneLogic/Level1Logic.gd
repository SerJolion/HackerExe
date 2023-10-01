extends Node2D

@export var WinCode:String = '@#@@@@#@##@@@##@@####@@##@#'
@export_multiline var WinMessage:String = 'Ты победил'
@export_multiline var FailMessage:String = 'Ты проиграл'

var GraphMatrix:Array

var GameTimer:Timer
var UpdateResultTimer:Timer
var Graph:Node2D

var MatrixPanel:Panel
var TimerPanel:Panel
var ResultPanel:Panel
var MessageBox:Control
var AudioPlayer:AudioStreamPlayer

var VertexName:Dictionary = {0:'Нач',1:' А ',2:' Б ',3:' В ',4:' Г ',5:' Д ',6:' Е ',7:' Ж '}
var ResultUpdateTime:float = 10
var CodeShowSpeed:int = 1
var PlayerPath:Array = []
var PlayerWin:bool = false

func _ready():
	Global.CurrentScene =  self
	Global.SetPause(false)
	Graph = $Graph
	MatrixPanel = $CanvasLayer/Control/Panel/VBoxContainer/MatrixPanel
	TimerPanel = $CanvasLayer/Control/Panel/VBoxContainer/TimerPanel2
	TimerPanel.MaxValue = Global.PlayTime
	TimerPanel.SetValue(Global.PlayTime)
	ResultPanel = $CanvasLayer/Control/Panel/VBoxContainer/ResultPanel
	MessageBox = $CanvasLayer/MassageBox
	AudioPlayer = $AudioStreamPlayer
	SetResultText(WinCode)
	GameTimer = $FailTimer
	GameTimer.start()
	UpdateResultTimer = $UpdateResultTimer
	UpdateResultTimer.wait_time = ResultUpdateTime
	#GraphVertexScene = load(GraphScenePath)
	GraphMatrix =  [[0,0,1,1,0,0],
					[0,0,1,0,0,3],
					[0,0,0,0,0,1],
					[0,0,0,0,1,4],
					[0,0,0,0,0,5],
					[0,0,0,0,0,0]]
	Graph.CreateGraph(GraphMatrix)
	CreateMatrix(GraphMatrix)

func _process(delta):
	pass

func UpdateDataPanel(conection:bool, speed:int):
	var ConectionLabel:Label = $CanvasLayer/Control/Panel/VBoxContainer/DataPanel/VBoxContainer/Label2
	var SpeedLabel:Label = $CanvasLayer/Control/Panel/VBoxContainer/DataPanel/VBoxContainer/Label3
	if conection:
		ConectionLabel.text = 'Подключено'
		ConectionLabel.set('theme_override_colors/font_color',Color.GREEN)
	else:
		ConectionLabel.text = 'Нет'
		ConectionLabel.set('theme_override_colors/font_color',Color.RED)
	SpeedLabel.text = str(speed)

func SetResultText(text:String):
	var ResultLabel:Label = $CanvasLayer/Control/Panel/VBoxContainer/ResultPanel/VBoxContainer/Label
	ResultLabel.text = text

func UpdateResultPanel():
	var ResultLabel:Label = $CanvasLayer/Control/Panel/VBoxContainer/ResultPanel/VBoxContainer/Label
	var ResulProgress:ProgressBar = $CanvasLayer/Control/Panel/VBoxContainer/ResultPanel/VBoxContainer/ProgressBar
	ResultLabel.visible_characters += 1
	ResulProgress.value = ResultLabel.visible_ratio * 100
	if ResultLabel.visible_ratio == 1:
		Global.Level1Code = WinCode
		PlayerWin = true
		Global.SetPause(true)
		#$FailTimer.stop()
		#$CanvasLayer/Control.hide()
		MessageBox.Message = WinMessage
		#Graph.hide()
		MessageBox.show()
		#Здесь условие выигрыша (Надо перенести проверку на попеду в другое место)

func CreateMatrix(Matrix:Array):
	var MatrixLabel = MatrixPanel.get_child(0).get_child(1)
	var MatrixText = '[center][table='+str(Matrix.size()+1)+']'
	MatrixText += '[cell] [/cell]'
	for index in Matrix[0].size():
		if index == Matrix[0].size()-1:
			MatrixText += '[cell]Кон[/cell]'
			break
		MatrixText += '[cell]' + VertexName[index] + '[/cell]'
	for i in Matrix.size():
		if i == Matrix.size()-1:
			MatrixText +='[cell]Кон[/cell]'
		else:
			MatrixText += '[cell]'+VertexName[i]+'[/cell]'
		for j in Matrix[i].size():
			MatrixText = MatrixText+'[cell]'+str(Matrix[i][j])+'[/cell]'
	MatrixText+='[/table][/center]'
	MatrixLabel.text = MatrixText

func StartResultTimer(WaitTime):
	UpdateResultTimer.wait_time = WaitTime
	UpdateResultTimer.start()

func StopResultTimer():
	UpdateResultTimer.stop()

func _on_timer_timeout():
	Global.PlayTime -= 1
	TimerPanel.Value = Global.PlayTime
	if Global.PlayTime <= 0:
		#Здесь проверяется условие проигрыша!
		MessageBox.Message = FailMessage
		$CanvasLayer/Control.hide()
		Graph.hide()
		$CanvasLayer/MassageBox.show()

func _on_update_result_timer_timeout():
	UpdateResultPanel()

func _on_massage_box_close_button_click():
	pass # Replace with function body.

func _on_massage_box_continue_button_click():
	if PlayerWin:
		Global.SwitchScene(2)
	else:
		Global.SwitchScene(0)
