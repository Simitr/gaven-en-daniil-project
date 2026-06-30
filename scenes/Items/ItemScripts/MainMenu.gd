extends Node2D




func _on_start_pressed() -> void:
	get_tree().change_scene("res://scenes/prologue_scene/PrologStartDeel.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
