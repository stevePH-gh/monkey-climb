extends Area2D

var target_lane_x : float = 368.0
var from_left : bool = true
var speed : float = 700.0
var active : bool = false
var velocity = Vector2.ZERO

func _ready():
	add_to_group("deadly")
	hide()

func launch_bird(lane_x, side_left):
	target_lane_x = lane_x
	from_left = side_left
	active = true
	
	# Starting position (Off-screen)
	var start_x = -100 if from_left else 800
	var start_y = randf_range(100, 400) 
	global_position = Vector2(start_x, start_y)
	
	var target_pos = Vector2(target_lane_x, 800)
	velocity = (target_pos - global_position).normalized()
	
	if has_node("bird_sprite"):
		var sprite = $bird_sprite
		rotation = 0
		
		sprite.flip_h = from_left
			
	show()

func _process(delta):
	if not active: return
	
	global_position += velocity * speed * delta
	
	# Reset if it goes off-screen
	if global_position.y > 1290 or global_position.x < -200 or global_position.x > 1000:
		active = false
		hide()
