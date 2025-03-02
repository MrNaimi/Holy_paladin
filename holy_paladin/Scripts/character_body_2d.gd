extends CharacterBody2D
@onready var animation_hitbox: AnimationPlayer = $Area2D/animation_hitbox
@onready var player_animations: AnimatedSprite2D = $Player_animations
@onready var pieru: AudioStreamPlayer2D = $"../pieru"
@onready var player: CharacterBody2D = $"."
@onready var shadow: Sprite2D = $Player_animations/shadow

var first_time = true
var shadow_changeable2 = true
var shadow_changeable = true
var copy = false
var pierucounter = 0
var combo = 1
var processiterations = 0
var dashing
var jumping
var leaping
var spinning
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
@onready var leap_animation: AnimatedSprite2D = $Leap_animation
@onready var heal_animation: AnimatedSprite2D = $Heal_animation

@onready var animation_player: AnimationPlayer = $Timers/AnimationPlayer
@onready var skill_tree: Control = $"../../CanvasLayer/SkillTree"

const WOLVES = preload("res://Scenes/wolves.tscn")
const IMPS = preload("res://Scenes/imps.tscn")

@onready var pause_menu: Control = $"../../CanvasLayer/PauseMenu"


@onready var viewport = get_viewport()

#Action bar buttons
@onready var action_1: TextureButton = $"../../CanvasLayer/BottomLeft/progressbars/ActionBar/Action1"
@onready var action_2: TextureButton = $"../../CanvasLayer/BottomLeft/progressbars/ActionBar/Action2"
@onready var action_3: TextureButton = $"../../CanvasLayer/BottomLeft/progressbars/ActionBar/Action3"
@onready var action_4: TextureButton = $"../../CanvasLayer/BottomLeft/progressbars/ActionBar/Action4"
@onready var action_5: TextureButton = $"../../CanvasLayer/BottomLeft/progressbars/ActionBar/Action5"


#tässä määritellään timereihin viittaus
@onready var animation_timer: Timer = $Timers/AnimationTimer
@onready var combo_timer: Timer = $Timers/ComboTimer
@onready var invincibility_timer: Timer = $Timers/InvincibilityTimer
@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var spell_cooldown_timer: Timer = $Timers/SpellCooldownTimer
@onready var heal_cooldown_timer: Timer = $Timers/HealCooldownTimer
@onready var holy_projectile_cooldown_timer: Timer = $Timers/HolyProjectileCooldownTimer
@onready var AOE_cooldown_timer: Timer = $Timers/AoECooldownTimer


@onready var jump_timer: Timer = $Timers/JumpTimer
@onready var leap_timer: Timer = $Timers/LeapTimer
@onready var spin_timer: Timer = $Timers/SpinTimer

@onready var camera_2d: Camera2D = $Camera2D

@onready var spin_hit_box: Area2D = $AttackHitboxes/SpinHitBox
@onready var jump_hit_box: Area2D = $AttackHitboxes/JumpHitBox
@onready var leap_hit_box: Area2D = $AttackHitboxes/LeapHitBox

@onready var light_attack_1: Area2D = $AttackHitboxes/Light_attack1
@onready var light_attack_2: Area2D = $AttackHitboxes/Light_attack2
@onready var light_attack_3: Area2D = $AttackHitboxes/Light_attack3
#@onready var tween = get_tree().create_tween()
@onready var tween_direction = 1
var attacking = false

@onready var walking: AudioStreamPlayer2D = $audios/walking

@export var holy_projectile: PackedScene

