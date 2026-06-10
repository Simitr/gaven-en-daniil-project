extends Area2D


@export var healthPotion_amount := 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_HealthPotions(healthPotion_amount)
		get_parent().queue_free()
