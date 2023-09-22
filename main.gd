extends Node
var ResourcePack
var loader
func _ready():
	ResourcePack = resource.new()
	loader = MapLoader.new($floor, ResourcePack, "floor", 0)
	loader._start_thread()
var move = Vector2(100,100)
func _process(delta):
	loader.CenterPos =move
	move.x += 1000*delta
	move.y += 1000*delta
	$Camera2D.position = move
