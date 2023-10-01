extends Node2D

@export_file var EdgeScenePath:String
@export var Index:int = 0

var drag = false
var Colision = false
var EdgeScene:PackedScene
var GraphObject:Node2D
var NeighBors:Dictionary = {}
var Edges:Dictionary = {}

func _ready():
	EdgeScene = load(EdgeScenePath)

func _process(delta):
	if drag:
		position = get_global_mouse_position()
	update_lines()

func SetColor(color:Color):
	$ColorRect.color = color

func SetEdgeColor(Vertex:Node2D, color:Color):
	if Edges.keys().has(Vertex):
		var Edge = Edges[Vertex]
		Edge.SetColor(color)

func ResetEdgeColor():
	for key in Edges.keys():
		Edges[key].SetColor(Color.GREEN)

func SetTextColor(color:Color):
	$Label.modulate = color

func SetText(Text:String):
	$Label.text = Text

func add_nighbor(GraphVertex:Node2D, TransitionCost:int):
	if !NeighBors.keys().has(GraphVertex):
		NeighBors[GraphVertex] = TransitionCost
		var Edge:Node2D = EdgeScene.instantiate()
		add_child(Edge)
		Edge.SetTo(GraphVertex.position)
		Edges[GraphVertex] = Edge

func HasNighbor(Vertex:Node2D)->bool:
	return NeighBors.keys().has(Vertex)

func update_lines():
	for key in Edges.keys():
		Edges[key].SetTo(key.position - position)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if drag:
					GraphObject.DropVertex()
				else:
					GraphObject.DragVertex(self)
			if event.button_index == MOUSE_BUTTON_RIGHT:
				GraphObject.ClickToVertex(Index)

func _on_area_2d_area_entered(area):
	Colision = true

func _on_area_2d_area_exited(area):
	Colision = false
