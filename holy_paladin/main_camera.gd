extends Camera2D
@onready var player: CharacterBody2D = $"../Node2D/Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = player.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
