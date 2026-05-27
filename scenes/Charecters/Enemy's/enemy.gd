extends CharacterBody2D

var player_chase = false
var player = null
var speed = 100.0

func _physics_process(delta):
	if player_chase and player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Игрок вошёл в DetectionArea!")
		player = body
		player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Игрок вышел из DetectionArea!")
		player = null
		player_chase = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
