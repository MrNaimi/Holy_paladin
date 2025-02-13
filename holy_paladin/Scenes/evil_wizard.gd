extends CharacterBody2D
@onready var wolves: CharacterBody2D = $"."

var copy = false
var returning = false
var og_position
var speed = 75.0
var player_chase = false
var player = null
@export var health = 3
@export var damage = 1
var idle = ""
@onready var wizard_animation: AnimatedSprite2D = $wizard_animation
var colour = ""
var rng = RandomNumberGenerator.new()

func _ready():
	og_position = position
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if is_instance_valid(wizard_animation):
		if !wizard_animation.is_playing():
			wizard_animation.play( "idle")
		#Kääntää suden idle animaation suunnan 1/1500 todennäköisyydellä per frami
		if RandomNumberGenerator.new().randi_range(0, 10000)==9 && wizard_animation.animation == "idle":
			print("Wizard has turned around")
			if wizard_animation.flip_h:
				wizard_animation.flip_h = true
			else:
				wizard_animation.flip_h = false
		#Pistää suden jahtaamaan pelaajaa
		if player_chase and !wizard_animation.animation in ["hit", "death"]:
			if wizard_animation.animation != "attack":
				wizard_animation.play("run")
			velocity = Vector2(1, 0)
			if player.position[0] > position[0]:
				wizard_animation.flip_h = false
			else:
				wizard_animation.flip_h = true
			var direction = ((player.position-Vector2(0, 20)) - position).normalized()
			position += direction * speed * delta
			
			# Hyökkää pelaajaan jos etäisyys on alle 25
			if position.distance_to(player.position)<60:
				print("Wizard attacked player")
				wizard_animation.play("attack")
				direction = ((player.position-Vector2(0, 20)) - position).normalized()
				speed = 30

			if position.distance_to(player.position)>100:
				wizard_animation.play("run")
				speed = 75
			
		#Palauttaa suden takaisin alkuperäisellä paikalleen
		elif returning:
			if og_position[0] > position[0]:
				wizard_animation.flip_h = false
			else:
				wizard_animation.flip_h = true
			var direction = (og_position - position).normalized()
			position += direction * speed * delta
			
			#if velocity == Vector2(0,0):
				#wizard_animation.play("idle")
				
			if position.distance_to(og_position)<2:
				wizard_animation.play("idle")
				returning = false

#Antaa signaalin, että on aika lähteä jahtaamaan pelaajaa
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_chase = true
	

#Susi ottaa damagea kun siihen lyödään ja kuolee kun healtti menee nollaan.
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		print("Wizard has taken damage")
		health -= area.damage
		if health > 0:
			wizard_animation.play("hit")
			speed = 75
		if health <= 0:
			print("Wizard has died")
			GlobalVariables.xp += 1
			wizard_animation.play("death")
			await get_tree().create_timer(1).timeout
			wolves.queue_free()
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)

#Antaa signaalin, jonka jälkeen susi alkaa palaamaan alkuperäiselle paikalleen 
func _on_aggro_off_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		returning = true
		player_chase = false
		wizard_animation.play("run")
