"""
	playerArea tilemaplayer
	This is the layer in which the character can interact with tiles, objects
	
	checks the current objective for playerArea the character is located
	if character completes current playerArea objective, moves character to next level or exits to edit mode
"""


extends TileMapLayer

@onready var main = get_node("/root/main")
@onready var camera = get_node("/root/main/cam_container/Camera2D")


@onready var button_group = get_node("/root/main/button_group")
@onready var top_menu = button_group.get_node("Top_menu")
@onready var block_menu = button_group.get_node("Block_menu")
@onready var level_menu = button_group.get_node("Level_menu")
@onready var layer_menu = button_group.get_node("Layer_menu")
@onready var mini_map = button_group.get_node("MiniMap")
@onready var quest_tracker = button_group.get_node("Quest_Tracker")
@onready var edit = button_group.get_node("Edit")

@export var objective = 0

var selected_tile
const dwarf = preload("res://scenes/dwarf.tscn")
const wizard = preload("res://scenes/wizard.tscn")
const witch = preload("res://scenes/witch.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# when playing checks if a character is present, if they are then checks if they have completed the chosen objectives, 
# if objective completed should transition to the next level
func _process(_delta: float) -> void:
	
	# used for the grid snapping of objects being placed/removed interacts with editor_object script 
	var tile = local_to_map(get_global_mouse_position())
	selected_tile = map_to_local(tile)
	
	
	# checks game mode, and if character is present, if true checks if level objective has been completed 
	if Global.playing and has_node("dwarf") or has_node("wizard") or has_node("witch"):
		
		if objectives(objective):
			go_to_next_level()
			
	elif Global.playing == false:
		Global.coins = 0
	


## checks what the current objective is and if it is complete returns true
func objectives(quest : int):
	
	if quest == 1:
		
		if Global.level_dict[Global.level.name]["coins"] == 0 and Global.level_dict[Global.level.name]["chests"] == 0:
			return true
		return false
	elif quest == 2:
		if Global.level_dict[Global.level.name]["enemies"] == 0:
			return true
		return false
###
### Changing levels within play. 
###

func go_to_next_level() -> void:
	var level_count = Global.level_array.size()
	var next_level
	
	if level_count == Global.i:
		## GAME OVER REACHED END OF LAST LEVEL, RETURN TO EDIT MODE
		
		
		
		## RETURN TO EDIT MODE AT LEVEL 1
		button_group._on_edit_pressed()

		
		Global.level.visible = false
		var level_return = main.get_node("/root/main/level")
		Global.level = level_return
		level_return.visible = true
		
		#### change cameras back to editing camera
		camera.enabled = true
		if Global.player_count > 0:
			if Global.playerArea.has_node("dwarf"):
				Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
			elif Global.playerArea.has_node("wizard"):
				Global.playerArea.remove_child(Global.playerArea.get_node("wizard"))
			elif Global.playerArea.has_node("witch"):
				Global.playerArea.remove_child(Global.playerArea.get_node("witch"))
			Global.player_count -= 1
		
		Global.i = 1
		
	
		
		
		### set the level to be drawn in 
		Global.background = level_return.get_node("Background")
		Global.playerArea = level_return.get_node("Player Area")
		Global.foreground = level_return.get_node("foreground")
		Global.playerArea.collision_enabled = true
		
		# reset objective and its overlay for next play through
		objective = Global.playerArea.objective
		button_group.objectiveOverlay.get_node("Container/curr_level_objective").text = button_group.objective_overlay(objective)
		
		
		


	
	elif level_count > Global.i:
		### GO TO NEXT LEVEL 
		var player
		## remove player from previous level
		if Global.player_count > 0:
			if Global.playerArea.has_node("dwarf"):
				player = "dwarf"
				Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
			elif Global.playerArea.has_node("wizard"):
				player = "wizard"
				Global.playerArea.remove_child(Global.playerArea.get_node("wizard"))
			elif Global.playerArea.has_node("witch"):
				player = "witch"
				Global.playerArea.remove_child(Global.playerArea.get_node("witch"))
			Global.player_count -= 1
		
		
		## remove collision from previous level
		Global.playerArea.collision_enabled = false
		
		## Turn off previous level visibility
		Global.level.visible = false
		
		
		## get and set next level
		next_level = main.get_node(Global.level_array[Global.i])
		next_level.visible = true
		Global.level = next_level
		button_group._on_load_level_pressed()
		
		
		var char
		## add player to new level
		if player == "dwarf": 
			char = dwarf.instantiate()
		elif player == "wizard":
			char = wizard.instantiate()
		elif player == "witch":
			char = witch.instantiate()

		## enable collision mesh for new level
		Global.playerArea = next_level.get_node('Player Area')
		Global.playerArea.collision_enabled = true
		
		## get objective for new level
		objective = Global.playerArea.objective
		button_group.objectiveOverlay.get_node("Container/curr_level_objective").text = button_group.objective_overlay(objective)
		
		# add player to new level
		Global.playerArea.add_child(char)
		
		## Player position set to spawn block (tile_id: 4)
		
		if Global.playerArea.has_node("dwarf"):
			Global.playerArea.get_node("dwarf").position = Global.playerArea.map_to_local((Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5)))
		elif Global.playerArea.has_node("wizard"):
			Global.playerArea.get_node("wizard").position = Global.playerArea.map_to_local((Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5)))
		elif Global.playerArea.has_node("witch"):
			Global.playerArea.get_node("witch").position = Global.playerArea.map_to_local((Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5)))
				
		
		
		Global.player_count += 1
		if Global.player_count == 1:
			# activates the camera to focus on the player
			if next_level.has_node("Player Area/dwarf"):
				next_level.get_node('Player Area/dwarf').get_child(2).enabled = true
			elif next_level.has_node("Player Area/wizard"):
				next_level.get_node('Player Area/wizard').get_child(2).enabled = true
			elif next_level.has_node("Player Area/witch"):
				next_level.get_node('Player Area/witch').get_child(2).enabled = true
		
		### increment i to access the next level in the global array of levels
		Global.i += 1
		
		
		
	
