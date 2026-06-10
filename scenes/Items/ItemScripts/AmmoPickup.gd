extends Area2D

@export var ammo_amount := 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.add_ammo(ammo_amount)
		get_parent().queue_free()
