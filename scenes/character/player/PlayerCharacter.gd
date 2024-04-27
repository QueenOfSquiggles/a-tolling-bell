extends CharacterBody3D
class_name PlayerCharacter

@export var motion_fsm: StateMachine
@onready var motion_walk := $MotionFSM/StateWalking
@onready var motion_crouch := $MotionFSM/StateCrouching
@onready var inventory := $InventoryGridStacked


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	motion_walk.do_crouch.connect(motion_fsm.push_state.bind(motion_crouch), CONNECT_DEFERRED)
	motion_crouch.stop_crouch.connect(motion_fsm.push_state.bind(motion_walk), CONNECT_DEFERRED)
	GameManager.serialize.connect(_serialize)
	GameManager.deserialize.connect(_deserialize)
	_deserialize()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("open_inventory"):
		var inv := preload("res://scenes/gui/level/inventory.tscn").instantiate()
		get_tree().current_scene.add_child(inv)
		inv.display_inventory(inventory)
	if event.is_action_pressed("ui_text_backspace"):
		GameManager.trigger_serialize()


func _serialize() -> void:
	var data := SaveData.open("player")
	if not data:
		return
	data.data_buffer["inventory"] = inventory.serialize()
	data.serialize()


func _deserialize() -> void:
	var data := SaveData.open("player")
	if not data or not data.deserialize():
		return
	inventory.deserialize(data.data_buffer["inventory"])
