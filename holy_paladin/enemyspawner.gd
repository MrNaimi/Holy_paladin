extends Node2D
@onready var player: CharacterBody2D = $"../Player"
@onready var enemy: CharacterBody2D = $"../Enemy"
var enemyscene = preload("res://enemy.tscn")
var x_spawn = 0
var y_spawn = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy() -> void:
		var new_enemy = enemyscene.instantiate()
		get_parent().add_child(new_enemy)
		print("enemy spawned")
		get_random_position()
		new_enemy.position.x=x_spawn
		new_enemy.position.y=y_spawn
		
func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1,1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_right
			
	x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	y_spawn = randf_range(spawn_pos1.y, spawn_pos1.y)
