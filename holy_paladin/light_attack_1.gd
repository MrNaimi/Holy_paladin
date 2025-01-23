extends Area2D

@export var damage = 1
@export var hitboxtime = 0.5
@onready var hit_box_timer: Timer = $HitBoxTimer
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var player_animations: AnimatedSprite2D = $"../../Player_animations"
@onready var original_position = hitbox.position.x
@onready var original_rotation = hitbox.rotation_degrees

@onready var flipped_position = original_position * -1
@onready var flipped_rotation = original_rotation * -1

func _process(delta):
	if player_animations.flip_h:
		hitbox.position.x = flipped_position
		hitbox.rotation_degrees = flipped_rotation
	else:
		hitbox.position.x = original_position
		hitbox.rotation_degrees = original_rotation

func _on_hit_box_timer_timeout() -> void:
	hitbox.disabled = true

#Tässä määritetään funktio joka enabloi hitboxin ja aloittaa sille ajastimen
func enableHitBox() -> void:

	hitbox.disabled = false
	hit_box_timer.wait_time = hitboxtime
	hit_box_timer.start()
