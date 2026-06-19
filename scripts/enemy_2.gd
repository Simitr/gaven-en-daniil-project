extends CharacterBody2D


@export var speed = 100

var player = null
var frozen = false
var hurt = false
var dead = false
var rage = false
var hp = 10.0

func _ready():
	player = get_tree().get_first_node_in_group("player")

func add_hp(damage):
	hp = hp + damage
	print(hp)
	

func _physics_process(delta):
	
	if (hp ==5):
		hurt = true
		speed = 60
		$AnimatedSprite2D.play("hurt")
	elif (hp == 0):
		dead = true
		queue_free() 
	frozen = false
	
	if (!rage):
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("light"):
				frozen = true
				break
	if player and !frozen:
		velocity = (player.global_position - global_position).normalized() * speed
	elif rage:
		velocity = (player.global_position - global_position).normalized() * speed*2
		
		
	else:
		velocity = Vector2.ZERO

	move_and_slide()
