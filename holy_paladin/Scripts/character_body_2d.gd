extends CharacterBody2D
@onready var animation_hitbox: AnimationPlayer = $Area2D/animation_hitbox
@onready var player_animations: AnimatedSprite2D = $Player_animations
@onready var combo_timer: Timer = $ComboTimer
@onready var pieru: AudioStreamPlayer2D = $"../pieru"
@onready var player: CharacterBody2D = $"."
var pierucounter = 0
var combo = 1
var processiterations = 0
var dashing
@export var SPEED = 100.0
@onready var hp = 10

#Viittaukset player attackkeihin
@onready var animation_timer: Timer = $AnimationTimer

@onready var light_attack_1: Area2D = $AttackHitboxes/Light_attack1
@onready var light_attack_2: Area2D = $AttackHitboxes/Light_attack2
@onready var light_attack_3: Area2D = $AttackHitboxes/Light_attack3
#@onready var tween = get_tree().create_tween()
@onready var tween_direction = 1

var current_speed = 0
func _ready():
	print("pylly")
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	
	if get_viewport().get_mouse_position().x >= get_viewport().size.x/2 and input_direction.x != 0:
		if !dashing:
			player_animations.play("walk")
		else:
			pass
	elif get_viewport().get_mouse_position().x <= get_viewport().size.x/2 and input_direction.x != 0:
		if !dashing:
			player_animations.play("walk")
		else:
			pass
	if input_direction.y != 0:
		if !dashing:
			player_animations.play("walk")
		else:
			pass
	if input_direction.x == 0 && input_direction.y == 0:
		if !player_animations.is_playing():
			player_animations.play("idle")
			
#checkaa mouse inputin kun clickaa. toistaa atm vaan animaation kerran
func _input(event):
	if event.is_action_pressed("dash") and velocity.x != 0:
		print("dash pressed")
		if velocity.x > 0:
			player_animations.flip_h = false
		elif velocity.x < 0:
			player_animations.flip_h = true
		player_animations.play("dash")
		if !player_animations.flip_h:
			get_tree().create_tween().tween_property(self, "position", Vector2(position.x+tween_direction*120, position.y),0.5)
			tween_direction = 1
		elif player_animations.flip_h:
			get_tree().create_tween().tween_property(self, "position", Vector2(position.x-tween_direction*120, position.y),0.5)
			tween_direction = 1
		animation_timer.start()
		dashing = true
			
	if current_speed==0:
		if event.is_action_pressed("attack"):
			print("mouse clicked")
			if get_viewport().get_mouse_position().x >= get_viewport().size.x / 2:
				player_animations.flip_h = false
			else:
				player_animations.flip_h = true
			match combo:
				1:
					if player_animations.animation == "idle":
						combo_timer.stop()
						player_animations.play("light_attack1")
						if player_animations.flip_h:
							tween_direction = -1
						light_attack_1.enableHitBox()
						print("attack1 played")
						combo_timer.start()
						combo = 2
						print("timer started")
				2:
					if player_animations.animation == "idle":
						combo_timer.stop()
						player_animations.play("light_attack2")
						print("attack2 played")
						light_attack_2.enableHitBox()
						combo_timer.start()
						combo = 3
				3:
					if player_animations.animation == "idle":
						combo_timer.stop()
						player_animations.play("light_attack3")
						light_attack_3.enableHitBox()
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
	if RandomNumberGenerator.new().randi_range(0, 1000000)==9:
		pierucounter+=1
		pieru.play(0)
	
	if get_viewport().get_mouse_position().x >= get_viewport().size.x/2:
		player_animations.flip_h = false;
	elif get_viewport().get_mouse_position().x <= get_viewport().size.x/2:
		player_animations.flip_h = true;
		
	
func _on_combo_timer_timeout() -> void:
	combo = 1


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_animation_timer_timeout() -> void:
	dashing = false
