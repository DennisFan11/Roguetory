class_name MapLoader
extends Resource
var thread = Thread.new()

var CellSize:int = Global.CellSize #格子尺寸 pix^2
var ChunkSize:int = Global.ChunkSize #區域尺寸 cell^2
var MapSize:int = Global.MapSize #地圖尺寸 chunk^2
var LoadSize:int = Global.LoadSize: #加載區塊半徑
	set(new):
		var r = (new*2+1)
		var output = []
		for x in range(r):
			for y in range(r):
				output.append(To1DArry(Vector2(x-new, y-new)))
		LoadArray = output.duplicate(true)
		LoadSize = new
		
			
var type:String #讀取類別
var Map_Mutex = Mutex.new()
var MapArray:Array = []
var ChunkNodesArray:Array = []
var ResourcePack:Object #資源包
var TargetNode:Object #目標節點

var T_mutex = Mutex.new() #加載互斥鎖
var TargetPosition:Vector2: #加載中心  需解鎖
	set(new):
		T_mutex.lock()
		TargetPosition = new
		T_mutex.unlock()
	get:
		T_mutex.lock()
		return(TargetPosition)
		T_mutex.unlock()
var L_mutex = Mutex.new() #加載陣列互斥鎖
var LoadArray = []: #加載陣列 需解鎖
	set(new):
		L_mutex.lock()
		LoadArray = new
		L_mutex.unlock()
	get:
		L_mutex.lock()
		return(LoadArray)
		L_mutex.unlock()


#背景線程,實例化控制器
var HalfCellSize:Vector2

func _init(target:Object, ResourcePack:Object, mapdata, type:String):
	LoadSize = Global.LoadSize
	if typeof(mapdata) == TYPE_ARRAY:
		MapArray = mapdata
	else:
		MapArray.resize((ChunkSize**2) * (MapSize**2))
		MapArray.fill(0)
		ChunkNodesArray.resize((ChunkSize**2) * (MapSize**2))
		ChunkNodesArray.fill(0)
	HalfCellSize = Vector2(CellSize/2, CellSize/2)
	TargetNode = target #目標節點
	

func _start_thread():
	thread.start(_load_thread)


func _load_thread(): #背景加載線程
	var 已加載區塊:Array = []
	var LastChunkPos:Vector2 = Vector2(-9999,-9999)
	while (true):
		await TargetNode.get_tree().process_frame
		var pos = ToChunkPos(ToCellPos(TargetPosition))
		if pos == Vector2i(LastChunkPos):
			continue #同位置 加載結束
		LastChunkPos = pos
		var 緩存 = []
		var 需加載 = [] #設定加載項
		for i in LoadArray:
			var id = Vector2(i+pos.x, i+MapSize*pos.y)
			緩存.append(i)
			print(i)
			if not 已加載區塊.has(id):
				需加載.append(id)
		var 需卸載 = [] #設定卸載項
		for i in 需加載:
			if 已加載區塊.has(i):
				需卸載.append(i)
		
		已加載區塊 = 緩存.duplicate(true)
		加載(需加載)
		卸載(需卸載)


func 加載(array:Array):
	for i in array:
		var output = Node.new()
		ChunkNodesArray[i] = output
		for k in ChunkToCell(To2DArry(i)):
			var id = To1DArry(k)
			if id >= MapArray.size() or id <= 0:
				continue
			var read = ResourcePack.data[type][MapArray[id]]
			var inst = read.instantiate()
			inst.position = ToWorldPos(To2DArry(id))
			output.add_child(inst)
		TargetNode.call_deferred("add_child",output)
			
func 卸載(array:Array):
	for i in array:
		TargetNode.call_deferred("queue_free",ChunkNodesArray[i])










func ChunkToCell(pos:Vector2i): #區域座標 轉 方塊座標
	var output = []
	for i in range(ChunkSize):
		for k in range(ChunkSize):
			output.append(Vector2i(i+pos.x*ChunkSize,k+pos.y*ChunkSize))
	return(output)
		
func ToCellPos(position:Vector2): #世界座標 轉 方塊座標
	return(Vector2i(position/CellSize))
func ToChunkPos(cell:Vector2): #方塊座標 轉 區域座標
	return(Vector2i(cell/ChunkSize))
func ToWorldPos(cell:Vector2): #方塊座標 轉 世界座標
	return(cell*CellSize + HalfCellSize)
	
func To1DArry(cell:Vector2): #區域座標 轉 一維陣列
	return int(cell.x + MapSize*cell.y)
func To2DArry(cell):
	return(Vector2i(cell%MapSize, cell/MapSize))








