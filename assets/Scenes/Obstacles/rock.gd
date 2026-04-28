extends Area2D

@export var fall_speed = 500.0

func _process(delta):
	global_position.y += fall_speed * delta
	
	if global_position.y > 1300:
		queue_free()
