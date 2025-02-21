extends Control

@onready var margin_container: MarginContainer = $MarginContainer
#@onready var margin_value = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	visible = false

	#margin_container.add_theme_constant_override("margin_top", margin_value)
	#margin_container.add_theme_constant_override("margin_left", margin_value)
	#margin_container.add_theme_constant_override("margin_bottom", margin_value)
	#margin_container.add_theme_constant_override("margin_right", margin_value)

func _process(delta: float) -> void:
	if visible:
		get_tree().paused = true
	elif !visible:
		get_tree().paused = false
		
func _input(event):
	if event.is_action_pressed("pause"):
		visible = not visible

func _on_resume_pressed() -> void:
	visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
