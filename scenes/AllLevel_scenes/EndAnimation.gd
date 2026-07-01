extends Area2D

@onready var sprite = $AnimatedSprite2D
@export_file("*.tscn") var next_scene: String

var triggered := false


func _on_body_entered(body):
	if triggered:
		return

	if not body.is_in_group("player"):
		return

	triggered = true
	Global.ui_on = false
	sprite.play("Cutscene")
	
	body.visible = false
	body.set_physics_process(false)
	body.set_process(false)

	await sprite.animation_finished

	get_tree().change_scene_to_file(next_scene)
	
