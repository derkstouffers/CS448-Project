"""
	Overarching GUI
	
	handles the overlay and its button interactions
	
"""


extends CanvasLayer

@onready var main = get_node("/root/main")
@onready var level1 = get_node("/root/main/level")

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
@onready var objectiveOverlay = button_group.get_node("objectiveOverlay")
@onready var edit = button_group.get_node("Edit")
@onready var building_blocks = button_group.get_node("Block_menu/ScrollContainer/building_blocks")
@onready var hazards = button_group.get_node("Block_menu/ScrollContainer/Hazards")
@onready var decor = button_group.get_node("Block_menu/ScrollContainer/Decor")
@onready var interactive = button_group.get_node("Block_menu/ScrollContainer/Interactive")
@onready var sprites = button_group.get_node("Block_menu/ScrollContainer/Sprite")
@onready var spawn = button_group.get_node("Block_menu/ScrollContainer/Spawn Point")

@onready var mini_map_player_layer = get_node("/root/main/button_group/MiniMap/SubViewportContainer/SubViewport/player_layer")
@onready var mini_map_background_layer = get_node("/root/main/button_group/MiniMap/SubViewportContainer/SubViewport/background_layer")
@onready var mini_map_foreground_layer = get_node("/root/main/button_group/MiniMap/SubViewportContainer/SubViewport/foreground_layer")

@onready var player_select_window = button_group.get_node("Top_menu/GridContainer/Play/player_select_window")
@onready var error_window = button_group.get_node("Top_menu/GridContainer/Play/Error Window")

@onready var clear_confirm: ConfirmationDialog = $"clear_confirm"

const level2 = preload("res://scenes/level.tscn")
const dwarf = preload("res://scenes/dwarf.tscn")
const slime = preload("res://scenes/slime.tscn")
const ghost = preload("res://scenes/ghost.tscn")
const wizard = preload("res://scenes/wizard.tscn")
const witch = preload("res://scenes/witch.tscn")
const ladder = preload("res://scenes/ladder.tscn")
const empty_dungeon = preload("res://scenes/main.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Global.gained_coins.connect(update_coins_gained)
	if !Global.dungeon_loaded:
		$ObjectiveSelector.popup_centered()
	elif Global.dungeon_loaded:
		
		var load_path = Global.load_path
	
		if ResourceLoader.exists(load_path):
			var loaded_data = ResourceLoader.load(load_path)
			
			if loaded_data is CustomData:
				Global.level_data = loaded_data.level_data
				call_deferred("_load_dungeon")
		
	$MiniMap/SubViewportContainer/SubViewport/Camera2D.make_current()
	var background_layer_tiles = Global.background.get_tile_set()
	var player_layer_tiles = Global.playerArea.get_tile_set()
	var foreground_layer_tiles = Global.foreground.get_tile_set()
	mini_map_player_layer.set_tile_set(player_layer_tiles)
	mini_map_background_layer.set_tile_set(background_layer_tiles)
	mini_map_foreground_layer.set_tile_set(foreground_layer_tiles)
	
	
	grand_children(self)

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.playing == false:
		update_coins_gained(0)
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



func grand_children(node: Node) -> void:
	for child in node.get_children():
		if child.has_signal("mouse_entered"):
			child.connect("mouse_entered", _mouse_enter)
			child.connect("mouse_exited", _mouse_exit)
		
		if child.get_child_count() > 0:
			grand_children(child)

"""
	TOP MENU
"""

""" PLAY """
func _on_play_pressed() -> void:
	if !ResourceLoader.exists(Global.load_path):
		_on_save_pressed()
	_on_save_file_dialog_file_selected(Global.load_path)
	
	var spawn_pts_present = true
	
	if Global.level_array.size() >= 1:
		for lev in Global.level_array:
			if main.get_node(lev).get_node("Player Area").get_used_cells_by_id(4).size() < 1:
				_on_edit_pressed()
				error_window.visible = true
				spawn_pts_present = false
				
				
	if spawn_pts_present:

		for level_ in Global.level_dict.keys():
					
			main.get_node(level_ + "/Background").clear()
			main.get_node(level_ + "/Player Area").clear()
			main.get_node(level_ + "/foreground").clear()
			
			
			## I think that because I am not removing the object data from the Global.level_data when this adds in more objects in the load, it doubles the number of objects in the Global.level_data? FIXME		
			for object in Global.level_data.get(level_).get("objects").keys():
				main.get_node(level_ + "/Player Area").remove_child(main.get_node(level_ + "/Player Area").get_node(object))
				
				if object.begins_with("dwarf"):
					Global.player_count -= 1
		

					
		_on_load_level_pressed()	

		Global.playing = true
				
		if Global.player_count < 1:
			player_select_window.visible = true
					
		top_menu.visible = false
		block_menu.visible = false
		layer_menu.visible = false
		level_menu.visible = false
		all_blocks.visible = false
		mini_map.visible = false
		edit.visible = true
		objectiveOverlay.visible = true
		quest_tracker.visible = true
				
		for lev in Global.level_array:
			if lev == Global.level.name:
				Global.playerArea.collision_enabled = true
			else:
				main.get_node(lev).get_node("Player Area").collision_enabled = false
				
				
				## Shift to player camera if player already placed in world
		if Global.player_count == 1:
			camera.enabled = false
			Global.playerArea.get_node("dwarf").get_child(2).enabled = true

func _on_error_window_close_requested() -> void:
	error_window.hide()
	
""" CHARACTERS / PLAYERS """	
# DWARF	
func _on_dwarf_pressed() -> void:
	player_select_window.visible = false
	
	## place player in world if no other player exists in world
	if Global.player_count < 1:
		var player
		player = dwarf.instantiate()
		Global.playerArea.add_child(player)
		Global.playerArea.get_node("dwarf").position = Global.playerArea.map_to_local(Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5))
		Global.player_count += 1
	
