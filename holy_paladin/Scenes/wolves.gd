extends CharacterBody2D
@onready var wolves: CharacterBody2D = $"."


var speed = 95.0
var player_chase = false
var player = null
@export var health = 3
@export var damage = 1
@onready var wolf_animation: AnimatedSprite2D = $wolf_animation




func _physics_process(delta: float) -> void:
	move_and_slide()
	if is_instance_valid(wolf_animation):
		if !wolf_animation.is_playing():
			wolf_animation.play("idle")
		if player_chase && !wolf_animation.animation == "hit" && !wolf_animation.animation == "death":
			wolf_animation.play("run")
			velocity = Vector2(1, 0)
			if player.position[0] > position[0]:
				wolf_animation.flip_h = true
			else:
				wolf_animation.flip_h = false
			position += (player.position - position)/speed

func _on_detection_area_body_entered(body: Node2D) -> void:
	print("JIppikaijeis")
	if body.name == "Player":
		player = body
		player_chase = true
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.is_in_group("attack"):
		print("IM HURTING :()")
		health -= area.damage
		if health > 0:
			wolf_animation.play("hit")
		if health <= 0:
			print("älä lyö vittu")
			GlobalVariables.xp += 1
			wolf_animation.play("death")
			await get_tree().create_timer(1).timeout
			wolves.queue_free()
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)
