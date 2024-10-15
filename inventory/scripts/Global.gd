extends Node

var playing = false
var player_count = 0
var TileID = 0
var current_tile_coords = Vector2i(0,0)
var place_tile = false
var backgroundLayer = false
var playerLayer = true
var foregroundLayer = false

@onready var level #= get_node("/root/main/level")
@onready var background #= get_node("/root/main/level/Background")
@onready var playerArea #= get_node("/root/main/level/Player Area")
@onready var foreground #= get_node("/root/main/level/foreground")
