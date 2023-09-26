extends Node
#---------------靜態資料------------
var CellSize:int = 16 #格子尺寸 pix^2
var ChunkSize:int = 5 #區域尺寸 cell^2
var MapSize:int = 100 #地圖尺寸 chunk^2
var LoadSize:int = 18 #加載區塊半徑
var MaxColide:int = 20
#---------------動態資料------------
var PlayerNode:Object
var PlayerPosition:Vector2 = Vector2.ZERO #來源:玩家實體
var PlayerInputVector:Vector2 = Vector2.ZERO #來源:_player_input.玩家輸入
var run:bool = false
var aim:bool = false
var moving:bool = false



func _player_input():
	var output = Vector2.ZERO
	if Input.is_action_pressed("up"):
		output += Vector2(0,-1)
	if Input.is_action_pressed("down"):
		output += Vector2(0,1)
	if Input.is_action_pressed("left"):
		output += Vector2(-1,0)
	if Input.is_action_pressed("right"):
		output += Vector2(1,0)
	PlayerInputVector = output.normalized()
		
