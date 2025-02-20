extends Control

var skills : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skills = get_children()
	for i in get_child_count():
		skills[i].change_key = str(i+1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
