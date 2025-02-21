extends ProgressBar

@onready var boss_name: Label = $Boss_name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_name.text ="Cerberus, The Hell Hound" 
	value = GlobalVariables.cerberus_health
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = GlobalVariables.cerberus_health
	if GlobalVariables.cerb_hp_bar:
		visible = true
	else:
		visible = false
	
