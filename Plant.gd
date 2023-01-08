extends Spatial

var soil = null
var super := false setget set_super

func eat():
	$Sprite3D.frame -= 1
	if $Sprite3D.frame == 0:
		soil.plant = null
		queue_free()
		return true
	return false

func can_harvest():
	return $Sprite3D.frame > 3

func harvest():
	var corn = load("res://items/corn.tres")
	var result = [corn]
	if $Sprite3D.frame > 7:
		result.append(corn)
	if super:
		result.append(corn)
		if $Sprite3D.frame > 7:
			result.append(corn)
	return result

func _on_Timer_timeout() -> void:
	$Sprite3D.frame = min($Sprite3D.frame + 1, 8)

func set_super(value):
	super = value
	if super:
		$Timer.wait_time *= 2
		$Sprite3D.texture = preload("res://plants/super_corn.png")

