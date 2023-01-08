extends Spatial

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func _on_Timer_timeout() -> void:
	var crow = preload("res://npcs/Crow.tscn").instance()
	crow.translation = Vector3(rng.randf_range(-30, 30), 2, rng.randf_range(-30, 30))
	get_parent().add_child(crow)
