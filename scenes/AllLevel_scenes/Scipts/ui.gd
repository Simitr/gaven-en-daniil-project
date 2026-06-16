extends CanvasLayer

@onready var health_bar = $"HealthBar"
@onready var ammo_label = $"Ammo/AmmoLabel"
@onready var potion_label = $"HealthPotion/PotionLabel"
@onready var lantern_slot = $"LanternSlot"
@onready var key_slot = $"KeySlot"

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
	
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		
	if player:
		update_ammo_ui()
		update_HealthPotions_ui()
		update_health_ui()
		update_KeySlot_ui()
		update_LanternSlot_ui()


func update_health_ui():
	health_bar.value = player.health

func update_ammo_ui():
	ammo_label.text = str(player.ammo)
	
func update_HealthPotions_ui():
	potion_label.text = str(player.health_potions)
	
func update_LanternSlot_ui():
	lantern_slot.value = 1

func update_KeySlot_ui():
	key_slot.value = 1
