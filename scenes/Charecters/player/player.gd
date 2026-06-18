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

func _ready():
	ammo = Global.ammo
	health_potions = Global.health_potions

	max_health = Global.max_health
	health = Global.health
	lantern = Global.lantern
	key = Global.key
	
	
	

func _process(delta):
	if Input.is_action_just_pressed("Heal"):
		use_HealthPotions()
	update_flashlight()
	var direction = (get_global_mouse_position() - global_position).normalized()
	Gun.position = direction * 50
	Gun.look_at(get_global_mouse_position())

func update_flashlight():
	if Global.armed && lantern == 1:
		targetPosition = get_global_mouse_position()
		flashlight2.look_at(get_global_mouse_position())
		 
	 
		flashlight2.visible = true
	else:
		flashlight2.visible = false
		


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


func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	Global.health = health


func heal(amount: int):
	health += amount
	health = min(health, max_health)
	Global.health = health
	
	
func add_lantern(amount: int):
	lantern += amount
	Global.lantern = lantern


func add_key(amount: int):
	key += amount
	Global.key = key
	

func shoot():
	
	use_ammo()
	var new_bullet = BULLET_CLASS.instantiate()
	print(new_bullet)
	new_bullet.init($CollisionShape2D/Gun)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if(Global.armed):
			if(Global.ammo > 0):
				shoot()
