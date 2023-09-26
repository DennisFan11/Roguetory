extends Node
var ResourcePack:resource
var loader:MapLoader
func _ready():
	ResourcePack = resource.new()
	loader = MapLoader.new($floor, ResourcePack, "floor", 0)
	loader._start_thread()
	
	var player = load("res://tscn/unit/player/player.tscn")
	player = player.instantiate()
	$units.add_child(player)
	
	
var move = Vector2(100,100)

func _process(delta):
	_camera(delta)
	Global._player_input()
	loader.CenterPos = Global.PlayerPosition
	if Input.is_action_pressed("shift"):
		Global.run = true
	else:
		Global.run = false
	if (Input.is_action_pressed("down") or
	Input.is_action_pressed("up") or 
	Input.is_action_pressed("left") or 
	Input.is_action_pressed("right")
	):
		Global.moving = true
	else:
		Global.moving = false
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var slime = load("res://tscn/unit/slime_child/slime_child.tscn")
		var unit = slime.instantiate()
		unit.position = $units.get_global_mouse_position()
		$units.add_child(unit)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var slime = load("res://tscn/unit/slime/slime.tscn")
		var unit = slime.instantiate()
		unit.position = $units.get_global_mouse_position()
		$units.add_child(unit)

#------------------相機移動--------------
var camera_speed = 20
func _camera(delta):
	if Input.is_action_just_pressed("zoom_in"):
		$Camera2D.zoom *=1.1
	if Input.is_action_just_pressed("zoom_out"):
		$Camera2D.zoom *=0.9
	$Camera2D.position = $Camera2D.position.lerp(Global.PlayerPosition, delta * camera_speed)
