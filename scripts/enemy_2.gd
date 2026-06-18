extends CharacterBody2D


@export var speed = 100

var player = null
var frozen = false

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	frozen = false

	for area in $Area2D.get_overlapping_areas():
		if area.is_in_group("light"):
			frozen = true
			break

	if player and !frozen:
		velocity = (player.global_position - global_position).normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
