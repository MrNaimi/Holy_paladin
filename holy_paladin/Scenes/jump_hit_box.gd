extends Area2D
@onready var damage = 2
@onready var hitboxtime = 1
@onready var hitboxdelay = 0.5
@onready var hitbox: CollisionShape2D = $CollisionShape2D
@onready var jump_hit_box_timer: Timer = $JumpHitBoxTimer
@onready var jump_hit_box_start_timer: Timer = $JumpHitBoxStartTimer
@onready var player_animations: AnimatedSprite2D = $"../../Player_animations"


@onready var original_position = hitbox.position.x
@onready var original_rotation = hitbox.rotation_degrees

@onready var flipped_position = original_position * -1
@onready var flipped_rotation = original_rotation * -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.disabled = true
	
func _process(delta):
	if player_animations.flip_h:
		hitbox.position.x = flipped_position
		hitbox.rotation_degrees = flipped_rotation
	else:
		hitbox.position.x = original_position
		hitbox.rotation_degrees = original_rotation

func enableHitBox():
	print("jump enabled")
	jump_hit_box_start_timer.wait_time = hitboxdelay
	jump_hit_box_start_timer.start()
	
func _on_jump_hit_box_start_timer_timeout() -> void:
	print("hitbox starttimer timeout")
	hitbox.disabled = false
	jump_hit_box_timer.wait_time = hitboxtime
	jump_hit_box_timer.start()


func _on_jump_hit_box_timer_timeout() -> void:
	print("hitbox timer timeout")
	hitbox.disabled = true
