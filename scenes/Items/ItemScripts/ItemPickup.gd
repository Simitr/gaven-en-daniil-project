extends Area2D

enum PickupType {
	AMMO,
	HEALTH_POTION,
	LANTERN,
	KEY
}

@export var type: PickupType
@export var amount := 1
@onready var sprite = $AnimatedSprite2D


func _ready():
	randomize()
	
	match type:
		PickupType.AMMO:
			amount = randi_range(1, 2)
			sprite.play("AmmoPickup")
			
		PickupType.HEALTH_POTION:
			amount = randi_range(1, 2)
			sprite.play("HealthPotionPickup")
			
		PickupType.LANTERN:
			amount = 1
			
		PickupType.KEY:
			amount = 1
		
		
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	match type:
		PickupType.AMMO:
			body.add_ammo(amount)

		PickupType.HEALTH_POTION:
			body.add_health_potions(amount)
		
		PickupType.LANTERN:
			body.add_lantern(amount)
		
		PickupType.KEY:
			body.add_key(amount)



	queue_free()
