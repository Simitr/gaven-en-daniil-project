extends CanvasModulate

@export var dark_color := Color("040405")
@export var normal_color := Color.WHITE  # обычное освещение сцены
@export var transition_speed := 2.0

var target_color := Color.BLACK

func _ready():
	# При входе в сцену — экран полностью чёрный
	color = Color.BLACK
	target_color = normal_color  # плавно проявляем сцену

 
