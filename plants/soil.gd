extends Tile

var plant = null setget set_plant

func set_plant(value):
	plant = value
	if value:
		value.soil = self
