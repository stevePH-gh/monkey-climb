extends Area2D # Changed from AnimatedSprite2D

var lane = 1
var lane_positions = [240, 360, 480]

# --- SWIPE VARIABLES ---
var touch_start_pos = Vector2.ZERO
var swipe_threshold = 50
func _ready():
	area_entered.connect(_on_area_entered)
	var horizontal_shift = (get_viewport_rect().size.x / 2) - 360
	
	for i in range(lane_positions.size()):
		lane_positions[i] += horizontal_shift
	
	# We use $AnimatedSprite2D to talk to the child node
	# $Monkey.play("climb") 
	position.x = lane_positions[lane]
	

func move_left():
	if lane > 0:
		lane -= 1
		position.x = lane_positions[lane]

func move_right():
	if lane < 2:
		lane += 1
		position.x = lane_positions[lane]

func _process(delta):
	# Keep your keyboard support for testing on PC
	if Input.is_action_just_pressed("ui_left"):
		move_left()
	if Input.is_action_just_pressed("ui_right"):
		move_right()

# --- ADDED TOUCH FUNCTION ---
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start_pos = event.position
		else:
			var touch_end_pos = event.position
			var swipe_dist = touch_end_pos.x - touch_start_pos.x
			
			if abs(swipe_dist) > swipe_threshold:
				if swipe_dist > 0:
					move_right()
				else:
					move_left()
			else:
				var screen_width = get_viewport_rect().size.x
				if event.position.x < screen_width / 2:
					move_left()
				else:
					move_right()
					
func _on_area_entered(area: Area2D):
	if area.name == "Obstacle1" || area.name == "Rock":
		print("Hit detected! Resetting safely...") # debug testing
		
		#get_tree().paused = true
		
		var bg = get_node("../Backgrounds")
		bg.process_mode = Node.PROCESS_MODE_DISABLED
		
		var spawner = get_node("../TreeSpawner")
		spawner.process_mode = Node.PROCESS_MODE_DISABLED
		
		var score = get_node("../score")
		score.process_mode = Node.PROCESS_MODE_DISABLED
		
		var anim_player = get_node("../GameOver/GameOverAnim")
		anim_player.play("game_over_screen")
		
		var obs_rock = get_node("../Boss1")
		obs_rock.process_mode = Node.PROCESS_MODE_DISABLED
		
		$Monkey.stop()
		#
		#var tree_stop = get_tree().current_scene.find_child("TreeSpawner", true, false)
		#if tree_stop:
			#tree_stop.speed = 0
			#
		#else:
			## If find_child fails, try the parent directly
			#if "speed" in get_parent():
				#get_parent().speed = 0
