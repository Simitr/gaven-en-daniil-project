extends CharacterBody2D

class_name Player

var max_health := 100
var health := 75
var HealthPotions := 0
var ammo := 6


func _process(delta):
	if Input.is_action_just_pressed("Heal"):
		use_HealthPotions()


func add_ammo(amount: int):
	ammo += amount

func use_ammo():
	if ammo > 0:
		ammo -= 1


func add_HealthPotions(amount: int):
	HealthPotions += amount
	
func use_HealthPotions():
	if HealthPotions > 0:
		HealthPotions -= 1
		heal(25)

func take_damage(amount: int):
	health -= amount
	health = max(health, 0)
	
func heal(amount: int):
	health += amount
	health = min(health, max_health)
	
