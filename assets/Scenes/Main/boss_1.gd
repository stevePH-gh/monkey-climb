extends Node2D

@export var move_speed = 250.0
@export var rock_scene: PackedScene 
@onready var sprite = $gorilla 

var left_limit = 100   
var right_limit = 600  
var moving_right = true
var active = false

# --- NEW SPAWN VARIABLES ---
var rock_timer = 0.0
@export var spawn_rate = 0.7 # How many seconds between drops

func _ready():
	hide()
	active = false

func activate_boss():
	show() 
	active = true
	position.y = -200 
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", 184, 1.0).set_trans(Tween.TRANS_QUINT)

func deactivate_boss():
	active = false # Stop movement and rock spawning
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", -300, 1.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	await tween.finished
	hide()
	print("Boss has left")

func _process(delta):
	if not active: return

	# 1. Horizontal Movement
	if moving_right:
		position.x += move_speed * delta
		sprite.flip_h = true
		if position.x >= right_limit:
			moving_right = false
	else:
		position.x -= move_speed * delta
		sprite.flip_h = false
		if position.x <= left_limit:
			moving_right = true

	# --- 2. ROCK SPAWNING LOGIC ---
	rock_timer += delta
	if rock_timer >= spawn_rate:
		drop_rock()
		rock_timer = 0.0 # Reset the clock for the next rock

func drop_rock():
	var rock = rock_scene.instantiate()
	# Adding to current_scene so the rock stays where it was dropped 
	# instead of sliding sideways with the gorilla
	get_tree().current_scene.add_child(rock)
	
	rock.global_position = global_position
	print("Rock dropped!") # Check the Output console to see if this works!
