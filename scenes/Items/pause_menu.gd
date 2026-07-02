extends CanvasLayer

func _on_back_game_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_quit_game_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Items/main_menu.tscn")
	Global.ui_on = false

func _on_back_desktop_pressed() -> void:
	get_tree().quit()
