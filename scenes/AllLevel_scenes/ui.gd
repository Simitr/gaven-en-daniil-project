extends CanvasLayer

var ammo := 6

func add_ammo(amount: int):
	ammo += amount
	update_ammo_ui()
	
func use_ammo():
	if ammo > 0:
		ammo -= 1
		update_ammo_ui()

@onready var ammo_label = $CanvasLayer/AmmoLabel

func update_ammo_ui():
	ammo_label.text = str(ammo)
	
	
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
