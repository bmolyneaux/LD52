extends Label

func on_mode_changed(a):
	queue_free()

func _ready() -> void:
	GameMode.connect("mode_changed", self, "on_mode_changed")
