extends Tile


func _ready() -> void:
	for crow in get_tree().get_nodes_in_group("crow"):
		crow.scare()
