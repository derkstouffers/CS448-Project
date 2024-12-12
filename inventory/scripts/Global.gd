"""
	Holds global variables needed for interaction between multiple scripts throughout project
"""

extends Node

# variables for loading files
var dungeon_loaded = false # used in initial load from load screen 
var load_path = "" 

# used for switching between play and edit modes
var playing = false
var player_count = 0 # tracks number of characters present in project limited to 1 for now

## Variables for setting tiles and objects
var TileID = 0
var current_tile_coords = Vector2i(0,0)
var place_tile = false
var current_item

# variables used upon initial load so that the playerLayer is the default open tilemap ready for tile placement
var backgroundLayer = false
var playerLayer = true
var foregroundLayer = false

var i = 1 ## for iterating the levels when changing levels in player_area script. Used while playing

## Dictionaries for holding data on the levels made 
var level_array = ["level"]
var level_dict = {"level" : {"coins" : 0, "chests": 0, "enemies": 0}}
var level_data = {
	"level" : {
		"objective" : 0,
		"background" : [], 
		"playerArea" : [], 
		"foreground": [], 
		"objects": {}
		}#level
	}#level_data
	
	
var attack_direction = 1



@onready var level 
@onready var background 
@onready var playerArea 
@onready var foreground 


## used for updating coin amount while playing
signal gained_coins(int)
var coins = 0
	
func gain_coins(coins_gained):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	
	
