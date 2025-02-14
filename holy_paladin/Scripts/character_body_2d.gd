extends CharacterBody2D
@onready var animation_hitbox: AnimationPlayer = $Area2D/animation_hitbox
@onready var player_animations: AnimatedSprite2D = $Player_animations
@onready var pieru: AudioStreamPlayer2D = $"../pieru"
@onready var player: CharacterBody2D = $"."

var copy = false
var pierucounter = 0
var combo = 1
var processiterations = 0
var dashing
var jumping
@onready var SPEED = GlobalVariables.playerSpeed
@onready var hp = GlobalVariables.playerHealth
@export var spell_radius = 150
#Viittaukset player attackkeihin

const LEVEL_UP = preload("res://Scenes/level_up.tscn")

#Viittaukset player attackkeihin
#@onready var spell_collision: CollisionShape2D = $AttackHitboxes/Spell/CollisionShape2D
#@onready var spell: Area2D = $AttackHitboxes/Spell
#@onready var spell_animation: AnimatedSprite2D = $AttackHitboxes/Spell/AnimatedSprite2D
@onready var spell_collision: CollisionShape2D = $"../Spell/CollisionShape2D"
@onready var spell: Area2D = $"../Spell"
@onready var spell_animation: AnimatedSprite2D = $"../Spell/AnimatedSprite2D"
@onready var animation_player: AnimationPlayer = $Timers/AnimationPlayer
@onready var skill_tree: Control = $"../../CanvasLayer/SkillTree"

const WOLVES = preload("res://Scenes/wolves.tscn")
const IMPS = preload("res://Scenes/imps.tscn")
@onready var viewport = get_viewport()


#tässä määritellään timereihin viittaus
@onready var animation_timer: Timer = $Timers/AnimationTimer
@onready var combo_timer: Timer = $Timers/ComboTimer
@onready var invincibility_timer: Timer = $Timers/InvincibilityTimer
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var spell_cooldown_timer: Timer = $Timers/SpellCooldownTimer
@onready var jump_timer: Timer = $Timers/JumpTimer

@onready var camera_2d: Camera2D = $Camera2D

@onready var light_attack_1: Area2D = $AttackHitboxes/Light_attack1
@onready var light_attack_2: Area2D = $AttackHitboxes/Light_attack2
@onready var light_attack_3: Area2D = $AttackHitboxes/Light_attack3
#@onready var tween = get_tree().create_tween()
@onready var tween_direction = 1



var current_speed = 0
func _ready():
	player.global_position = GlobalVariables.player_spawn_location
	var spell_radius = 150
	var mouseposition = null
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED

	
	if get_viewport().get_mouse_position().x >= get_viewport().size.x/2 and input_direction.x != 0:
		if !dashing and !jumping:
			player_animations.play("walk")
		else:
			pass
	elif get_viewport().get_mouse_position().x <= get_viewport().size.x/2 and input_direction.x != 0:
		if !dashing and !jumping:
			player_animations.play("walk")
		else:
			pass
	if input_direction.y != 0:
		if !dashing and !jumping:
			player_animations.play("walk")
		else:
			pass
	if input_direction.x == 0 && input_direction.y == 0:
		if !player_animations.is_playing():
			player_animations.play("idle")
			
