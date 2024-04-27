extends Node
class_name InteractionComponent

signal on_interacted_with(succeeded: bool)

@export var object_key: String = "Unnamed Object"
@export var text_prompt: String = ""
@export var requires_item: String = ""


func interact() -> void:
	on_interacted_with.emit()