# WIZARD	
func _on_wizard_pressed() -> void:
	player_select_window.visible = false
	
	## place player in world if no other player exists in world
	if Global.player_count < 1:
		
		var player
		player = wizard.instantiate()
		Global.playerArea.add_child(player)
		Global.playerArea.get_node("wizard").position = Global.playerArea.map_to_local(Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5))
		Global.player_count += 1

# WITCH
func _on_witch_pressed() -> void:
	player_select_window.visible = false
	
	## place player in world if no other player exists in world
	if Global.player_count < 1:
		
		var player
		player = witch.instantiate()
		Global.playerArea.add_child(player)
		Global.playerArea.get_node("witch").position = Global.playerArea.map_to_local(Vector2i(Global.playerArea.get_used_cells_by_id(4)[0].x, Global.playerArea.get_used_cells_by_id(4)[0].y - 5))
		Global.player_count += 1

# PLAYER SELECT WINDOW 	
func _on_player_select_window_close_requested() -> void:
	player_select_window.hide()


func _on_player_select_window_mouse_entered() -> void:
	object_cursor.can_place = false
	Global.place_tile = true

"""
	SAVE 
	
	opens file dialog, can overwrite previous save files or can type new file name in
	saves scene and dungeon data
	auto called when play is pressed or can be pressed on its own
"""
func _on_save_mouse_entered() -> void:
	Global.place_tile = true
	object_cursor.can_place = false


func _on_save_mouse_exited() -> void:
	Global.place_tile = false
	object_cursor.can_place = false

func _on_save_pressed() -> void:
	$saveFileDialog.mode = FileDialog.FILE_MODE_SAVE_FILE
	$saveFileDialog.popup_centered()

func _on_save_file_dialog_file_selected(path: String) -> void:
	folder_exists("dungeon_save_files")
	folder_exists("dungeon_save_data")
	
	# Save Scene
	var new_dungeon = PackedScene.new()
	new_dungeon.pack(self.get_parent())		
	
	var save_scene = path
	if !save_scene.contains(".tscn"):
		save_scene = save_scene + ".tscn"

	var scene_error = ResourceSaver.save(new_dungeon, save_scene)
	if scene_error == OK:
		print("save scene successful")
	else:
		print("save scene failed")
	
	
	# Save levels data
	var custom_data = CustomData.new()
	custom_data.level_data = {}
	custom_data.level_dict = {}
	
	for levl in main.get_children():
		
		# Gets objective, tilemap array data, and objects with position for each level and saves it all to a data file with the same name as the scene file
		if levl.name.begins_with("level"):
			custom_data.level_data[levl.name] = {
				"objective": levl.get_node("Player Area").objective,
				"background": levl.get_node("Background").get_tile_map_data_as_array(),
				"playerArea": levl.get_node("Player Area").get_tile_map_data_as_array(),
				"foreground": levl.get_node("foreground").get_tile_map_data_as_array(),
				"objects": get_object_data(levl.get_node("Player Area"))
			}
			custom_data.level_dict[levl.name] = {
				"coins" : Global.level_dict[levl.name].get("coins"),
				"chests" : Global.level_dict[levl.name].get("chests"),
				"enemies" : Global.level_dict[levl.name].get("enemies")
				
			}
	# makes sure saved scene file and corresponding data file have same name
	var scene_name = path.get_file().get_basename()	
	var save_path = "user://dungeon_save_data/%s.tres" % scene_name
	var error = ResourceSaver.save(custom_data, save_path)
	Global.load_path = save_path
	if error == OK:
		print("save data successful")
		Global.level_data = {}
		Global.level_data = custom_data.level_data
	else:
		print("save data failed")
	
