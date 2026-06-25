extends CharacterBody2D

enum State { CHASE, FLEE, WAIT, ATTACK, PHASE_THROUGH }

@export var speed = 100.0
@export var rage_speed_multiplier = 1.8
@export var flee_speed = 140.0
@export var flee_distance = 250.0
@export var attack_range = 40.0
@export var flee_wait_time = 2.0
@export var attack_cooldown = 1.0
@export var attack_damage = 10
@export var knockback_force = 200.0
@export var corner_check_radius = 60.0
@export var phase_speed = 160.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

var nav_agent: NavigationAgent2D
var wait_timer: Timer
var attack_timer: Timer

var player = null
var state = State.CHASE
var dead = false
var can_attack = true

var phase_timer := 0.0
var phase_duration := 1.5
var phase_direction := Vector2.ZERO
var phase_cooldown_timer := 0.0
var phase_cooldown := 5.0


func _ready():
	if Global.monster_dead:
		queue_free()
		return

	player = get_tree().get_first_node_in_group("player")

	if has_node("NavigationAgent2D"):
		nav_agent = $NavigationAgent2D
		nav_agent.path_desired_distance = 4.0
		nav_agent.target_desired_distance = 4.0
	else:
		push_warning("Enemy: добавь дочерний узел NavigationAgent2D!")

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

	# АНИМАЦИЯ: воспроизвести анимацию появления врага
	# if sprite.sprite_frames and sprite.sprite_frames.has_animation("spawn"):
	#     sprite.play("spawn")


func add_hp(damage):
	# damage отрицательный при уроне
	Global.monster_hp += damage
	_vanish()
	if Global.monster_hp <= 0 and not dead:
		_die()


# Вызывается снаружи при нанесении урона врагу
func take_damage(damage: int):
	if dead:
		return

	# АНИМАЦИЯ: анимация получения урона
	# if sprite.sprite_frames and sprite.sprite_frames.has_animation("hurt"):
	#     sprite.play("hurt")

	add_hp(-damage)

	if not dead:
		# Враг исчезает при получении удара — уходит и возвращается позже
		_vanish()


func _die():
	dead = true
	Global.monster_dead = true

	# АНИМАЦИЯ: анимация смерти
	# if sprite.sprite_frames and sprite.sprite_frames.has_animation("death"):
	#     sprite.play("death")
	# await sprite.animation_finished

	queue_free()


# Враг "растворяется" — исчезает и уведомляет спаунер о повторном появлении
func _vanish():
	if dead:
		return
	dead = true

	# АНИМАЦИЯ: анимация исчезновения
	# if sprite.sprite_frames and sprite.sprite_frames.has_animation("vanish"):
	#     sprite.play("vanish")
	# await sprite.animation_finished

	# Уведомляем спаунер чтобы он запустил таймер переспауна
	var spawner = get_tree().get_first_node_in_group("enemy_spawner")
	if spawner and spawner.has_method("schedule_respawn"):
		spawner.schedule_respawn()

	queue_free()


func _physics_process(delta):
	if dead or not player:
		return

	if phase_cooldown_timer > 0:
		phase_cooldown_timer -= delta

	match state:
		State.CHASE:         _process_chase(delta)
		State.FLEE:          _process_flee()
		State.WAIT:          velocity = Vector2.ZERO
		State.ATTACK:        _process_attack()
		State.PHASE_THROUGH: _process_phase_through(delta)

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


# ── CHASE ──────────────────────────────────────

func _process_chase(delta):
	if _is_in_light():
		_enter_flee_state()
		return

	if global_position.distance_to(player.global_position) <= attack_range:
		state = State.ATTACK
		return

	if _is_cornered() and phase_cooldown_timer <= 0:
		_enter_phase_through()
		return

	# АНИМАЦИЯ: анимация преследования
	# if sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
	#     sprite.play("walk")

	if nav_agent == null:
		velocity = (player.global_position - global_position).normalized() * _chase_speed()
		return

	nav_agent.target_position = player.global_position
	if nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	velocity = (nav_agent.get_next_path_position() - global_position).normalized() * _chase_speed()


func _chase_speed() -> float:
	return speed * (rage_speed_multiplier if Global.rage else 1.0)


# ── FLEE ───────────────────────────────────────

func _enter_flee_state():
	state = State.FLEE

	# АНИМАЦИЯ: анимация испуга / бегства
	# if sprite.sprite_frames and sprite.sprite_frames.has_animation("scared"):
	#     sprite.play("scared")


func _process_flee():
	var lights = _get_light_areas()

	if lights.is_empty():
		state = State.WAIT
		velocity = Vector2.ZERO

		# АНИМАЦИЯ: анимация ожидания / idle
		# if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
		#     sprite.play("idle")

		wait_timer.start()
		return

	var flee_dir = Vector2.ZERO
	for l in lights:
		flee_dir += (global_position - l.global_position).normalized()
	flee_dir = flee_dir.normalized()

	if nav_agent == null:
		velocity = flee_dir * flee_speed
		return

	nav_agent.target_position = global_position + flee_dir * flee_distance
	velocity = (nav_agent.get_next_path_position() - global_position).normalized() * flee_speed


# ── ATTACK ─────────────────────────────────────

func _process_attack():
	velocity = Vector2.ZERO

	if can_attack:
		can_attack = false

		# АНИМАЦИЯ: анимация атаки
		# if sprite.sprite_frames and sprite.sprite_frames.has_animation("attack"):
		#     sprite.play("attack")

		attack_timer.start()

		if player and player.has_method("take_damage"):
			player.take_damage(attack_damage)
		if player and player.has_method("apply_knockback"):
			player.apply_knockback((player.global_position - global_position).normalized() * knockback_force)

		# Враг исчезает после нанесения урона
		_vanish()
		return

	if global_position.distance_to(player.global_position) > attack_range * 1.2:
		state = State.CHASE


# ── PHASE THROUGH ──────────────────────────────

func _is_cornered() -> bool:
	var space = get_world_2d().direct_space_state
	var blocked = 0
	for d in [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]:
		var q = PhysicsRayQueryParameters2D.create(
			global_position, global_position + d * corner_check_radius, collision_mask)
		q.exclude = [self]
		if space.intersect_ray(q):
			blocked += 1
	return blocked >= 3


func _enter_phase_through():
	state = State.PHASE_THROUGH
	phase_cooldown_timer = phase_cooldown
	phase_timer = phase_duration
	phase_direction = (global_position - player.global_position).normalized()
	set_collision_mask_value(1, false)
	modulate = Color(1, 1, 1, 0.4)

	# АНИМАЦИЯ: анимация прохождения сквозь стены
	# if sprite.sprite_frames and sprite.sprite_frames.has_animation("scared"):
	#     sprite.play("scared")


func _process_phase_through(delta):
	phase_timer -= delta
	velocity = phase_direction * phase_speed

	if phase_timer <= 0:
		set_collision_mask_value(1, true)
		modulate = Color(1, 1, 1, 1.0)
		if _is_in_light():
			_enter_flee_state()
		else:
			state = State.WAIT
			wait_timer.start()


# ── WAIT таймер ────────────────────────────────

func _on_wait_timer_timeout():
	state = State.CHASE


func _on_area_2d_body_entered(_body: Node2D) -> void:
	pass
