extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_help_pressed() -> void:
	play("enter_help")


func _on_backhelp_pressed() -> void:
	play("exit_help")
