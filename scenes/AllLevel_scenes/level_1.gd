extends Node2D

@onready var canvas_modulate = get_node_or_null("CanvasModulate")
@onready var world_objects = get_node_or_null("WorldObjects")



func _on_timer_timeout():
	if GameState.save == true:
		GameState.save = false
		get_tree().change_scene_to_file("res://scenes/AllLevel_scenes/move.tscn")
		

func _ready():
	if Global.interact_triggered:
		$WorldObjects/interactTrigger/CollisionShape2D.set_disabled(true)
	var timer := Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()
	if canvas_modulate:
		canvas_modulate.activate_darkness()
	if world_objects:
		for child in world_objects.get_children():
			if child is Torch:
				child.activate()
	var player = $WorldObjects/Player
	if GameState.has_saved_position:
		player.global_position = GameState.saved_player_position
		GameState.has_saved_position = false
		return # позиция восстановлена — не трогаем spawn_point
	if Global.spawn_point == "":
		return
	var spawn = get_node_or_null(Global.spawn_point)
	if spawn != null:
		player.global_position = spawn.global_position
	else:
		print("Spawn not found: ", Global.spawn_point)


func _on_interact_trigger_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and not GameState.interact_triggered:
		GameState.interact_triggered = true
		$WorldObjects/interactTrigger/CollisionShape2D.call_deferred("set_disabled", true)
		GameState.saved_player_position = body.global_position
		GameState.has_saved_position = true
		call_deferred("_go_to_interact_scene")

func _go_to_interact_scene():
	get_tree().change_scene_to_file("res://scenes/AllLevel_scenes/interact.tscn")
