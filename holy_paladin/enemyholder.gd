extends Node2D

@onready var node_2d: Node2D = $Node2D
@onready var node_2d_2: Node2D = $Node2D2
@onready var node_2d_3: Node2D = $Node2D3

var enemies_dead = 0
var spawn_order = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(enemies_dead)
	if enemies_dead==3 && spawn_order == 1:
		node_2d_2.set_process(true)
		node_2d_2.visible = true
