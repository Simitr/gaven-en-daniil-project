extends Object
class_name GameInput

static func movement_input() -> Vector2:
	var dir := Vector2.ZERO

	if Input.is_action_pressed("walkRight"):
		dir.x += 1

	if Input.is_action_pressed("walkLeft"):
		dir.x -= 1

	if Input.is_action_pressed("walkDown"):
		dir.y += 1

	if Input.is_action_pressed("walkUp"):
		dir.y -= 1
		
	if Input.is_action_just_pressed("armed"):
		Global.armed = !Global.armed
		
	return dir.normalized()
