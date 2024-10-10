extends Node2D

var can_place = true
var is_panning = true

@onready var level = get_node("/root/main/level")
@onready var editor = get_node("/root/main/cam_container")
@onready var editor_cam = editor.get_node("Camera2D")

@export var cam_spd = 10


var current_item

@onready var background : TileMapLayer = level.get_node("/root/main/level/TileMap/Background")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/TileMap/Player Area")
@onready var foreground : TileMapLayer = level.get_node("/root/main/level/TileMap/foreground")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#editor_cam.current = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if !Global.place_tile:
		
		if(current_item != null and can_place and Input.is_action_just_pressed("mb_left")):
			var new_item = current_item.instantiate()
			level.add_child(new_item)
			new_item.global_position = get_global_mouse_position()
			
	else:
		if(can_place):
			
			if Input.is_action_pressed("mb_left"):
				place_tile()
				
			if Input.is_action_pressed("mb_right"):
				remove_tile()
	
	move_editor()
	
	is_panning = Input.is_action_pressed("mb_middle")
	pass


func place_tile():
	if Global.backgroundLayer:
		var mousepos = background.local_to_map(get_global_mouse_position())
		background.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)
		pass
	elif Global.playerLayer:
		var mousepos = playerArea.local_to_map(get_global_mouse_position())
		playerArea.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)
	elif Global.foregroundLayer:
		var mousepos = foreground.local_to_map(get_global_mouse_position())
		foreground.set_cell(Vector2i(mousepos.x, mousepos.y), Global.TileID, Global.current_tile_coords)

func remove_tile():
	if Global.backgroundLayer:
		var mousepos = background.local_to_map(get_global_mouse_position())
		background.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		pass
	elif Global.playerLayer:
		var mousepos = playerArea.local_to_map(get_global_mouse_position())
		playerArea.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
		pass
	elif Global.foregroundLayer:
		var mousepos = foreground.local_to_map(get_global_mouse_position())
		foreground.set_cell(Vector2i(mousepos.x, mousepos.y), -1)
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
