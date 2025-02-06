extends Control
@onready var x: Label = $VBoxContainer/x
@onready var y: Label = $VBoxContainer/y
@onready var character_x: Label = $VBoxContainer/character_x
@onready var character_y: Label = $VBoxContainer/character_y
@onready var viewportsize: Label = $VBoxContainer/viewportsize
@onready var characterspeed: Label = $VBoxContainer/characterspeed
@onready var combotimer: Label = $VBoxContainer/combotimer
@onready var combo_timer: Timer = $"../../Node2D/Player/Timers/ComboTimer"


@onready var dash_cooldown_timer: Timer = $"../../Node2D/Player/Timers/DashCooldownTimer"
@onready var spell_cooldown_timer: Timer = $"../../Node2D/Player/Timers/SpellCooldownTimer"
@onready var player: CharacterBody2D = $"../../Node2D/Player"


@onready var xp_bar: TextureProgressBar = $progressbars/XPbar
@onready var hp_bar: TextureProgressBar = $progressbars/HPbar
@onready var combotimerbar: TextureProgressBar = $progressbars/combotimerbar
@onready var dashcooldown: TextureProgressBar = $progressbars/dashcooldown
@onready var dashcooldowntext: Label = $progressbars/dashcooldowntext
@onready var spellcooldown: TextureProgressBar = $progressbars/spellcooldown
@onready var spellcooldowntext: Label = $progressbars/spellcooldowntext



@onready var pieru: AudioStreamPlayer2D = $"../../../pieru"
@onready var pierucounter: Label = $VBoxContainer/pierucounter
@onready var processpeed: Label = $VBoxContainer/processpeed



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dashcooldown.max_value=dash_cooldown_timer.wait_time
	spellcooldown.max_value=spell_cooldown_timer.wait_time
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	xp_bar.value=GlobalVariables.xp
	xp_bar.max_value=GlobalVariables.xp_threshold
	hp_bar.value=player.hp
	combotimerbar.value=combo_timer.time_left
	
	
	dashcooldown.value = dash_cooldown_timer.time_left
	spellcooldown.value = spell_cooldown_timer.time_left
	
	dashcooldowntext.text = str(dashcooldown.value).left(1)
	spellcooldowntext.text = str(spellcooldown.value).left(1)
	
	if dash_cooldown_timer.is_stopped():
		dashcooldowntext.text = ""
	if spell_cooldown_timer.is_stopped():
		spellcooldowntext.text = ""
		
		
	x.text ="mouse pos x: "+str(get_viewport().get_mouse_position().x)
	y.text ="mouse pos y: "+str(get_viewport().get_mouse_position().y)
	character_x.text = "charactaser pos x: "+str(player.position.x)
	character_y.text = "character pos y: "+str(player.position.y)
	viewportsize.text = "viewport size: "+str(get_viewport().size.x)
	characterspeed.text = "character speed: "+str(player.current_speed)
	combotimer.text = "combo time left: "+str(float(combo_timer.time_left)).left(4)
	pierucounter.text = str(player.pierucounter)
	processpeed.text = str(player.processiterations)
	
