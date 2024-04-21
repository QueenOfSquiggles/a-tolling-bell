extends Control

@onready var inv_display := %InventoryGuiDisplay


func _ready() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func display_inventory(inv: Inventory) -> void:
	inv_display.inventory = inv


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory") or event.is_action("ui_cancel"):
		get_tree().paused = false
		queue_free()
