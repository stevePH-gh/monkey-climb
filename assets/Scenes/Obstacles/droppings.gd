extends Area2D

@export var speed = 500.0
# Default is straight down, but Boss 2 will change this when spawning
var direction = Vector2.DOWN 

func _ready():
	# Keep the same death logic as the rock
	add_to_group("deadly")

func _process(delta):
	# Move in the assigned direction
	global_position += direction * speed * delta
	
	# Cleanup if it misses and falls off-screen
	if global_position.y > 1300:
		queue_free()
