extends CharacterBody2D
@onready var enemy_animation: AnimatedSprite2D = $enemy_animation
@onready var imp: CharacterBody2D = $"."
@onready var soft_collision: Area2D = $soft_collision
const FIREBALL = preload("res://Scenes/fireball.tscn")
var shoot = true
var fireball
var returning = false
var speed = 40
var player_chase = false
var og_position

var player = null
@export var health = 3
@export var damage = 1
var player_cpos
@onready var shoot_cd: Timer = $shoot_cd

func _ready() -> void:
	og_position = position
	pass
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
			
			if position.distance_to(player.position) < 150 && shoot:
				print("Flying imp has shot a fireball")
				enemy_animation.play("hawk_tuah")
		elif returning:
			if og_position[0] > position[0]:
				enemy_animation.flip_h = true
			else:
				enemy_animation.flip_h = false
			var direction = (og_position - position).normalized()
			position += direction * speed * delta
			
			if position.distance_to(og_position)<40:
				enemy_animation.play("idle")
				returning = false		
				

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_chase = true
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		print("flying imp has taken damage")
		health -= area.damage
		if health > 0:
			enemy_animation.play("hurt")
		if health <= 0:
			print("flying imp has died")
			GlobalVariables.xp += 1
			enemy_animation.play("death")
			await get_tree().create_timer(1).timeout
			imp.queue_free()
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)
		
func shoot_fireball():
	shoot = false
	shoot_cd.start()
	var fireball = FIREBALL.instantiate()
	get_tree().current_scene.add_child(fireball)
	fireball.global_position = global_position
	fireball.direction = ((player.position + Vector2(0,-15)) - position ).normalized()
	#print("Enemy position:", global_position)
	#print("Player position:", player.global_position)
	#print("Fireball direction:", fireball.direction)


func _on_shoot_cd_timeout() -> void:
	shoot = true


func _on_enemy_animation_animation_finished() -> void:
	shoot_fireball()


func _on_aggro_off_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_chase = false
		returning = true
		enemy_animation.play("idle")