"""
	LOAD
"""
func _on_load_pressed() -> void:
	$loadFileDialog.access = FileDialog.ACCESS_USERDATA
	$loadFileDialog.mode = FileDialog.FILE_MODE_OPEN_FILE
	$loadFileDialog.popup_centered()


func _on_load_file_dialog_file_selected(path: String) -> void:
	
	get_tree().change_scene_to_file(path)
		
	# get the corresponding level data for chosen dungeon
	var scene_name = path.get_file().get_basename()
	Global.load_path = "user://dungeon_save_data/%s.tres" % scene_name
	
	
	var load_path = Global.load_path
	
	if ResourceLoader.exists(load_path):
		var loaded_data = ResourceLoader.load(load_path)
		
		if loaded_data is CustomData:
			Global.level_dict = {}
			Global.level_data = {}
			Global.level_dict = loaded_data.level_dict #{"coins": 0, "chests": 0, "enemies": 0}
			Global.level_data = loaded_data.level_data
			
			
			for level_name in loaded_data.level_data.keys():
				
				
				var level_data = loaded_data.level_data[level_name]
				
				var level = main.get_node_or_null(level_name)
				if level == null:
					
					level = level2.instantiate()
					level.name = level_name
					main.add_child(level)
					add_level_button(level)
					
					
				level.get_node("Player Area").objective = level_data["objective"]
				level.get_node("Background").set_tile_map_data_from_array(level_data["background"])
				level.get_node("Player Area").set_tile_map_data_from_array(level_data["playerArea"])
				level.get_node("foreground").set_tile_map_data_from_array(level_data["foreground"])	
				
				
				# adding all the interactive objects back into tilemaplayer
				load_object_data(level_name)
			
						
				print("load successful")
		else:
			print("Data is not expected type")
			
	else:
		print("No data file found")
	pass # Replace with function body.	

### Initial load if a file is chosen at load screen
func _load_dungeon():
	var load_path = Global.load_path
	
	if ResourceLoader.exists(load_path):
		var loaded_data = ResourceLoader.load(load_path)
		
		if loaded_data is CustomData:
			Global.level_dict = {}
			Global.level_data = {}
			Global.level_dict = loaded_data.level_dict  #[level_name] = {"coins": 0, "chests": 0, "enemies": 0}
		
			
			Global.level_data = loaded_data.level_data
			
			for level_name in loaded_data.level_data.keys():
				
				
				var level_data = loaded_data.level_data[level_name]
				
				var level = main.get_node_or_null(level_name)
				if level == null:
					
					level = level2.instantiate()
					level.name = level_name
					main.add_child(level)
					add_level_button(level)
					
					
				level.get_node("Player Area").objective = level_data["objective"]
				level.get_node("Background").set_tile_map_data_from_array(level_data["background"])
				level.get_node("Player Area").set_tile_map_data_from_array(level_data["playerArea"])
				level.get_node("foreground").set_tile_map_data_from_array(level_data["foreground"])	
				
				
				# adding all the interactive objects back into tilemaplayer
				load_object_data(level_name)			
			
			$objectiveOverlay/Container/curr_level_objective.text = objective_overlay(Global.playerArea.objective)
			$Top_menu/GridContainer/objectives.select(Global.playerArea.objective)			
			print("load successful")
			Global.level.visible = true
		else:
			print("Data is not expected type")
			
	else:
		print("No data file found")
		
		
