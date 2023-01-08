extends Control

func on_game_mode_changed(mode):
	visible = mode == GameMode.Mode.Main

func _ready() -> void:
	
	var i = 0
	for item in Inventory._items:
		get_child(i).set_item(item)
		i += 1
	
	GameMode.connect("mode_changed", self, "on_game_mode_changed")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.scancode >= KEY_1 and event.scancode <= KEY_9 and event.pressed:
			Inventory.select_item(event.scancode - KEY_1)
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			Inventory.select_item(Inventory.selected_index + 1)
		if event.button_index == BUTTON_WHEEL_DOWN:
			Inventory.select_item(Inventory.selected_index - 1)
