extends Camera2D
@onready var camera_2d: Camera2D = $"."

var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 2.0)
	await get_tree().create_timer(4).timeout
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 2.0)
	await get_tree().create_timer(4).timeout
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 2.0)
	await get_tree().create_timer(4).timeout
	camera_transition(camera_2d, "position",camera_2d.position +Vector2(240,0) , 2.0)
	

func camera_transition(node, property, fin_val, duration):
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(node, property, fin_val, duration)
