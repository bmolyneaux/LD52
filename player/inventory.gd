extends Node

signal item_selected(index, item)
signal item_added(index, item)
signal item_removed(index, item)

var _items = []#preload("res://items/shovel.tres")]
var selected_index = null
var selected_node = null

signal money_changed(balance)

var money := 0 setget set_money

signal hunger_changed(value)

var monster_hunger := 0.2 setget set_hunger

func reset():
	monster_hunger = 0.2
	money = 0

func set_hunger(value):
	monster_hunger = value
	emit_signal("hunger_changed", value)
	
	if monster_hunger >= 1.0 or monster_hunger <= 0.0:
		GameMode.mode = GameMode.Mode.GameOver
		GameMode.change_scene("res://scenes/game_over.tscn")

func set_money(value):
	money = value
	emit_signal("money_changed", money)

func _ready() -> void:
	if _items.size() > 0:
		select_item(0)

func select_item(index):
	if index == null:
		return
	
	if index < 0:
		index = _items.size() - 1
	
	if index >= _items.size():
		index = 0
	
	selected_index = index
	var selected_item = null
	if _items.size() > 0 and _items.size() > selected_index:
		selected_item = _items[index]
	if _items.size() == 0:
		selected_index = null
	emit_signal("item_selected", selected_index, selected_item)
	
	if selected_node:
		selected_node.queue_free()
		selected_node = null
	
	if selected_item:
		selected_node = selected_item.scene.instance()
		add_child(selected_node)

func add_item(item):
	var index = find_item(item)
	if index != null:
		item = _items[index]
	if item.stacks:
		item.count += 1
	if item.count == 1:
		_items.append(item)
	
	index = _items.size() - 1
	emit_signal("item_added", index, item)
	if selected_index == null:
		select_item(index)

func remove_item(index):
	var item = _items.find(index)
	_items.remove(index)
	emit_signal("item_removed", _items.size(), item)
	
	if selected_node:
		selected_node.queue_free()
		selected_node = null
	if selected_index == index:
		select_item(index)

func remove_item2(item):
	var index = find_item(item)
	if index != null:
		item = _items[index]
	if item.stacks:
		item.count -= 1
	if item.count == 0:
		remove_item(index)

func get_selected():
	if selected_index == null:
		return null
	return _items[selected_index]

func find_item(item):
	for i in _items.size():
		if _items[i].name == item.name:
			return i
	return null

func sell_item(item):
	Inventory.money += item.get_sell_price()
	remove_item2(item)
	#$AudioStreamPlayer.play()

func buy_item(item):
	Inventory.money -= item.cost
	add_item(item)
	#$AudioStreamPlayer.play()
