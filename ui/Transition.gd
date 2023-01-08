extends Node

var z := 0.0 setget set_z

func set_z(value):
	z = value
	$Rect.material.set_shader_param("circle_size", z)

func fade_in():
	var tween = $Tween
	tween.interpolate_property(self, "z",
			0.0, 1.5, 1,
			Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")

func fade_out():
	var tween = $Tween
	tween.interpolate_property(self, "z",
			1.5, 0.0, 1,
			Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")

func _ready() -> void:
	fade_in()

func _process(delta):
	$Rect.rect_scale.x = $Rect.rect_size.x
	$Rect.rect_scale.y = $Rect.rect_size.y
	$Rect.material.set_shader_param("screen_width", $Rect.rect_size.x)
	$Rect.material.set_shader_param("screen_height", $Rect.rect_size.y)
