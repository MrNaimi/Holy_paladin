extends CanvasLayer

@onready var portal_text: Label = $portal_text

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GlobalVariables.portal_text:
		portal_text.visible = true
	else:
		portal_text.visible = false
		
