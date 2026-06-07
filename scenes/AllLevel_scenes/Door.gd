extends Area2D

@export_file("*.tscn") var next_scene : String
@export var target_spawn : String


func _on_body_entered(body: Node2D) -> void:

	if body.name == "Player":

		Global.spawn_point = target_spawn
		
		TransitionLayer.transition_to_next_scene(next_scene)
		
