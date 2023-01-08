extends Control

func set_visible_text(control):
	$FeedMe.visible = false
	$NoItem.visible = false
	$NotFood.visible = false
	$Yes.visible = false
	$NoFood.visible = false
	control.visible = true

func on_hunger_changed(hunger):
	$HBoxContainer/Label.text = str(round(hunger * 100)) + "%"

func _ready() -> void:
	Inventory.connect("hunger_changed", self, "on_hunger_changed")
	on_hunger_changed(Inventory.monster_hunger)


func _on_Control2_mouse_entered() -> void:
	if Inventory.find_item(preload("res://items/corn.tres")) != null:
		set_visible_text($Yes)
	else:
		set_visible_text($NoFood)
	if false:
		var item = Inventory.get_selected()
		if item:
			if item.food:
				$HBoxContainer/Control2/Face.texture = preload("res://npcs/monster_icon_eat.png")
				set_visible_text($Yes)
			else:
				set_visible_text($NotFood)
		else:
			set_visible_text($NoItem)


func _on_Control2_mouse_exited() -> void:
	$HBoxContainer/Control2/Face.texture = preload("res://npcs/monster_icon1.png")
	set_visible_text($FeedMe)


func _on_Control2_pressed() -> void:
	var i = Inventory.find_item(preload("res://items/corn.tres"))
	if i == null:
		return
	var item = Inventory._items[i]
	
	#var item = Inventory.get_selected()
	
	if item and item.food:
		Inventory.monster_hunger += 0.02
		Inventory.remove_item2(item)
		$AudioStreamPlayer.play()


func _on_Timer_timeout() -> void:
	Inventory.monster_hunger -= 0.01
