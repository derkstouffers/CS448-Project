extends TabContainer

@onready var object_cursor = get_node("/root/main/editor_object")

func _ready():
	#_on_mouse_entered()
	#_on_mouse_exited()
	connect("mouse_entered", mouse_enter)
	connect("mouse_exited", mouse_exit)
	pass

#func _process(delta: float) -> void:
	#pass
	#
#func _on_mouse_entered() -> void:
	##Global.place_tile = false
	#object_cursor.can_place = false
	#object_cursor.hide()
	#pass # Replace with function body.
#
#
#func _on_mouse_exited() -> void:
	##Global.place_tile = true
	#object_cursor.can_place = true
	#object_cursor.show()
	#pass # Replace with function body.
	
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
func _on_night_forest_pressed() -> void:
	#background.texture =  
	pass # Replace with function body.


###
### GROUND and WALL TILES 
###

func _on_stone_2_pressed() -> void:
	object_cursor.can_place = false
	object_cursor.hide()
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_beige_bricks_2_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(2,0)
	pass # Replace with function body.


func _on_brown_bricks_2_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(3,0)
	pass # Replace with function body.


func _on_dark_gray_bricks_2_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(4,0)
	pass # Replace with function body.
	
	
###
### HAZARD TILES
###

func _on_lava_2_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(1,0)
	pass # Replace with function body.
	
func _on_med_spikes_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 2
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
