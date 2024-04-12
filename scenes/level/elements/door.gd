extends RigidBody3D

@export var push_force := 3.0


func interact() -> void:
	var player := get_tree().get_first_node_in_group("player") as Node3D
	var mesh := get_child(0) as Node3D
	var dir = (mesh.global_position - player.global_position).normalized()
	var offset = mesh.global_position - global_position
	apply_impulse(dir * push_force, offset)
	print("Pushing door: %s" % str(dir))
