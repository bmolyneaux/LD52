extends KinematicBody

var _input_vector := Vector2(0, 0)

var _max_speed := 3.0
var _acceleration := 10.0
var _world_space_velocity := Vector3.ZERO

var rng = RandomNumberGenerator.new()

var _nook = null

func play_idle(_anim):
	var i = rng.randi_range(1, 3)
	$AnimationPlayer.play("idle" + str(i))


func _ready() -> void:
	$AnimationPlayer.connect("animation_finished", self, "play_idle")
	randomize()

func store():
	_nook = preload("res://npcs/nook.tscn").instance()
	add_child(_nook)
	

func main():
	if not _nook or not _nook.active:
		return
	_nook.leave()
	_nook = null


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.scancode == KEY_SPACE and event.pressed and not event.echo:
		if GameMode.mode == GameMode.Mode.Store:
			main()
		elif GameMode.mode == GameMode.Mode.Main:
			store()


func _physics_process(delta: float) -> void:
	if GameMode.mode != GameMode.Mode.Main:
		return

	var input_vector = Vector2(0, 0)
	if Input.is_key_pressed(KEY_W):
		input_vector.y -= 1
	if Input.is_key_pressed(KEY_A):
		input_vector.x -= 1
	if Input.is_key_pressed(KEY_S):
		input_vector.y += 1
	if Input.is_key_pressed(KEY_D):
		input_vector.x += 1
		
	var acceleration_boost = 1.0
	
	var world_space_input = Vector3(input_vector.x, 0, input_vector.y).rotated(Vector3.UP, PI / 4)
	if input_vector == Vector2.ZERO:
		world_space_input = -_world_space_velocity.normalized()
	
	if input_vector == Vector2.ZERO:
		acceleration_boost = 2.0
	
	if world_space_input.dot(_world_space_velocity) < 0.3:
		acceleration_boost = 2.0
	
	_world_space_velocity += world_space_input * _acceleration * delta * acceleration_boost
	
	if input_vector == Vector2.ZERO:
		if _world_space_velocity.length_squared() < 0.05:
			_world_space_velocity = Vector3.ZERO
	
	if _world_space_velocity.length_squared() > _max_speed * _max_speed:
		_world_space_velocity = _world_space_velocity.normalized() * _max_speed
	
	_world_space_velocity = move_and_slide(_world_space_velocity)
	
	if _world_space_velocity.length_squared() > 0.5:
		$Particles.emitting = true
		$AnimationPlayer.play("walk")
		if _world_space_velocity.dot(Vector3(1, 0, -1)) > 0:
			$Sprite3D.flip_h = true
		else:
			$Sprite3D.flip_h = false
	elif !$AnimationPlayer.current_animation.begins_with("idle"):
		$Particles.emitting = false
		$AnimationPlayer.play("idle1")
