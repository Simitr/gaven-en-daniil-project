extends Area2D

@export_file("*.tscn") var next_scene : String
@export var target_spawn : String


func _on_body_entered(body: Node2D) -> void:

	if body.name == "Player":

		Global.spawn_point = target_spawn

		call_deferred("change_scene")
		
func change_scene():
	
	get_tree().change_scene_to_file(next_scene)
