extends FiniteState

@export var anim: AnimationPlayer
@export var ceiling_ray: RayCast3D
@export var actor: CharacterBody3D
@export var speed := 5.0
@export var acceleration := 3.0
@export var interact_area: PlayerInteractionArea
const GRAVITY := -9.8

var can_interact := false

signal stop_crouch


func enter_state() -> void:
	super.enter_state()
	anim.play("Crouch")


func exit_state() -> void:
	super.exit_state()
	anim.play_backwards("Crouch")


func tick(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "backwards", "forwards", 0.1)
	var global_dir := Vector3()
	global_dir += -actor.global_basis.z * input_dir.y
	global_dir += actor.global_basis.x * input_dir.x

	if global_dir.length_squared() > 1.0:
		global_dir = global_dir.normalized()
	var target_velocity = global_dir * speed
	target_velocity += do_gravity()
	actor.velocity = actor.velocity.lerp(target_velocity, acceleration * delta)
	actor.move_and_slide()

	if Input.is_action_just_pressed("interact") and can_interact:
		interact_area.do_interact()
	if not ceiling_ray.is_colliding() and Input.is_action_just_pressed("crouch"):
		stop_crouch.emit()


func do_gravity() -> Vector3:
	if not actor.is_on_floor():
		return Vector3(0, GRAVITY, 0)
	return Vector3()


func _on_interaction_area_interact_changed(_name: String, node: Node3D) -> void:
	can_interact = not node == null
