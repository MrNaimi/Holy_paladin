extends CanvasLayer

@onready var portal_text: Label = $portal_text
@onready var portal_spawn_text: Label = $portal_spawn_text
var text_shown = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalVariables.game_won:
		portal_spawn_text.text = "You have won the game! Thanks for playing this demo."
		portal_spawn_text.visible = true
		await get_tree().create_timer(3).timeout
		get_tree().quit()
		
	if GlobalVariables.portal_text:
		portal_text.visible = true
	else:
		portal_text.visible = false
		
	if GlobalVariables.enemies_killed == 1 and text_shown:
		portal_spawn_text.visible = true
		await get_tree().create_timer(5).timeout
		text_shown = false
		portal_spawn_text.visible = false
		
		
