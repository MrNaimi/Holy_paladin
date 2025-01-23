extends CharacterBody2D
@onready var target: CharacterBody2D = $"../Player"

var speed = 30
func _physics_process(delta: float) -> void:
	var direction = (target.position-position).normalized()
	velocity = direction*speed
	#look_at(target.position)
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("area entered")
	if area.is_in_group("attack"):
		queue_free()
