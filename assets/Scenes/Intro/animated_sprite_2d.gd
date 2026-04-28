extends AnimatedSprite2D

func _ready() -> void:
	# Reset animation to first frame
	frame = 0 # ensures it doesn’t start mid-animation
	play("intro")  # start from the first frame


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_finished() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Title Screen/title-screen.tscn")