# used during loading compared to previous add level which is used after already in a dungeon file
func add_level_button(add_level):
	var dungeon_levels =  $Level_menu/GridContainer3 
	button = Button.new()
	
	dungeon_levels.add_child(button)
	button.text = add_level.name
	add_level.visible = false
	Global.level_array.append(button.text)
	add_level.get_node("Player Area").collision_enabled = false
	button.pressed.connect(_on_level_select.bind(button.text))
	button.mouse_entered.connect(self._mouse_enter)
	button.mouse_exited.connect(self._mouse_exit)

### Gets data for objects that are not tileset tiles specific to the Player Area for each level
# objects : {"object_name" : {"position": Vector2i()}} 

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
			elif object.begins_with("ghost"):
				var instance = ghost.instantiate()
				main.get_node(lev + "/Player Area").add_child(instance, true)
				instance.position = Global.level_data.get(lev).get("objects").get(object)["position"]
			elif object.begins_with("ladder"):
				var instance = ladder.instantiate()
				main.get_node(lev + '/Player Area').add_child(instance, true)
				instance.position = Global.level_data.get(lev).get("objects").get(object)["position"]
			

### LOAD INDIVIDUAL LEVEL
func _on_load_level_pressed():
	main.get_node(Global.level.name + "/Player Area").objective = Global.level_data[Global.level.name]['objective']
	main.get_node(Global.level.name + "/Background").set_tile_map_data_from_array(Global.level_data[Global.level.name]['background'])
	main.get_node(Global.level.name + "/Player Area").set_tile_map_data_from_array(Global.level_data[Global.level.name]['playerArea'])
	main.get_node(Global.level.name + "/foreground").set_tile_map_data_from_array(Global.level_data[Global.level.name]['foreground'])
	load_object_data(Global.level.name)

# CHECK IF DIRECTORIES FOR SAVING AND LOADING DUNGEON DATA EXIST	
func folder_exists(folder_name: String)->void:
	var folder_path = "user://" + folder_name
	var dir = DirAccess.open(folder_path)
	if dir == null:
		dir = DirAccess.open("user://")
		if dir != null:
			dir.make_dir(folder_name)
			print("Folder created at: ", folder_path)
		else:
			print("Failed to open user:// directory")
	else:
		print("folder already exists")
	

###
### Objective/Quest picker for each level
###	
"""
	OBJECTIVES
"""
func objective_overlay(objective)->String:
	
	if objective == 1:
		return "%s objective: Collect all coins and chests" % Global.level.name
	elif objective == 2:
		return "%s objective: Defeat all enemy sprites" % Global.level.name
	else:
		return "%s no objective selected" % Global.level.name


func _on_objectives_item_selected(index: int) -> void:
	if index == 1:
		Global.playerArea.objective = 1
	elif index == 2:
		Global.playerArea.objective = 2
	elif index == 0:
		Global.playerArea.objective = 0
	
	$objectiveOverlay/Container/curr_level_objective.text = objective_overlay(Global.playerArea.objective)
	
func _on_objective_selector_id_pressed(id: int) -> void:
	if id == 0:
		Global.playerArea.objective = 1
	if id == 1:
		Global.playerArea.objective = 2
	
	$objectiveOverlay/Container/curr_level_objective.text = objective_overlay(Global.playerArea.objective)
	$Top_menu/GridContainer/objectives.select(Global.playerArea.objective)


func _on_objective_selector_mouse_entered() -> void:
	object_cursor.can_place = false


func _on_objective_selector_mouse_exited() -> void:
	object_cursor.can_place = true

""" LAYER SELECTION """
func _on_background_pressed() -> void:
	Global.backgroundLayer = true
	Global.playerLayer = false
	Global.foregroundLayer = false

func _on_player_area_pressed() -> void:
	Global.backgroundLayer = false
	Global.playerLayer = true
	Global.foregroundLayer = false

func _on_foreground_pressed() -> void:
	Global.backgroundLayer = false
	Global.playerLayer = false
	Global.foregroundLayer = true

""" CLEAR CURRENT LEVEL """
func _on_clear_pressed() -> void:
	clear_confirm.popup_centered()
	if not clear_confirm.is_connected("confirmed", _on_clear_popup):
		clear_confirm.connect("confirmed", _on_clear_popup)

