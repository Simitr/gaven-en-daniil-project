extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func _ready():
	reveal()

func fade_to_black():
	animation_player.play("fade_to_black")

func reveal():
	animation_player.play("reveal")

func transition_to_next_scene(scene_path):
	
	fade_to_black()
	
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(scene_path)
	
	reveal()
