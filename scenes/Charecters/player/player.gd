extends CharacterBody2D

class_name Player

var ammo
var health_potions
var max_health
var health


func _ready():
	ammo = Global.ammo
	health_potions = Global.health_potions

	max_health = Global.max_health
	health = Global.health
	

func _process(delta):
	if Input.is_action_just_pressed("Heal"):
		use_HealthPotions()



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
