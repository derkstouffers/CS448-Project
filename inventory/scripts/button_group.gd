extends CanvasLayer

@onready var main = get_node("/root/main")
@onready var level1 = get_node("/root/main/level")

#@onready var background : TileMapLayer = level.get_node("/root/main/level/Background")
#@onready var playerArea : TileMapLayer = level.get_node("/root/main/level/Player Area")
#@onready var foreground : TileMapLayer = level.get_node("/root/main/level/foreground")

@onready var object_cursor = get_node("/root/main/editor_object")
@onready var camera = $"../cam_container/Camera2D"

@onready var button_group = get_node("/root/main/button_group")
@onready var top_menu = button_group.get_node("Top_menu")
@onready var block_menu = button_group.get_node("Block_menu")
@onready var all_blocks = button_group.get_node("All_Blocks")
@onready var level_menu = button_group.get_node("Level_menu")
@onready var layer_menu = button_group.get_node("Layer_menu")
@onready var search_bar = button_group.get_node("All_Blocks/SearchBar")
@onready var mini_map = button_group.get_node("MiniMap")
@onready var quest_tracker = button_group.get_node("Quest_Tracker")
@onready var edit = button_group.get_node("Edit")
@onready var ground = button_group.get_node("Block_menu/Ground")
@onready var walls = button_group.get_node("Block_menu/Walls")
@onready var hazards = button_group.get_node("Block_menu/Hazards")
@onready var decor = button_group.get_node("Block_menu/Decor")
@onready var interactive = button_group.get_node("Block_menu/Interactive")
@onready var sprites = button_group.get_node("Block_menu/Sprite")
@onready var spawn = button_group.get_node("Block_menu/Spawn Point")

@onready var mini_map_player_layer = get_node("/root/main/button_group/MiniMap/SubViewportContainer/SubViewport/player_layer")
@onready var mini_map_background_layer = get_node("/root/main/button_group/MiniMap/SubViewportContainer/SubViewport/background_layer")
@onready var mini_map_foreground_layer = get_node("/root/main/button_group/MiniMap/SubViewportContainer/SubViewport/foreground_layer")

@onready var player_select_window = button_group.get_node("Top_menu/GridContainer/Play/player_select_window")
@onready var error_window = button_group.get_node("Top_menu/GridContainer/Play/Error Window")

@onready var clear_confirm: ConfirmationDialog = $"clear_confirm"

@onready var next_level_button = $next_level


