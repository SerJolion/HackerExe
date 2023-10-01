extends Control

var PlayTimerSpinBox:SpinBox
#var Level2TimerSpunbox:SpinBox
var SoundLevelSLider:HSlider
var MusicLevelSlider:HSlider

func _ready():
	PlayTimerSpinBox = $SettingsPanel/MarginContainer/VBoxContainer/ScrollContainer/MainContainer/PlayTimeConteiner/SpinBox
	SoundLevelSLider = $SettingsPanel/MarginContainer/VBoxContainer/ScrollContainer/MainContainer/SoundLevelContainer/HSlider
	MusicLevelSlider = $SettingsPanel/MarginContainer/VBoxContainer/ScrollContainer/MainContainer/MusicLevelContainer/HSlider
	PlayTimerSpinBox.value = Global.GetSetting('PlayTime')
	#Level2TimerSpunbox.value = Global.GetSetting('Level2Time')
	SoundLevelSLider.value = Global.GetSetting('SoundLevel')
	MusicLevelSlider.value = Global.GetSetting('MusicLevel')


func _on_close_button_pressed():
	hide()


func _on_applay_button_pressed():
	Global.SetSetting('PlayTime', PlayTimerSpinBox.value)
	#Global.SetSetting('Level2Time',Level2TimerSpunbox.value)
	Global.SetSetting('SoundLevel', SoundLevelSLider.value)
	Global.SetSetting('MusicLevel', MusicLevelSlider.value)
