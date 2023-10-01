extends Panel

var drag:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drag:
		var PosX = clamp(get_global_mouse_position().x,0,1366-size.x)
		var PosY = clamp(get_global_mouse_position().y,0,768-size.y)
		position = Vector2(PosX, PosY)

func SetTitle(Text:String):
	pass

func Drag():
	pass

func Drop():
	pass

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				drag = true
		else:
			if event.button_index == MOUSE_BUTTON_LEFT:
				drag = false
