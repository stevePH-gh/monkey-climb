# Tree.gd (attached to tree1, tree2, tree3)
extends Sprite2D

@export var obstacle_scene: PackedScene

func spawn_snake():
	if obstacle_scene:
		var obs = obstacle_scene.instantiate()
		obs.name = "Snake"
		add_child(obs)
		obs.position = Vector2(0, 0)
