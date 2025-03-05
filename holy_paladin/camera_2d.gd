extends Camera2D
@onready var camera_2d: Camera2D = $"."
@onready var label = $"../Label"
@onready var sound: AudioStreamPlayer2D = $"../sound"
@onready var sound_2: AudioStreamPlayer2D = $"../sound2"
@onready var animation_player: AnimationPlayer = $"../ColorRect2/AnimationPlayer"

var ISOMETRIC_TILEMAP = preload("res://Scenes/isometric_tilemap.tscn")
var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.hide()
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(300,0) , 2)
	sound_2.play()
	await get_tree().create_timer(4).timeout
	#sound.stop()
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(320,0) , 2)
	#sound.play()
	await get_tree().create_timer(4).timeout
	#sound.stop()
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(320,0) , 2)
	#sound.play()
	await get_tree().create_timer(4).timeout
	#sound.stop()
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(330,0) , 2)
	await get_tree().create_timer(4).timeout
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(330,0) , 2)
	await get_tree().create_timer(4).timeout
	#sound.stop()
	label.show()
	sound.play()
	await get_tree().create_timer(4).timeout
	animation_player.play("fade")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/isometric_tilemap.tscn")
	
	

func camera_transition(node, property, fin_val, duration):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, property, fin_val, duration)
