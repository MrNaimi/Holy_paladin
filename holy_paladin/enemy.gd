extends CharacterBody2D

@onready var target: CharacterBody2D = $"../Player"

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var speed = 30
func _physics_process(delta: float) -> void:
	ray_cast_2d.set_target_position(target.position-position)
	#print(ray_cast_2d.get_collider())
	if ray_cast_2d.get_collider() is not TileMapLayer:
		var direction = (target.position-position).normalized()
		velocity = direction*speed
		move_and_slide()
	else:
		pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("area entered")
	GlobalVariables.enemies_killed += 1
	if area.is_in_group("attack"):
		queue_free()
