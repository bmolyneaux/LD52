extends Spatial

var active = false

func _ready() -> void:
	GameMode.mode = GameMode.Mode.Store
	var from = get_tree().get_nodes_in_group("main_camera")[0]
	var to = $CameraRoot/Camera
	CameraTransition.transition_camera3D(from, to)
	
	yield(get_tree().create_timer(1), "timeout")
	active = true

func leave():
	$AnimationPlayer.play_backwards("popup")
	var to = get_tree().get_nodes_in_group("main_camera")[0]
	var from = $CameraRoot/Camera
	CameraTransition.transition_camera3D(from, to)
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	active = false
	GameMode.mode = GameMode.Mode.Main
