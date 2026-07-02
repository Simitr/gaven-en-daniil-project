extends Node2D

@onready var light: PointLight2D =  $flashlight2
@onready var area: Area2D = $flashlight2/Area2D

@export var stable_duration: float = 20.0
@export var flicker_duration: float = 2.0
@export var flicker_speed_min: float = 0.05
@export var flicker_speed_max: float = 0.15
@export var blackout_duration: float = 3.0

var base_energy: float = 1.0
var cycle_running: bool = false

func _ready() -> void:
	randomize()
	base_energy = light.energy

	# Area2D всегда остаётся monitoring/monitorable — физика не должна прерываться
	area.monitoring = true
	area.monitorable = true

	if not area.is_in_group("light"):
		area.add_to_group("light")

	if not cycle_running:
		cycle_running = true
		_run_cycle()

func _run_cycle() -> void:
	while true:
		# Фаза 1: стабильный свет
		light.enabled = true
		light.visible = true
		light.energy = base_energy
		if not area.is_in_group("light"):
			area.add_to_group("light")
		await get_tree().create_timer(stable_duration).timeout

		# Фаза 2: моргание (свет ещё "работает" как источник опасности)
		var elapsed: float = 0.0
		while elapsed < flicker_duration:
			var flicker_time: float = randf_range(flicker_speed_min, flicker_speed_max)
			light.energy = randf_range(0.1, base_energy) if randf() > 0.3 else 0.0
			await get_tree().create_timer(flicker_time).timeout
			elapsed += flicker_time

		# Фаза 3: полное отключение — визуально гасим свет,
		# но area НЕ трогаем через monitoring/monitorable
		light.energy = 0.0
		light.enabled = false
		light.visible = false

		# Убираем из группы "light" — враг перестаёт считать это зоной света
		if area.is_in_group("light"):
			area.remove_from_group("light")

		await get_tree().create_timer(blackout_duration).timeout
		
		var elapsed2: float = 0.0
		while elapsed2 < flicker_duration:
			var flicker_time: float = randf_range(flicker_speed_min, flicker_speed_max)
			light.energy = randf_range(0.1, base_energy) if randf() > 0.3 else 0.0
			await get_tree().create_timer(flicker_time).timeout
			elapsed2 += flicker_time
