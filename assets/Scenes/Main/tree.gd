extends Node2D

@export var total_rows_to_spawn: int = 5  # Set this higher in the Inspector
var rows_spawned_so_far: int = 0
@export var speed = 290 # adjustable for game over
var screen_height
var rows = []
var row_height
var row_spacing = 50

# NEW CODE FOR BALANCED SPAWNING
var rows_since_last_snake = 0
const MIN_ROW_GAP = 2  # At least 2 completely empty rows between snakes

func _ready():
	# Make sure $tree1, $tree2, $tree3 are direct children of this node
	var base_row = [$tree1, $tree2, $tree3]
	screen_height = get_viewport_rect().size.y
	row_height = base_row[0].get_rect().size.y
	rows.append(base_row)

	var row_total_height = row_height + row_spacing
	var initial_count = int(screen_height / row_total_height) + 4
	
	rows_spawned_so_far = 0 

	for i in range(1, initial_count):
		create_row(base_row, -row_total_height * i)
	for i in range(1, initial_count):
		create_row(base_row, row_total_height * i)

# Modified create_row to handle the initial spawn
func create_row(base_row, offset_y):
	var new_row = []
	var horizontal_shift = (get_viewport_rect().size.x / 2) - 360

	for tree in base_row:
		var t = tree.duplicate()
		t.position.x = tree.position.x + horizontal_shift
		t.position.y = tree.position.y + offset_y
		add_child(t)
		new_row.append(t)
	
	# Decide if this new row gets a snake
	roll_for_snake_in_row(new_row)
	rows.append(new_row)

# NEW FUNCTION: The Master Decision Maker
func roll_for_snake_in_row(row_nodes):
	if rows_since_last_snake < MIN_ROW_GAP:
		rows_since_last_snake += 1
		return
	
	if randf() < 0.35: # 35% chance for a snake in this row
		# Pick ONE random tree from the 3 in the row
		var random_tree = row_nodes[randi() % row_nodes.size()]
		random_tree.spawn_snake()
		rows_since_last_snake = 0 # Reset cooldown
	else:
		rows_since_last_snake += 1
		
func _process(delta):
	speed += delta * 2.0
	
	for row in rows:
		for tree in row:
			tree.position.y += speed * delta

	# Loop backwards to safely remove rows from the list
	for i in range(rows.size() - 1, -1, -1):
		var row = rows[i]
		
# Inside your _process loop where you teleport the row:
		if row[0].position.y - row_height >= screen_height:
			if rows_spawned_so_far < total_rows_to_spawn:
				var highest_y = get_highest_y()
				for tree in row:
					tree.position.y = highest_y - (row_height + row_spacing)
					
					# CLEANUP: Remove old snake before rolling for a new one
					var old_snake = tree.get_node_or_null("Snake")
					if old_snake:
						old_snake.queue_free()
				
				# ROLL: Check if this "new" teleported row gets a snake
				roll_for_snake_in_row(row) 
				
				rows_spawned_so_far += 1
			else:
				# Cleanup: Delete the trees and remove the row from our list
				for tree in row:
					tree.queue_free()
				rows.remove_at(i)
				
				if rows.size() == 0:
					print("Level Complete!")

func get_highest_y():
	# SAFETY: If no rows exist, return 0 to prevent a crash
	if rows.size() == 0:
		return 0.0
		
	var highest_y = rows[0][0].position.y
	for r in rows:
		if r[0].position.y < highest_y:
			highest_y = r[0].position.y
	return highest_y
