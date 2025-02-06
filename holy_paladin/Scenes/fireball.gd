extends CharacterBody2D

@export var speed: int = 120
var direction: Vector2 = Vector2.ZERO


func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()