const level2 = preload("res://scenes/level.tscn")
const player1 = preload("res://scenes/dwarf.tscn")
const slime = preload("res://scenes/slime.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.gained_coins.connect(update_coins_gained)
	$ObjectiveSelector.popup_centered()
	$MiniMap/SubViewportContainer/SubViewport/Camera2D.make_current()
	var background_layer_tiles = Global.background.get_tile_set()
	var player_layer_tiles = Global.playerArea.get_tile_set()
	var foreground_layer_tiles = Global.foreground.get_tile_set()
	mini_map_player_layer.set_tile_set(player_layer_tiles)
	mini_map_background_layer.set_tile_set(background_layer_tiles)
	mini_map_foreground_layer.set_tile_set(foreground_layer_tiles)
	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## Only getting Player Layer map data for now
	var background_map_data = Global.background.get_tile_map_data_as_array()
	var player_map_data = Global.playerArea.get_tile_map_data_as_array()
	var foreground_map_data = Global.foreground.get_tile_map_data_as_array()
	if player_map_data != null:
		mini_map_player_layer.set_tile_map_data_from_array(player_map_data)
	if background_map_data != null:
		mini_map_background_layer.set_tile_map_data_from_array(background_map_data)
	if foreground_map_data != null:
		mini_map_foreground_layer.set_tile_map_data_from_array(foreground_map_data)
	else:
		print("MINIMAP Failed")
	pass


###
### TOP MENU
###

func _on_play_pressed() -> void:
	if Global.playerArea.get_used_cells_by_id(15).size() < 1:
		error_window.visible = true
		
	else:
		for level_ in Global.level_dict.keys():
			for i in main.get_node(level_ + "/Player Area").get_children():
				if i.name.begins_with("coin"):
					Global.level_dict[level_]["coins"] += 1
				if i.name.begins_with("chest"):
					Global.level_dict[level_]["chests"] += 1
				if i.name.begins_with("slime"):
					Global.level_dict[level_]["enemies"] += 1
		#print(Global.level_dict)
		pass
		#Global.playing = true
		Global.playing = true
		
		if Global.player_count < 1:
			player_select_window.visible = true
			
		top_menu.visible = false
		block_menu.visible = false
		layer_menu.visible = false
		level_menu.visible = false
		search_bar.visible = false
		mini_map.visible = false
		edit.visible = true
		next_level_button.visible = true ## Temporary
		quest_tracker.visible = true
		
		for lev in Global.level_array:
			if lev == Global.level.name:
				Global.playerArea.collision_enabled = true
			else:
				main.get_node(lev).get_node("Player Area").collision_enabled = false
				pass
		
		#### NEED TO MAKE A WINDOW (PLAYER ALREADY EXISTS IN A LEVEL THEN RETURNS USER TO EDIT MODE)
		## Shift to player camera if player already placed in world
		if Global.player_count == 1:
			camera.enabled = false
			Global.playerArea.get_node("dwarf").get_child(2).enabled = true
		
		pass # Replace with function body.
func _on_error_window_close_requested() -> void:
	error_window.hide()
	pass # Replace with function body.
	
	
func _on_dwarf_pressed() -> void:
	player_select_window.visible = false
	
	## place player in world if no other player exists in world
	if Global.player_count < 1:
		print("PLAYER BEING ADDED")
		var player
		player = player1.instantiate()
		Global.playerArea.add_child(player)
		Global.playerArea.get_node("dwarf").position = Global.playerArea.map_to_local(Vector2i(Global.playerArea.get_used_cells_by_id(15)[0].x, Global.playerArea.get_used_cells_by_id(15)[0].y - 5))
		Global.player_count += 1
	pass # Replace with function body.
	
func _on_player_select_window_close_requested() -> void:
	player_select_window.hide()
	pass # Replace with function body.


func _on_player_select_window_mouse_entered() -> void:
	object_cursor.can_place = false
	Global.place_tile = true
	pass # Replace with function body.
	
func _on_background_pressed() -> void:
	Global.backgroundLayer = true
	Global.playerLayer = false
	Global.foregroundLayer = false	
	

	pass # Replace with function body.
	

func _on_player_area_pressed() -> void:
	
	Global.backgroundLayer = false
	Global.playerLayer = true
	Global.foregroundLayer = false

	pass # Replace with function body.


func _on_foreground_pressed() -> void:
	
	Global.backgroundLayer = false
	Global.playerLayer = false
	Global.foregroundLayer = true

	pass # Replace with function body.


func _on_clear_pressed() -> void:
	clear_confirm.popup_centered()
	if not clear_confirm.is_connected("confirmed", _on_clear_popup):
		clear_confirm.connect("confirmed", _on_clear_popup)
	pass # Replace with function body.

func _on_clear_popup() -> void:
	Global.background.clear()
	Global.playerArea.clear()
	Global.foreground.clear()
	
	
	if Global.player_count > 0:
		Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
		Global.player_count -= 1

###
### BLOCK MENU
###
func _on_ground_pressed() -> void:
	walls.visible = false
	ground.visible = true
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	spawn.visible = false
	pass # Replace with function body.


func _on_walls_pressed() -> void:
	ground.visible = false
	walls.visible = true
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	spawn.visible = false
	pass # Replace with function body.

func _on_hazards_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = true
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	spawn.visible = false
	pass # Replace with function body.


func _on_decor_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = true
	interactive.visible = false
	sprites.visible = false
	spawn.visible = false
	pass # Replace with function body.
	
func _on_interactive_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = true	
	sprites.visible = false
	spawn.visible = false
	pass # Replace with function body.

func _on_sprite_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = true
	spawn.visible = false
	pass # Replace with function body.

func _on_player_spawn_point_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	spawn.visible = true
	pass # Replace with function body.
	
###
### EDIT TOGGLE
###

func _on_edit_pressed() -> void:
	top_menu.visible = true
	block_menu.visible = true
	layer_menu.visible = true
	level_menu.visible = true
	search_bar.visible = true
	mini_map.visible = true
	edit.visible = false
	next_level_button.visible = false
	quest_tracker.visible = false
	Global.playing = false
	
	
	### change cameras back to editing camera
	camera.enabled = true
	if Global.player_count > 0:
		Global.playerArea.get_node("dwarf").get_child(2).enabled = false
	pass # Replace with function body.


func _on_top_menu_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_top_menu_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_block_menu_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_block_menu_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.

func _on_grid_container_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_grid_container_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.

func _on_ground_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_ground_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.

func _on_walls_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_walls_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.
	
	
func _on_hazards_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_hazards_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.
	
func _on_decor_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_decor_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_interactive_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_interactive_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_sprite_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_sprite_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.
	
func _on_stone_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_stone_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_beige_bricks_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_beige_bricks_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_brown_bricks_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_brown_bricks_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_dark_gray_bricks_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_dark_gray_bricks_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_lava_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_lava_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_sm__spike_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_sm__spike_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_med_spike_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_med_spike_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_lg_spike_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_lg_spike_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_jacko_lantern_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_jacko_lantern_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_btm_lft_web_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_btm_lft_web_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_btm_rt_web_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_btm_rt_web_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_top_l_web_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_top_l_web_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_top_r_web_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_top_r_web_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_coin_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_coin_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_ladder_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_ladder_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_chest_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_chest_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_edit_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_edit_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.
	
func _on_play_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_play_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_background_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_background_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_player_area_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_player_area_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_foreground_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_foreground_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.

func _on_clear_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.	

func _on_clear_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.	

func _on_lwr__l_stone_stair_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_lwr__l_stone_stair_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.	
	

func _on_lwr_r_stone_stair_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_lwr_r_stone_stair_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.	
	
func _on_torch_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_torch_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.
	
###
### PLAYER SPAWN BLOCK
###

func _on_player_spawn_point_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_player_spawn_point_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_spawn_block_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 15
	Global.current_tile_coords = Vector2i(0,0)		
	pass # Replace with function body.


func _on_spawn_block_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_spawn_block_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.

	
###
### GROUND BLOCKS
###

func _on_stone_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

func _on_lwr__l_stone_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 12
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

	
func _on_lwr_r_stone_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 13
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.





###
### WALLS
###
func _on_beige_bricks_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(2,0)
	pass # Replace with function body.


func _on_brown_bricks_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(3,0)
	pass # Replace with function body.


func _on_dark_gray_bricks_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(4,0)
	pass # Replace with function body.	
	
	
###
### HAZARDS
###	

func _on_lava_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(1,0)	
	pass # Replace with function body.


func _on_sm__spike_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 6
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.


func _on_med_spike_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.


func _on_lg_spike_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 7
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.

	
###
### DECOR
###		
	
func _on_jacko_lantern_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.


func _on_btm_lft_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 8
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_btm_rt_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 9
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_top_l_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 10
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_top_r_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 11
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.	

func _on_torch_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 14
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.



	
###
### INTERACTIVE
###	
@onready var coin = preload("res://scenes/coin.tscn")
func _on_coin_pressed() -> void:
	Global.place_tile = false
	Global.current_item = coin
	
	pass # Replace with function body.
	
func update_coins_gained(gained_coins):
	$Quest_Tracker/Container/coin_tracker.text = str(Global.coins)
	pass


func _on_ladder_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 4
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

@onready var chest = preload("res://scenes/chest.tscn")
func _on_chest_pressed() -> void:	
	Global.place_tile = false
	Global.current_item = chest
	pass # Replace with function body.


###
### SPRITES
###

func _on_slime_pressed() -> void:
	Global.place_tile = false
	Global.current_item = slime
	pass # Replace with function body.
	
	
func _on_slime_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_slime_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.



###
### LEVEL MENU
###
var button
var new_level
func _on_add_level_pressed() -> void:
	
	var dungeon_levels =  $Level_menu/GridContainer3  #button_group.get_node("/Level_menu/GridContainer3")
	button = Button.new()
	
	new_level = level2.instantiate()
	
	
	### add new level to the main scene
	level1.add_sibling(new_level, true)
	
	
	### add new button for level to the level menu
	dungeon_levels.add_child(button)
	
	### Give functionality to button
	button.text = new_level.get_name()
	Global.level_array.append(button.text)
	Global.level_dict[button.text] = {"coins" : 0, "chests": 0, "enemies": 0} ## testing a different version with dictionary
	#print(Global.level_dict)
	Global.level.visible = false
	new_level.visible = true
	
	Global.playerArea.collision_enabled = false
	
	Global.level = new_level
	Global.background = new_level.get_node("Background")
	Global.playerArea = new_level.get_node("Player Area")
	Global.foreground = new_level.get_node("foreground")
	
	Global.playerArea.collision_enabled = true
	
	button.pressed.connect(_on_level_select.bind(button.text))
	button.mouse_entered.connect(self._mouse_enter)
	button.mouse_exited.connect(self._mouse_exit)
	
	$ObjectiveSelector.popup_centered()
	
	pass # Replace with function body.
		
func _on_level_select(level_name):		
	var level_select
	level_select = main.get_node(level_name)
	
	## make level selected visible and previous level hidden
	Global.level.visible = false
	level_select.visible = true
	
	# fix block collision issues from one level to the next
	Global.playerArea.collision_enabled = false
	
	
	### set the level to be drawn in 
	Global.level =  level_select
	Global.background = level_select.get_node("Background")
	Global.playerArea = level_select.get_node("Player Area")
	Global.foreground = level_select.get_node("foreground")
	Global.playerArea.collision_enabled = true
	
	pass

func _mouse_enter():
	object_cursor.can_place = false

func _mouse_exit():
	object_cursor.can_place = true	
	



func _on_level_1_pressed() -> void:
	
	Global.level.visible = false
	level1.visible = true
	Global.playerArea.collision_enabled = false
	
	Global.level =  level1
	Global.background = get_node("/root/main/level/Background")
	Global.playerArea = get_node("/root/main/level/Player Area")
	Global.foreground = get_node("/root/main/level/foreground")
	Global.playerArea.collision_enabled = true
	pass # Replace with function body.


func _on_level_menu_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_level_menu_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_add_level_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_add_level_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_delete_level_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_delete_level_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_level_1_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_level_1_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.



###
### SEARCHBAR
###
func _on_search_bar_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_search_bar_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


###
### MINIMAP
###

func _on_mini_map_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_mini_map_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.
	
	
###
### Save button
### temporary functionality
### will probably change this to save the whole project the user is making rather than individual levels
func _on_save_mouse_entered() -> void:
	Global.place_tile = true
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_save_mouse_exited() -> void:
	Global.place_tile = false
	object_cursor.can_place = false
	pass # Replace with function body.
	
func _on_save_pressed() -> void:
	for lev in Global.level_array:
		Global.level_data[lev] = {
			"background": main.get_node(lev + "/Background").get_tile_map_data_as_array(), 
			"playerArea" : main.get_node(lev + "/Player Area").get_tile_map_data_as_array(),
			"foreground": main.get_node(lev + "/foreground").get_tile_map_data_as_array(),
			"objects": get_object_data(main.get_node(lev + "/Player Area"))
			}
	pass # Replace with function body.

### loads all levels with prior save data	
func _on_load_pressed() -> void:
	for lev in Global.level_data:
		main.get_node(lev + "/Background").set_tile_map_data_from_array(Global.level_data[lev]['background'])
		main.get_node(lev + "/Player Area").set_tile_map_data_from_array(Global.level_data[lev]['playerArea'])
		main.get_node(lev + "/foreground").set_tile_map_data_from_array(Global.level_data[lev]['foreground'])
		load_object_data(lev)
	pass # Replace with function body.

### Gets data for objects that are not tileset tiles specific to the Player Area for each level
# objects : {"object_name" : {"position": Vector2i()}} 
#
#
func get_object_data(tilemaplayer: TileMapLayer)->Dictionary:
	
	var object_data = {}
	
	for child in tilemaplayer.get_children():
		if child.has_method("get_position"):
			var object_name = child.get_name()
			object_data[object_name] = {"position" : child.get_position()}
	return object_data

### loads the object_data into their respective levels and Player Areas
# objects will need added to this as we add them into the system
func load_object_data(lev):
	#for lev in Global.level_data.keys():
		for object in Global.level_data.get(lev).get("objects").keys():
			if object.begins_with("coin"):
				var instance = coin.instantiate()
				main.get_node(lev + '/Player Area').add_child(instance, true)
				instance.position = Global.level_data.get(lev).get("objects").get(object)["position"]
			elif object.begins_with("chest"):
				var instance = chest.instantiate()
				main.get_node(lev + '/Player Area').add_child(instance, true)
				instance.position = Global.level_data.get(lev).get("objects").get(object)["position"]
			elif object.begins_with("slime"):
				var instance = slime.instantiate()
				main.get_node(lev + '/Player Area').add_child(instance, true)
				instance.position = Global.level_data.get(lev).get("objects").get(object)["position"]
			elif object.begins_with("ladder"):
				#var instance = ladder.instantiate()
				#main.get_node(lev + '/Player Area').add_child(instance, true)
				##print(Global.level_data.get(lev).get("objects").get(object)["position"])
				#instance.position = Global.level_data.get(lev).get("objects").get(object)["position"]
				pass
			#pass
	#pass

### WORKING ON INDIVIDUAL SAVE AND LOAD
func _on_save_level_pressed():
	
	Global.level_data[Global.level.name] = {
		"background": main.get_node(Global.level.name + "/Background").get_tile_map_data_as_array(), 
		"playerArea" : main.get_node(Global.level.name + "/Player Area").get_tile_map_data_as_array(),
		"foreground": main.get_node(Global.level.name + "/foreground").get_tile_map_data_as_array(),
		"objects": get_object_data(main.get_node(Global.level.name + "/Player Area"))
		}
	pass
	
func _on_load_level_pressed():
	
	main.get_node(Global.level.name + "/Background").set_tile_map_data_from_array(Global.level_data[Global.level.name]['background'])
	main.get_node(Global.level.name + "/Player Area").set_tile_map_data_from_array(Global.level_data[Global.level.name]['playerArea'])
	main.get_node(Global.level.name + "/foreground").set_tile_map_data_from_array(Global.level_data[Global.level.name]['foreground'])
	load_object_data(Global.level.name)
	pass

###
### Changing levels within play. THERE IS A BUG IF YOU GO BACK TO EDIT AFTER REACHING A LATER LEVEL IN PLAY MODE THEN START FROM LEVEL 1 AGAIN AND TRY TO GO TO THE NEXT LEVEL
###
var i = 1
func _on_next_level_pressed() -> void:
	var level_count = Global.level_array.size()
	var next_level
	
	## remove player from previous level
	Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
	Global.player_count -= 1
	
	## remove collision from previous level
	Global.playerArea.collision_enabled = false
	
	## Turn off previous level visibility
	Global.level.visible = false
	
	## get and set next level
	next_level = main.get_node(Global.level_array[i])
	next_level.visible = true
	Global.level = next_level
	
	
	## add player to new level 
	var player = player1.instantiate()
	
	## enable collision mesh for new level
	Global.playerArea = next_level.get_node('Player Area')
	Global.playerArea.collision_enabled = true
	
	
	next_level.get_node('Player Area').add_child(player)
	
	## set position for where player will enter new level
	## need to probably make it variable for each level that can be placed by user
	Global.playerArea.get_node("dwarf").position = Global.playerArea.map_to_local((Vector2i(Global.playerArea.get_used_cells_by_id(15)[0].x, Global.playerArea.get_used_cells_by_id(15)[0].y - 5)))
	
	Global.player_count += 1
	if Global.player_count == 1:
		camera.enabled = false
		next_level.get_node('Player Area/dwarf').get_child(2).enabled = true
	
	## if the next level is the size of the level array in global then there are no more levels
	if level_count != i:
		## increment i to access the next level in the global array of levels
		i += 1
	if level_count == i:
		i = 1
		
	else:
		print("GAME OVER")
	
	pass # Replace with function body.

###
### Objective/Quest picker for each level
###
func _on_objective_selector_id_pressed(id: int) -> void:
	if id == 0:
		Global.playerArea.objective = 1
	if id == 1:
		Global.playerArea.objective = 2
	pass # Replace with function body.


func _on_objective_selector_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_objective_selector_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.

func _on_all_items_pressed() -> void:
	block_menu.visible = false
	all_blocks.visible = true
	
func _on_non_search_menu_pressed() -> void:
	block_menu.visible = true
	all_blocks.visible = false
	
func _on_search_bar_text_changed(new_text: String) -> void:
	var buttons = get_node("All_Blocks/ScrollContainer/GridContainer")
	
	if new_text == "":
		for child in buttons.get_children():
			child.visible = true
		
	if new_text != "":
		for child in buttons.get_children():
			if child.name.to_lower().contains(new_text):
				child.visible = true
			else:
				child.visible = false
