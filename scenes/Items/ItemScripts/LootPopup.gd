extends CanvasLayer

@onready var icon = $Panel/ItemRect
@onready var item_name = $Panel/ItemName
@onready var item_line = $Panel/ItemLine

func _ready():
	hide()

func show_loot(texture: Texture2D, loot_name: String, loot_byline: String):
	icon.texture = texture
	item_name.text = loot_name
	item_line.text = loot_byline

	show()

	await get_tree().create_timer(3.0).timeout

	hide()
