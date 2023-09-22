class_name MapLoader
extends Resource
var thread = Thread.new()
var CellSize:int = Global.CellSize #格子尺寸 pix^2
var ChunkSize:int = Global.ChunkSize #區域尺寸 cell^2
var MapSize:int = Global.MapSize #地圖尺寸 chunk^2
var LoadSize:int = Global.LoadSize #加載區塊半徑
var Type:String #讀取類別
var MapArray:Array #地圖存檔
var ChunkNodesArray:Array #區塊實例
var ResourcePack:Object #資源包
var TargetNode:Object #目標節點


#背景線程,實例化控制器
func _init(target:Object, resource_pack:Object, type:String, mapdata):
	TargetNode = target
	ResourcePack = resource_pack
	Type = type
	if (typeof(mapdata) == TYPE_ARRAY):
		pass
	else:
		MapArray = EmptyMap(0)
	ChunkNodesArray.resize(MapSize)
	for i in range(MapSize):
		var y =[]
		y.resize(MapSize)
		y.fill(0)
		ChunkNodesArray[i] = y.duplicate()
		
		
		
		
func _start_thread():
	thread.start(_load_thread)
	

#---------------------跨線程同步資料-----------------
var CenterPos:Vector2:
	set(new):
		CPmux.try_lock()
		CenterPos = new
		CPmux.unlock()
var CPmux = Mutex.new()

#---------------------背景加載線程-------------------

func _load_thread(): 
	print("thread start")
	var 已加載區塊:Array = []
	var LastChunkPos:Vector2i = Vector2i.ZERO
	var CenterChunkpos = ToChunkPos(ToCellPos(CenterPos))
	while (true):
		await TargetNode.get_tree().process_frame
		CenterChunkpos = ToChunkPos(ToCellPos(CenterPos))
		if 已加載區塊.size() != 0 and LastChunkPos == CenterChunkpos:
			continue #加載區塊重複
		LastChunkPos = ToChunkPos(ToCellPos(CenterPos))
		var 需加載區塊 = LoadChunkArray(CenterChunkpos)
		var 需刪除區塊 = []
		var save = []
		for 區塊 in 已加載區塊:
			if 區塊 not in 需加載區塊:
				需刪除區塊.append(區塊)
		for 區塊 in 需加載區塊:
			if 區塊 not in 已加載區塊:
				save.append(區塊)
		已加載區塊 = 需加載區塊
		需加載區塊 = save
		
		for i in 加載(需加載區塊):
			TargetNode.call_deferred("add_child", i)
		for i in 刪除(需刪除區塊):
			i.call_deferred("queue_free")
		
func 加載(load:Array):
	var output = []
	for i in load:
		var node = Node.new()
		var cells = ChunkToCell(i)
		if i.x<0 or i.x>=MapSize or i.y<0 or i.y>=MapSize:
			continue
		for c in cells:
			var inst = ResourcePack.data[Type][MapArray[c.x][c.y]].instantiate()
			inst.position = ToWorldPos(c)
			node.add_child(inst)
		ChunkNodesArray[i.x][i.y] = node
		output.append(node)
	return output
			
func 刪除(load):
	var output = []
	for i in load:
		if i.x<0 or i.x>=MapSize or i.y<0 or i.y>=MapSize:
			continue
		if typeof(ChunkNodesArray[i.x][i.y]) != TYPE_OBJECT:
			continue
		output.append(ChunkNodesArray[i.x][i.y])
		ChunkNodesArray[i.x][i.y] = 0
	return (output)
		
#---------------------工具-----------------------------
func LoadChunkArray(position:Vector2i) -> Array: #輸入區塊座標 輸出加載區塊陣列
	var size
	if LoadSize %2 ==0:
		size = LoadSize
	else: 
		size = LoadSize+1
	var output =[]
	output.resize(size**2)
	for x in range(size):
		for y in range(size):
			output[x*size+y] = Vector2i(x-size/2+position.x,y-size/2+position.y)
	return (output)
	
func EmptyMap(with) -> Array:
	var output:Array = []
	output.resize(MapSize*ChunkSize)
	for i in range(MapSize*ChunkSize):
		var k = []
		k.resize(MapSize*ChunkSize)
		k.fill(with)
		output[i] = k.duplicate(true)
	return(output)
	
func ChunkToCell(pos:Vector2i) -> Array: #區域座標 轉 方塊座標
	var output = []
	for i in range(ChunkSize):
		for k in range(ChunkSize):
			output.append(Vector2i(i+pos.x*ChunkSize,k+pos.y*ChunkSize))
	return(output)
func ToCellPos(position:Vector2) -> Vector2i: #世界座標 轉 方塊座標
	return(Vector2i(position/CellSize))
func ToChunkPos(cell:Vector2) -> Vector2i: #方塊座標 轉 區域座標
	return(Vector2i(cell/ChunkSize))
func ToWorldPos(cell:Vector2) -> Vector2: #方塊座標 轉 世界座標
	return(cell*CellSize + Vector2(CellSize/2,CellSize/2))






