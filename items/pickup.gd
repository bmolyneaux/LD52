tool
extends Spatial

export var texture: Texture setget set_texture
export var item : Resource

func set_texture(value):
	texture = value
	$Sprite3D.texture = value


func _on_Area_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Inventory.add_item(item)
		var poof = preload("res://vfx/poof.tscn").instance()
		get_parent().add_child(poof)
		poof.translation = translation
		$AudioStreamPlayer3D.play()
		queue_free()
