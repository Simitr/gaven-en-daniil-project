extends State
class_name WalkingState

@export var character: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var legs: AnimatedSprite2D
@export var speed: float = 90.0


func update(delta):
	if !GlobalArmed.armed:
		var dir = GameInput.movement_input()

		if dir == Vector2.ZERO:
			fsm.change_state("Idle")
			return

		if dir.x < 0:
			animated_sprite.play("walkingback")
		elif dir.x > 0:
			animated_sprite.play("walking")
		elif dir.y > 0:
			animated_sprite.play("walkingDown")

		if dir.y < 0:
			legs.play("walkingUp")
			legs.visible = true

			if legs.frame == 1 or legs.frame == 4:
				animated_sprite.position = Vector2(-2, -14)
			else:
				animated_sprite.position = Vector2(-2, -15)

			animated_sprite.play("WalkingUp")
		else:
			legs.visible = false

		character.velocity = dir * speed
		character.move_and_slide()

	else:
		fsm.change_state("WalkAremd")
