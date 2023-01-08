extends Button

export var camera1: NodePath
export var camera2: NodePath
export var dialog: NodePath

func _on_Button_pressed() -> void:
	visible = false
	CameraTransition.transition_camera3D(get_node(camera1), get_node(camera2), 0.5)
	yield(get_tree().create_timer(0.4), "timeout")
	get_node(dialog).visible = true
	yield(get_tree().create_timer(0.7), "timeout")
	Inventory.reset()
	GameMode.change_scene("res://level.tscn")
