extends Area2D
@onready var spell_collision: CollisionShape2D = $CollisionShape2D
@onready var hitbox_start_timer: Timer = $HitboxStartTimer
@onready var hit_box_timer: Timer = $HitBoxTimer
@onready var spell_animation: AnimatedSprite2D = $"../../AnimatedSprite2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spell_collision.disabled = true
	spell_animation.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enableHitBox():
	hitbox_start_timer.start()


func _on_hitbox_start_timer_timeout() -> void:
	spell_collision.disabled = false
	hit_box_timer.start()
	spell_animation.visible = true
	spell_animation.play("default")

func _on_hit_box_timer_timeout() -> void:
	spell_collision.disabled = true
	print("spell collision off")


func _on_animated_sprite_2d_animation_finished() -> void:
	spell_animation.visible = false
