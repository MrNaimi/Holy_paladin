extends Area2D

var speed = 400
var move_direction

func _physics_process(delta):
	position += move_direction * speed * delta



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		queue_free()
