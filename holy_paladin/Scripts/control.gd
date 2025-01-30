extends Control
@onready var x: Label = $VBoxContainer/x
@onready var y: Label = $VBoxContainer/y
@onready var character_x: Label = $VBoxContainer/character_x
@onready var character_y: Label = $VBoxContainer/character_y
@onready var viewportsize: Label = $VBoxContainer/viewportsize
@onready var characterspeed: Label = $VBoxContainer/characterspeed
@onready var combotimer: Label = $VBoxContainer/combotimer
@onready var combo_timer: Timer = $"../../ComboTimer"
@onready var pieru: AudioStreamPlayer2D = $"../../../pieru"
@onready var pierucounter: Label = $VBoxContainer/pierucounter
@onready var processpeed: Label = $VBoxContainer/processpeed

@onready var player: CharacterBody2D = $"../.."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	x.text ="mouse pos x: "+str(get_viewport().get_mouse_position().x)
	y.text ="mouse pos y: "+str(get_viewport().get_mouse_position().y)
	character_x.text = "character pos x: "+str(player.position.x)
	character_y.text = "character pos y: "+str(player.position.y)
	viewportsize.text = "viewport size: "+str(get_viewport().size.x)
	characterspeed.text = "character speed: "+str(player.current_speed)
	combotimer.text = "combo time left: "+str(float(combo_timer.time_left)).left(4)
	pierucounter.text = str(player.pierucounter)
	processpeed.text = str(player.processiterations)
