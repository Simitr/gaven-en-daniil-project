extends Area2D


var speed: float = 300.0
var damage: float = 5.0
var direction: Vector2
var is_dead = false

@export var sprite: AnimatedSprite2D

func init(parent: Node2D) -> void:
	parent.get_tree().current_scene.add_child(self)

	global_position = parent.global_position
	global_rotation = parent.global_rotation

	var spread = deg_to_rad(randf_range(-10.0, 10.0))
	direction = Vector2.RIGHT.rotated(global_rotation + spread)
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	





func _on_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	is_dead = true
	if body.has_method("add_hp"):
		body.add_hp(-damage)
	speed = 0
	sprite.play("dead")
	await sprite.animation_finished
	queue_free() 
