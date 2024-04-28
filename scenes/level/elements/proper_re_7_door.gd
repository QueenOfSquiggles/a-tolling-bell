extends Node3D

enum DoorDir {OpenPositive, OpenNegative, Close}

@export var angle_open_small_degrees :float = 15.0
@export var angle_open_full_degrees :float = 90.0
@export var time_open_small :float = 1.0
@export var time_open_full :float = 2.5
@export var time_close :float = 1.0

@onready var hinge: Node3D = $Node3D

const ROTATION_PROPERTY := "rotation:y"
const ANGLE_EQ_THRESHOLD := deg_to_rad(5.0)

func _on_interaction_component_on_interacted_with() -> void:
	do_door_interact()

func do_door_interact() -> void:
	var player := GameManager.get_player()
	var delta := (global_position - player.global_position).normalized()
	var dot := delta.dot(global_basis.z.normalized())
	var target_dir := DoorDir.OpenPositive if dot > 0 else DoorDir.OpenNegative
	var current_dir := DoorDir.Close
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	var sign := 1.0 if target_dir == DoorDir.OpenPositive else -1.0
	if _is_open():
		current_dir = DoorDir.OpenPositive if hinge.rotation.y > 0 else DoorDir.OpenNegative
		var full_open := deg_to_rad(angle_open_full_degrees) * sign
		if current_dir == target_dir and abs(hinge.rotation.y - full_open) > ANGLE_EQ_THRESHOLD:
			tween.tween_property(hinge, ROTATION_PROPERTY, full_open, time_open_full)
		else:
			tween.tween_property(hinge, ROTATION_PROPERTY, 0, time_close)
	else:
		tween.tween_property(hinge, ROTATION_PROPERTY, \
			deg_to_rad(angle_open_small_degrees) * sign, time_open_small)
		


func _is_open() -> bool:
	return not hinge.rotation.y == 0
