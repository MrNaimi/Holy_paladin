extends CharacterBody2D
@onready var animation_hitbox: AnimationPlayer = $Area2D/animation_hitbox
@onready var player_animations: AnimatedSprite2D = $Player_animations
@onready var combo_timer: Timer = $ComboTimer

var combo = 1
@export var SPEED = 100.0

var current_speed = 0
func _ready():
	print("pylly")
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	
	#IF statements to flip sprite and play the walking animation
	if input_direction.x > 0:
		player_animations.flip_h = false;
		player_animations.play("walk")
	elif input_direction.x < 0:
		player_animations.flip_h = true;
		player_animations.play("walk")
	if input_direction.y != 0:
		player_animations.play("walk")
	if input_direction.x == 0 && input_direction.y == 0:
		if player_animations.animation != "light_attack1" && player_animations.animation != "light_attack2":
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
			if combo == 1:
				combo_timer.stop()
				player_animations.play("light_attack1")
				print("attack1 played")
				combo_timer.start()
				combo = 2
				print("timer started")
			elif combo == 2:
				combo_timer.stop()
				player_animations.play("light_attack2")
				print("attack2 played")
				combo_timer.start()
				combo = 3
			elif combo == 3:
				combo_timer.stop()
				player_animations.play("light_attack3")
				print("attack3 played")
				combo = 1
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	#Määritän tässä characterin tämänhetkisen nopeuden
	current_speed = sqrt(velocity.x*velocity.x+velocity.y*velocity.y)


func _on_combo_timer_timeout() -> void:
	combo = 1
