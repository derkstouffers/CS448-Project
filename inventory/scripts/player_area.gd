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
@onready var next_level_button = button_group.get_node("next_level")

@export var objective = 0

var selected_tile
const player1 = preload("res://scenes/dwarf.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var tile = local_to_map(get_global_mouse_position())
	selected_tile = map_to_local(tile)
	
	if Global.playing and has_node("dwarf"):
		
		if objectives(objective):
			#await get_tree().create_timer(2.0).timeout
			go_to_next_level()
	pass



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
### Changing levels within play. THERE IS A BUG IF YOU GO BACK TO EDIT AFTER REACHING A LATER LEVEL IN PLAY MODE THEN START FROM LEVEL 1 AGAIN AND TRY TO GO TO THE NEXT LEVEL
###

func go_to_next_level() -> void:
	var level_count = Global.level_array.size()
	var next_level
	
	if level_count == Global.i:
		## GAME OVER REACHED END OF LAST LEVEL MADE RETURN TO EDIT MODE
		
		## RETURN TO EDIT MODE AT LEVEL 1
		Global.playing = false
		top_menu.visible = true
		level_menu.visible = true
		layer_menu.visible = true
		block_menu.visible = true
		mini_map.visible = true
		edit.visible = false
		next_level_button.visible = false
		quest_tracker.visible = false
		
		Global.level.visible = false
		var level_return = main.get_node("/root/main/level")
		Global.level = level_return
		level_return.visible = true
		
		### change cameras back to editing camera
		camera.enabled = true
		if Global.player_count > 0:
			Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
			Global.player_count -= 1
		Global.i = 1
	
		# fix block collision issues from one level to the next
		Global.playerArea.collision_enabled = false
		
		
		### set the level to be drawn in 
		Global.background = level_return.get_node("Background")
		Global.playerArea = level_return.get_node("Player Area")
		Global.foreground = level_return.get_node("foreground")
		Global.playerArea.collision_enabled = true
		
		


	
	elif level_count > Global.i:
		### GO TO NEXT LEVEL 
		
		## remove player from previous level
		Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
		Global.player_count -= 1
		
		## remove collision from previous level
		Global.playerArea.collision_enabled = false
		
		## Turn off previous level visibility
		Global.level.visible = false
		
		## get and set next level
		
		next_level = main.get_node(Global.level_array[Global.i])
		next_level.visible = true
		Global.level = next_level
		
	
		## add player to new level 
		var player = player1.instantiate()

		## enable collision mesh for new level
		Global.playerArea = next_level.get_node('Player Area')
		Global.playerArea.collision_enabled = true
		objective = Global.playerArea.objective

		Global.playerArea.add_child(player)
		
		## set position for where player will enter new level
		## need to probably make it variable for each level that can be placed by user
		Global.playerArea.get_node("dwarf").position = Global.playerArea.map_to_local((Vector2i(Global.playerArea.get_used_cells_by_id(15)[0].x, Global.playerArea.get_used_cells_by_id(15)[0].y - 5)))
		
		Global.player_count += 1
		if Global.player_count == 1:
			#camera.enabled = false
			next_level.get_node('Player Area/dwarf').get_child(2).enabled = true
	
		### increment i to access the next level in the global array of levels
		Global.i += 1
			
	pass # Replace with function body.
	
