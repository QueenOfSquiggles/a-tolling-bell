extends Node

var _player: PlayerCharacter


func get_player() -> PlayerCharacter:
	if _player:
		return _player
	var temp := get_tree().get_first_node_in_group("player") as PlayerCharacter
	if temp:
		_player = temp
		return _player
	push_warning("Failed to collect player node. Possibly calling too early??")
	return null
