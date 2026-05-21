extends Area2D

var target_lane_x : float = 368.0
var from_left : bool = true
var speed : float = 1400.0
var active : bool = false
var velocity = Vector2.ZERO

func _ready():
	add_to_group("deadly")
	hide()

func launch_bird(lane_x, side_left):
	target_lane_x = lane_x
	from_left = side_left
	active = true
	
	var start_x = -150 if from_left else 870
	var start_y = -100 
	global_position = Vector2(start_x, start_y)
	
	var target_pos = Vector2(target_lane_x, 800) 
	
	# TARGET CALCULATION
	velocity = (target_pos - global_position).normalized()
	
	
	look_at(target_pos)
	rotation += PI # FACE THE TARGET
	
	show()

func _process(delta):
	if not active: return
	
	global_position += velocity * speed * delta
	
	# Reset if it goes off-screen
	if global_position.y > 1350 or global_position.x < -400 or global_position.x > 1200:
		active = false
		hide()
