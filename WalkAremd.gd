extends State
class_name WalkArmed

@export var character: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var speed: float = 90.0

@export var lamp_l: AnimatedSprite2D
@export var lamp_r: AnimatedSprite2D
@export var hands_animation: AnimatedSprite2D




var position := false
var down := false
var up := false

enum Side {
	LEFT,
	RIGHT
}

 

func update(delta):
	var dir = GameInput.movement_input()

	if dir == Vector2.ZERO:
		fsm.change_state("Idle")
		return

	if !Global.armed:
		lamp_l.visible = false
		lamp_r.visible = false
		hands_animation.visible = false

		

		fsm.change_state("Walk")
		return
	$"../../AnimatedSprite2D2".play("walking")
	character.velocity = dir * speed
	character.move_and_slide()

	animated_sprite.position = Vector2(-2, -15)

	hands_animation.visible = true

	var mouse_dir = character.get_global_mouse_position() - character.global_position
	var angle = rad_to_deg(mouse_dir.angle())

	if angle < 0:
		angle += 360

	var side: int

	if angle >= 90 and angle < 280:
		side = Side.LEFT
	else:
		side = Side.RIGHT

	# ==========================================
	# ВНИЗ
	# ==========================================

	if angle >= 50 and angle < 130:

		down = true

		if animated_sprite.frame == 1 or animated_sprite.frame == 4:
			hands_animation.position = Vector2(1, -2)
			lamp_l.position = Vector2(1, -2)
			lamp_r.position = Vector2(1, -2)
		else:
			hands_animation.position = Vector2(1, -3)
			lamp_l.position = Vector2(1, -3)
			lamp_r.position = Vector2(1, -3)

		animated_sprite.play("walkingDownGun")
		hands_animation.play("handsWalkingDown")

		if side == Side.RIGHT:
			hands_animation.frame = 7
		elif side == Side.LEFT:
			hands_animation.frame = 0

		if side == Side.LEFT:
			lamp_l.visible = false
			lamp_r.visible = true
			lamp_r.play("LampRightWalkingDown")
		else:
			lamp_l.visible = true
			lamp_r.visible = false
			lamp_l.play("LampLeftWalkingDown")

		return

	else:
		down = false

	# ==========================================
	# ВВЕРХ
	# ==========================================

	if angle >= 240 and angle < 320:

		lamp_l.visible = false
		lamp_r.visible = false
		hands_animation.visible = false
		var frame = animated_sprite.frame
		var progress = animated_sprite.frame_progress

		

		if side == Side.RIGHT:
			if animated_sprite.animation != "walkingUpRightGun":
				animated_sprite.play("walkingUpRightGun")
				animated_sprite.frame = frame
				animated_sprite.frame_progress = progress
		else:
			if animated_sprite.animation != "walkingUpLeftGun":
				animated_sprite.play("walkingUpLeftGun")
				animated_sprite.frame = frame
				animated_sprite.frame_progress = progress

		

		up = true

	else:

		up = false

	# ==========================================
	# ВЛЕВО
	# ==========================================

	if side == Side.LEFT and !down and !up:

		animated_sprite.play("walkinLeftGun")
		hands_animation.play("handsWalkingLeft")

		if angle >= 90 and angle < 130:
			hands_animation.frame = 0
		elif angle >= 130 and angle < 170:
			hands_animation.frame = 1
		elif angle >= 170 and angle < 200:
			hands_animation.frame = 2
		elif angle >= 200 and angle < 280:
			hands_animation.frame = 3

		lamp_l.visible = true
		lamp_r.visible = false

		lamp_l.play("LampLeftWalking")

	# ==========================================
	# ВПРАВО
	# ==========================================

	elif side == Side.RIGHT and !down and !up:

		animated_sprite.play("walkingGun")
		hands_animation.play("handsWalkingRight")

		# Исправлен баг из C#
		if animated_sprite.frame == 1 or animated_sprite.frame == 3:
			hands_animation.position = Vector2(1, -2)
			lamp_l.position = Vector2(1, -2)
			lamp_r.position = Vector2(1, -2)
		else:
			hands_animation.position = Vector2(1, -3)
			lamp_l.position = Vector2(1, -3)
			lamp_r.position = Vector2(1, -3)

		if angle >= 280 and angle < 350:
			hands_animation.frame = 3
		elif angle >= 335:
			hands_animation.frame = 2
		elif angle >= 15 and angle < 40:
			hands_animation.frame = 1
		elif angle >= 40 and angle < 90:
			hands_animation.frame = 0

		lamp_l.visible = false
		lamp_r.visible = true

		lamp_r.play("LampRightWalking")
