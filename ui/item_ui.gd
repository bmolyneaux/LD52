extends Control

var _item = null

func on_item_selected(index, item):
	if index == get_index():
		$TextureButton.grab_focus()
		#self.color = Color.green
	else:
		pass
		#self.color = Color.darkgray


func on_item_added(index, item):
	if index == get_index():
		set_item(item)
	elif Inventory._items.size() > get_index():
		set_item(Inventory._items[get_index()])

func on_item_removed(index, item):
	if Inventory._items.size() <= get_index():
		set_item(null)
	else:
		set_item(Inventory._items[get_index()])

func _ready() -> void:
	$Key.text = str(get_index() + 1)
	Inventory.connect("item_selected", self, "on_item_selected")
	Inventory.connect("item_added", self, "on_item_added")
	Inventory.connect("item_removed", self, "on_item_removed")
	#on_item_selected(Inventory.selected_index, Inventory._items[Inventory.selected_index])

func on_count_changed(count):
	$Count.text = str(count)

func set_item(item):
	if not item:
		if _item:
			_item.disconnect("count_changed", self, "on_count_changed")
		$Count.text = ""
		$TextureButton/TextureRect.texture = null
		$TextureButton.disabled = true
		$TextureButton.focus_mode = Control.FOCUS_NONE
	else:
		item.connect("count_changed", self, "on_count_changed")
		$TextureButton/TextureRect.texture = item.icon
		$TextureButton.disabled = false
		$TextureButton.focus_mode = Control.FOCUS_ALL
		if item.stacks:
			$Count.text = str(item.count)
		else:
			$Count.text = ""
	_item = item


func _on_TextureButton_pressed() -> void:
	Inventory.select_item(get_index())

func _process(delta: float) -> void:
	if Inventory.selected_index == get_index():
		$TextureButton.grab_focus()
