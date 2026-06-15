extends Node2D

class_name Torch
@onready var light = $LightTexture

func _ready():
	light.enabled = false

func activate():
	light.enabled = true

var target_energy: float = 1.5
var amplitude: float = 0.1
var flicker_speed: float = randi_range(8.0, 9.0)
var time: float = 0.0

func _process(delta):
	time += delta * flicker_speed
	light.energy = target_energy + sin(time) * amplitude
