extends Tool

func is_valid_placement(intersection: Vector3):
	if intersection == null:
		return false
	var tile = TileManager.get_tile(intersection)
	if tile == null:
		return false
	if not tile.is_in_group("soil"):
		return false
	if tile.plant == null:
		return false
	return tile.plant.can_harvest()

func interact(intersection):
	var tile = TileManager.get_tile(intersection)
	if tile and tile.is_in_group("soil"):
		for item in tile.plant.harvest():
			Inventory.add_item(item)
		tile.plant.queue_free()
		tile.plant = null
		$AudioStreamPlayer3D.play()

func get_cursor():
	return preload("res://items/shears_cursor.png")
