extends Sprite3D

export var frames : int

func _ready() -> void:
	var i = randi() % frames
	frame = i
