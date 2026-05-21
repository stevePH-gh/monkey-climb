extends Node2D

# We keep this as a fallback, but we'll prioritize Level 1's speed
@export var scroll_speed = 2 
var bg_tiles = []
var bg_count = 6 

# Store a reference to Level 1 so we don't have to look it up every frame
@onready var level1 = get_node_or_null("../Level1")

func _ready():
	# 1. Get the offset from Level 1
	var start_y_offset = 0
	
	if level1:
		var last_tile = level1.get_node_or_null("base3")
		if last_tile:
			start_y_offset = last_tile.position.y
	
	# 2. Setup initial Level 2 tiles
	var base = $base
	var base2 = $base2
	var base2H = base2.texture.get_height() - 390
	
	base.position.y = start_y_offset + base2H
	bg_tiles.append(base)
	
	base2.position.y = base.position.y + base2H
	bg_tiles.append(base2)

	# 3. Generate repeated tiles
	for i in range(1, bg_count):
		var t = base2.duplicate()
		t.position.y = base2.position.y + (base2H * i)
		add_child(t)
		bg_tiles.append(t)

func _process(delta):
	# --- AUTO-SYNC SPEED ---
	# If Level 1 exists, use its speed. Otherwise, use our own.
	var current_speed = scroll_speed
	if level1:
		current_speed = level1.scroll_speed
	
	for tile in bg_tiles:
		tile.position.y += current_speed * delta
