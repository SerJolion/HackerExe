extends Node2D

@export_file var VertexScenePath:String

var VertexScene:PackedScene
var GraphVertex:Dictionary = {}

var Start:int
var Finish:int
var speed:int
var GraphMatrix:Array
var PlayerPath:Array = []
var Level:Node2D

var isDragging:bool = false
var DraggingVertex:Node2D = null

func _ready():
	Level = get_parent()
	VertexScene = load(VertexScenePath)

# возможно переделать создание ребер графа (добавить возможность добавлять
# ребра с обратной транзацией)
func CreateGraph(Matrix:Array):
	GraphMatrix = Matrix
	for i in Matrix.size():
		var Vertex = VertexScene.instantiate()
		GraphVertex[i] = Vertex
		Vertex.Index = i
		if i == 0:
			Start = i
			Vertex.SetText('Начало')
		elif i ==Matrix.size()-1:
			Finish = i
			Vertex.SetText('Конец')
		else:
			Vertex.SetText(get_parent().VertexName[i])
		Vertex.GraphObject = self
		add_child(Vertex)
		Vertex.position = Vector2(30 + i*50,30 + i*50)
	for i in Matrix.size():
		for j in Matrix[i].size():
			if Matrix[i][j] > 0:
				get_child(i).add_nighbor(get_child(j), Matrix[i][j])

func HasTransition(IndexA:int, IndexB:int)->bool:
	if IndexA < GraphMatrix.size():
		for i in GraphMatrix[IndexA]:
			if i == IndexB:
				return true
	return false

#Надо доработать
func GetNormPath(Path:Array)->Array:
	var StartIndex = Path.find(Start)
	var FinishIndex = Path.find(Finish)
	var NormPath:Array = []
	if StartIndex >= 0 and Path.find(Finish) >= 0:
		var CurrentVertex = GraphVertex[StartIndex]
		NormPath.append(CurrentVertex.Index)
		while CurrentVertex.Index != null:
			for index in Path:
				var NextVertex = GraphVertex[index]
				if CurrentVertex.HasNighbor(NextVertex):
					if NextVertex.Index == Finish:
						NormPath.append(NextVertex.Index)
						return NormPath
					else:
						CurrentVertex = NextVertex
						NormPath.append(CurrentVertex.Index)
	return []

func CheckPath(Path:Array)->bool:
	var StartIndex = Path.find(Start)
	var FinishIndex = Path.find(Finish)
	if StartIndex >= 0 and Path.find(Finish) >= 0:
		var CurrentVertex = GraphVertex[StartIndex]
		while CurrentVertex.Index != null:
			for index in Path:
				var NextVertex = GraphVertex[index]
				if CurrentVertex.HasNighbor(NextVertex):
					if NextVertex.Index == Finish:
						return true
					else:
						CurrentVertex = NextVertex
			
	return false

#переделать
func ShowPath(Path:Array):
	for key in GraphVertex.keys():
		GraphVertex[key].ResetEdgeColor()
	var Vertex:Node2D = null
	for index in Path.size():
		Vertex = GraphVertex[Path[index]]
		Vertex.SetColor(Color.YELLOW)
		if index < Path.size()-1:
			Vertex.SetEdgeColor(GraphVertex[Path[index+1]],Color.YELLOW)
			print()

func DragVertex(Vertex:Node2D):
	if isDragging == false:
		isDragging = true
		Vertex.drag = true
		Vertex.z_index = 1
		DraggingVertex = Vertex

func DropVertex():
	if isDragging == true and DraggingVertex.Colision == false:
		isDragging = false
		DraggingVertex.drag = false
		DraggingVertex.z_index = 0
		DraggingVertex = null

func ClickToVertex(Index:int):
	speed = 0
	var Vertex = GraphVertex[Index]
	if PlayerPath.has(Index):
		PlayerPath.erase(Index)
		Vertex.SetColor(Color.GREEN)
		Vertex.ResetEdgeColor()
	else:
		PlayerPath.append(Index)
		Vertex.SetColor(Color.YELLOW)
		for i in PlayerPath:
			if Vertex.HasNighbor(GraphVertex[i]):
				Vertex.SetEdgeColor(GraphVertex[i], Color.YELLOW)
	#ShowPath(PlayerPath)
	for index in range(1,PlayerPath.size()):
		speed += GraphMatrix[PlayerPath[index-1]][PlayerPath[index]]
	Level.UpdateDataPanel(CheckPath(PlayerPath), speed)
	print(GetNormPath(PlayerPath))
	if CheckPath(PlayerPath):
		Level.StartResultTimer(speed * 0.5)
	else:
		Level.StopResultTimer()
