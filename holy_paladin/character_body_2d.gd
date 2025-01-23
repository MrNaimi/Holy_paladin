extends CharacterBody2D
@onready var animation_hitbox: AnimationPlayer = $Area2D/animation_hitbox
@onready var player_animations: AnimatedSprite2D = $Player_animations
@onready var combo_timer: Timer = $ComboTimer
@onready var pieru: AudioStreamPlayer2D = $"../pieru"
var pierucounter = 0
var combo = 1
var processiterations = 0
@export var SPEED = 100.0
@onready var light_attack_1: Area2D = $AttackHitboxes/Light_attack1
@onready var light_attack_2: Area2D = $AttackHitboxes/Light_attack2
@onready var light_attack_3: Area2D = $AttackHitboxes/Light_attack3
var enabled_hitbox
@onready var hit_box_timer: Timer = $HitBoxTimer


var current_speed = 0
func _ready():
	print("pylly")
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	
	#IF statements to flip sprite and play the walking animation
	if get_viewport().get_mouse_position().x >= get_viewport().size.x/2 and input_direction.x != 0:
		player_animations.flip_h = false;
		player_animations.play("walk")
	elif get_viewport().get_mouse_position().x <= get_viewport().size.x/2 and input_direction.x != 0:
		player_animations.flip_h = true;
		player_animations.play("walk")
	if input_direction.y != 0:
		player_animations.play("walk")
	if input_direction.x == 0 && input_direction.y == 0:
		if !player_animations.is_playing():
			player_animations.play("idle")
			
		
#checkaa mouse inputin kun clickaa. toistaa atm vaan animaation kerran
func _input(event):
	if current_speed==0:
		if event.is_action_pressed("attack"):
			print("mouse clicked")
			if get_viewport().get_mouse_position().x >= get_viewport().size.x/2:
				player_animations.flip_h = false;
			else:
				player_animations.flip_h = true;
			if combo == 1 and player_animations.animation == "idle":
				combo_timer.stop()
				player_animations.play("light_attack1")
				light_attack_1.get_child(0).disabled = false
				enabled_hitbox=light_attack_1.get_child(0)
				hit_box_timer.start()
				print("attack1 played")
				combo_timer.start()
				combo = 2
				print("timer started")
			elif combo == 2 and player_animations.animation == "idle":
				combo_timer.stop()
				player_animations.play("light_attack2")
				print("attack2 played")
				light_attack_2.get_child(0).disabled = false
				enabled_hitbox=light_attack_2.get_child(0)
				hit_box_timer.start()
				combo_timer.start()
				combo = 3
			elif combo == 3 and player_animations.animation == "idle":
				combo_timer.stop()
				player_animations.play("light_attack3")
				light_attack_3.get_child(0).disabled = false
				enabled_hitbox=light_attack_3.get_child(0)
				hit_box_timer.start()
				print("attack3 played")
				combo = 1
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	if current_speed==0 and player_animations.animation == "walk":
		player_animations.stop()
	#Määritän tässä characterin tämänhetkisen nopeuden
	processiterations += 1
	current_speed = sqrt(velocity.x*velocity.x+velocity.y*velocity.y)
	
	#TÄRKEÄ PIERUÄÄNI
	if RandomNumberGenerator.new().randi_range(0, 10000)==9:
		pierucounter+=1
		pieru.play(0)
		
func _on_combo_timer_timeout() -> void:
	combo = 1


func _on_hit_box_timer_timeout() -> void:
	enabled_hitbox.disabled = true
