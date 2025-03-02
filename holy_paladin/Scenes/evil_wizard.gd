extends CharacterBody2D
@onready var wolves: CharacterBody2D = $"."
@onready var hitbox: CollisionShape2D = $wizard_animation/fire_area/CollisionShape2D
@onready var original_position = hitbox.position.x
@onready var flipped_position = original_position * -1
@onready var evil_wizard: CharacterBody2D = $"."
@onready var area_2d: Area2D = $wizard_animation/Area2D

@onready var fire_area: Area2D = $wizard_animation/fire_area

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
				hitbox.position.x = original_position
			else:
				hitbox.position.x = flipped_position
				wizard_animation.flip_h = true
			var direction = ((player.position-Vector2(0, 20)) - position).normalized()
			position += direction * speed * delta
			
			# Hyökkää pelaajaan jos etäisyys on alle 25
			if position.distance_to(player.position)<80:
				wizard_animation.play("attack")
				direction = ((player.position-Vector2(0, 20)) - position).normalized()
				speed = 30

			if position.distance_to(player.position)>120:
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
			area_2d.queue_free()
			await get_tree().create_timer(1).timeout
			wolves.queue_free()

#Antaa signaalin, jonka jälkeen susi alkaa palaamaan alkuperäiselle paikalleen 
func _on_aggro_off_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		returning = true
		player_chase = false
		wizard_animation.play("run")


func _on_fire_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)

func _on_fire_area_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	evil_wizard.show
	print("wizard shows")

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	evil_wizard.hide
	print("wizard hidden")
