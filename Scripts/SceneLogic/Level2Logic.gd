extends Node2D

@export var WinCode:String = '000001010011100101110111 '
@export_range(0.1, 5, 0.1) var ExecutionSpeed:float = 0.5 # На самом деле это не скорость, а время выполнения одно шага кода
@export_multiline var WinMessage:String = 'Ты победил'
@export_multiline var FailMessage:String = 'Ты проиграл'

var CharBlockScene:PackedScene

var LineIndex:int = 0: set = SetLineIndex
var isCodeRunning = false

var TimerPanel:Panel
var LineIndexLabel:Label
var OutputLineLabel:Label
var ProgrammField:TextEdit
var TuringLine:Node2D
var GameTimer:Timer
var CodeRunningTimer:Timer
var MusicPlayer:AudioStreamPlayer

var StartCodeButton:Button
var StepCodeButton:Button
var ResetCodeButton:Button

# Called when the node enters the scene tree for the first time.
func _ready():
	
	GameTimer = $GameTimer
	CodeRunningTimer = $CodeRunningTimer
	CodeRunningTimer.wait_time = ExecutionSpeed
	LineIndexLabel = $CanvasLayer/Control/CodePanel/VBoxContainer/HBoxContainer/LineIndex
	OutputLineLabel = $CanvasLayer/Control/CodePanel/VBoxContainer/HBoxContainer/OutputLine
	ProgrammField = $CanvasLayer/Control/CodePanel/VBoxContainer/TextEdit
	TuringLine = $TuringLine
	StepCodeButton = $CanvasLayer/Control/CodePanel/VBoxContainer/HBoxContainer/StepCodeButton
	StartCodeButton = $CanvasLayer/Control/CodePanel/VBoxContainer/HBoxContainer/StartCodebutton
	ResetCodeButton = $CanvasLayer/Control/CodePanel/VBoxContainer/HBoxContainer/ResetCodeButton
	MusicPlayer = $MusicPlayer 
	TimerPanel = $CanvasLayer/Control/Panel/VBoxContainer/TimerPanel
	TimerPanel.MaxValue = Global.PlayTime
	TimerPanel.SetValue(Global.PlayTime)
	Global.SetPause(false)

func _process(delta):
	pass

func SetExecutionSpeed():
	pass

func WinCheck():
	var string:String = ''
	for data in TuringLine.GetCurrentData():
		string += data
	if string == WinCode:
		$CanvasLayer/Control/MassageBox.Message = WinMessage
		$CanvasLayer/Control/MassageBox.show()
		$CanvasLayer/Control/MassageBox.ContinueButtonClick.connect(func():Global.SwitchScene(3))

func FailCheck():
	if Global.PlayTime <= 0:
		Global.SetPause(true)
		$CanvasLayer/Control/MassageBox.Message = FailMessage
		$CanvasLayer/Control/MassageBox.show()
		$CanvasLayer/Control/MassageBox.ContinueButtonClick.connect(func():Global.SwitchScene(0))

func DoCommand(Line:String):
	var SplitLine = Line.to_lower().split(' ')
	var Command = SplitLine[0]
	var Argument:String = ' '
	if len(SplitLine) > 1:
		Argument = SplitLine[1]
	match Command:
		'speed':
			if Argument != ' ':
				pass
			else:
				print('Ошибка аргумента')
		'move_to':
			if Argument != ' ':
				TuringLine.CarrigeSetPosition(int(Argument))
			else:
				print('Ошибка аргумента')
		'move_to_start':
			TuringLine.CarrigeMoveToStart()
		'move_to_end':
			TuringLine.CarrigeMoveToEnd()
		'left':
			TuringLine.CarrigeMoveLeft()
		'right':
			TuringLine.CarrigeMoveRight()
		'take':
			TuringLine.CarrigeTake()
		'put':
			TuringLine.CarrigePut()
		_:
			OutputLineLabel.set('theme_override_colors/font_color',Color.RED)
			OutputLineLabel.text = 'Ошибка: команда {0} отсутствует'.format([Command])

func DoCodeStep():
	if LineIndex < ProgrammField.get_line_count():
		var CurrentLine = ProgrammField.get_line(LineIndex)
		if CurrentLine != '':
			DoCommand(CurrentLine)
			LineIndex += 1
		else:
			if LineIndex == ProgrammField.get_line_count()-1:
				LineIndex += 1
			else:
				OutputLineLabel.set('theme_override_colors/font_color',Color.RED)
				OutputLineLabel.text = 'Ошибка: пустая строка'
				isCodeRunning = false
	else:
		OutputLineLabel.set('theme_override_colors/font_color',Color.GREEN)
		OutputLineLabel.text = 'Программа завершена'
		#Проверка выиграша!!!!!
		WinCheck()
		if isCodeRunning:
			StartCodeButton.disabled = false
			StepCodeButton.disabled = false
			CodeRunningTimer.stop() 
			isCodeRunning = false

func SetLineIndex(value:int):
	LineIndex = value
	LineIndexLabel.text = 'Текущая трока:{0}'.format([value])

func _on_start_codebutton_pressed():
	TuringLine.Reset()
	LineIndex = 0
	StepCodeButton.disabled = true
	StartCodeButton.disabled = true
	isCodeRunning = true
	OutputLineLabel.set('theme_override_colors/font_color',Color.GREEN)
	OutputLineLabel.text = 'Выполнение программы'
	CodeRunningTimer.start()

func _on_step_code_button_pressed():
	StepCodeButton.disabled = true
	StartCodeButton.disabled = true
	DoCodeStep()

func _on_turing_line_action_error(ErrorName):
	OutputLineLabel.set('theme_override_colors/font_color',Color.RED)
	OutputLineLabel.text = 'Ошибка: ' + ErrorName

func _on_reset_code_button_pressed():
	TuringLine.Reset()
	LineIndex = 0
	StartCodeButton.disabled = false
	StepCodeButton.disabled = false

#func _on_turing_line_action_ended():
#	if isCodeRunning:
#		DoCodeStep()
#	else:
#		StartCodeButton.disabled = false
#		StepCodeButton.disabled = false

func _on_game_timer_timeout():
	Global.PlayTime -= 1
	TimerPanel.SetValue(Global.PlayTime)
	FailCheck()


func _on_code_running_timer_timeout():
	DoCodeStep()
