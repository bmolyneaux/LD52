extends Button


func _on_Button_pressed() -> void:
	var player = get_tree().get_nodes_in_group("player")[0]
	if GameMode.mode == GameMode.Mode.Store:
		player.main()
	elif GameMode.mode == GameMode.Mode.Main:
		player.store()
