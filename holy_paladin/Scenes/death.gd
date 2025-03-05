extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var xp = 0
	var enemies_killed = 0
	var level = 1
	var xp_threshold = 1
	var talentpoints = 0
	var skillpoints = 10
	var basicAttackDamage = 1
	var baseBasicAttackDamage = 1
	var spellDamage = 3
	var playerSpeed = Vector2(100, 100)
	var playerHealth = 100
	var playerArmor = 50

	# Cooldown timers
	var spellTimer = 5.0
	var dashTimer = 3.0
	var healTimer = 5.0
	var projectileTimer = 3.0
	var jumpTimer = 2.0
	var holyShieldTimer = 6.0
	var leapTimer = 10.0
	var spinTimer = 10.0
	var AoETimer = 10.0

	var unlockedSkills = []
	var unlockedSkillsTextures = []

	var helled = false
	var tween_direction
	var playerpos = null
	var flip_h = false

	var cerberus_health = 20
	var cerb_hp_bar = false
	var cerb_spawned = true

	var portal_text = false
	var tp_boss = false
	var roadGenerated = false
	var player_spawn_location = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/isometric_tilemap.tscn")
	


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
