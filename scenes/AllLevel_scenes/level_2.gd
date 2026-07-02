extends Node2D

@onready var canvas_modulate = get_node_or_null("CanvasModulate")
@onready var world_objects = get_node_or_null("WorldObjects")

 

func _ready():
	if not Global.shoottutorial:
		Global.shoottutorial = true
		get_tree().change_scene_to_file("res://scenes/Items/lkm.tscn")
	if canvas_modulate:
		canvas_modulate.activate_darkness()
		
	if world_objects:
		for child in world_objects.get_children():
			if child is Torch:
				child.activate()

	if Global.spawn_point == "":
		return

	var player = $WorldObjects/Player

	var spawn = get_node_or_null(Global.spawn_point)

	if spawn != null:

		player.global_position = spawn.global_position

	else:

		print("Spawn not found: ", Global.spawn_point)
