extends TextureButton

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer
@onready var time: Label = $Time
@onready var key: Label = $Key
@onready var texture_changed = false
@onready var ability_name = null
var wait_time = 1.5

var change_key = "":
	set(value):
		change_key = value
		key.text = value
		
		shortcut = Shortcut.new()
		var input_key = InputEventKey.new()
		input_key.keycode = value.unicode_at(0)
		
		shortcut.events = [input_key]

func _ready():
	change_key = "1"
	texture_progress_bar.max_value = timer.wait_time
	set_process(false)

func _process(_delta):
	time.text = "%3.1f" % timer.time_left
	texture_progress_bar.value = timer.time_left
	

func _on_pressed() -> void:
	timer.start()
	disabled = true
	set_process(true)


func _on_timer_timeout() -> void:
	disabled = false
	time.text = ""
	set_process(false)
	
func changeTexture(texture):
	changeTimer(ability_name)
	texture_progress_bar.texture_progress = texture
	texture_normal = texture
	
func changeTimer(ability_name : String):
	match ability_name:
		"Dash":
			wait_time = GlobalVariables.dashTimer
		"Heal":
			wait_time = GlobalVariables.healTimer
		"Holy Projectile":
			wait_time = GlobalVariables.projectileTimer
		"Jump":
			wait_time = GlobalVariables.jumpTimer
		"Leap":
			wait_time = GlobalVariables.leapTimer
		"Spin":
			wait_time = GlobalVariables.spinTimer
		"AoE":
			wait_time = GlobalVariables.AoETimer
	timer.wait_time = wait_time
