extends Sprite2D

@onready var enemyreference = $"../../../Node2D/imp"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if visible:
		self.position.x=enemyreference.position.x/10
		self.position.y=enemyreference.position.y/10
