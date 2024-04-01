extends FiniteState

@export var actor : CharacterBody3D
@export var camera : VirtualCamera3D

func on_enter() -> void:
	camera.push()

func on_exit() -> void:
	camera.pop()

func tick() -> void:
	var desired := Input.get_vector("left", "right", "backwards", "forwards")
	var desired_local := Vector3.ZERO
	desired_local += camera.global_basis.z * desired.y * -1
	desired_local += camera.global_basis.x * desired.x
	if desired_local.length_squared() < 0.1:
		desired_local = Vector3.ZERO
	actor.frame_velocity += desired_local
