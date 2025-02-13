extends Node
@onready var xp = 0
@onready var enemies_killed = 0
@onready var level = 1
@onready var xp_threshold = 1
@onready var talentpoints = 0

@onready var tween_direction
@onready var playerpos = null
@onready var flip_h = false

@onready var roadGenerated = false
@onready var player_spawn_location = Vector2(0,0)
