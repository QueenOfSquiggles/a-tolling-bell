extends StaticBody3D


func interact() -> void:
	print("%s was interacted with!" % name)


func get_interaction_text() -> String:
	return name
