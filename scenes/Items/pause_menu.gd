extends Node2D

@onready var pause_menu = $pause_menu

func _on_quit_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Items/main_menu.tscn")


func _on_back_desktop_pressed() -> void:
	get_tree().quit()


func _on_back_game_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
