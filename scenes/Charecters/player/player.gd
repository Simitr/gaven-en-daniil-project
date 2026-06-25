extends CharacterBody2D
class_name Player

const BULLET_CLASS = preload("res://scenes/Items/bullet.tscn")

var ammo: int = 0
var health_potions: int = 0
var max_health: int = 0
var health: int = 0
var lantern: int = 0
var key: int = 0
var targetPosition: Vector2

@export var flashlight2: PointLight2D
@export var Gun: Marker2D
@export var footstep_player: AudioStreamPlayer2D
@export var footstep_sounds: Array[AudioStream] = []

# ── экранный эффект урона ──
# Добавь в сцену ColorRect (растянуть на весь экран, красный, alpha = 0)
# и назови его "DamageOverlay", либо укажи путь ниже.
@export var damage_overlay: ColorRect   # красный оверлей (CanvasLayer → ColorRect)

var step_timer := 0.0
var step_interval := 0.40
var shoot_timer := 0.0
var shoot_interval := 0.80

@export var muzzle_flash: PointLight2D
var flash_timer := 0.0
var flash_duration := 0.4

# ── нокбэк ──
var knockback_velocity := Vector2.ZERO
var knockback_decay := 8.0   # насколько быстро гасится (множитель lerp)

# ── эффект урона ──
var damage_flash_timer := 0.0
var damage_flash_duration := 0.4


func _ready():
	ammo            = Global.ammo
	health_potions  = Global.health_potions
	max_health      = Global.max_health
	health          = Global.health
	lantern         = Global.lantern
	key             = Global.key
	Global.ui_on    = true

	if damage_overlay:
		damage_overlay.modulate.a = 0.0


func _process(delta):
	if Input.is_action_just_pressed("Heal"):
		use_HealthPotions()

	update_flashlight()

	var direction = (get_global_mouse_position() - global_position).normalized()
	Gun.position = direction * 20
	Gun.look_at(get_global_mouse_position())

	if shoot_timer > 0:
		shoot_timer -= delta

	# вспышка выстрела
	if flash_timer > 0:
		flash_timer -= delta
		muzzle_flash.energy = flash_timer / flash_duration
		if flash_timer <= 0:
			muzzle_flash.enabled = false

	# эффект урона на экране
	if damage_flash_timer > 0:
		damage_flash_timer -= delta
		if damage_overlay:
			damage_overlay.modulate.a = damage_flash_timer / damage_flash_duration
		if damage_flash_timer <= 0 and damage_overlay:
			damage_overlay.modulate.a = 0.0


func _physics_process(delta):
	# ── базовое движение (замени на своё если есть) ──
	var move_dir = Vector2.ZERO
	if Input.is_action_pressed("ui_right"): move_dir.x += 1
	if Input.is_action_pressed("ui_left"):  move_dir.x -= 1
	if Input.is_action_pressed("ui_down"):  move_dir.y += 1
	if Input.is_action_pressed("ui_up"):    move_dir.y -= 1

	var move_speed = 150.0
	velocity = move_dir.normalized() * move_speed

	# применяем нокбэк поверх движения
	velocity += knockback_velocity
	knockback_velocity = knockback_velocity.lerp(Vector2.ZERO, knockback_decay * delta)

	if move_dir != Vector2.ZERO:
		play_footstep(delta)

	move_and_slide()


# ─────────────────────────────────────────────
#  Фонарь
# ─────────────────────────────────────────────

func update_flashlight():
	if Global.armed and lantern == 1:
		targetPosition = get_global_mouse_position()
		flashlight2.look_at(get_global_mouse_position())
		flashlight2.enabled = true
		$flashlight2/Area2D/CollisionShape2D2.disabled = false
	else:
		flashlight2.enabled = false
		$flashlight2/Area2D/CollisionShape2D2.disabled = true


# ─────────────────────────────────────────────
#  Шаги
# ─────────────────────────────────────────────

func play_footstep(delta: float):
	if footstep_sounds.is_empty():
		return
	step_timer += delta
	if step_timer < step_interval:
		return
	step_timer = 0.0
	if footstep_player.playing:
		return
	var sound = footstep_sounds[randi() % footstep_sounds.size()]
	footstep_player.stream = sound
	footstep_player.volume_db = randf_range(-20.0, -15.0)
	footstep_player.pitch_scale = randf_range(0.9, 1.1)
	footstep_player.play()


# ─────────────────────────────────────────────
#  Патроны / зелья / фонарь / ключ
# ─────────────────────────────────────────────

func add_ammo(amount: int):
	ammo += amount
	Global.ammo = ammo

func use_ammo():
	if ammo > 0:
		ammo -= 1
		Global.ammo = ammo

func add_health_potions(amount: int):
	health_potions += amount
	Global.health_potions = health_potions

func use_HealthPotions():
	if health_potions > 0:
		health_potions -= 1
		heal(25)
		Global.health_potions = health_potions

func add_lantern(amount: int):
	lantern += amount
	Global.lantern = lantern

func add_key(amount: int):
	key += amount
	Global.key = key


# ─────────────────────────────────────────────
#  Здоровье
# ─────────────────────────────────────────────

func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	Global.health = health

	# эффект красного экрана
	damage_flash_timer = damage_flash_duration
	if damage_overlay:
		damage_overlay.modulate.a = 1.0

	if health <= 0:
		get_tree().quit()

func heal(amount: int):
	health += amount
	health = min(health, max_health)
	Global.health = health

func _on_death():
	# замени на свою логику (game over, respawn и т.д.)
	get_tree().reload_current_scene()


# ─────────────────────────────────────────────
#  Нокбэк (вызывается из Enemy.gd)
# ─────────────────────────────────────────────

func apply_knockback(force: Vector2):
	knockback_velocity = force


# ─────────────────────────────────────────────
#  Выстрел — все враги в дереве переходят в FLEE
# ─────────────────────────────────────────────

func shoot():
	Global.rage = true
	use_ammo()

	muzzle_flash.enabled = true
	muzzle_flash.energy = 1.0
	flash_timer = flash_duration

	var new_bullet = BULLET_CLASS.instantiate()
	new_bullet.init($CollisionShape2D/Gun)

	# ── сигнал всем врагам убегать ──
	_notify_enemies_flee()


func _notify_enemies_flee():
	# все узлы в группе "enemy" получают сигнал о выстреле
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.has_method("on_player_shot"):
			enemy.on_player_shot(global_position)


# ─────────────────────────────────────────────
#  Ввод
# ─────────────────────────────────────────────

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if Global.armed and Global.ammo > 0:
			if shoot_timer <= 0:
				shoot()
				shoot_timer = shoot_interval


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("enemyarea"):
		print(area)
		print(area.get_groups())
