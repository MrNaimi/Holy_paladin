extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var target: CharacterBody2D = $"../../Player"
var speed = 10
func _physics_process(delta: float) -> void:
	var direction = (target.position-position).normalized()
	velocity = direction*speed
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("area entered")
	if area.is_in_group("attack"):
		animation_player.play("death")
		speed = 0
		await get_tree().create_timer(1.5).timeout
		GlobalVariables.enemy_spawned = true
		GlobalVariables.enemies_killed += 1
		queue_free()
		
		
