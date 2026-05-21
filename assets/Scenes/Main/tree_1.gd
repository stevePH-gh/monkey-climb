# Tree.gd (attached to tree1, tree2, tree3)
extends Sprite2D

@export var obstacle_scene: PackedScene

func spawn_snake():
	
	if get_parent() and "active" in get_parent():
		if not get_parent().active:
			return
			
	if obstacle_scene:
		var obs = obstacle_scene.instantiate()
		obs.name = "Snake"
		add_child(obs)
		obs.position = Vector2(0, 0)
