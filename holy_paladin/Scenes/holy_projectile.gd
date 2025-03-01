extends Area2D
@onready var death: Timer = $Death

var speed = 200
var move_direction

func _ready() -> void:
	death.start()
	
func _physics_process(delta):
	position += move_direction * speed * delta



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		queue_free()

func _on_death_timeout() -> void:
	queue_free()
