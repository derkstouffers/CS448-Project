extends MenuBar

@onready var level = get_node("/root/main/level")
@onready var tile_map : TileMap = $"../level/TileMap"
@onready var background : TileMapLayer = level.get_node("/root/main/level/TileMap/Background")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/TileMap/Player Area")
@onready var foreground : TileMapLayer = level.get_node("/root/main/level/TileMap/foreground")
@onready var inventory = get_node("/root/main/inventory")
const player1 = preload("res://scenes/dwarf.tscn")

func _on_clear_pressed() -> void:
	background.clear()
	playerArea.clear()
	foreground.clear()
	pass # Replace with function body.


func _on_player_select_item_selected(_index: int) -> void:
	
	var player
	player = player1.instantiate()
	player.global_position = get_global_mouse_position()
	playerArea.add_child(player)
	pass # Replace with function body.


func _on_play_pressed() -> void:
	Global.playing = !Global.playing
	inventory.visible = !Global.playing
	#visible = !Global.playing
	pass # Replace with function body.
