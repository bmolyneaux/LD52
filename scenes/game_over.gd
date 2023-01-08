extends Spatial


func _ready() -> void:
	if Inventory.monster_hunger >= 1.0:
		$AnimationPlayer2.play("win_sequence")
	else:
		$AnimationPlayer2.play("game_over_sequence")
	yield($AnimationPlayer2, "animation_finished")
	GameMode.change_scene("res://Menu.tscn")
