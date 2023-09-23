extends Sprite2D

#---------------基礎屬性------------
var r:float = 5.0 #半徑pix
var gr:float = 1 #實體半徑pix

var cforce:float = 0.5 #碰撞斥力倍率
var damper:float = 0.95 #pix/s
var add_speed:float = 5 #pix/s
var max_speed:float = 45 #pix/s  60
var ai:slime_ai = slime_ai.new(self)
func _data_sync():
	$"..".r = r
	$"..".gr = gr
	$"..".cforce = cforce
	$"..".damper = damper
	$"..".add_speed = add_speed
	$"..".max_speed = max_speed
func _ready():
	_data_sync()
@export var curve:Curve
var TIME:float = 0:
	set(new):
		if new>=1:
			TIME = 0
		else:
			TIME = new
func _physics_process(delta):
	TIME+=delta
	$"..".max_speed = curve.sample_baked(TIME)*max_speed
	$"..".move_vector = ai.get_target_vector()
	
	

	
