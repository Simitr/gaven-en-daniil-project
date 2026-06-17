extends Area2D

@export var popup: CanvasLayer
@export var key_texture: Texture2D

var player_in_range := false
var opened := false

@onready var sprite = $AnimatedSprite2D


func _ready() -> void:
	sprite.play("ChestClosed")


func _process(_delta):
	if player_in_range and not opened:
		if Input.is_action_just_pressed("Interact"):
			open_chest()



func open_chest():
	if opened:
		return
	opened = true
	sprite.play("ChestOpened")

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.add_key(1)

	if popup:
		popup.show_loot(key_texture, "Key of Azurath", "Acquired")
	else:
		print("Popup missing or not in group")
		

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		sprite.play("ChestInteract")
	if opened == true:
		sprite.play("ChestOpen")


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
	if opened == true:
		sprite.play("ChestOpen")