#checkaa mouse inputin kun clickaa. toistaa atm vaan animaation kerran
func _input(event):
	
	if event.is_action_pressed("esc"):
		if skill_tree.visible:
				skill_tree.visible = false
				
	if event.is_action_pressed("talents"):
		if skill_tree.visible:
			skill_tree.visible = false
		else:
			skill_tree.visible = true
	
	if event.is_action_pressed("dash") and dash_cooldown_timer.is_stopped() and skill_tree.checkSkill("Dash"):
		dash_cooldown_timer.start()
		print("Player used dash")
		invincibility_timer.start()
		get_tree().create_tween().tween_property(self, "position", Vector2(position.x+velocity.x-10, position.y+velocity.y-10),0.3)
		if velocity.x > 0:
			player_animations.flip_h = false
			GlobalVariables.flip_h = false
		elif velocity.x < 0:
			player_animations.flip_h = true
			GlobalVariables.flip_h = true
		player_animations.play("dash")
		animation_timer.start()
		dashing = true
	
	if event.is_action_pressed("jump") and jump_timer.is_stopped():
		jump_timer.start()
		print("Player used jump")
		player_animations.play("jump")
		animation_timer.start()
		jumping = true
			
	if current_speed==0:
		if event.is_action_pressed("taunt") and spell_cooldown_timer.is_stopped():
			spell_cooldown_timer.start()
			print("Player used taunt/spell")
			#Seuraa pelaajan hiirtä ja heittää spell hitboxin siihen.
			var mouse_pos = get_global_mouse_position()
			var player_pos = player.global_transform.origin + Vector2(0, -15)
			var distance = player_pos.distance_to(mouse_pos)
			var mouse_dir = (mouse_pos-player_pos).normalized()
			if distance > spell_radius:
				mouse_pos = player_pos + (mouse_dir*spell_radius)
			spell_collision.global_transform.origin = mouse_pos
			spell_animation.global_transform.origin = mouse_pos + Vector2(-27, 4)
			
			player_animations.play("taunt")
			spell.enableHitBox()
			
		if event.is_action_pressed("attack") and !skill_tree.visible:
			print("Mouse 1 clicked")
			if get_viewport().get_mouse_position().x >= get_viewport().size.x / 2:
				if !copy:
					GlobalVariables.flip_h = false
					player_animations.flip_h = false
				elif !copy:
					GlobalVariables.flip_h = true
					player_animations.flip_h = true
				if copy:
					player_animations.flip_h = GlobalVariables.flip_h
			match combo:
				1:
					if player_animations.animation == "idle":
						combo_timer.stop()
						player_animations.play("light_attack1")
						if player_animations.flip_h:
							tween_direction = -1
						light_attack_1.enableHitBox()
						print("Light attack 1 used")
						combo_timer.start()
						combo = 2
						print("Combo timer started")
				2:
					if player_animations.animation == "idle":
						combo_timer.stop()
						player_animations.play("light_attack2")
						print("Light attack 2 used")
						light_attack_2.enableHitBox()
						combo_timer.start()
						combo = 3
				3:
					if player_animations.animation == "idle":
						combo_timer.stop()
						player_animations.play("light_attack3")
						light_attack_3.enableHitBox()
						print("Light attack 3 used")
						combo = 1
			
func _physics_process(delta: float) -> void:
	SPEED = GlobalVariables.playerSpeed
	hp = GlobalVariables.playerHealth
	if GlobalVariables.xp >= GlobalVariables.xp_threshold:
		level_up()
		
	GlobalVariables.playerpos = position
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
	if !dashing:
		if get_viewport().get_mouse_position().x >= get_viewport().size.x/2:
			player_animations.flip_h = false
		elif get_viewport().get_mouse_position().x <= get_viewport().size.x/2:
			player_animations.flip_h = true
		
func level_up():
	var level_up = LEVEL_UP.instantiate()
	get_tree().current_scene.add_child(level_up)
	level_up.global_position = self.global_position + Vector2(0, -40)
	GlobalVariables.level += 1
	GlobalVariables.xp_threshold = GlobalVariables.level
	GlobalVariables.xp = 0
	GlobalVariables.talentpoints += 1
	GlobalVariables.skillpoints += 1
			
func hurt(damage):
	if invincibility_timer.is_stopped():
		GlobalVariables.playerHealth -= damage
		animation_player.play("hit")
		invincibility_timer.start()
	else:
		pass

func _on_combo_timer_timeout() -> void:
	combo = 1


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_animation_timer_timeout() -> void:
	dashing = false


func _on_jump_timer_timeout() -> void:
	jumping = false
	
