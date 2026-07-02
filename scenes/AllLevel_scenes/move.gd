extends Node2D
var right:bool = false
var up:bool = false
var left:bool = false
var down:bool = false
var time_reduced := false
var timer := Timer.new()

func _ready():
	BackgroundMusic.get_node("AudioStreamPlayer2D").play()
	Global.ui_on = false
	timer.wait_time = 3.0        # 10 секунд
	timer.one_shot = true         # сработает один раз
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
 
func _on_timer_timeout():
	Global.move = true
	get_tree().change_scene_to_file("res://scenes/AllLevel_scenes/Level1.tscn")

func _process(delta: float) -> void:
	if Input.is_action_pressed("walkRight"):
		$d.texture = load("res://assets/game/prologue_texture/Character/dPress.png")
		right = true
	else:
		$d.texture = load("res://assets/game/prologue_texture/Character/d.png")
	if  Input.is_action_pressed("walkUp"):
		up = true
		$w.texture = load("res://assets/game/prologue_texture/Character/wPress.png")
	else:
		$w.texture = load("res://assets/game/prologue_texture/Character/w.png")
	if Input.is_action_pressed("walkDown"):
		down = true
		$s.texture = load("res://assets/game/prologue_texture/Character/sPress.png")
	else:
		$s.texture = load("res://assets/game/prologue_texture/Character/s.png")
	if Input.is_action_pressed("walkLeft"):
		left = true
		$a.texture = load("res://assets/game/prologue_texture/Character/aPress.png")
	else:
		$a.texture = load("res://assets/game/prologue_texture/Character/a.png")
	if right and left and up and down:
		if not time_reduced:
			time_reduced = true
			timer.stop()
			timer.wait_time = 0.2
			timer.start()
