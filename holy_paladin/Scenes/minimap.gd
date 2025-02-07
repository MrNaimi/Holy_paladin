extends Control
@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var player: CharacterBody2D = $"../../Node2D/Player"
@onready var camera_2d: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var minimapicon: Sprite2D = $minimapicon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	sub_viewport.world_2d = player.viewport.world_2d
	camera_2d.zoom = Vector2(0.3,0.3)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	minimapicon.flip_h = player.player_animations.flip_h
	camera_2d.position.x = player.position.x - 270
	camera_2d.position.y = player.position.y + 100
