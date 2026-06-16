extends State
class_name IdleState

@export var character: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var lamp_l: AnimatedSprite2D
@export var lamp_r: AnimatedSprite2D
@export var hands_animation: AnimatedSprite2D


var direction: Vector2
var x := 0

var down := false
var up := false
enum Side {
	LEFT,
	RIGHT
}


func enter():
	lamp_l.visible = false
	lamp_r.visible = false
	hands_animation.visible = false


	if animated_sprite.animation == "walking":
		animated_sprite.play("idle")
	elif animated_sprite.animation == "walkingback":
		animated_sprite.play("idleLeft")
	elif animated_sprite.animation == "walkingDown":
		animated_sprite.play("idleDown")
	elif animated_sprite.animation == "WalkingUp":
		animated_sprite.play("idleUp")


func update(delta):
	hands_animation.visible = false
	lamp_l.visible = false
	lamp_r.visible = false

	var dir = GameInput.movement_input()

	if dir != Vector2.ZERO and !Global.armed:
		fsm.change_state("Walk")
	elif dir != Vector2.ZERO and Global.armed:
		fsm.change_state("WalkAremd")

	if Global.armed:

		var mouse_dir = character.get_global_mouse_position() - character.global_position
		var angle = rad_to_deg(mouse_dir.angle())

		if angle < 0:
			angle += 360

		var side: int

		if angle >= 90 and angle < 280:
			side = Side.LEFT
		else:
			side = Side.RIGHT

 

		if angle >= 50 and angle < 130:

			animated_sprite.play("idleDownGun")

			down = true

			hands_animation.play("handsWalkingDown")
			hands_animation.visible = true

			if side == Side.RIGHT:
				hands_animation.frame = 7
			else:
				hands_animation.frame = 0

			if side == Side.LEFT:
				lamp_l.visible = false
				lamp_r.visible = true
				lamp_r.play("LampRightWalkingDown")
			else:
				lamp_l.visible = true
				lamp_r.visible = false
				lamp_l.play("LampLeftWalkingDown")

		else:
			down = false

		if angle >= 240 and angle < 320:

			lamp_l.visible = false
			lamp_r.visible = false
			hands_animation.visible = false

			if side == Side.RIGHT:
				animated_sprite.frame = 1
			else:
				animated_sprite.frame = 0

			animated_sprite.play("idleUpGun")

			up = true

		else:
			up = false

		if side == Side.RIGHT and !down and !up:

			animated_sprite.play("idleGun")

			if angle >= 280 and angle < 350:
				hands_animation.frame = 3
			elif angle >= 335:
				hands_animation.frame = 2
			elif angle >= 15 and angle < 40:
				hands_animation.frame = 1

			hands_animation.play("handsWalkingRight")
			hands_animation.visible = true

			lamp_l.visible = false
			lamp_r.visible = true

			lamp_r.play("LampRightWalking")

		elif side == Side.LEFT and !down and !up:

			animated_sprite.play("idleLeftGun")

			if angle >= 130 and angle < 170:
				hands_animation.frame = 1
			elif angle >= 170 and angle < 200:
				hands_animation.frame = 2
			elif angle >= 200 and angle < 280:
				hands_animation.frame = 3

			hands_animation.play("handsWalkingLeft")
			hands_animation.visible = true

			lamp_l.visible = true
			lamp_r.visible = false

			lamp_l.play("LampLeftWalking")

	else:

		if animated_sprite.animation == "idleGun":
			animated_sprite.play("idle")

		elif animated_sprite.animation == "idleLeftGun":
			animated_sprite.play("idleLeft")

		elif animated_sprite.animation == "idleDownGun":
			animated_sprite.play("idleDown")

		elif animated_sprite.animation == "idleUpGun":
			animated_sprite.play("idleUp")
