extends Node2D

@onready var canvas_modulate = get_node_or_null("CanvasModulate")
@onready var torches = get_node_or_null("Props")

func _ready():
	
	if canvas_modulate:
		canvas_modulate.activate_darkness()
		
	if torches:
		for Torch in torches.get_children():
			Torch.activate()

	if Global.spawn_point == "":
		return

	var player = $Player

	var spawn = get_node_or_null(Global.spawn_point)

	if spawn != null:

		player.global_position = spawn.global_position

	else:

		print("Spawn not found: ", Global.spawn_point)
