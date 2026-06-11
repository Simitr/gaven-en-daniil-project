extends CanvasLayer

@onready var health_bar = $"HealthBar"
@onready var ammo_label = $"Ammo/AmmoLabel"
@onready var potion_label = $"HealthPotion/PotionLabel"

var player

func _ready():
	await get_tree().process_frame

	player = get_tree().get_first_node_in_group("player")

	if player:
		health_bar.max_value = player.max_health
		health_bar.value = player.health
		update_ammo_ui()
		update_HealthPotions_ui()
	

func _process(delta):
	if player:
		update_ammo_ui()
		update_HealthPotions_ui()
		update_health_ui()

func update_health_ui():
	health_bar.value = player.health

func update_ammo_ui():
	ammo_label.text = str(player.ammo)
	
func update_HealthPotions_ui():
	potion_label.text = str(player.HealthPotions)
