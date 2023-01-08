extends Spatial
class_name Tile

export var can_be_replaced := false

func _ready() -> void:
	TileManager.add_tile(self)
	assert(TileManager.get_tile(translation) == self)
