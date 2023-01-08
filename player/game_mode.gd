extends Node

enum Mode {
	Main,
	Store,
	GameOver
}

signal mode_changed(new_mode)

var mode = Mode.Main setget set_mode

func set_mode(value):
	mode = value
	emit_signal("mode_changed", mode)

func change_scene(scene):
	yield(Transition.fade_out(), "completed")
	TileManager.clear()
	get_tree().change_scene(scene)
	yield(Transition.fade_in(), "completed")
