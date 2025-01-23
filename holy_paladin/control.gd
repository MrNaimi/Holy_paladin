extends Control
@onready var x: Label = $x
@onready var y: Label = $y
@onready var character_x: Label = $character_x
@onready var character_y: Label = $character_y
@onready var viewportsize: Label = $viewportsize

@onready var character_body_2d: CharacterBody2D = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	x.text ="mouse pos x: "+str(get_viewport().get_mouse_position().x)
	y.text ="mouse pos y: "+str(get_viewport().get_mouse_position().y)
	character_x.text = "character pos x: "+str(character_body_2d.position.x)
	character_y.text = "character pos y: "+str(character_body_2d.position.y)
	viewportsize.text = "viewport size: "+str(get_viewport().size.x)
