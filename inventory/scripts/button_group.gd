extends CanvasLayer

@onready var main = get_node("/root/main")
@onready var level = get_node("/root/main/level2")


@onready var background : TileMapLayer = level.get_node("/root/main/level2/worldMap/Background")
@onready var playerArea : TileMapLayer = level.get_node("/root/main/level2/worldMap/Player Area")
@onready var foreground : TileMapLayer = level.get_node("/root/main/level2/worldMap/foreground")

@onready var object_cursor = get_node("/root/main/editor_object")

@onready var button_group = get_node("/root/main/button_group")
@onready var top_menu = button_group.get_node("Top_menu")
@onready var block_menu = button_group.get_node("Block_menu")
@onready var level_menu = button_group.get_node("Level_menu")
@onready var edit = button_group.get_node("Edit")
@onready var ground = button_group.get_node("Block_menu/Ground")
@onready var walls = button_group.get_node("Block_menu/Walls")
@onready var hazards = button_group.get_node("Block_menu/Hazards")
@onready var decor = button_group.get_node("Block_menu/Decor")
@onready var interactive = button_group.get_node("Block_menu/Interactive")

@onready var player_select_window = button_group.get_node("Top_menu/GridContainer/Play/player_select_window")

const level2 = preload("res://scenes/level.tscn")
const player1 = preload("res://scenes/dwarf.tscn")
var player_count = 0
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
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
	player_select_window.visible = true
	top_menu.visible = false
	block_menu.visible = false
	level_menu.visible = false
	edit.visible = true
	
	pass # Replace with function body.

func _on_dwarf_pressed() -> void:
	player_select_window.visible = false
	if player_count < 1:
		var player
		player = player1.instantiate()
		player.is_dragging = true
		#player.global_position = get_global_mouse_position()
		playerArea.add_child(player)
		player_count += 1
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


func _on_player_select_pressed() -> void:
	
	if player_count < 1:
		var player
		player = player1.instantiate()
		player.is_dragging = true
		#player.global_position = get_global_mouse_position()
		playerArea.add_child(player)
		player_count += 1
	pass # Replace with function body.

######
###### WANT TO MAKE IT A POPUP TO MAKE SURE WE WANT TO CLEAR 
######
func _on_clear_pressed() -> void:
	background.clear()
	playerArea.clear()
	foreground.clear()
	
	
	if player_count > 0:
		playerArea.remove_child(playerArea.get_node("dwarf"))
		player_count -= 1
	pass # Replace with function body.

###
### BLOCK MENU
###
func _on_ground_pressed() -> void:
	walls.visible = false
	ground.visible = true
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	pass # Replace with function body.


func _on_walls_pressed() -> void:
	ground.visible = false
	walls.visible = true
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	pass # Replace with function body.

func _on_hazards_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = true
	decor.visible = false
	interactive.visible = false
	pass # Replace with function body.


func _on_decor_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = true
	interactive.visible = false
	pass # Replace with function body.
	
func _on_interactive_pressed() -> void:
	ground.visible = false
	walls.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = true	
	pass # Replace with function body.
	
###
### EDIT TOGGLE
###

func _on_edit_pressed() -> void:
	top_menu.visible = true
	block_menu.visible = true
	level_menu.visible = true
	edit.visible = false
	Global.playing = false
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


func _on_player_select_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.


func _on_player_select_mouse_exited() -> void:
	object_cursor.can_place = true
	pass # Replace with function body.


func _on_clear_mouse_entered() -> void:
	object_cursor.can_place = false
	pass # Replace with function body.	

func _on_clear_mouse_exited() -> void:
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
	
###
### INTERACTIVE
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
### LEVEL MENU
###

func _on_add_level_pressed() -> void:
	#var dungeon_levels = button_group.get_node("/Level_menu/GridContainer3")
	#var new_level
	#new_level = level2.instantiate()
	
	#main.add_child(new_level)
	#
	#dungeon_levels.add_child()
	#
	#level.visible = false
	#new_level.visible = true
	
	pass # Replace with function body.


func _on_level_1_pressed() -> void:
	level.visible = true
	pass # Replace with function body.