func _on_clear_popup() -> void:
	# clear tilemaps
	Global.background.clear()
	Global.playerArea.clear()
	Global.foreground.clear()
	
	# remove interactive objects from current level clicked
	for object in Global.level_data.get(Global.level.name).get("objects").keys():
		Global.playerArea.remove_child(Global.playerArea.get_node(object))
	
	# remove player	
	if Global.player_count > 0:
		if Global.playerArea.has_node("dwarf"):
			Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
			Global.player_count -= 1
		if Global.playerArea.has_node("wizard"):
			Global.playerArea.remove_child(Global.playerArea.get_node("wizard"))
			Global.player_count -= 1
		if Global.playerArea.has_node("witch"):
			Global.playerArea.remove_child(Global.playerArea.get_node("witch"))
			Global.player_count -= 1
		
	Global.level_dict[Global.level.name]["coins"] = 0
	Global.level_dict[Global.level.name]["chests"] = 0
	Global.level_dict[Global.level.name]["enemies"] = 0
	
	
	

"""
	BLOCK MENU
"""

# Building Blocks
func _on_ground_pressed() -> void:
	building_blocks.visible = true
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	spawn.visible = false

# HAZARDS
func _on_hazards_pressed() -> void:
	building_blocks.visible = false
	hazards.visible = true
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	spawn.visible = false

# DECOR
func _on_decor_pressed() -> void:
	building_blocks.visible = false
	hazards.visible = false
	decor.visible = true
	interactive.visible = false
	sprites.visible = false
	spawn.visible = false

# INTERACTIVE
func _on_interactive_pressed() -> void:
	building_blocks.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = true
	sprites.visible = false
	spawn.visible = false

# SPRITES
func _on_sprite_pressed() -> void:
	building_blocks.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = true
	spawn.visible = false

# SPAWN
func _on_player_spawn_point_pressed() -> void:
	building_blocks.visible = false
	hazards.visible = false
	decor.visible = false
	interactive.visible = false
	sprites.visible = false
	spawn.visible = true

"""
	EDIT TOGGLE
"""
func _on_edit_pressed() -> void:
	top_menu.visible = true
	block_menu.visible = true
	layer_menu.visible = true
	level_menu.visible = true
	search_bar.visible = true
	mini_map.visible = true
	edit.visible = false
	quest_tracker.visible = false
	objectiveOverlay.visible = false
	Global.playing = false
	
	# clear each level
	for lev in Global.level_array:
		main.get_node(lev).get_node("Background").clear()
		main.get_node(lev).get_node("Player Area").clear()
		main.get_node(lev).get_node("foreground").clear()
		
		# remove interactive objects from each level
		
		for object in Global.level_data.get(lev).get("objects").keys():
			main.get_node(lev).get_node("Player Area").remove_child(main.get_node(lev).get_node("Player Area").get_node(object))
	
		
	### change cameras back to editing camera
	camera.enabled = true
	
	# remove charcter if present 
	if Global.player_count > 0:
		if Global.playerArea.has_node("dwarf"):
			Global.playerArea.get_node("dwarf").get_child(2).enabled = false
			Global.playerArea.remove_child(Global.playerArea.get_node("dwarf"))
		elif Global.playerArea.has_node("wizard"):
			Global.playerArea.get_node("wizard").get_child(2).enabled = false
			Global.playerArea.remove_child(Global.playerArea.get_node("wizard"))
		elif Global.playerArea.has_node("witch"):
			Global.playerArea.get_node("witch").get_child(2).enabled = false
			Global.playerArea.remove_child(Global.playerArea.get_node("witch"))
		Global.player_count -= 1
	
	# reload current dungeon file
	_load_dungeon()


###
### PLAYER SPAWN BLOCK
###

func _on_spawn_block_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 4
	Global.current_tile_coords = Vector2i(0,0)



""" 
	TILES / INTERACTIVE OBJECTS
	
	activates and makes selected tile/object placeable 
"""
###
### building_blocks BLOCKS
###

func _on_stone_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(0,0)

func _on_lwr__l_stone_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(5,0)

func _on_lwr_r_stone_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(6,0)

func _on_wood_log_top_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(7,0)

func _on_wood_log_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(8,0)

func _on_wood_planks_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(9,0)

func _on_gold_block_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(10,0)

func _on_brick_slab_l_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(11,0)

func _on_brick_slab_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(12,0)

func _on_wood_slab_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(13,0)

func _on_lwr_l_brick_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(14,0)

func _on_lwr_l_wood_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(15,0)

func _on_lwr_r_brick_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(16,0)

func _on_lwr_r_wood_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(17,0)

func _on_brick_slab_r_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(18,0)


func _on_wood_log_side_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(19,0)

func _on_brick_slab_top_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(20,0)

