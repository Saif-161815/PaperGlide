extends CharacterBody2D


var gravity = 1000
var flap = -320
var game_started = false


func _physics_process(delta: float) -> void:
	
	if not game_started:
		return
		
	velocity.y += gravity * delta
	if velocity.y > 0:
		velocity.y += 7
	
	if Input.is_action_just_pressed("flap"):
		velocity.y = flap
		rotation = -0.4
		$flapaudio.play()
	
	move_and_slide()
	
	
	var target_rotation = clamp(velocity.y * 0.003, -0.1, 0.3)
	rotation = lerp(rotation, target_rotation, 0.1)
	
