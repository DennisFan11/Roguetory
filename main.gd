extends Node
var ResourcePack
var loader
func _ready():
	ResourcePack = resource.new()
	loader = MapLoader.new($floor, ResourcePack, 0,"floor")
	loader._start_thread()
var move = Vector2(0,0)
func _process(delta):
	loader.TargetPosition =move
	move.x += 20*delta
