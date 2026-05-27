extends Node2D

func _ready():

	if Global.spawn_point == "":
		return

	var player = $Player

	var spawn = get_node_or_null(Global.spawn_point)

	if spawn != null:

		player.global_position = spawn.global_position

	else:

		print("Spawn not found: ", Global.spawn_point)
