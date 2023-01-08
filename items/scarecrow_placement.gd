extends Tool

func interact(intersection):
	Inventory.remove_item2(load("res://items/scarecrow.tres"))
	var scarecrow = preload("res://items/scarecrow.tscn").instance()
	scarecrow.translation = intersection.round()
	get_parent().add_child(scarecrow)
	$AudioStreamPlayer3D.play()

func get_cursor():
	return preload("res://items/scarecrow_cursor.png")
