extends RayCast3D

signal interact_changed(name: String, node: Node3D)


class IData:
	var text: String = ""
	var node: Node3D


var current: IData = null
var last_is_colliding := false


func do_interact() -> void:
	if current and current.node:
		current.node.interact()


func _physics_process(_delta: float) -> void:
	var colliding = is_colliding()
	var flag = colliding != last_is_colliding
	if colliding and current:
		flag = flag or get_collider() != current.node
	if flag:
		last_is_colliding = colliding
		if colliding:
			var coll = get_collider()
			if "interact" in coll:
				var data := IData.new()
				data.node = coll
				if "get_interaction_text" in coll:
					data.text = data.node.get_interaction_text()
				current = data
				interact_changed.emit(data.text, data.node)
			else:
				_null_interact()
		elif not colliding and current:
			_null_interact()


func _null_interact() -> void:
	current = null
	interact_changed.emit("", null)
