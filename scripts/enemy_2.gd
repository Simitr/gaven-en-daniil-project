extends CharacterBody2D


@export var speed = 10

var player = null



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
