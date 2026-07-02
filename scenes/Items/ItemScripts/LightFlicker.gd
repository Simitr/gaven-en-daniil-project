extends Node2D

class_name Torch

@onready var light = $LightTexture
@onready var collision = get_node_or_null("LightTexture/Area2D/CollisionShape2D")
@onready var sprite = $AnimatedSprite2D


var player_in_range := false
var torch_on := false


var target_energy: float = 0.5
var amplitude: float = 0.1
var flicker_speed: float = randf_range(8.0, 9.0)
var time: float = 0.0

func _ready():
	light.enabled = true


	if collision != null and collision.shape is CircleShape2D:
		collision.shape.radius = 128

	target_energy = 0.1
	var room_name = get_tree().current_scene.name

	if room_name == "LevelBoss":
		$AnimatedSprite2D.animation = "BossAnimation"
	else:
		$AnimatedSprite2D.animation = "default"

	$AnimatedSprite2D.play()
	


func _process(delta):
	if player_in_range and Input.is_action_just_pressed("Interact"):
		toggle_torch()

	time += delta * flicker_speed
	light.energy = target_energy + sin(time) * amplitude


func activate():
	light.enabled = true


func toggle_torch():

	if collision == null:
		print("Missing CollisionShape2D on ", name)
		return

	if collision.shape is not CircleShape2D:
		return

	if torch_on:

		# Small light
		target_energy = 0.1
		collision.shape.radius = 64
		flicker_speed = randf_range(1.0, 4.0)

	else:

		# Normal light
		target_energy = 1
		collision.shape.radius = 64
		flicker_speed = randf_range(8.0, 9.0)

	torch_on = !torch_on
	
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		if !torch_on: sprite.play("Interact")
		if torch_on: sprite.play("default")


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		if !torch_on: sprite.play("Interact")
		if torch_on: sprite.play("default")
