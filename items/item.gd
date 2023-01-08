extends Resource
class_name Item

export var name: String
export var scene: PackedScene
export var icon: Texture
export var cursor: Texture
export var cost: int
export var stacks: bool
export var food: bool

signal count_changed(value)

var count := 0 setget set_count

func set_count(value):
	count = value
	emit_signal("count_changed", count)

func get_sell_price():
	return int(floor(cost * 0.8))
