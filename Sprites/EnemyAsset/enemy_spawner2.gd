extends Node2D

# ── EnemySpawner ────────────────────────────────────────────────────────────
# Добавь этот узел (Node2D) в сцену и назначь ему группу "enemy_spawner".
# В качестве дочерних узлов добавь Marker2D (или Node2D) — это будут точки спауна.
#
# ВАЖНО для мультикомнатных сцен:
# Чтобы враг не спаунился "в другой комнате не в ту сторону" и не застревал
# в стенах, каждая точка спауна должна называться с префиксом комнаты, например:
#   Room1_SpawnA, Room1_SpawnB, Room2_SpawnA, Room2_SpawnB ...
# Разделитель — символ "_" (можно поменять в ROOM_NAME_SEPARATOR).
# Если префиксов нет — все точки считаются одной "комнатой" (старое поведение).
#
# Схема сцены:
#   EnemySpawner  (этот скрипт, группа "enemy_spawner")
#   ├── Room1_SpawnA  (Marker2D)
#   ├── Room1_SpawnB  (Marker2D)
#   └── Room2_SpawnA  (Marker2D)
# ────────────────────────────────────────────────────────────────────────────

const ROOM_NAME_SEPARATOR := "_"

# Путь к сцене врага
@export var enemy_scene: PackedScene

# Минимальное и максимальное время до повторного появления (в секундах)
@export var respawn_time_min: float = 10.0
@export var respawn_time_max: float = 30.0

# Минимальное расстояние от игрока, на котором может заспауниться враг
@export var min_spawn_distance_from_player: float = 200.0

# Радиус проверки на "не в стене". Должен быть примерно с половину
# коллайдера врага, а лучше чуть больше (запас).
@export var wall_check_radius: float = 16.0

# По какому физическому слою определяем стены/препятствия.
# Выставь маску так, чтобы совпадала с collision_layer твоих стен.
@export_flags_2d_physics var wall_collision_mask: int = 1

# Сколько раз пробовать другую точку, если первая уперлась в стену
@export var max_spawn_attempts: int = 8

# ── Фиксированный спаун ──────────────────────────────────────────────────
# Если включено — весь рандом/подбор по комнатам и дистанции игнорируется,
# враг ВСЕГДА появляется в этой точке. Удобно для конкретной локации, где
# нужен предсказуемый спаун (например, босс или враг у определённого прохода).
@export var use_fixed_spawn_point: bool = true

# Точка (Marker2D/Node2D), в которую всегда спаунится враг, если
# use_fixed_spawn_point = true. Перетащи сюда нужный маркер в инспекторе.
@export var fixed_spawn_point: Vector2 


# Проверять ли стены даже для фиксированной точки (обычно не нужно —
# ты сам разместил маркер в правильном месте).
@export var check_walls_for_fixed_point: bool = false

var respawn_timer: Timer
var spawn_points: Array = []
var rooms: Dictionary = {} # room_name (String) -> Array[Node2D]


func _ready():
	add_to_group("enemy_spawner")

	for child in get_children():
		if child is Timer:
			continue
		spawn_points.append(child)
		var room_name = _extract_room_name(child.name)
		if not rooms.has(room_name):
			rooms[room_name] = []
		rooms[room_name].append(child)

	if spawn_points.is_empty():
		push_warning("EnemySpawner: нет точек спауна! Добавь дочерние узлы Marker2D.")

	respawn_timer = Timer.new()
	respawn_timer.one_shot = true
	add_child(respawn_timer)
	respawn_timer.timeout.connect(_on_respawn_timer_timeout)

	if not Global.monster_dead:
		_spawn_enemy()


func _extract_room_name(node_name: String) -> String:
	var idx = node_name.find(ROOM_NAME_SEPARATOR)
	if idx == -1:
		return "_default"
	return node_name.substr(0, idx)


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
		# Нет подходящей свободной точки — попробуем позже
		respawn_timer.wait_time = 3.0
		respawn_timer.start()
		print("EnemySpawner: не найдено свободной точки спауна, повтор через 3 сек.")
		return

	var enemy = enemy_scene.instantiate()

	get_tree().current_scene.add_child.call_deferred(enemy)
	enemy.set_deferred("global_position", spawn_pos)

	print("EnemySpawner: враг появился в позиции ", spawn_pos)


# Проверяет, не пересекает ли точка стену/препятствие
func _is_position_free(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = wall_check_radius
	query.shape = shape
	query.transform = Transform2D(0, pos)
	query.collision_mask = wall_collision_mask
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var result = space_state.intersect_shape(query, 1)
	return result.is_empty()


# Выбирает случайную свободную точку спауна, достаточно далёкую от игрока.
# Сначала пытается найти точку в "комнате" игрока (если есть группировка по
# комнатам), иначе — среди всех точек.
func _pick_spawn_position() -> Variant:
	if use_fixed_spawn_point:
		return _get_fixed_spawn_position()

	var player = get_tree().get_first_node_in_group("player")
	var candidates = _get_candidate_points(player)

	candidates.shuffle()

	var attempts = 0
	var fallback: Node2D = null
	var fallback_dist = -1.0

	for point in candidates:
		if attempts >= max_spawn_attempts:
			break
		attempts += 1

		var pos = point.global_position
		var dist = INF if player == null else pos.distance_to(player.global_position)

		# запоминаем самую дальнюю точку на случай, если ничего не подойдёт
		if dist > fallback_dist:
			fallback_dist = dist
			fallback = point

		if player != null and dist < min_spawn_distance_from_player:
			continue

		if _is_position_free(pos):
			return pos

	# Ничего не подошло по дистанции/стенам — берём самую дальнюю
	# свободную точку, если такая есть
	for point in candidates:
		if _is_position_free(point.global_position):
			return point.global_position

	return null


# Возвращает координаты фиксированной точки спауна (если use_fixed_spawn_point = true)
func _get_fixed_spawn_position() -> Variant:

	var point = Vector2(630, 330)

	var pos = Vector2(550, 550)

	if check_walls_for_fixed_point and not _is_position_free(pos):
		push_warning("EnemySpawner: фиксированная точка спауна пересекает стену!")

	return pos


# Возвращает точки спауна той же "комнаты", что и игрок (по ближайшей точке
# среди всех). Если группировка не задана — возвращает все точки.
func _get_candidate_points(player: Node2D) -> Array:
	if rooms.size() <= 1 or player == null:
		return spawn_points.duplicate()

	# Находим ближайшую к игроку точку — считаем её текущей комнатой игрока
	var nearest_point: Node2D = null
	var nearest_dist = INF
	for point in spawn_points:
		var d = point.global_position.distance_to(player.global_position)
		if d < nearest_dist:
			nearest_dist = d
			nearest_point = point

	if nearest_point == null:
		return spawn_points.duplicate()

	var player_room = _extract_room_name(nearest_point.name)
	return rooms.get(player_room, spawn_points).duplicate()
