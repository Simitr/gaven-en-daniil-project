extends CanvasModulate

@export var dark_color := Color("160d16ff")
@export var transition_speed := 2.0

var target_color := Color.WHITE
var active := false

func _process(delta):
	color = color.lerp(target_color, delta * transition_speed)


func activate_darkness():
	active = true
	target_color = dark_color
