extends RichTextLabel

var score = 0.0
var current_level = 1
var boss_spawned = false 
var boss_active = false 

@onready var level_label = $"../LevelInfo/LevelPopUp"
@onready var anim_player = $"../LevelInfo/AnimationPlayer"
@onready var boss = get_node_or_null("../Boss1") 

func _ready() -> void:
	_trigger_level_up(1)

func _process(delta: float) -> void:
	score += delta * 15.0
	text = str(int(score)).pad_zeros(6)
	
	# --- BOSS LOGIC ---
	# Spawn Boss
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
	
	# --- LEVEL LOGIC ---
	var new_level = int(score / 1150) + 1
	if new_level > current_level:
		current_level = new_level
		_trigger_level_up(current_level)

func _trigger_level_up(lvl: int):
	if level_label and anim_player:
		level_label.text = "Level " + str(lvl)
		anim_player.play("show_level")
