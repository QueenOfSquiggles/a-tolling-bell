extends Area3D
class_name PlayerInteractionArea

signal interact_changed(name: String, node: Node3D)


class IData:
	var text: String = ""
	var node: Node3D
	var component: InteractionComponent
	var icon_name: String

	func _to_string() -> String:
		var n := "NULL"
		if node:
			n = node.name
		return "[%s] : %s" % [n, text]


@export var target_camera: PhantomCamera3D
@export var icon_scene: PackedScene

var current: IData = null
var last_is_colliding := false
var coll_arr: Array[IData]

var last_best_dot_product: float = 0.0


func do_interact() -> void:
	if current and is_instance_valid(current.node):
		current.component.interact()


func _physics_process(_delta: float) -> void:
	_update_interact()


func _on_body_entered(body: Node3D) -> void:
	var interaction := (
		Components.get_component(body, "InteractionComponent") as InteractionComponent
	)
	if not interaction:
		return
	var data := IData.new()
	data.node = body
	data.component = interaction
	data.text = interaction.text_prompt
	data.icon_name = body.name
	coll_arr.append(data)
	_create_object_icon(data)
	_update_interact()


func _on_body_exited(body: Node3D) -> void:
	var interaction := (
		Components.get_component(body, "InteractionComponent") as InteractionComponent
	)
	if not interaction:
		return
	var icon := find_child(str(body.name))
	if icon:
		icon.queue_free()
	var target: int = -1
	for i in range(coll_arr.size()):
		if coll_arr[i].node == body:
			target = i
			break
	if target >= 0:
		coll_arr.remove_at(target)
	_update_interact()


func _create_object_icon(target: IData) -> void:
	if not target or not target.node or find_child(str(target.icon_name)):
		return
	var icon := icon_scene.instantiate() as Node3D
	icon.name = target.icon_name
	add_child(icon)
	icon.owner = self
	icon.top_level = true
	icon.global_position = target.node.global_position


func _update_interact() -> void:
	var front: IData = null
	var best_delta := 0.0
	var cam_vector = -target_camera.global_basis.z.normalized()
	for i in coll_arr:
		if not is_instance_valid(i.node):
			var icon := find_child(i.icon_name)
			if icon:
				icon.queue_free()
			continue
		var normalized_dir := (i.node.global_position - global_position).normalized()
		var d := cam_vector.dot(normalized_dir)
		if d > best_delta:
			best_delta = d
			front = i
	last_best_dot_product = best_delta
	if front == current:
		return
	current = front
	if current:
		interact_changed.emit(current.text, current.node)
	else:
		interact_changed.emit("", null)
