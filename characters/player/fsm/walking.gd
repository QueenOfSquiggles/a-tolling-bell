extends FiniteState

@export var actor : Player
@export var camera : VirtualCamera3D

var active := false

func on_enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	active = true

func on_exit() -> void:
	active = false

func tick(_delta: float) -> void:
	var desired := Input.get_vector("left", "right", "backwards", "forwards", 0.2)
	var desired_local := Vector3.ZERO
	desired_local += camera.global_basis.z * desired.y * -1
	desired_local += camera.global_basis.x * desired.x
	actor.frame_velocity = desired_local * actor.walk_speed

func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
	
	var mm := event as InputEventMouseMotion
	if mm:
		pass