func _on_wood_slab_top_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(21,0)

func _on_upr_l_brick_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(22,0)

func _on_upr_lwood_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(23,0)

func _on_upr_r_brick_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(24,0)

func _on_upr_r_wood_stair_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(25,0)

func _on_stone_slab_top_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(26,0)

func _on_stone_slab_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(27,0)

func _on_beige_bricks_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(2,0)

func _on_brown_bricks_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(3,0)

func _on_dark_gray_bricks_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 0
	Global.current_tile_coords = Vector2i(4,0)

###
### HAZARDS
###

func _on_lava_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(5,0)	

func _on_sm__spike_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(1,0)	

func _on_med_spike_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(0,0)

func _on_lg_spike_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(2,0)

func _on_ice_block_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(3, 0)


func _on_water_block_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 2
	Global.current_tile_coords = Vector2i(4, 0)

###
### DECOR
###

func _on_jacko_lantern_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(0,0)

func _on_btm_lft_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(1,0)

func _on_btm_rt_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(2,0)

func _on_top_l_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(3,0)

func _on_top_r_web_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(4,0)

func _on_torch_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(5,0)

func _on_window_day_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(8,0)

func _on_window_night_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(9,0)

func _on_chandelier_black_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(10,0)

func _on_lantern_black_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(11,0)

func _on_chandelier_brown_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(12,0)

func _on_lantern_brown_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(13,0)

func _on_cattail_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(14,0)

func _on_crate_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(15,0)

func _on_daisy_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(16,0)

func _on_wood_fence_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(17,0)

func _on_sign_down_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(18,0)

func _on_chandelier_gray_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(19,0)

func _on_lantern_gray_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(20,0)

func _on_hanging_lantern_brown_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(21,0)

func _on_hanging_lantern_gray_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(22,0)

func _on_hanging_lantern_black_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(23,0)

func _on_hanging_lantern_purple_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(24,0)

func _on_sign_left_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(25,0)

func _on_chandelier_purple_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(26,0)

func _on_lantern_purple_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(27,0)

func _on_sign_right_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(28,0)

func _on_sign_up_pressed() -> void:
	Global.place_tile = true
	Global.current_item = null
	Global.TileID = 1
	Global.current_tile_coords = Vector2i(29,0)

###
### INTERACTIVE
###

@onready var coin = preload("res://scenes/coin.tscn")
func _on_coin_pressed() -> void:
	Global.place_tile = false
	Global.current_item = coin

func update_coins_gained(_gained_coins):
	$Quest_Tracker/Container/coin_tracker.text = str(Global.coins)

func _on_ladder_pressed() -> void:
	Global.place_tile = false
	Global.current_item = ladder

@onready var chest = preload("res://scenes/chest.tscn")
func _on_chest_pressed() -> void:	
	Global.place_tile = false
	Global.current_item = chest

###
### SPRITES
###

func _on_slime_pressed() -> void:
	Global.place_tile = false
	Global.current_item = slime
	
	
#func _on_ghost_pressed() -> void:
	#Global.place_tile = false
	#Global.current_item = ghost

"""
	LEVEL MENU
	
	add levels when + button pressed
	makes level selected visible when button pressed
"""

var button
var new_level

func _on_add_level_pressed() -> void:
	var dungeon_levels =  $Level_menu/GridContainer3 
	button = Button.new()
	
	new_level = level2.instantiate()
	
	
	### add new level to the main scene
	level1.add_sibling(new_level, true)
	
	
	### add new button for level to the level menu
	dungeon_levels.add_child(button)
	
	### Give functionality to button
	button.text = new_level.get_name()
	Global.level_array.append(button.text)
	Global.level_dict[button.text] = {"coins" : 0, "chests": 0, "enemies": 0} 
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
	
	$objectiveOverlay/Container/curr_level_objective.text = objective_overlay(Global.playerArea.objective)
	$Top_menu/GridContainer/objectives.select(Global.playerArea.objective)
	
	

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
	$objectiveOverlay/Container/curr_level_objective.text = objective_overlay(Global.playerArea.objective)
	$Top_menu/GridContainer/objectives.select(Global.playerArea.objective)
	
	



"""
	ALL ITEMS
	
	SEARCH 
"""
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

func _on_scroll_container_mouse_entered() -> void:
	object_cursor.can_place = false


func _on_scroll_container_mouse_exited() -> void:
	object_cursor.can_place = true
	
