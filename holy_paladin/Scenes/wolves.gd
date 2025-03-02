extends CharacterBody2D
@onready var wolves: CharacterBody2D = $"."
@onready var area_2d: Area2D = $wolf_animation/Area2D

var copy = false
var returning = false
var og_position
var speed = 95.0
var player_chase = false
var player = null
@export var health = 3
@export var damage = 1
var idle = ""
@onready var wolf_animation: AnimatedSprite2D = $wolf_animation
var colour = ""
var rng = RandomNumberGenerator.new()

func _ready():
	og_position = position
	#Annetaan susille numero 1 ja 4 väliltä jonka avulla valitaan suden animaation värit
	var colour_num = rng.randi_range(1,4)
	if colour_num == 1:
		colour = "grey"
	elif colour_num == 2:
		colour = "brown"
	elif colour_num == 3:
		colour = "mushroom"
	elif colour_num == 4:
		colour = "mushroom"
	elif colour_num == 5:
		colour = "mushroom"
	else:
		colour = "white"
	#print("Wolves colour is " + colour)

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if is_instance_valid(wolf_animation):
		if !wolf_animation.is_playing():
			wolf_animation.play(colour + "_idle")
		#Kääntää suden idle animaation suunnan 1/1500 todennäköisyydellä per frami
		#if RandomNumberGenerator.new().randi_range(0, 10000)==9 && wolf_animation.animation == colour + "_idle":
			#print("Wolf has turned around")
			#if wolf_animation.flip_h:
				#wolf_animation.flip_h = false
			#else:
				#wolf_animation.flip_h = true
		#Pistää suden jahtaamaan pelaajaa
		if player_chase && !wolf_animation.animation == (colour + "_hit") && !wolf_animation.animation == (colour + "_death") && !wolf_animation.animation == (colour + "_attack"):
			wolf_animation.play(colour + "_run")
			velocity = Vector2(1, 0)
			if player.position[0] > position[0]:
				wolf_animation.flip_h = true
			else:
				wolf_animation.flip_h = false
			var direction = ((player.position-Vector2(0, 20)) - position).normalized()
			position += direction * speed * delta
			
			# Hyökkää pelaajaan jos etäisyys on alle 25
			if position.distance_to(player.position)<25:
				print("Wolf attacked player")
				wolf_animation.play(colour + "_attack")
		
		#Palauttaa suden takaisin alkuperäisellä paikalleen
		elif returning:
			if og_position[0] > position[0]:
				wolf_animation.flip_h = true
			else:
				wolf_animation.flip_h = false
			var direction = (og_position - position).normalized()
			position += direction * speed * delta
			
			#if velocity == Vector2(0,0):
				#wolf_animation.play(colour + "_idle")
				
			if position.distance_to(og_position)<2:
				wolf_animation.play(colour + "_idle")
				returning = false

#Antaa signaalin, että on aika lähteä jahtaamaan pelaajaa
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		player_chase = true
	

#Susi ottaa damagea kun siihen lyödään ja kuolee kun healtti menee nollaan.
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		print("Wolf has taken damage")
		health -= area.damage
		if health > 0:
			wolf_animation.play(colour + "_hit")
		if health <= 0:
			print("Wolf has died")
			GlobalVariables.xp += 1
			wolf_animation.play(colour + "_death")
			area_2d.queue_free()
			await get_tree().create_timer(1).timeout
			wolves.queue_free()
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)

#Antaa signaalin, jonka jälkeen susi alkaa palaamaan alkuperäiselle paikalleen 
func _on_aggro_off_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		returning = true
		player_chase = false
		wolf_animation.play(colour + "_run")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print("wolf entered screen!")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("wolf exited screen!")


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	wolves.show
	print("wolf showing")

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	wolves.hide
	print("wolf hidden")
