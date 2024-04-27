extends StaticBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var phantom_camera_3d: PhantomCamera3D = $PhantomCamera3D

var active := false

const ACTIVATION_LEVEL := 5


func _on_interaction_component_on_interacted_with() -> void:
	get_tree().paused = true
	print("Starting special interaction")
	phantom_camera_3d.priority = ACTIVATION_LEVEL
	animation_player.play("initialize")
	animation_player.animation_finished.connect(_on_anim_finish.unbind(1), CONNECT_DEFERRED | CONNECT_ONE_SHOT)

func _on_anim_finish() -> void:
	active = true
	print("Now active")

func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
	if event.is_action_pressed("open_inventory"):
		active = false
		print("Ending special interaction")
		phantom_camera_3d.priority = 0
		get_tree().paused = false
