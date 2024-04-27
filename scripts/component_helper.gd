extends Node
class_name Components


## Used for component type system approaches to check for a component of a given type
static func get_component(source: Node, component_type: String) -> Node:
	if not source:
		return null
	var potential := source.find_children("*", component_type, false)
	if potential.is_empty():
		return null
	return potential.front()
