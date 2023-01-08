extends Button

export var sell := false
export var item: Resource setget set_item

func thing_changed(a, b):
	set_item(item)

func set_item(value):
	item = value
	var money = item.get_sell_price() if sell else item.cost
	$HBoxContainer/Price.text = "$" + str(money)
	$HBoxContainer/Name.text = item.name
	$HBoxContainer/TextureRect.texture = item.icon
	$Count.text = "x" + str(item.count)
	on_money_changed(Inventory.money)


func _on_Button_pressed() -> void:
	if sell:
		Inventory.sell_item(item)
	else:
		Inventory.buy_item(item)

func on_money_changed(money):
	if not sell and money < item.cost:
		disabled = true
	else:
		disabled = false

func _ready() -> void:
	Inventory.connect("money_changed", self, "on_money_changed")
	Inventory.connect("item_added", self, "thing_changed")
