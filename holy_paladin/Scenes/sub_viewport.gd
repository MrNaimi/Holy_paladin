extends SubViewport
@onready var minimapimage: Sprite2D = $minimapimage
@onready var camera_2d: Camera2D = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#minimapimage.texture = get_viewport().get_texture()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_2d.zoom = Vector2(1,1)
