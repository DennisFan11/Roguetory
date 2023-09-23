extends Area2D

#---------------基礎屬性------------
var r:float = 90 #半徑pix
var gr:float = 5 #實體半徑pix

var cforce:float = 1 #碰撞斥力倍率
var damper:float = 0.95 
var add_speed:float = 10 #pix/s
var max_speed:float = 30 #pix/s

func _ready():
	_reset_shape()
	
func _reset_shape():
	$"../CollisionShape2D".shape.radius = gr
	$"CollisionShape2D".shape.radius = r
	
#---------------動態屬性------------
var move_vector = Vector2.ZERO #移動方位輸入
var last_Collide = 0
var disable_time = 0:
	set(new):
		if new<=0:
			disable_time = 0
		else:
			disable_time = new
#---------------輸出屬性------------
var vec:Vector2 = Vector2.ZERO #移動速度輸出


func _physics_process(delta):
	#---------------阻尼器---------------------
	vec *= damper
		
	#---------------移動輸入處理----------------
	var add_vec = move_vector * add_speed
	vec += add_vec
	if vec.length() > max_speed:
		vec = vec.normalized() * max_speed
	
		
	#---------------碰撞處理--------------------
	if disable_time == 0:
		if has_overlapping_areas():
			last_Collide = get_overlapping_areas().size()
			for units in get_overlapping_areas():
				var dist = (r+units.r) - (units.global_position - global_position).length()
				var add_force = (global_position - units.global_position).normalized() * dist * cforce
				
				$Line2D.points[1] = add_force
				vec += add_force
	else:
		last_Collide = 0
		$Line2D.points[1] = Vector2.ZERO
	if last_Collide >= Global.MaxColide:
		disable_time = 1
	else:
		disable_time -= delta
	if disable_time>0:
		monitoring = false
		monitorable = false
	else:
		monitoring = true
		monitorable = true
		
	#---------------輸出----------------------
	$"..".velocity = vec
	$"..".move_and_slide()











