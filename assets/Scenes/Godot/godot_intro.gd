extends Node2D

func _ready():
	await get_tree().create_timer(3.0).timeout
	fade_out()


func fade_out():

	var tween = create_tween()
	tween.tween_property(self, "modulate:a",0, 0.5)

	await tween.finished

	get_tree().change_scene_to_file("res://assets/Scenes/Intro/intro.tscn")
