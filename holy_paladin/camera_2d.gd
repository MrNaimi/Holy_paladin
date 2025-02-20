extends Camera2D
@onready var camera_2d: Camera2D = $"."
@onready var label = $"../Label"
var ISOMETRIC_TILEMAP = preload("res://Scenes/isometric_tilemap.tscn")
var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.hide()
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 1.5)
	await get_tree().create_timer(3).timeout
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 1.5)
	await get_tree().create_timer(3).timeout
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 1.5)
	await get_tree().create_timer(3).timeout
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 1.5)
	await get_tree().create_timer(3).timeout
	label.show()
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://Scenes/isometric_tilemap.tscn")
	
	

func camera_transition(node, property, fin_val, duration):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, property, fin_val, duration)
