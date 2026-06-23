extends CanvasLayer

@onready var health_bar = $"HealthBar"
@onready var ammo_label = $"Ammo/AmmoLabel"
@onready var potion_label = $"HealthPotion/PotionLabel"
@onready var lantern_item = $"LanternSlot/LanternItem"
@onready var key_item = $"KeySlot/KeyItem"
@onready var ammo = $Ammo
@onready var health = $HealthPotion
@onready var lantern = $LanternSlot
@onready var key = $KeySlot
var player


func _ready():
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

	if player:
		health_bar.max_value = player.max_health
		update_ui()


func _process(_delta):
	if !Global.ui_on:
		
		health_bar.visible = false
		ammo_label.visible = false
		potion_label.visible = false
		lantern_item.visible = false
		key_item.visible = false
		ammo.visible = false
		health.visible = false
		lantern.visible = false
		key.visible = false
	else:
		health_bar.visible = true
		ammo_label.visible = true
		potion_label.visible = true
		lantern_item.visible = true
		key_item.visible = true
		ammo.visible = true
		health.visible = true
		lantern.visible = true
		key.visible = true
	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")

	if player:
		update_ui()


func update_ui():
	health_bar.value = player.health
	ammo_label.text = str(player.ammo)
	potion_label.text = str(player.health_potions)

	lantern_item.visible = player.lantern > 0
	key_item.visible = player.key > 0
