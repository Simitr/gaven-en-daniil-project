extends Node2D

var timer := Timer.new()
var time_reduced := false


func _ready():
	Global.ui_on = false
	timer.wait_time = 3.0        # 10 секунд
	timer.one_shot = true         # сработает один раз
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
 
func _on_timer_timeout():
	Global.armed = true
	get_tree().change_scene_to_file("res://scenes/AllLevel_scenes/Level1.tscn")

func _process(delta: float) -> void:
	if Input.is_action_pressed("Interact"):
		$f.texture = load("res://assets/game/prologue_texture/Character/fPress.png")
		if not time_reduced:
			time_reduced = true
			timer.stop()
			timer.wait_time = 0.2
			timer.start()
	else:
		$f.texture = load("res://assets/game/prologue_texture/Character/f.png")
	
