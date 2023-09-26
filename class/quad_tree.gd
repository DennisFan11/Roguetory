class_name QuadTree
extends MapLoader
var TreeMap = [0]
#layers = 7,6,5,4,3,2,1,0 0是根節點
# 0 1
# 2 3
func 加載(load:Array): #覆寫 輸入:加載區塊座標陣列
	var output = []
	for chunk in load:
		if chunk.x<0 or chunk.x>=MapSize or chunk.y<0 or chunk.y>=MapSize:
			continue
		var node = Node.new()
		var mid_pos = Vector2(ChunkSize*CellSize/2,ChunkSize*CellSize/2)
		var list = 四元樹區塊遍歷(TreeMap[chunk.x][chunk.y], mid_pos, ChunkSize*CellSize, 0)
		for i in list:
			if i[0] == 0:
				continue
			else:
				var inst = ResourcePack.data[Type][i[0]].instantiate()
				inst.lod = i[2]
				inst.position = i[1]+ chunk*ChunkSize*CellSize
				node.add_child(inst)
		ChunkNodesArray[chunk.x][chunk.y] = node
		output.append(node)
	return output

#-------------Tool----------
func 四元樹區塊遍歷(node, mid_pos:Vector2, size:float, depth:int=0):
	var output = []
	if typeof(node) == TYPE_INT:
		return([[node,mid_pos,depth]])
	output.append_array(四元樹區塊遍歷(node[0], Vector2(mid_pos.x-size/4, mid_pos.y+size/4), size/2, depth+1))
	output.append_array(四元樹區塊遍歷(node[1], Vector2(mid_pos.x+size/4, mid_pos.y+size/4), size/2, depth+1))
	output.append_array(四元樹區塊遍歷(node[2], Vector2(mid_pos.x-size/4, mid_pos.y-size/4), size/2, depth+1))
	output.append_array(四元樹區塊遍歷(node[3], Vector2(mid_pos.x+size/4, mid_pos.y-size/4), size/2, depth+1))
	return output





func 世界座標_轉_區塊內座標(pos:Vector2):
	return pos-Vector2(ToChunkPos(pos)*ChunkSize)






