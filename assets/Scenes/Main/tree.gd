extends Node2D

@export var total_rows_to_spawn: int = 5 
var rows_spawned_so_far: int = 0
@export var speed = 290 
var screen_height
var rows = []
var row_height
var row_spacing = 50

var active = false 

var rows_since_last_snake = 0
const MIN_ROW_GAP = 2  

func _ready():
	var base_row = [$tree1, $tree2, $tree3]
	
	# FIX: Clean the base trees immediately so we don't duplicate existing snakes
	for tree in base_row:
		for child in tree.get_children():
			child.queue_free()

	row_height = base_row[0].get_rect().size.y
	var row_total_height = row_height + row_spacing
	
	var current_y = -72.0
	while current_y < 1350 + row_total_height:
		create_row(base_row, current_y)
		current_y += row_total_height

func create_row(base_row, pos_y):
	var new_row = []
	var horizontal_shift = (get_viewport_rect().size.x / 2) - 360

	for tree in base_row:
		var t = tree.duplicate()
		# FIX: Ensure the duplicate is clean of any children just in case
		for child in t.get_children():
			child.free() 
			
		t.position.x = tree.position.x + horizontal_shift
		t.position.y = pos_y
		add_child(t)
		new_row.append(t)
	
	if active:
		roll_for_snake_in_row(new_row)
	
	rows.append(new_row)

func roll_for_snake_in_row(row_nodes):
	if not active:
		return
		
	if rows_since_last_snake < MIN_ROW_GAP:
		rows_since_last_snake += 1
		return
	
	if randf() < 0.35: 
		var random_tree = row_nodes[randi() % row_nodes.size()]
		if random_tree.has_method("spawn_snake"):
			random_tree.spawn_snake()
		rows_since_last_snake = 0 
	else:
		rows_since_last_snake += 1
		
func _process(delta):
	speed += delta * 2.0
	
	for row in rows:
		for tree in row:
			tree.position.y += speed * delta

	for i in range(rows.size() - 1, -1, -1):
		var row = rows[i]
		
		if row[0].position.y >= 1350:
			var highest_y = get_highest_y()
			var target_y = highest_y - (row_height + row_spacing)
			
			if target_y > -72:
				target_y = -72

			for tree in row:
				tree.position.y = target_y
				
				# FIX: Kill ALL children (snakes) to ensure a fresh start
				for child in tree.get_children():
					child.queue_free()
			
			roll_for_snake_in_row(row)

func get_highest_y():
	if rows.size() == 0:
		return -72.0
	var highest = rows[0][0].position.y
	for r in rows:
		if r[0].position.y < highest:
			highest = r[0].position.y
	return highest
