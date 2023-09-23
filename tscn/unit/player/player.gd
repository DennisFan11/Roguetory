extends Sprite2D

#---------------基礎屬性------------
var r:float = 18 #半徑pix
var gr:float = 10 #實體半徑pix

var cforce:float = 0.5 #碰撞斥力倍率
var damper:float = 0.95 #pix/s
var add_speed:float = 10 #pix/s
var max_speed:float = 100 #pix/s
func _data_sync():
	$"..".r = r
	$"..".gr = gr
	$"..".cforce = cforce
	$"..".damper = damper
	$"..".add_speed = add_speed
	$"..".max_speed = max_speed
func _ready():
	_data_sync()
	Global.PlayerNode = self

func _process(delta):
	Global.PlayerPosition = global_position
	$"..".move_vector = Global.PlayerInputVector
	
	

	
