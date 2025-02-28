extends ProgressBar

@onready var boss_name: Label = $Boss_name
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var damagetimer: Timer = $damagetimer
@onready var previousvalue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_name.text ="Cerberus, The Hell Hound" 
	value = GlobalVariables.cerberus_health
	progress_bar.value = GlobalVariables.cerberus_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = GlobalVariables.cerberus_health
	if GlobalVariables.cerb_hp_bar:
		visible = true
	else:
		visible = false
	if progress_bar.value > GlobalVariables.cerberus_health:
		if previousvalue != GlobalVariables.cerberus_health:
			damagetimer.start()
		previousvalue = GlobalVariables.cerberus_health
		if damagetimer.is_stopped():
			#print("hurtbar pitäisi nyt toimia")
			progress_bar.value -= delta*10
			#print(progress_bar.value)
