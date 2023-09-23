extends Node
class_name slime_ai
var unit:Object
var target:Object
func _init(node):
	unit = node
func get_target_vector():
	target = Global.PlayerNode #target.global_position
	var out = (target.global_position - unit.global_position).normalized()
	return(out)

