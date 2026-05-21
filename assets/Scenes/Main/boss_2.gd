extends Node2D

@export var move_speed : float = 450.0
@export var drop_scene: PackedScene 
@onready var sprite = $Bird 

var left_limit = -80
var right_limit = 810
var moving_right = false 
var active = false

# --- MANUAL TIMER VARIABLES ---
var drop_timer = 0.0
@export var spawn_rate = 0.4 # Seconds between drops

func activate_boss():
	show() 
	active = true
	global_position = Vector2(right_limit, 200) 
	moving_right = false
	drop_timer = 0.0 # Reset timer on entry

func deactivate_boss():
	active = false 
	var tween = create_tween()
	tween.tween_property(self, "position:x", 1000, 1.5)
	await tween.finished
	hide()

func _process(delta):
	if not active: return
	
	# 1. Movement logic
	if moving_right:
		position.x += move_speed * delta
		if sprite:
			sprite.flip_h = true 
		if position.x >= right_limit:
			moving_right = false
	else:
		position.x -= move_speed * delta
		if sprite:
			sprite.flip_h = false 
		if position.x <= left_limit:
			moving_right = true

	# 2. Spawning logic (No Timer node signal required)
	drop_timer += delta
	if drop_timer >= spawn_rate:
		spawn_dropping()
		drop_timer = 0.0

func spawn_dropping():
	if drop_scene == null:
		return
		
	var drop = drop_scene.instantiate()
	get_tree().current_scene.add_child(drop)
	drop.global_position = global_position
	
	# Targeting the monkey
	var monkey = get_tree().get_first_node_in_group("player")
	if monkey:
		var dir = (monkey.global_position - global_position).normalized()
		if "direction" in drop:
			drop.direction = dir
