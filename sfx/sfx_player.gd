extends AudioStreamPlayer3D


func _ready() -> void:
	connect("finished", self, "queue_free")


func _on_Spatial_tree_exiting() -> void:
	var papa = get_parent().get_parent()
	get_parent().remove_child(self)
	papa.add_child(self)
