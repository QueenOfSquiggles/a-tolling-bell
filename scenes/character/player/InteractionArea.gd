extends Area3D

signal interact_changed(name: String, node: Node3D)


class IData:
	var text: String = ""
	var node: Node3D

	func _to_string() -> String:
		var n := "NULL"
		if node:
			n = node.name
		return "[%s] : %s" % [n, text]


var current: IData = null
var last_is_colliding := false
var coll_stack: Array[IData]


func do_interact() -> void:
	if current and current.node:
		current.node.interact()


func _on_body_entered(body: Node3D) -> void:
	if not "interact" in body:
		print("Area Interact: Rejecting body :: %s" % body.name)
		return
	var data := IData.new()
	data.node = body
	if "get_interaction_text" in body:
		data.text = body.get_interaction_text()
	coll_stack.push_front(data)
	_update_interact()


func _on_body_exited(body: Node3D) -> void:
	if not "interact" in body:
		return
	# cheating by not treating it as a stack here :)
	var target: int = -1
	for i in range(coll_stack.size()):
		if coll_stack[i].node == body:
			target = i
			break
	if target >= 0:
		coll_stack.remove_at(target)
	_update_interact()


func _update_interact() -> void:
	var front: IData = null
	if not coll_stack.is_empty():
		front = coll_stack.front()
	if front == current:
		return
	current = front
	print("Area Interact: %s" % str(current))
	if current:
		interact_changed.emit(current.text, current.node)
	else:
		interact_changed.emit("", null)
