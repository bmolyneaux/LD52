extends Label

func on_money_changed(money):
	text = "$" + str(money)

func _ready() -> void:
	Inventory.connect("money_changed", self, "on_money_changed")
	on_money_changed(Inventory.money)
