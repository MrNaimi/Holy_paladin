extends Node2D
@onready var portal_animation: AnimatedSprite2D = $portal_animation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	portal_animation.play()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !GlobalVariables.boss_beaten:
		GlobalVariables.tp_boss = true
		GlobalVariables.portal_text = true
	else:
		GlobalVariables.game_won = true
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if !GlobalVariables.boss_beaten:
		GlobalVariables.tp_boss = false
		GlobalVariables.portal_text = false
