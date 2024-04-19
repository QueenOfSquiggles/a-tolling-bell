extends StaticBody3D

@export var item_id: String


func interact() -> void:
	print("%s was interacted with!" % name)
	var player := GameManager.get_player()
	if not player:
		return
	var arr := player.find_children("", "Inventory")
	for e in arr:
		if e and e is InventoryGridStacked:
			var item := (e as InventoryGridStacked).create_and_add_item(item_id)
			if item:
				queue_free()
			break


func get_interaction_text() -> String:
	return name
