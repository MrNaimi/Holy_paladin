extends Area2D
@onready var damage = 5
@onready var hitbox2: CollisionShape2D = $CollisionShape2D2
@onready var leap_hit_box_timer_2: Timer = $LeapHitBoxTimer2
@onready var leap_hit_box_start_timer_2: Timer = $LeapHitBoxStartTimer2
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var player_animations: AnimatedSprite2D = $"../../Player_animations"


@onready var original_position = hitbox2.position.x
@onready var original_rotation = hitbox2.rotation_degrees

@onready var flipped_position = original_position * -1
@onready var flipped_rotation = original_rotation * -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox2.disabled = true
	

func enableHitBox():
	leap_hit_box_start_timer_2.start()
	audio_stream_player_2d.play()


func _on_leap_hit_box_timer_2_timeout() -> void:
	hitbox2.disabled = true


func _on_leap_hit_box_start_timer_2_timeout() -> void:
	hitbox2.disabled = false
	leap_hit_box_timer_2.start()
