extends Area2D

@export var popup: CanvasLayer
@export_file("*.tscn") var next_scene : String
@export var target_spawn : String

var player_in_range := false

func _process(_delta):
	if player_in_range:
		if Global.key_pickup:
			Global.spawn_point = target_spawn
			TransitionLayer.transition_to_next_scene(next_scene)
		else:
			popup.show_message("Door is Locked")


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
