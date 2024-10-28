extends Node2D

var can_place = true
var is_panning = true

@onready var level = get_node("/root/main/level")
@onready var editor = get_node("/root/main/cam_container")
@onready var editor_cam = editor.get_node("Camera2D")

@export var cam_spd = 10


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
	#editor_cam.make_current()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.playing:
		
		global_position = get_global_mouse_position()
		
		if Global.place_tile == false:
			
			current_item = Global.current_item
			var new_item 
			if(current_item != null and can_place and Input.is_action_just_pressed("mb_left")):
				new_item = current_item.instantiate()
				if new_item.name == "coin" and Global.playerArea.get_node_or_null("coin"):
					Global.playerArea.get_node("coin").add_sibling(new_item, true)
					
				elif new_item.name == "chest" and Global.playerArea.get_node_or_null("chest"):
					Global.playerArea.get_node("chest").add_sibling(new_item, true)
					
				elif new_item.name == "slime" and Global.playerArea.get_node_or_null("slime"):
					Global.playerArea.get_node("slime").add_sibling(new_item, true)
					
				### HARDCODED FOR PLAYER AREA RIGHT NOW SINCE THE NON_TILEMAP TILES ARE ALL INTERACTIVES RIGHT NOW
				else:
					Global.playerArea.add_child(new_item)
				
				new_item.global_position = get_global_mouse_position()
				
			if(current_item != null and can_place and Input.is_action_just_pressed("mb_right")):
				### THIS SHOULD BE DELETE LOGIC FOR NON_TILEMAP TILE PLACEMENT
				pass
				
		else:
			if(can_place):
				
				if Input.is_action_pressed("mb_left"):
					if Global.playerArea.get_used_cells_by_id(15).size() < 1:
						place_tile()
						#print(Global.playerArea.get_used_cells_by_id(15))
					elif Global.playerArea.get_used_cells_by_id(15).size() == 1 and !Global.TileID == 15:
						place_tile()
						
					
				if Input.is_action_pressed("mb_right"):
					remove_tile()
		
		move_editor()
		
		is_panning = Input.is_action_pressed("mb_middle")
	pass


func place_tile():
	if Global.backgroundLayer:
		var mousepos = Global.background.local_to_map(get_global_mouse_position())
		Global.background.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)
		pass
	elif Global.playerLayer:
		var mousepos = Global.playerArea.local_to_map(get_global_mouse_position())
		Global.playerArea.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)
	elif Global.foregroundLayer:
		var mousepos = Global.foreground.local_to_map(get_global_mouse_position())
		Global.foreground.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)

func remove_tile():
	if Global.backgroundLayer:
		var mousepos = Global.background.local_to_map(get_global_mouse_position())
		Global.background.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		pass
	elif Global.playerLayer:
		var mousepos = Global.playerArea.local_to_map(get_global_mouse_position())
		Global.playerArea.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		pass
	elif Global.foregroundLayer:
		var mousepos = Global.foreground.local_to_map(get_global_mouse_position())
		Global.foreground.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		pass

func move_editor():
	if Input.is_action_pressed("w"):
		editor.global_position.y -= cam_spd
	if Input.is_action_pressed("a"):
		editor.global_position.x -= cam_spd
	if Input.is_action_pressed("s"):
		editor.global_position.y += cam_spd
	if Input.is_action_pressed("d"):
		editor.global_position.x += cam_spd
	pass
