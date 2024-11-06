extends Node

var playing = false
var player_count = 0

var TileID = 0
var current_tile_coords = Vector2i(0,0)
var place_tile = false
var current_item

var backgroundLayer = false
var playerLayer = true
var foregroundLayer = false

var i = 1 ## for iterating the levels 
var level_array = ["level"]
var level_dict = {"level" : {"coins" : 0, "chests": 0, "enemies": 0}}
var level_data = {
	"level" : {
		"background" : [], 
		"playerArea" : [], 
		"foreground": [], 
		"objects": {}
		}#level
	}#level_data
	
	
var attack_direction = 1



@onready var level #= get_node("/root/main/level")
@onready var background #= get_node("/root/main/level/Background")
@onready var playerArea #= get_node("/root/main/level/Player Area")
@onready var foreground #= get_node("/root/main/level/foreground")


signal gained_coins(int)
var coins = 0
	
func gain_coins(coins_gained):
	coins += coins_gained
	emit_signal("gained_coins", coins_gained)
	
	
