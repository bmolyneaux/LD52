extends Control

func on_items_changed(a, b):
	for child in $Sell/VBoxContainer.get_children():
		child.queue_free()
	
	for item in Inventory._items:
		var button = preload("res://ui/shop_item_ui.tscn").instance()
		button.sell = true
		button.set_item(item)
		$Sell/VBoxContainer.add_child(button)

func on_game_mode_changed(mode):
	visible = mode == GameMode.Mode.Store

func _ready() -> void:
	GameMode.connect("mode_changed", self, "on_game_mode_changed")
	
	Inventory.connect("item_added", self, "on_items_changed")
	Inventory.connect("item_removed", self, "on_items_changed")
	
	on_items_changed(null, null)
