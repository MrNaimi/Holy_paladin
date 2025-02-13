extends CharacterBody2D
@export var speed: int = 120
var direction: Vector2 = Vector2.ZERO
@onready var sizzler: AnimationPlayer = $sizzler
var damage = 10

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	sizzler.play("penis")
	await get_tree().create_timer(1).timeout
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)
