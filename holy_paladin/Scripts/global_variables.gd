extends Node
@onready var xp = 0
@onready var enemies_killed = 0
@onready var level = 1
@onready var xp_threshold = 1
@onready var talentpoints = 0
@onready var skillpoints = 10
@onready var basicAttackDamage = 1
@onready var baseBasicAttackDamage = 1
@onready var spellDamage = 3
@onready var playerSpeed = Vector2(500, 500)
@onready var playerHealth = 100

@onready var playerArmor = 50

#Cooldown timers
@onready var dashTimer = 3.0
@onready var spellTimer = 5.0

@onready var unlockedSkills = []

@onready var helled = false
@onready var tween_direction
@onready var playerpos = null
@onready var flip_h = false

@onready var cerberus_health = 20
@onready var cerb_hp_bar = false

@onready var portal_text = false
@onready var tp_boss = false
@onready var roadGenerated = false
@onready var player_spawn_location = Vector2(0,0)
