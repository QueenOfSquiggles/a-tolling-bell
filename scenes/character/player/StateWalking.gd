extends FiniteState

@export var actor: CharacterBody3D
@export var speed := 5.0
@export var acceleration := 3.0
@export var step_ray: RayCast3D
@export var step_height := 0.3
@export var step_force := 1.2
@export var interact_ray: RayCast3D
const GRAVITY := -9.8

var can_interact := false

signal do_crouch


func enter_state() -> void:
	super.enter_state()


func exit_state() -> void:
	super.exit_state()


func tick(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "backwards", "forwards", 0.1)
	var global_dir := Vector3()
	global_dir += -actor.global_basis.z * input_dir.y
	global_dir += actor.global_basis.x * input_dir.x

	if global_dir.length_squared() > 1.0:
		global_dir = global_dir.normalized()
	var target_velocity = global_dir * speed
	target_velocity += stairs_check(input_dir.y > 0)
	target_velocity += do_gravity()
	actor.velocity = actor.velocity.lerp(target_velocity, acceleration * delta)
	actor.move_and_slide()

	# TODO: refactor to common handler (HFSM??)
	if Input.is_action_just_pressed("interact") and can_interact:
		interact_ray.do_interact()
	if Input.is_action_just_pressed("crouch"):
		do_crouch.emit()


func stairs_check(forwards_intent: bool) -> Vector3:
	if not step_ray.is_colliding() or not forwards_intent:
		return Vector3()
	var delta_pos = step_ray.global_position - step_ray.get_collision_point()
	var height = step_ray.target_position.length() - delta_pos.length()
	if height <= step_height:
		return Vector3(0, -GRAVITY * step_force, 0)
	return Vector3()


func do_gravity() -> Vector3:
	if not actor.is_on_floor():
		return Vector3(0, GRAVITY, 0)
	return Vector3()


func _on_interaction_ray_interact_changed(n: String, node: Node3D) -> void:
	print("Interaction: " + n)
	can_interact = node != null
