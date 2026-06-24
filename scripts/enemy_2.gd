extends CharacterBody2D

enum State { CHASE, FLEE, WAIT, ATTACK }

@export var speed = 100.0
@export var rage_speed_multiplier = 1.8
@export var flee_speed = 140.0
@export var flee_distance = 250.0      # на сколько далеко пытается убежать от света
@export var attack_range = 40.0
@export var flee_wait_time = 2.0       # сколько ждёт в темноте перед новой попыткой напасть
@export var attack_cooldown = 1.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D



var nav_agent: NavigationAgent2D
var wait_timer: Timer
var attack_timer: Timer

var player = null
var state = State.CHASE
var hurt = false
var dead = false
var can_attack = true

var hp = 25.0

func _ready():
	player = get_tree().get_first_node_in_group("player")

	if has_node("NavigationAgent2D"):
		nav_agent = $NavigationAgent2D
		nav_agent.path_desired_distance = 4.0
		nav_agent.target_desired_distance = 4.0
	else:
		push_warning("Enemy: добавь дочерний узел NavigationAgent2D, иначе обхода препятствий не будет.")

	wait_timer = Timer.new()
	wait_timer.one_shot = true
	wait_timer.wait_time = flee_wait_time
	add_child(wait_timer)
	wait_timer.timeout.connect(_on_wait_timer_timeout)

	attack_timer = Timer.new()
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_cooldown
	add_child(attack_timer)
	attack_timer.timeout.connect(func(): can_attack = true)


func add_hp(damage):
	_enter_flee_state()
	hp += damage
	print(hp)
	if hp <= 0 and not dead:
		dead = true
		queue_free()


func _physics_process(delta):
	if dead or not player:
		print("enemyfout")
		return

	match state:
		State.CHASE:
			_process_chase()
		State.FLEE:
			_process_flee()
		State.WAIT:
			velocity = Vector2.ZERO
		State.ATTACK:
			_process_attack()

	move_and_slide()


func _is_in_light() -> bool:
	for a in area.get_overlapping_areas():
		if a.is_in_group("light"):
			return true
	return false


func _get_light_areas() -> Array:
	var lights = []
	for a in area.get_overlapping_areas():
		if a.is_in_group("light"):
			lights.append(a)
	return lights


func _process_chase():
	if _is_in_light():
		_enter_flee_state()
		return

	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player <= attack_range:
		_enter_attack_state()
		return

	if nav_agent == null:
		# запасной вариант без NavigationAgent2D — идёт по прямой
		velocity = (player.global_position - global_position).normalized() * _current_chase_speed()
		return

	nav_agent.target_position = player.global_position
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var next_path_pos = nav_agent.get_next_path_position()
	var direction = (next_path_pos - global_position).normalized()
	velocity = direction * _current_chase_speed()


func _current_chase_speed() -> float:
	var s = speed
	if Global.rage:
		s *= rage_speed_multiplier
	return s


func _process_flee():
	var lights = _get_light_areas()

	if lights.is_empty():
		# вышел из света — останавливается и ждёт перед новой попыткой напасть
		velocity = Vector2.ZERO
		state = State.WAIT
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")
		wait_timer.start()
		return

	var flee_direction = Vector2.ZERO
	for l in lights:
		flee_direction += (global_position - l.global_position).normalized()
	flee_direction = flee_direction.normalized()

	if nav_agent == null:
		velocity = flee_direction * flee_speed
		return

	nav_agent.target_position = global_position + flee_direction * flee_distance
	var next_path_pos = nav_agent.get_next_path_position()
	var direction = (next_path_pos - global_position).normalized()
	velocity = direction * flee_speed


func _enter_flee_state():
	state = State.FLEE
	if sprite.sprite_frames and sprite.sprite_frames.has_animation("scared"):
		sprite.play("scared")


func _enter_attack_state():
	state = State.ATTACK


func _process_attack():
	velocity = Vector2.ZERO

	if can_attack:
		can_attack = false
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("attack"):
			sprite.play("attack")
		attack_timer.start()
		# здесь добавь нанесение урона игроку, например:
		# if player.has_method("add_hp"):
		#     player.add_hp(-1)

	# если игрок отошёл — возвращаемся в погоню
	if global_position.distance_to(player.global_position) > attack_range * 1.2:
		state = State.CHASE


func _on_wait_timer_timeout():
	state = State.CHASE


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().quit()
