extends CharacterBody2D
@onready var level_up_animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	level_up_animation.play("default")


func _on_level_up_t_imer_timeout() -> void:
	queue_free()
