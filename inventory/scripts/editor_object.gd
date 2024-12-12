"""
	If in EDIT mode:
		Gives user the ability to place/remove objects and tiles in current chosen tilemaplayer
		Allows user to move camera to see different areas of tilemap, sets world limit
	
	Uses mouse buttons for place/remove of tiles/objects:
		left mouse button to place 
		right mouse button to remove
	
	Uses arrow keys to move editor camera around tilemap


"""


extends Node2D

var can_place = true


@onready var level = get_node("/root/main/level")
@onready var editor = get_node("/root/main/cam_container")
@onready var editor_cam = editor.get_node("Camera2D")

@export var cam_spd = 10
var limit_left = -1500
var limit_right = 1500
var limit_top = -1500
var limit_bottom = 1500

var current_item

@onready var background : TileMapLayer = level.get_node("/root/main/level/Background")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/Player Area")
@onready var foreground : TileMapLayer = level.get_node("/root/main/level/foreground")





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level = level
	Global.background = background
	Global.playerArea = playerArea
	Global.foreground = foreground



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if !Global.playing:
		
		global_position = get_global_mouse_position()
		
		## Place/remove interactive objects in tilemap
		if Global.place_tile == false:
			
			current_item = Global.current_item
			var new_item 
			if(current_item != null and can_place and Input.is_action_just_pressed("mb_left")):
				new_item = current_item.instantiate()

				Global.playerArea.add_child(new_item, true)
				
				new_item.global_position = Global.playerArea.selected_tile ## grid snap for object that isn't from tileset
				
				# updates level_dict for newly placed object
				if new_item.name.begins_with("coin"):
					Global.level_dict[Global.level.name]["coins"] += 1
				if new_item.name.begins_with("chest"):
					Global.level_dict[Global.level.name]["chests"] += 1
				if new_item.name.begins_with("slime"):
					Global.level_dict[Global.level.name]["enemies"] += 1
				
							
			if(can_place and Input.is_action_just_pressed("mb_right")):
				### remove interactive objects placed in level specifically the Player Area
			
				for child in Global.playerArea.get_children():
					if child.has_method("get_position") and child.get_position() == Global.playerArea.selected_tile:
						
						# updates level_dict for newly removed object
						if child.name.begins_with("coin"):
							Global.level_dict[Global.level.name]["coins"] -= 1
						if child.name.begins_with("chest"):
							Global.level_dict[Global.level.name]["chests"] -= 1
						if child.name.begins_with("slime"):
							Global.level_dict[Global.level.name]["enemies"] -= 1
							
						child.queue_free()
				
				
		else:
			if(can_place):
				# places/removes tiles in tilemap, limits spawn block to one per level
				if Input.is_action_pressed("mb_left"):
					if Global.playerArea.get_used_cells_by_id(4).size() < 1:
						place_tile()
						
					elif Global.playerArea.get_used_cells_by_id(4).size() == 1 and !Global.TileID == 4:
						place_tile()
						
					
				if Input.is_action_pressed("mb_right"):
					remove_tile()
		
		# gives ability to move editor camera around tilemap
		move_editor()
		


# sets chosen tile to mouse position for current tilemaplayer 
func place_tile():
	if Global.backgroundLayer:
		var mousepos = Global.background.local_to_map(get_global_mouse_position())
		Global.background.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)
		
	elif Global.playerLayer:
		var mousepos = Global.playerArea.local_to_map(get_global_mouse_position())
		Global.playerArea.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)
		
	elif Global.foregroundLayer:
		var mousepos = Global.foreground.local_to_map(get_global_mouse_position())
		Global.foreground.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)

# removes chosen tile at mouse position for current tilemaplayer
func remove_tile():
	if Global.backgroundLayer:
		var mousepos = Global.background.local_to_map(get_global_mouse_position())
		Global.background.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		
	elif Global.playerLayer:
		var mousepos = Global.playerArea.local_to_map(get_global_mouse_position())
		Global.playerArea.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		
	elif Global.foregroundLayer:
		var mousepos = Global.foreground.local_to_map(get_global_mouse_position())
		Global.foreground.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		
# Uses arrow keys to move camera around tilemap while in edit mode
func move_editor():
	if Input.is_action_pressed("jump"):
		editor.global_position.y -= cam_spd
	if Input.is_action_pressed("left"):
		editor.global_position.x -= cam_spd
	if Input.is_action_pressed("down"):
		editor.global_position.y += cam_spd
	if Input.is_action_pressed("right"):
		editor.global_position.x += cam_spd
	
	
	
	# Clamp the new position within the defined limits
	global_position.x = clamp(global_position.x, limit_left, limit_right)
	global_position.y = clamp(global_position.y, limit_top, limit_bottom)
	
