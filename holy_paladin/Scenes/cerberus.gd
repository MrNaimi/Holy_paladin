extends CharacterBody2D
@onready var wolves: CharacterBody2D = $"."
@onready var boss_sound: AudioStreamPlayer2D = $Boss_sound
var direction = Vector2(0, 0)
var charg_d = Vector2(0,0)
var cerb_charged = true
var copy = false
var returning = false
var og_position
var speed = 250.0
var player_chase = false
var player = null
@export var health = 20
@export var damage = 5
var idle = ""
@onready var wolf_animation: AnimatedSprite2D = $wolf_animation
var colour = ""
@onready var timer: Timer = $Timer

func _ready():
	og_position = position
	colour = "black"
func _physics_process(delta: float) -> void:
	GlobalVariables.cerberus_health = health
	move_and_slide()
	
	if is_instance_valid(wolf_animation):
		if !wolf_animation.is_playing():
			wolf_animation.play(colour + "_idle")
		#Kääntää suden idle animaation suunnan 1/1500 todennäköisyydellä per frami
		if RandomNumberGenerator.new().randi_range(0, 10000)==9 && wolf_animation.animation == colour + "_idle":
			print("Cerberus turned")
			if wolf_animation.flip_h:
				wolf_animation.flip_h = false
			else:
				wolf_animation.flip_h = true
		#Pistää suden jahtaamaan pelaajaa
		if player_chase and wolf_animation.animation not in [colour + "_hit", colour + "_death", colour + "_attack", "break"]:
			wolf_animation.play(colour + "_run")
			velocity = Vector2(1, 0)
			if  cerb_charged:
				speed = 250
				print("CERB CHARGING")
				timer.start()
				
				if player.position[0] > position[0]:
					wolf_animation.flip_h = true
				else:
					wolf_animation.flip_h = false
				
				direction = ((player.position-Vector2(0, 20)) - position).normalized()
				charg_d = direction
				cerb_charged = false
			
			position += charg_d * speed * delta
		
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
		GlobalVariables.cerb_hp_bar = true
		boss_sound.play(0)
	

#Susi ottaa damagea kun siihen lyödään ja kuolee kun healtti menee nollaan.
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		print("Cerb has taken damage")
		print(GlobalVariables.cerberus_health)
		health -= area.damage
		if health <= 0:
			print("Wolf has died")
			GlobalVariables.xp += 1
			wolf_animation.play(colour + "_death")
			await get_tree().create_timer(1).timeout
			GlobalVariables.cerb_hp_bar = false
			wolves.queue_free()
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)

#Antaa signaalin, jonka jälkeen susi alkaa palaamaan alkuperäiselle paikalleen 
func _on_aggro_off_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		returning = true
		player_chase = false
		wolf_animation.play(colour + "_run")


func _on_timer_timeout() -> void:
	speed = 0
	wolf_animation.stop()
	wolf_animation.play("break")
	await get_tree().create_timer(2).timeout
	cerb_charged = true
