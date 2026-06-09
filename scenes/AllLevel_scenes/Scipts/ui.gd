extends CanvasLayer

@onready var ammo_label = $"Ammo/AmmoLabel"

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	update_ammo_ui()

func _process(delta):
	if player:
		update_ammo_ui()

func update_ammo_ui():
	ammo_label.text = str(player.ammo)
