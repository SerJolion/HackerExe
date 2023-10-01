@tool
extends Node2D

@export var Text:String = 'Block' : set = SetText
@export var CanHaveParent:bool = true
@export var CanHaveChild:bool = true
@export var BlockColor:Color = Color.GREEN : set = SetColor
@export var ColideBlockColor:Color = Color.YELLOW

var drag:bool = false
var World:Node2D

var BlockColide:Node2D
var Child:Node2D

var Line:Line2D
var Background:ColorRect
var TextLabel:Label
var AudioPlayer:AudioStreamPlayer

func _ready():
	Line = $Line2D
	Background = $Background
	TextLabel = $Background/Text
	AudioPlayer = $AudioStreamPlayer
	World = get_parent()
	Child = null
	BlockColide = null
	TextLabel.text = Text
	Background.color = BlockColor
	#$Area2D/CollisionShape2D.shape.size.x = 120

func _process(delta):
	if drag:
		position = get_global_mouse_position()

func Drag():
	#Поднимаем куб
	if get_parent() != World:
		AudioPlayer.play()
		get_parent().RemoveChild()
	z_index = 1
	drag = true

func Drop():
#Отпускаем куб
	if BlockColide != null:
		if CanHaveParent:
			if BlockColide != Child:
				BlockColide.AddChild(self)
				AudioPlayer.play()
				World.get_parent().ReadTextFromBlock()
	z_index = 0
	drag = false

func AddChild(CharBlock:Node2D):
	if CanHaveChild:
		if Child == null:
			Child = CharBlock
			CharBlock.reparent(self)
			Child.position = $ChildPosition.position
			Line.gradient.set_color(0,BlockColor)
			Line.gradient.set_color(1,Child.BlockColor)
			Line.show()

func RemoveChild():
	if Child != null:
		Child.reparent(World)
		Child.drag = true
		Child = null
		Line.hide()

func SetColor(value:Color):
	BlockColor = value
	if Background != null:
		Background.color = BlockColor

func SetText(value:String):
	Text = value
	if TextLabel != null:
		TextLabel.text = Text

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if drag:
					Global.CurrentScene.Drop()
					#Отпускаем куб
#					if BlockColide != null:
#						if CanHaveParent:
#							if BlockColide != Child:
#								BlockColide.AddChild(self)
#								AudioPlayer.play()
#								World.get_parent().ReadTextFromBlock()
#					z_index = 0
#					drag = false
				else:
					Global.CurrentScene.Drag(self)
					#Поднимаем куб
#					if get_parent() != World:
#						AudioPlayer.play()
#						get_parent().RemoveChild()
#					z_index = 1
#					drag = true

func _on_area_2d_area_entered(area):
	if area.get_groups().has('BlockAreas'):
		BlockColide = area.get_parent()
		Background.color = ColideBlockColor

func _on_area_2d_area_exited(area):
	if area.get_groups().has('BlockAreas'):
		BlockColide = null
		Background.color = BlockColor


func _on_text_item_rect_changed():
	pass
#	TextLabel.pivot_offset = TextLabel.size / 2
#	Background.size.x = TextLabel.size.x
#	Background.pivot_offset = Background.size/2
#	$Area2D/CollisionShape2D.shape.size.x = TextLabel.size.x
