"""
	custom data structures to hold information on the levels within a project
	Used for saving and loading
	
	level_data: 
		objective: for each level holds the corresponding objective chosen by user
		background: for background, playerArea, and foreground each holds an array
					of values representing tiles in the corresponding tilemap
		playerArea: 
		foreground:
		objects: holds a dictionary of the different objects in corresponding level
		
	
	level_dict:
		holds the number of each of the following found in the corresponding level,
		used for checking if objective is completed
		coins:
		chests:
		enemies:
"""


extends Resource

class_name CustomData

@export var level_data: Dictionary = {
	"level" : {
		"objective" : 0,	# holds level objective 0: no objective, 1: collect all coins and chests, 2: defeat all enemies
		"background" : [],  # array holding the values for where tiles are located in corresponding tilemap
		"playerArea" : [], 
		"foreground": [], 
		"objects": {}		# holds dictionary of all objects within corresponding level with objects location as value ex. {"coin" : Vector2i(100, 50), "chest": Vector2i(170, 90)}
		}#level
	}#level_data
	
@export var level_dict: Dictionary = {
	"level": {
		"coins" : 0,
		"chests" : 0,
		"enemies" : 0
		}
}
