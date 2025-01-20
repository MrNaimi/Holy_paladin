extends CharacterBody2D


const SPEED = 100.0

func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	
	#IF statements to flip sprite and play the walking animation
	if input_direction.x > 0:
		$AnimatedSprite2D.flip_h = false;
		get_node("AnimatedSprite2D").play("walk")
	elif input_direction.x < 0:
		$AnimatedSprite2D.flip_h = true;
		get_node("AnimatedSprite2D").play("walk")
	if input_direction.y != 0:
		get_node("AnimatedSprite2D").play("walk")
	if input_direction.x == 0 && input_direction.y == 0:
		if $AnimatedSprite2D.animation != "heavy_attack" && $AnimatedSprite2D.animation != "attack":
			get_node("AnimatedSprite2D").play("idle")


#checkaa mouse inputin kun right-clickaa. toistaa atm vaan animaation kerran
func _input(event):
	if event.is_action_pressed("heavy_attack"):
		if get_global_mouse_position().x >= position.x:
			$AnimatedSprite2D.flip_h = false;
		else:
			$AnimatedSprite2D.flip_h = true;
		get_node("AnimatedSprite2D").play("heavy_attack")
	if event.is_action_pressed("attack"):
		if get_global_mouse_position().x >= position.x:
			$AnimatedSprite2D.flip_h = false;
		else:
			$AnimatedSprite2D.flip_h = true;
		get_node("AnimatedSprite2D").play("attack")
	

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
