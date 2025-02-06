extends CanvasLayer

@export var player : CharacterBody2D
@export var tileMap : TileMapLayer
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var camera_2d: Camera2D = $SubViewportContainer/SubViewport/Camera2D


var miniMapPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#miniMapPlayer = player.duplicate()
	
	
	var new_tilemap = tileMap.duplicate()
	for node in new_tilemap.get_children():
		if node.name == "world" or node is CharacterBody2D:
			if node is CharacterBody2D:
				for item in node.get_children():
					if item.name != "minimapicon":
						item.visible = false
					else:
						item.visible = true
			
	sub_viewport.add_child(new_tilemap)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.position.x = GlobalVariables.playerpos.x-300
	camera_2d.position.y = GlobalVariables.playerpos.y+100
	
	if GlobalVariables.free_object:
		print(sub_viewport.get_child(1).get_children())
		for node in sub_viewport.get_child(1).get_children():
			if node.name == GlobalVariables.free_object_name:
				node.queue_free()
		GlobalVariables.free_object_name = ""
		GlobalVariables.free_object = false
		
