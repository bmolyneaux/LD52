extends Spatial


func _get_mouse_intersection():
	var camera = get_viewport().get_camera()
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	return Plane.PLANE_XZ.intersects_ray(from, camera.project_ray_normal(mouse_position))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var intersection = _get_mouse_intersection()
		if intersection and TileManager.can_place_tile(intersection.round()):
			var soil = preload("res://plants/soil.tscn").instance()
			soil.translation = intersection.round()
			get_parent().add_child(soil)
			$AudioStreamPlayer3D.play()


func _physics_process(delta: float) -> void:
	var intersection = _get_mouse_intersection()
	
	if intersection and TileManager.can_place_tile(intersection.round()):
		intersection = intersection.round()
		$SelectionIndicator.visible = true
		$SelectionIndicator.translation = intersection
		Input.set_custom_mouse_cursor(preload("res://tools/shovel.png"))
	else:
		$SelectionIndicator.visible = false
		Input.set_custom_mouse_cursor(null)


func _exit_tree() -> void:
	Input.set_custom_mouse_cursor(null)
