extends CanvasModulate

@export var dark_color := Color("040405")
@export var transition_speed := 2.0

var target_color := Color.BLACK

func _ready():
	color = Color.BLACK
	target_color = Color.BLACK

func _process(delta):
	color = color.lerp(target_color, delta * transition_speed)

func activate_darkness():
	target_color = dark_color
