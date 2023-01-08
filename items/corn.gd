extends Tool

export var super := false

func is_valid_placement(intersection: Vector3):
	if intersection == null:
		return false
	var tile = TileManager.get_tile(intersection)
	if tile == null:
		return false
	if not tile.is_in_group("soil"):
		return false
	return tile.plant == null

func interact(intersection):
	var corn = preload("res://plants/Plant.tscn").instance()
	corn.translation = intersection
	corn.super = super
	get_parent().add_child(corn)
	if super:
		Inventory.remove_item2(load("res://items/super_corn.tres"))
	else:
		Inventory.remove_item2(load("res://items/corn.tres"))
	TileManager.get_tile(intersection).plant = corn
	#$AudioStreamPlayer3D.play()

func get_cursor():
	if super:
		return preload("res://items/super_corn_cursor.png")
	else:
		return preload("res://items/corn_cursor.png")

