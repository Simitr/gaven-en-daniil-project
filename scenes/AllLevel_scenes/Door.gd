extends Area2D

@export var next_scene : PackedScene
@export var target_spawn : String

func _ready():
	print("Door ready")

func _on_body_entered(body: Node2D) -> void:

	if body.name == "Player":

		Global.spawn_point = target_spawn

		get_tree().change_scene_to_packed(next_scene)
