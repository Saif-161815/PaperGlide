extends Node2D

@onready var player = $Player
@onready var over_label: Label = $OverLabel
@export var PipeScene: PackedScene
@onready var score_label = $ScoreLabel
@onready var best_label = $BestLabel
@onready var start_label: Label = $StartLabel


var is_game_over = false
var game_started = false
var score = 0
var best_score = 0

func _physics_process(delta: float) -> void:
	
	if not game_started:
		if Input.is_action_just_pressed("flap"):
			game_started = true
			start_label.visible = false
			player.game_started = true
			return
		
	if is_game_over:
		if Input.is_action_just_pressed("flap"):
			get_tree().paused = false
			get_tree().reload_current_scene()
		return
		
	if player.is_on_floor() or player.is_on_ceiling() or player.is_on_wall():
		game_over()
		
func _ready():
	start_label.visible = true
	load_best_score()
	best_label.text = "Best: " + str(best_score)
	
func game_over():
	is_game_over = true
	
	if score > best_score:
		best_score = score
		save_best_score()
	
	best_label.text = "Best: " + str(best_score)
	
	over_label.visible = true
	$Timer.stop()
	get_tree().paused = true
	$hitaudio.play()

func _on_timer_timeout() -> void:
	if not game_started:
		return
		
	var pipe = PipeScene.instantiate()
	add_child(pipe)
	pipe.add_to_group("pipes")
	var random_y = randf_range(190,560)
	pipe.position = Vector2(600, random_y)
	
	
func increase_score():
	score += 1
	score_label.text = "Score: " + str(score)
	$scoreaudio.play()
func save_best_score():
	var file = FileAccess.open("user://save.dat", FileAccess.WRITE)
	file.store_var(best_score)


func load_best_score():
	if FileAccess.file_exists("user://save.dat"):
		var file = FileAccess.open("user://save.dat", FileAccess.READ)
		best_score = file.get_var()
