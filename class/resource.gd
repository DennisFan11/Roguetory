class_name resource
extends Resource
var data = {
	"floor":[0,1],
	"block":[0,1],
}
func _init():
	data["floor"][0] = load("res://tiles/dirt.tscn")
