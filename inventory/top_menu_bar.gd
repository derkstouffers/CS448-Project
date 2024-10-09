extends MenuBar

@onready var level = get_node("/root/main/level")
@onready var tile_map : TileMap = $"../level/TileMap"
@onready var background : TileMapLayer = level.get_node("/root/main/level/TileMap/Background")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/TileMap/Player Area")
@onready var foreground : TileMapLayer = level.get_node("/root/main/level/TileMap/foreground")



func _on_clear_pressed() -> void:
	background.clear()
	playerArea.clear()
	foreground.clear()
	pass # Replace with function body.
