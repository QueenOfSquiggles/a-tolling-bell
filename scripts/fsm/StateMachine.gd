extends Node
class_name StateMachine

enum TickMode { PROCESS, PHYSICS_PROCESS }
@export var tick_mode := TickMode.PROCESS
@export var default_state: FiniteState

var state: FiniteState = null


func _ready() -> void:
	set_process(tick_mode == TickMode.PROCESS)
	set_physics_process(tick_mode == TickMode.PHYSICS_PROCESS)
	push_state(default_state)


func _process(delta: float) -> void:
	tick(delta)


func _physics_process(delta: float) -> void:
	tick(delta)


func tick(delta: float) -> void:
	if not state:
		return
	state.tick(delta)


func push_state(n_state: FiniteState) -> void:
	if state:
		state.exit_state()
	state = n_state
	if state:
		state.enter_state()
