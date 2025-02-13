extends Control

@onready var w_key: Sprite2D = $movetutorial/background2/keys/WKey
@onready var a_key: Sprite2D = $movetutorial/background2/keys/AKey
@onready var s_key: Sprite2D = $movetutorial/background2/keys/SKey
@onready var d_key: Sprite2D = $movetutorial/background2/keys/DKey

@onready var one_key: Sprite2D = $"skilltutorial/background4/keys/1Key"
@onready var two_key: Sprite2D = $"skilltutorial/background4/keys/2Key"
@onready var three_key: Sprite2D = $"skilltutorial/background4/keys/3Key"
@onready var four_key: Sprite2D = $"skilltutorial/background4/keys/4Key"
@onready var five_key: Sprite2D = $"skilltutorial/background4/keys/5Key"



@onready var m1_key: Sprite2D = $combattutorial/background/keys/M1Key
@onready var m2_key: Sprite2D = $combattutorial/background/keys/M2Key
@onready var space_key: Sprite2D = $combattutorial/background/keys/SpaceKey

@onready var t_key: Sprite2D = $restofthecontrols/background3/Control/TKey
@onready var esc_key: Sprite2D = $restofthecontrols/background3/Control/EscKey



@onready var combattutorial: Control = $combattutorial
@onready var skilltutorial: Control = $skilltutorial


@export var modulate_color = Color(0,0.5,0.5,1.0)
@onready var movetutorial: Control = $movetutorial


@onready var restofthecontrols: Control = $restofthecontrols
@onready var combattutorialhider: Timer = $combattutorial/background/combattutorialhider
@onready var controlshider: Timer = $restofthecontrols/background3/controlshider
@onready var tutorialhider: Timer = $movetutorial/background2/tutorialhider
@onready var skilltutorialhider: Timer = $skilltutorial/background4/skilltutorialhider

@onready var bottomlefthider: Timer = $bottomlefttutorial/bottomlefthider
@onready var toplefthider: Timer = $minimaptutorial/Toplefthighlight/toplefthider
@onready var bottomlefttutorial: Control = $bottomlefttutorial
@onready var minimaptutorial: Control = $minimaptutorial
@onready var petergotohell: Control = $petergotohell
@onready var petergotohellhider: Timer = $petergotohell/petergotohellhider

var buttonspressed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for tutorial in get_children():
		tutorial.visible=false
		
	movetutorial.visible=true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(s_key.get_self_modulate())
	if movetutorial.visible:
		if Input.is_action_pressed("move_down") and s_key.get_self_modulate() == Color(1,1,1,1):
			s_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("move_up") and w_key.get_self_modulate() == Color(1,1,1,1):
			w_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("move_left") and a_key.get_self_modulate() == Color(1,1,1,1):
			a_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("move_right") and d_key.get_self_modulate() == Color(1,1,1,1):
			d_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if buttonspressed>=4 && tutorialhider.is_stopped():
			tutorialhider.start()
	if combattutorial.visible:
		if Input.is_action_pressed("attack") and m1_key.get_self_modulate() == Color(1,1,1,1):
			m1_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("heavy_attack") and m2_key.get_self_modulate() == Color(1,1,1,1):
			m2_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("dash") and space_key.get_self_modulate() == Color(1,1,1,1):
			space_key.set_self_modulate(modulate_color)
			buttonspressed+=1
			
		if buttonspressed>=3 && combattutorialhider.is_stopped():
			combattutorialhider.start()
			
	if skilltutorial.visible:
		if Input.is_action_pressed("taunt") and one_key.get_self_modulate() == Color(1,1,1,1):
			one_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("jump") and two_key.get_self_modulate() == Color(1,1,1,1):
			two_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("three") and three_key.get_self_modulate() == Color(1,1,1,1):
			three_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("four") and four_key.get_self_modulate() == Color(1,1,1,1):
			four_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("five") and five_key.get_self_modulate() == Color(1,1,1,1):
			five_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		
		if buttonspressed>=5 && skilltutorialhider.is_stopped():
			skilltutorialhider.start()
			
	if restofthecontrols.visible:
		if Input.is_action_pressed("talents") and t_key.get_self_modulate() == Color(1,1,1,1):
			t_key.set_self_modulate(modulate_color)
			buttonspressed+=1
		if Input.is_action_pressed("esc") and esc_key.get_self_modulate() == Color(1,1,1,1):
			esc_key.set_self_modulate(modulate_color)
			buttonspressed+=1
			
		if buttonspressed>=2 && controlshider.is_stopped():
			controlshider.start()
			 	
	if !bottomlefthider.is_stopped():
		bottomlefttutorial.visible=true
	
	if !toplefthider.is_stopped():
		minimaptutorial.visible=true
		
func _on_tutorialhider_timeout() -> void:
	movetutorial.visible = false
	combattutorial.visible = true
	buttonspressed=0


func _on_combattutorialhider_timeout() -> void:
	combattutorial.visible = false
	skilltutorial.visible = true
	buttonspressed=0

func _on_skilltutorialhider_timeout() -> void:
	skilltutorial.visible=false
	restofthecontrols.visible=true
	buttonspressed=0

func _on_controlshider_timeout() -> void:
	print("timeout")
	restofthecontrols.visible=false
	bottomlefttutorial.visible = true
	bottomlefthider.start()
	buttonspressed=0


func _on_bottomlefthider_timeout() -> void:
	bottomlefttutorial.visible = false
	minimaptutorial.visible = true
	toplefthider.start()


func _on_toplefthider_timeout() -> void:
	minimaptutorial.visible = false
	petergotohell.visible = true
	petergotohellhider.start()


func _on_petergotohellhider_timeout() -> void:
	petergotohell.visible = false
