extends CharacterBody2D
@onready var enemy_animation: AnimatedSprite2D = $enemy_animation

var speed = 95.0
var player_chase = false
var player = null
var health = 3




func _physics_process(delta: float) -> void:
	if !enemy_animation.is_playing():
		enemy_animation.play("idle")
	if player_chase && !enemy_animation.animation == "hurt":
		enemy_animation.play("flying")
		velocity = Vector2(1, 0)
		if player.position[0] > position[0]:
			enemy_animation.flip_h = true
		else:
			enemy_animation.flip_h = false
		position += (player.position - position)/speed

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("IM HURTING :()")
	health -= 1
	if health > 0:
		enemy_animation.play("hurt")
	if health == 0:
		enemy_animation.play("hurt")
