extends Node2D

@export var speed: float = 200.0
var counted = false

func _physics_process(delta: float) -> void:
	if get_tree().paused:
		return
	position.x -= speed * delta
	
	if position.x < -100:
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not counted:
		get_parent().increase_score()
