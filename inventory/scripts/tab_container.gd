extends TabContainer
@onready var level = get_node("/root/main/level2")
@onready var object_cursor = get_node("/root/main/editor_object")

const player1 = preload("res://scenes/dwarf.tscn")


func _ready():
	connect("mouse_entered", mouse_enter)
	connect("mouse_exited", mouse_exit)
	pass
#
#func _process(delta: float) -> void:
	#pass
	#

	
func mouse_enter():
	object_cursor.can_place = false
	object_cursor.hide()
	pass
func mouse_exit():
	object_cursor.can_place = true
	object_cursor.show()
	pass
	
	

###
### BACKGROUND
###



###
### GROUND and WALL TILES 
###
func _on_stone_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

func _on_bricks_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(2,0)
	pass # Replace with function body.


func _on_bricks_item_selected(index: int) -> void:
	if(index == 0):
		Global.place_tile = true
		Global.TileID = 0
		Global.current_tile_coords = Vector2i(2,0)
	elif(index == 1):
		Global.place_tile = true
		Global.TileID = 0
		Global.current_tile_coords = Vector2i(3,0)
	elif(index == 2):
		Global.place_tile = true
		Global.TileID = 0
		Global.current_tile_coords = Vector2i(4,0)			
	pass # Replace with function body.
	
	
###
### HAZARD TILES
###
func _on_lava_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(1,0)
	pass # Replace with function body.


func _on_spikes_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 6
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

func _on_spikes_item_selected(index: int) -> void:
	if(index == 0):
		Global.place_tile = true
		Global.TileID = 6
		Global.current_tile_coords = Vector2i(0,0)
	if(index == 1):
		Global.place_tile = true
		Global.TileID = 2
		Global.current_tile_coords = Vector2i(0,0)
	if(index == 2):
		Global.place_tile = true
		Global.TileID = 7
		Global.current_tile_coords = Vector2i(0,0)		
	pass # Replace with function body.	


###
### DECOR TILES
###
func _on_jack_o_lantern_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(0,0)
	
	pass # Replace with function body.
	
func _on_spider_webs_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 8
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.
	
func _on_spider_webs_item_selected(index: int) -> void:
	if(index == 0):
		Global.place_tile = true
		Global.TileID = 8
		Global.current_tile_coords = Vector2i(0,0)
	if(index == 1):
		Global.place_tile = true
		Global.TileID = 9
		Global.current_tile_coords = Vector2i(0,0)
	if(index == 2):
		Global.place_tile = true
		Global.TileID = 10
		Global.current_tile_coords = Vector2i(0,0)
	if(index == 3):
		Global.place_tile = true
		Global.TileID = 11
		Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.
	
	
###
### INTERACTIVE TILES
###
func _on_coin_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 3
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_ladder_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 4
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_chest_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 5
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


###
### CHARACTERS
###

func _on_dwarf_pressed() -> void:
	var player
	player = player1.instantiate()
	level.add_child(player)
	player.global_position = get_global_mouse_position()
	
	pass # Replace with function body.
