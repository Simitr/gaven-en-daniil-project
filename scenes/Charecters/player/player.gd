extends CharacterBody2D

class_name Player

var ammo := 6

func add_ammo(amount: int):
	ammo += amount

func use_ammo():
	if ammo > 0:
		ammo -= 1
