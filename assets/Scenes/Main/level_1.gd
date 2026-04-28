extends Node2D

@export var scroll_speed = 2

var bg_height
var bg_tiles = []

var bg_count = 6

# Inside your Level1 script (the one with the bg tiles)

func _ready():
	var base = $base
	var base2 = $base2
	var base3 = $base3 # Ensure this node exists in your scene tree
	
	var base2H = base2.texture.get_height() - 390

	bg_tiles.append(base)
	bg_tiles.append(base2)
	bg_tiles.append(base3)

	# 1. Generate repeated tiles
	for i in range(1, bg_count):
		var t = base2.duplicate()
		t.position = base2.position
		t.position.y += base2H * i
		add_child(t)
		bg_tiles.append(t)
		
	# 2. Force base3 to the TOP of the draw stack
	# This moves base3 to be the last child, so it's drawn last (on top)
	move_child(base3, get_child_count() - 1)
	
	# 3. Position it exactly at the end
	base3.position = base2.position
	base3.position.y += base2H * bg_count

func _process(delta):
	
	for tile in bg_tiles:
		tile.position.y += scroll_speed * delta
