extends Node
class_name FiniteState

signal do_state_exit

var state_enabled := false


func enter_state() -> void:
	state_enabled = true


func exit_state() -> void:
	state_enabled = false


func tick(_delta: float) -> void:
	pass
