extends Node
@onready var free_object_name = ""
@onready var free_object = false
@onready var xp = 0
@onready var enemies_killed = 0
@onready var level = 1
@onready var xp_threshold = 1
@onready var talentpoints = 0

@onready var tween_direction
@onready var playerpos = null
@onready var flip_h = false
