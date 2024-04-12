extends FiniteState

@export var cam: PhantomCamera3D
@export var actor: Node3D

@export var cam_x_min := -70.0
@export var cam_x_max := 70.0
@export var mouse_look_speed := 1.0
@export var joy_look_speed := 1.0
@export var main_look_speed := 1.0
const MOUSE_LOOK_FACTOR := 0.003
const JOY_LOOK_FACTOR := 0.003

var motion_agg: Vector2


func enter_state() -> void:
	super.enter_state()
	motion_agg = Vector2()


func exit_state() -> void:
	super.exit_state()


func tick(delta: float) -> void:
	poll_joystick(delta)
	motion_agg = -motion_agg * main_look_speed
	cam.rotate_x(motion_agg.y)
	cam.rotation.x = clampf(cam.rotation.x, deg_to_rad(cam_x_min), deg_to_rad(cam_x_max))
	actor.rotate_y(motion_agg.x)
	motion_agg = Vector2()


func poll_joystick(delta: float) -> void:
	var axis := Input.get_vector(
		"joy_look_left", "joy_look_right", "joy_look_down", "joy_look_up", 0.2
	)
	motion_agg += axis * JOY_LOOK_FACTOR * delta


func _unhandled_input(event: InputEvent) -> void:
	if not state_enabled or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		var mm := event as InputEventMouseMotion
		motion_agg += mm.relative * MOUSE_LOOK_FACTOR
