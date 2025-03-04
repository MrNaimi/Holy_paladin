extends CharacterBody2D
@export var speed: int = 180
var direction: Vector2 = Vector2.ZERO
var damage = 10
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	animated_sprite_2d.play("lava_wave")

func _on_timer_timeout() -> void:
	animation_player.play("wave_grow")
	await get_tree().create_timer(3).timeout
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().hurt(damage)
