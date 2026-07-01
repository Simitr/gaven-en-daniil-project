extends Area2D


var player_in_range := false
var picked_up := false
var lit := false


@onready var sprite = $AnimatedSprite2D
@onready var light = $LightTexture


func _ready():
	light.enabled = false


func _process(_delta):
	if player_in_range and not picked_up:
		if Input.is_action_just_pressed("Interact"):
			light.enabled = true
			lit = true
			

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		sprite.play("Interact")


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		sprite.play("Interact")
