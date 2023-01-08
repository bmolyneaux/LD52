extends Node

var tiles: Dictionary

func clear():
	for tile in tiles.values():
		tile.queue_free()
	tiles.clear()

func _get_key(position: Vector3) -> String:
	# Avoid serializing -0
	var x = 0
	var z = 0
	if position.x != 0:
		x = position.x
	if position.z != 0:
		z = position.z
	return str(x) + "," + str(z)

func add_tile(tile: Tile):
	var key = _get_key(tile.translation.round())
	var old_tile = tiles.get(key)
	if old_tile:
		tiles.erase(key)
		if is_instance_valid(old_tile):
			old_tile.queue_free()
	tiles[key] = tile

func remove_tile(tile: Tile):
	var key = _get_key(tile.translation.round())
	tiles[key].queue_free()
	tiles.erase(key)

func get_tile(position: Vector3) -> Tile:
	return tiles.get(_get_key(position.round()))

func can_place_tile(position: Vector3) -> bool:
	var tile = tiles.get(_get_key(position.round()))
	if not tile:
		return true
	
	return tile.can_be_replaced
