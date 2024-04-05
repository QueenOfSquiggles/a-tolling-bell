extends CharacterBody3D
class_name Player

@export_group("Movement Settings")
@export var walk_speed :float = 2.0
@export var sprint_speed :float = 5.0
@export var acceleration :float = 3.0
 
@onready var fsm := $FiniteStateMachine
@onready var cam := $VirtualCamera3D
@onready var interact := $VirtualCamera3D/InteractRaycast3D

var frame_velocity : Vector3 = Vector3.ZERO

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	velocity = velocity.lerp(frame_velocity, acceleration * delta)
	move_and_slide()
	frame_velocity = Vector3.ZERO

