extends Area2D
@export var damage = 1
@export var hitboxtime = 0.5
@export var hitboxdelay = 0.2
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var hit_box_timer: Timer = $HitBoxTimer
@onready var hit_box_start_timer: Timer = $HitBoxStartTimer
@onready var spell_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var spellaudio: AudioStreamPlayer2D = $spellaudio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enableHitBox():
	hit_box_start_timer.wait_time = hitboxdelay
	hit_box_start_timer.start()

func _on_hit_box_start_timer_timeout() -> void:
	hitbox.disabled = false
	hit_box_timer.wait_time = hitboxtime
	hit_box_timer.start()
	spell_animation.visible = true
	spellaudio.play()
	spell_animation.play("spell")
	print("Spell has been used")

func _on_hit_box_timer_timeout() -> void:
	hitbox.disabled = true
	
func _on_animated_sprite_2d_animation_finished() -> void:
	spell_animation.visible = false
