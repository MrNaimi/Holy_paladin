extends Control
@onready var skill_tree: Control = $"../SkillTree"
@export var division_amount = 50
@onready var margin_container: MarginContainer = $MarginContainer


@onready var sfxbusvolume: HSlider = $MarginContainer/VBoxContainer/SFXbusvolume
@onready var musicbusvolume: HSlider = $MarginContainer/VBoxContainer/Musicbusvolume
@onready var masterbusvolume: HSlider = $MarginContainer/VBoxContainer/Masterbusvolume

#@onready var margin_value = 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfxbusvolume.value/division_amount))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(musicbusvolume.value/division_amount))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(masterbusvolume.value/division_amount))
	visible = false

	#margin_container.add_theme_constant_override("margin_top", margin_value)
	#margin_container.add_theme_constant_override("margin_left", margin_value)
	#margin_container.add_theme_constant_override("margin_bottom", margin_value)
	#margin_container.add_theme_constant_override("margin_right", margin_value)


func _process(delta: float) -> void:
	if visible:
		get_tree().paused = true
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfxbusvolume.value/division_amount))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(musicbusvolume.value/division_amount))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(masterbusvolume.value/division_amount))
	elif !visible:
		get_tree().paused = false
	
	
func _input(event):
	if event.is_action_pressed("pause") && !skill_tree.visible:
		visible = not visible

func _on_resume_pressed() -> void:
	visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
