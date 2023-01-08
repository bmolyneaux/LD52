extends Spatial

var angle := 0.0
var turn_rate := PI/2
var speed := 2.0

enum CrowState {
	Circle,
	FlyTo,
	Land,
	Eat,
	Startle,
	FlyAway
}

var state = CrowState.Circle

var target = null

var ready_to_eat = true

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func _circle_process(delta):
	$AnimationPlayer.play("fly")
	var direction = Vector3(cos(angle), 0, sin(angle))
	translation += direction * speed * delta
	angle += turn_rate * delta
	if angle > 180.0:
		angle -= 360.0
	$Sprite3D.flip_h = direction.dot(Vector3(1, 0, -1)) < 0

func _fly_to_process(delta):
	$AnimationPlayer.play("fly")
	if not is_instance_valid(target):
		state = CrowState.Circle
		return
	var destination = target.translation + Vector3.UP * 2.0
	if translation.distance_squared_to(destination) < 0.1:
		state = CrowState.Land
		return
	var direction = translation.direction_to(destination)
	translation += direction * speed * delta
	$Sprite3D.flip_h = direction.dot(Vector3(1, 0, -1)) < 0

func _land_process(delta):
	$AnimationPlayer.play("fly")
	translation.y -= 0.5 * speed * delta
	if translation.y < 0.01:
		translation.y = 0.0
		state = CrowState.Eat
		ready_to_eat = true

func _eat_process(delta):
	if not is_instance_valid(target):
		target = translation + Vector3(rng.randf_range(-10, 10), 2, rng.randf_range(-10, 10))
		state = CrowState.FlyAway
		return
	if target.has_method("eat") and ready_to_eat:
		$AnimationPlayer.play("eat")
		target.eat()
		$AnimationPlayer.animation_set_next("eat", "idle")
		ready_to_eat = false
		yield(get_tree().create_timer(2), "timeout")
		ready_to_eat = true

func _fly_away_process(delta):
	$AnimationPlayer.play("fly")
	var destination = target
	if translation.distance_squared_to(destination) < 0.1:
		state = CrowState.Circle
		return
	var direction = translation.direction_to(destination)
	translation += direction * speed * delta
	$Sprite3D.flip_h = direction.dot(Vector3(1, 0, -1)) < 0

func _too_scary(destination, scarecrows):
	for scarecrow in scarecrows:
		if destination.distance_squared_to(scarecrow.translation) < 15.0:
			return true
	return false

func _physics_process(delta: float) -> void:
	match state:
		CrowState.Circle:
			_circle_process(delta)
		CrowState.FlyTo:
			_fly_to_process(delta)
		CrowState.Land:
			_land_process(delta)
		CrowState.Eat:
			_eat_process(delta)
		CrowState.FlyAway:
			_fly_away_process(delta)


func _on_Timer_timeout() -> void:
	if state != CrowState.Circle:
		return
	
	var plants = get_tree().get_nodes_in_group("plant")
	if plants.size() == 0:
		return
	
	var scarecrows = get_tree().get_nodes_in_group("scarecrow")
	
	plants.shuffle()
	for plant in plants:
		if _too_scary(plant.translation, scarecrows):
			continue
		target = plant
		state = CrowState.FlyTo
		return

func scare():
	var scarecrows = get_tree().get_nodes_in_group("scarecrow")
	if _too_scary(translation, scarecrows):
		state = CrowState.FlyAway
		target = translation + Vector3(rng.randf_range(-10, 10), 2, rng.randf_range(-10, 10))
		return
