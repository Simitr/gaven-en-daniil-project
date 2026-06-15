extends Area2D

enum PickupType {
	AMMO,
	HEALTH_POTION
}

@export var type: PickupType
@export var amount := 1


func _ready():
	randomize()
	
	match type:
		PickupType.AMMO:
			amount = randi_range(1, 2)
			
		PickupType.HEALTH_POTION:
			amount = randi_range(1, 2)
		
		
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	match type:
		PickupType.AMMO:
			body.add_ammo(amount)

		PickupType.HEALTH_POTION:
			body.add_health_potions(amount)

	get_parent().queue_free()