var current_speed = 0
func _ready():
	player.global_position = GlobalVariables.player_spawn_location
	var spell_radius = 150
	var mouseposition = null
	leap_animation.visible = false
	heal_animation.visible = false
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED

	
	if get_viewport().get_mouse_position().x >= get_viewport().size.x/2 and input_direction.x != 0:
		if !dashing and !jumping and !attacking and !leaping and !spinning:
			player_animations.play("walk")
			if !walking.playing:
				walking.pitch_scale=RandomNumberGenerator.new().randf_range(0.9, 1.2)
				walking.play()
		else:
			pass
	elif get_viewport().get_mouse_position().x <= get_viewport().size.x/2 and input_direction.x != 0:
		if !dashing and !jumping and !attacking and !leaping and !spinning:
			player_animations.play("walk")
			if !walking.playing:
				walking.pitch_scale=RandomNumberGenerator.new().randf_range(0.9, 1.2)
				walking.play()
		else:
			pass
	if input_direction.y != 0:
		if !dashing and !jumping and !attacking and !leaping and !spinning:
			player_animations.play("walk")
			if !walking.playing:
				walking.pitch_scale=RandomNumberGenerator.new().randf_range(0.9, 1.2)
				walking.play()
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
		
	if event.is_action_pressed("heavy_attack"):
		if spell_cooldown_timer.is_stopped():
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
			
	if event.is_action_pressed("portal") && GlobalVariables.tp_boss:
		tp_boss()
		
	if true:
			
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
					if player_animations.animation in ["idle", "walk"]:
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
					if player_animations.animation in ["idle", "walk"]:
						combo_timer.stop()
						player_animations.play("light_attack2")
						print("Light attack 2 used")
						light_attack_2.enableHitBox()
						combo_timer.start()
						combo = 3
				3:
					if player_animations.animation in ["idle", "walk"]:
						combo_timer.stop()
						player_animations.play("light_attack3")
						light_attack_3.enableHitBox()
						print("Light attack 3 used")
						combo = 1
			
func _physics_process(delta: float) -> void:
	if current_speed==0:
		walking.stop()
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
			if first_time:
				shadow.global_position += Vector2(7.5,0)
				first_time = false
			if shadow_changeable2 and !first_time:
				shadow.global_position += Vector2(-7.5,0)
				shadow_changeable2 = false
				shadow_changeable =true
			player_animations.flip_h = false
		elif get_viewport().get_mouse_position().x <= get_viewport().size.x/2:
			player_animations.flip_h = true
			if shadow_changeable:
				shadow.global_position += Vector2(7.5,0)
				shadow_changeable = false
				shadow_changeable2 = true
			first_time = false
			
	

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
	#player.global_position = (Vector2(1974, 2272))
	jumping = false

func _on_leap_timer_timeout() -> void:
	leaping = false
	
func _on_spin_timer_timeout() -> void:
	spinning = false
	
@export var charge = 0

