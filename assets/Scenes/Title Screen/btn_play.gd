extends Button

@onready var texture1 = preload("res://assets/sprites/button_container.png")
@onready var texture2 = preload("res://assets/sprites/button_container-pressed.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Main/monkey_climb.tscn")


func _on_button_down() -> void:
	$flexibleContainer.texture = texture2
	$flexibleContainer/btnLabel.position.y += 5

func _on_button_up() -> void:
	$flexibleContainer.texture = texture1
	$flexibleContainer/btnLabel.position.y -= 5
