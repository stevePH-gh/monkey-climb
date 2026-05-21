extends RichTextLabel

# LEVELS
# 0000 - LV1 START
# 1150 - LV2 START
# 2300 - LV3 START
# 3450 - LV4 START
# 4600 - LV5 START

var score = 0.0
var current_level = 1
var boss_spawned = false 
var boss_active = false 
var boss2_spawned = false
var boss2_active = false

@onready var bird_spawner = $"../BirdSpawner"
@onready var meteor_spawner = $"../MeteorSpawner"

@onready var level_label = $"../LevelInfo/LevelPopUp"
@onready var anim_player = $"../LevelInfo/AnimationPlayer"
@onready var tree_spawner = $"../TreeSpawner"

@onready var bg_speedtest = $"../Backgrounds/Level1"

@onready var boss = get_node_or_null("../Boss1")
@onready var boss2 = get_node_or_null("../Boss2")

var current_track_index = 1
@export var lv2_music: AudioStream #BGM CHANEG
@export var lv3_music: AudioStream
@export var lv4_music: AudioStream
@export var lv5_music: AudioStream
@onready var bgm_player = $"../AudioStreamPlayer2D"

# LASER AND SNAKE
var snake_stopped = false
var laser_started = false
var laser_stopped = false

@export var snake_scene: PackedScene
@export var laser_scene: PackedScene

func _ready() -> void:
	_trigger_level_up(1)
	
	_apply_obstacle_swap(snake_scene)
	tree_spawner.active = true

func _process(delta: float) -> void:
	score += delta * 15.0
	text = str(int(score)).pad_zeros(6)
	
	if int(score) >= 680 and not snake_stopped: #snake spawner at 680
		if tree_spawner:
			tree_spawner.active = false
		snake_stopped = true
		print("--- SNAKE SPAWNER STOPPED ---")

	# --- BOSS 1 LOGIC ---
	if int(score) >= 750 and not boss_spawned:
		if boss:
			boss.activate_boss()
			boss_spawned = true
			boss_active = true
	
	# Despawn Boss
	if int(score) >= 1150 and boss_active:
		if boss:
			boss.deactivate_boss()
			boss_active = false
			
			
	# === BOSS 2 SPAWN ===
	if int(score) >= 1950 and not boss2_spawned:
		if boss2:
			boss2.activate_boss()
			boss2_spawned = true
			boss2_active = true
			
	if int(score) >= 2300 and boss2_active:
		if boss2:
			boss2.deactivate_boss()
			boss2_active = false
			
	#if int(score) >= 1100: #DEPRECATED
		#if tree_spawner: # PLAY UNG SNAKE
			#tree_spawner.active = true
			
			
		# BIRD SPAWNER LOGIC ---
	if int(score) >= 1180:
		if bird_spawner and not bird_spawner.active:
			bird_spawner.active = true
	
	if int(score) >= 1940:
		if bird_spawner and bird_spawner.active:
			bird_spawner.active = false
	
		# METEOR SPAWNER
	if int(score) >= 2350: #2350 START
			if meteor_spawner and not meteor_spawner.active:
				meteor_spawner.active = true
				print("meteor works")
	
	if int(score) >= 4400: #4400 END
		if meteor_spawner and meteor_spawner.active:
			meteor_spawner.active = false
			
		# LASER SPAWNER
	if int(score) >= 3460 and not laser_started:
		if tree_spawner:
			_apply_obstacle_swap(laser_scene)
			tree_spawner.active = true
		laser_started = true
		print("spawn laswer")
		
	if int(score) >= 4650 and not laser_stopped:
		if tree_spawner:
			tree_spawner.active = false
		laser_stopped = true
		print("stop laser")
		
	# --- LEVEL LOGIC ---
	var new_level = int(score / 1150) + 1
	if new_level > current_level:
		current_level = new_level
		_trigger_level_up(current_level)
		
# === BGM CHANGE ===
	# Level 2 Music
	if int(score) >= 1160 and current_track_index == 1:
		_change_bgm(lv2_music, 2)
		bg_speedtest.scroll_speed += 10
		
	# Level 3 Music
	if int(score) >= 2300 and current_track_index == 2:
		_change_bgm(lv3_music, 3)
		
	# Level 4 Music
	# if int(score) >= 0 and current_track_index == 3:
		# _change_bgm(lv4_music, 4)
		
	# Level 5 Music
	# if int(score) >= 0 and current_track_index == 4:
		# _change_bgm(lv5_music, 5)

func _change_bgm(new_stream: AudioStream, new_index: int):
	if bgm_player and new_stream:
		bgm_player.stop()
		bgm_player.stream = new_stream
		bgm_player.play()
		current_track_index = new_index
		print("BGM Swapped to Track: ", new_index)

func _trigger_level_up(lvl: int):
	if level_label and anim_player:
		level_label.text = "Level " + str(lvl)
		anim_player.play("show_level")
		
		
func _apply_obstacle_swap(target_scene: PackedScene):
	if not tree_spawner or not target_scene:
		return
		
	if tree_spawner.has_node("tree1"): tree_spawner.get_node("tree1").obstacle_scene = target_scene
	if tree_spawner.has_node("tree2"): tree_spawner.get_node("tree2").obstacle_scene = target_scene
	if tree_spawner.has_node("tree3"): tree_spawner.get_node("tree3").obstacle_scene = target_scene
	
	if "rows" in tree_spawner:
		for row in tree_spawner.rows:
			for tree in row:
				if "obstacle_scene" in tree:
					tree.obstacle_scene = target_scene
