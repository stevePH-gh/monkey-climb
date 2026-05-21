extends Node2D

@onready var bird = $bird_area 
@onready var indicator = get_node_or_null("bird_target")

# These values are passed to bird.launch_bird(lane, side)
# In your bird script, 'lane' determines the X position (where it strikes)
var tree_rows = [240.0, 368.0, 480.0] 

var timer = 0.0
var active = false 
var next_lane = 0.0

func _process(delta):
	if not active: return
	
	timer += delta
	
	# --- SHOW WARNING (at 2.0s) ---
	if timer >= 2.0 and timer < 3.5:
		if not bird.active and next_lane == 0.0:
			next_lane = tree_rows.pick_random()
			
			if indicator:
				indicator.global_position.x = next_lane
				indicator.global_position.y = 780 
				
				indicator.visible = true
				indicator.z_index = 100 # Ensure it's above the trees

	if timer >= 3.5:
		if bird and not bird.active:
			var final_lane = next_lane if next_lane != 0.0 else tree_rows.pick_random()
			var side = randf() > 0.5
			
			bird.launch_bird(final_lane, side)
			
			if indicator:
				indicator.visible = false
			
			# Reset everything for the next cycle
			timer = 0.0
			next_lane = 0.0
