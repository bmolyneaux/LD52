extends Button

func on_item_selected(index, item):
	if item:
		text = "Sell " + item.name + " for $" + str(item.get_sell_price())
		visible = true
	else:
		visible = false

func _ready() -> void:
	pass
	#Inventory.connect("item_selected", self, "on_item_selected")

func _on_SellButton_pressed() -> void:
	Inventory.money += Inventory.get_selected().get_sell_price()
	Inventory.remove_item(Inventory.selected_index)
	$AudioStreamPlayer.play()
