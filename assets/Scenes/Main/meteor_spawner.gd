extends Node2D

@onready var mtr = $meteor_area 
@onready var indicator = get_node_or_null("meteor_target")

# Lane X positions
var tree_rows = [240.0, 368.0, 480.0] 

var timer = 0.0
var active = false 
var next_lane = 0.0

func _process(delta):
	if not active: return
	
	timer += delta
	
	# --- SHOW WARNING ---
	if timer >= 1 and timer < 1.5:
		if next_lane == 0.0:
			next_lane = tree_rows.pick_random()
			
			if indicator:
				indicator.global_position.x = next_lane
				# Matches the target_pos.y in the meteor script
				indicator.global_position.y = 900 
				indicator.visible = true

	# --- LAUNCH ---
	if timer >= 1.5:
		if mtr and not mtr.active:
			var final_lane = next_lane if next_lane != 0.0 else tree_rows.pick_random()
			
			# Decide side: If target is on the left, spawn from right (and vice versa)
			# to ensure a clear diagonal path across the screen
			var spawn_from_left = (final_lane > 360) 
			
			mtr.launch_bird(final_lane, spawn_from_left)
			
			if indicator:
				indicator.visible = false
			
			timer = 0.0
			next_lane = 0.0
