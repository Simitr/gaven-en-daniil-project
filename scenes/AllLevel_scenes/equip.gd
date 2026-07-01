extends Node2D

func _ready():
	var timer := Timer.new()
	timer.wait_time = 3.0        # 10 секунд
	timer.one_shot = true         # сработает один раз
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
 
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/AllLevel_scenes/Level1.tscn")

func _process(delta: float) -> void:
	if Input.is_action_pressed("armed"):
		$e.texture = load("res://assets/game/prologue_texture/Character/ePress.png")
	else:
		$e.texture = load("res://assets/game/prologue_texture/Character/e.png")
	
 
