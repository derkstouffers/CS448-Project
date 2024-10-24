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
@onready var level_menu = button_group.get_node("Level_menu")
@onready var layer_menu = button_group.get_node("Layer_menu")
@onready var search_bar = button_group.get_node("SearchBar")
@onready var mini_map = button_group.get_node("MiniMap")
@onready var quest_tracker = button_group.get_node("Quest_Tracker")
@onready var edit = button_group.get_node("Edit")
@onready var ground = button_group.get_node("Block_menu/Ground")
@onready var walls = button_group.get_node("Block_menu/Walls")
@onready var hazards = button_group.get_node("Block_menu/Hazards")
@onready var decor = button_group.get_node("Block_menu/Decor")
@onready var interactive = button_group.get_node("Block_menu/Interactive")
@onready var sprites = button_group.get_node("Block_menu/Sprite")


@onready var player_select_window = button_group.get_node("Top_menu/GridContainer/Play/player_select_window")

@onready var clear_confirm: ConfirmationDialog = $"clear_confirm"

@onready var next_level_button = $next_level

const level2 = preload("res://scenes/level.tscn")
const player1 = preload("res://scenes/dwarf.tscn")
const slime = preload("res://scenes/slime.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.gained_coins.connect(update_coins_gained)
	pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


###
### TOP MENU
###

func _on_play_pressed() -> void:
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

func _on_dwarf_pressed() -> void:
	player_select_window.visible = false
	
	## place player in world if no other player exists in world
	if Global.player_count < 1:
		var player
		player = player1.instantiate()
		player.is_dragging = true
		Global.playerArea.add_child(player)
		Global.player_count += 1
	pass # Replace with function body.
	
func _on_player_select_window_close_requested() -> void:
	player_select_window.hide()
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

######
###### WANT TO MAKE IT A POPUP TO MAKE SURE WE WANT TO CLEAR 
######
func _on_clear_pressed() -> void:
	clear_confirm.popup_centered()
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
	pass # Replace with function body.


func _on_walls_pressed() -> void:
	ground.visible = false
	walls.visible = true
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	pass # Replace with function body.

func _on_hazards_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = true
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	pass # Replace with function body.


func _on_decor_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = true
	interactive.visible = false
	sprites.visible = false
	pass # Replace with function body.
	
func _on_interactive_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = true	
	sprites.visible = false
	pass # Replace with function body.

func _on_sprite_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = true
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
### GROUND BLOCKS
###

func _on_stone_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

func _on_lwr__l_stone_stair_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 12
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

	
func _on_lwr_r_stone_stair_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 13
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.





###
### WALLS
###
func _on_beige_bricks_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(2,0)
	pass # Replace with function body.


func _on_brown_bricks_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(3,0)
	pass # Replace with function body.


func _on_dark_gray_bricks_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(4,0)
	pass # Replace with function body.	
	
	
###
### HAZARDS
###	

func _on_lava_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(1,0)	
	pass # Replace with function body.


func _on_sm__spike_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 6
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.


func _on_med_spike_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.


func _on_lg_spike_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 7
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.

	
###
### DECOR
###		
	
func _on_jacko_lantern_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(0,0)	
	pass # Replace with function body.


func _on_btm_lft_web_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 8
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_btm_rt_web_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 9
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_top_l_web_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 10
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.


func _on_top_r_web_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 11
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.	

func _on_torch_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 14
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.



	
###
### INTERACTIVE
###	
@onready var coin = preload("res://scenes/coin.tscn")
func _on_coin_pressed() -> void:
	#Global.place_tile = true
	#Global.TileID = 3
	#Global.current_tile_coords = Vector2i(0,0)
	Global.place_tile = false
	Global.current_item = coin
	
	pass # Replace with function body.
	
func update_coins_gained(gained_coins):
	$Quest_Tracker/Container/coin_tracker.text = str(Global.coins)
	pass


func _on_ladder_pressed() -> void:
	Global.place_tile = true
	Global.TileID = 4
	Global.current_tile_coords = Vector2i(0,0)
	pass # Replace with function body.

@onready var chest = preload("res://scenes/chest.tscn")
func _on_chest_pressed() -> void:	
	#Global.place_tile = true
	#Global.TileID = 5
	#Global.current_tile_coords = Vector2i(0,0)
	Global.place_tile = false
	Global.current_item = chest
	pass # Replace with function body.


###
### SPRITES
###

func _on_slime_pressed() -> void:
	#var slimes
	#slimes = slime.instantiate()
	#slimes.get_node("Path2D/PathFollow2D/slime").is_dragging = true
	#Global.playerArea.add_child(slimes)
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
	Global.level.visible = false
	new_level.visible = true
	button.pressed.connect(_on_level_select.bind(button.text))
	button.mouse_entered.connect(self._mouse_enter)
	button.mouse_exited.connect(self._mouse_exit)
	
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


func _on_save_pressed() -> void:
	var scene = PackedScene.new()
	var scene_node = main.get_node("/root/main/" + Global.level.name)
	scene.pack(scene_node)
	ResourceSaver.save(scene, "res://scenes/" + scene_node.name + ".tscn")
	pass # Replace with function body.


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
	player.set_position(Vector2i(500, 200))
	
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
