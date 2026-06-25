extends Node2D

# ── EnemySpawner ────────────────────────────────────────────────────────────
# Добавь этот узел (Node2D) в сцену и назначь ему группу "enemy_spawner".
# В качестве дочерних узлов добавь Marker2D (или Node2D) — это будут точки спауна.
# Назови их как угодно, главное чтобы они были прямыми детьми этого узла.
#
# Схема сцены:
#   EnemySpawner  (этот скрипт, группа "enemy_spawner")
#   ├── SpawnPoint1  (Marker2D)
#   ├── SpawnPoint2  (Marker2D)
#   └── SpawnPoint3  (Marker2D)
# ────────────────────────────────────────────────────────────────────────────

# Путь к сцене врага
@export var enemy_scene: PackedScene

# Минимальное и максимальное время до повторного появления (в секундах)
@export var respawn_time_min: float = 5.0
@export var respawn_time_max: float = 5.0

# Минимальное расстояние от игрока, на котором может заспауниться враг
@export var min_spawn_distance_from_player: float = 200.0

var respawn_timer: Timer
var spawn_points: Array = []


func _ready():
	add_to_group("enemy_spawner")

	# Собираем все дочерние узлы как точки спауна
	for child in get_children():
		spawn_points.append(child)

	if spawn_points.is_empty():
		push_warning("EnemySpawner: нет точек спауна! Добавь дочерние узлы Marker2D.")

	respawn_timer = Timer.new()
	respawn_timer.one_shot = true
	add_child(respawn_timer)
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)

	# Спауним врага при старте сцены (если он не мёртв глобально)
	if not Global.monster_dead:
		_spawn_enemy()


# Вызывается из скрипта врага когда тот исчезает (после урона или получения урона)
func schedule_respawn():
	if Global.monster_dead:
		return

	var wait_time = randf_range(respawn_time_min, respawn_time_max)
	respawn_timer.wait_time = wait_time
	respawn_timer.start()
	print("EnemySpawner: враг появится через %.1f сек." % wait_time)


func _on_respawn_timer_timeout():
	if Global.monster_dead:
		return
	_spawn_enemy()


func _spawn_enemy():
	if enemy_scene == null:
		push_error("EnemySpawner: enemy_scene не назначена!")
		return

	var spawn_pos = _pick_spawn_position()
	if spawn_pos == null:
		# Нет подходящей точки — попробуем позже
		respawn_timer.wait_time = 3.0
		respawn_timer.start()
		return

	var enemy = enemy_scene.instantiate()

	# Добавляем врага в корень сцены, чтобы он не был дочерним узлом спаунера
	# call_deferred нужен чтобы add_child не вызывался пока сцена ещё грузится
	get_tree().current_scene.add_child.call_deferred(enemy)
	enemy.set_deferred("global_position", spawn_pos)

	print("EnemySpawner: враг появился в позиции ", spawn_pos)


# Выбирает случайную точку спауна, достаточно далёкую от игрока
func _pick_spawn_position() -> Variant:
	var player = get_tree().get_first_node_in_group("player")

	# Перемешиваем точки чтобы выбор был случайным
	var shuffled = spawn_points.duplicate()
	shuffled.shuffle()

	for point in shuffled:
		if player == null:
			return point.global_position

		var dist = point.global_position.distance_to(player.global_position)
		if dist >= min_spawn_distance_from_player:
			return point.global_position

	# Если все точки слишком близко — берём самую дальнюю
	if not shuffled.is_empty() and player != null:
		var farthest = shuffled[0]
		var max_dist = 0.0
		for point in shuffled:
			var d = point.global_position.distance_to(player.global_position)
			if d > max_dist:
				max_dist = d
				farthest = point
		return farthest.global_position

	return null
