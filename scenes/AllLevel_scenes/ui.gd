extends CanvasLayer

var ammo := 6

@onready var ammo_label = $"Ammo/AmmoLabel"


func update_ammo_ui():
	ammo_label.text = str(ammo)
	
func add_ammo(amount: int):
	ammo += amount
	update_ammo_ui()
	
func use_ammo():
	if ammo > 0:
		ammo -= 1
		
	update_ammo_ui()

func _process(delta):

	if Input.is_action_just_pressed("ui_accept"):
		add_ammo(1)
