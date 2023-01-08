extends Spatial
class_name Tool

func _get_mouse_intersection():
	var camera = get_viewport().get_camera()
	var mouse_position = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_position)
	var intersection = Plane.PLANE_XZ.intersects_ray(from, camera.project_ray_normal(mouse_position))
	if not intersection:
		return Vector3(0,0,0)
	return intersection.round()

func is_valid_placement(intersection: Vector3):
	if TileManager.get_tile(intersection) == null:
		return true
	return TileManager.can_place_tile(intersection)

func interact(intersection):
	pass

func get_cursor():
	return null

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		var intersection = _get_mouse_intersection()
		if intersection:
			if is_valid_placement(intersection):
				interact(intersection)


func _physics_process(delta: float) -> void:
	if GameMode.mode != GameMode.Mode.Main:
		$SelectionIndicator.visible = false
		Input.set_custom_mouse_cursor(null)
		return
	
	var intersection = _get_mouse_intersection()
	
	if intersection and is_valid_placement(intersection):
		$SelectionIndicator.visible = true
		$SelectionIndicator.translation = intersection
		Input.set_custom_mouse_cursor(get_cursor())
	else:
		$SelectionIndicator.visible = false
		Input.set_custom_mouse_cursor(null)


func _exit_tree() -> void:
	Input.set_custom_mouse_cursor(null)
