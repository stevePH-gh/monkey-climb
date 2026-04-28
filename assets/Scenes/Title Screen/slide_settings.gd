extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_settings_pressed() -> void:
	play("enter_settings")


func _on_backsettings_pressed() -> void:
	play("exit_setting")


func _on_btn_help_pressed() -> void:
	pass # Replace with function body.
