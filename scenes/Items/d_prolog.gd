extends Node2D


 

var time_reduced := false
var timer := Timer.new()
func _ready():
	Global.ui_on = false
	timer.wait_time = 3.0        # 10 секунд
	timer.one_shot = true         # сработает один раз
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
 
func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/prologue_scene/PrologForReal.tscn")
func _process(delta: float) -> void:
	if Input.is_action_pressed("walkRight"):
		if not time_reduced:
			time_reduced = true
			timer.stop()
			timer.wait_time = 0.2
			timer.start()
		$d.texture = load("res://assets/game/prologue_texture/Character/dPress.png")
	else:
		$d.texture = load("res://assets/game/prologue_texture/Character/d.png")
