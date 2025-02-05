extends CharacterBody2D
@onready var enemy_animation: AnimatedSprite2D = $enemy_animation
@onready var imp: CharacterBody2D = $"."
@onready var soft_collision: Area2D = $soft_collision


var speed = 60
var player_chase = false
var player = null
@export var health = 3
@export var damage = 1




func _physics_process(delta: float) -> void:
	move_and_slide()
	if is_instance_valid(enemy_animation):
		if !enemy_animation.is_playing():
			enemy_animation.play("idle")
		if player_chase && !enemy_animation.animation == "hurt" && !enemy_animation.animation == "death" && !enemy_animation.animation == "hawk_tuah":
			enemy_animation.play("flying")
			velocity = Vector2(1, 0)
			if player.position[0] > position[0]:
				enemy_animation.flip_h = true
			else:
				enemy_animation.flip_h = false
			var direction = (player.position - position).normalized()
			position += direction * speed * delta
			if position.distance_to(player.position) < 75:
				print("Hawk tuah")
				enemy_animation.play("hawk_tuah")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_chase = true
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.is_in_group("attack"):
		print("IM HURTING :()")
		health -= area.damage
		if health > 0:
			enemy_animation.play("hurt")
		if health <= 0:
			print("älä lyö vittu")
			GlobalVariables.xp += 1
			enemy_animation.play("death")
			await get_tree().create_timer(1).timeout
			imp.queue_free()
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)
