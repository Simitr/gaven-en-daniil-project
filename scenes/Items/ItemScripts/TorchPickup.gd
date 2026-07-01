extends Area2D

@export var popup: CanvasLayer
@export var lantern_texture: Texture2D

var player_in_range := false
var picked_up := false

@onready var sprite = $AnimatedSprite2D

func _ready():
	if Global.torch_pickup:
		queue_free()


func _process(_delta):
	if Global.armed:
		pickup_lantern()
	if player_in_range and not picked_up:
		if Input.is_action_just_pressed("Interact"):
			pickup_lantern()


func pickup_lantern():
	if picked_up:
		return
		
	picked_up = true
	Global.torch_pickup = true

	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.add_lantern(1)

	if popup:
		popup.show_loot(
			lantern_texture,
			"Ancient Torch",
			"You made a lantern!"
		)

	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		sprite.play("Interact")


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