func useAbility(ability : String):
	#DASH KÄYTTÖ
	if ability == "Dash":
		if dash_cooldown_timer.is_stopped() and skill_tree.checkSkill("Dash"):
			dash_cooldown_timer.wait_time = GlobalVariables.dashTimer
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
	if ability == "Holy Projectile":
		if holy_projectile_cooldown_timer.is_stopped():
			holy_projectile_cooldown_timer.wait_time = GlobalVariables.projectileTimer
			if charge < 5:
				charge = charge + 1
				print(charge)
				player_animations.play("holy_projectile")
				var h = holy_projectile.instantiate()
				add_child(h)
				h.position.y -= 15
				h.move_direction = player.global_position.direction_to(get_global_mouse_position())
			else:
				holy_projectile_cooldown_timer.start()
				charge = 0
		
	if ability == "Jump":
		if jump_timer.is_stopped():
			jump_timer.wait_time = GlobalVariables.jumpTimer
			jump_timer.start()
			print("Player used jump")
			invincibility_timer.start()
			get_tree().create_tween().tween_property(self, "position", Vector2(position.x+velocity.x-5, position.y+velocity.y-5),1)
			if velocity.x > 0:
				player_animations.flip_h = false
				GlobalVariables.flip_h = false
			elif velocity.x < 0:
				player_animations.flip_h = true
				GlobalVariables.flip_h = true
			player_animations.play("jump")
			animation_timer.start()
			jumping = true
			jump_hit_box.enableHitBox()
			
	if ability == "Heal":
		#Needs to be implemented
		if heal_cooldown_timer.is_stopped():
			heal_cooldown_timer.wait_time = GlobalVariables.healTimer
			heal_cooldown_timer.start()
			player_animations.play("taunt")
			if GlobalVariables.playerHealth <= 95:
				GlobalVariables.playerHealth += 5
				heal_animation.visible = true
				heal_animation.play("heal")
				print("Health is now", GlobalVariables.playerHealth)
			elif GlobalVariables.playerHealth > 95 and GlobalVariables.playerHealth < 100:
				GlobalVariables.playerHealth = 100
				heal_animation.visible = true
				heal_animation.play("heal")
				print("Health is now", GlobalVariables.playerHealth)
			else:
				pass
			
	if ability == "Holy Shield":
		#Needs to be implemented
		pass
	if ability == "Leap":
		#Needs to be implemented
		if leap_timer.is_stopped():
			leap_timer.wait_time = GlobalVariables.leapTimer
			leap_timer.start()
			print("Player used Leap")
			invincibility_timer.start()
			if velocity.x > 0:
				leap_animation.flip_h = false
			elif velocity.x < 0:
				leap_animation.flip_h = true
			elif velocity.x == 0:
				if player_animations.flip_h:
					leap_animation.flip_h = true
				else:
					leap_animation.flip_h = false
			leap_animation.visible = true
			player_animations.visible = false
			leap_animation.play("leap")
			leaping = true
			leap_hit_box.enableHitBox()
			await get_tree().create_timer(1.7).timeout
			if leap_animation.flip_h:
				get_tree().create_tween().tween_property(self, "position", Vector2(position.x-90, position.y),0.1)
			else:
				get_tree().create_tween().tween_property(self, "position", Vector2(position.x+90, position.y),0.1)
			
	if ability == "Spin":
		if spin_timer.is_stopped():
			spin_timer.wait_time = GlobalVariables.spinTimer
			spin_timer.start()
			print("Player used Spin")
			invincibility_timer.start()
			#get_tree().create_tween().tween_property(self, "position", Vector2(position.x+velocity.x-5, position.y+velocity.y-5),0.8)
			if velocity.x > 0:
				player_animations.flip_h = false
				GlobalVariables.flip_h = false
			elif velocity.x < 0:
				player_animations.flip_h = true
				GlobalVariables.flip_h = true
			player_animations.play("spin_attack")
			animation_timer.start()
			spinning = true
			spin_hit_box.enableHitBox()
			
	if ability == "AoE":
		#Needs to be implemented
		if AOE_cooldown_timer.is_stopped():
			AOE_cooldown_timer.wait_time = GlobalVariables.AoETimer
			player_animations.play("taunt")
			await get_tree().create_timer(1).timeout
			AOE_cooldown_timer.start()
			# Define the offsets as a list of vectors
			var directions = [
				Vector2(0, -20),
				Vector2(20, -20),
				Vector2(20, 0),
				Vector2(20, 20),
				Vector2(0, 20),
				Vector2(-20, 20),
				Vector2(-20, 0),
				Vector2(-20, -20)
			]
			# Loop through each direction and instantiate a projectile
			for direction in directions:
				var projectile = holy_projectile.instantiate()
				add_child(projectile)
				projectile.position.y -= 15
				projectile.move_direction = player.global_position.direction_to(player.global_position + direction)
				
func _on_action_1_pressed() -> void:
	if !GlobalVariables.unlockedSkills.is_empty():
		useAbility(GlobalVariables.unlockedSkills[0])
		action_1.changeTexture(GlobalVariables.unlockedSkillsTextures[0])

func _on_action_2_pressed() -> void:
	if GlobalVariables.unlockedSkills.size() >= 2:
		useAbility(GlobalVariables.unlockedSkills[1])
		action_2.changeTexture(GlobalVariables.unlockedSkillsTextures[1])
		
func _on_action_3_pressed() -> void:
	if GlobalVariables.unlockedSkills.size() >= 3:
		useAbility(GlobalVariables.unlockedSkills[2])
		action_3.changeTexture(GlobalVariables.unlockedSkillsTextures[2])

func _on_action_4_pressed() -> void:
	if GlobalVariables.unlockedSkills.size() >= 4:
		useAbility(GlobalVariables.unlockedSkills[3])
		action_4.changeTexture(GlobalVariables.unlockedSkillsTextures[3])

func _on_action_5_pressed() -> void:
	tp_boss()
	if GlobalVariables.unlockedSkills.size() == 5:
		useAbility(GlobalVariables.unlockedSkills[4])
		action_5.changeTexture(GlobalVariables.unlockedSkillsTextures[4])
		
func tp_boss():
	player.global_position = (Vector2(1974, 2272))
	GlobalVariables.cerb_spawned = false
	GlobalVariables.tp_boss = false

func tp_hell(x):
	GlobalVariables.helled = true


func _on_leap_animation_animation_finished() -> void:
	player_animations.visible = true
	leap_animation.visible = false


func _on_heal_animation_animation_finished() -> void:
	heal_animation.visible = false
