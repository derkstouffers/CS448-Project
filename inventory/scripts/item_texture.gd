#extends TextureRect
#
#@export var this_scene : PackedScene
#@onready var object_cursor = get_node("/root/main/editor_object")
#@onready var cursor_sprite = get_node("/root/main/editor_object/Sprite2D")
#
#
#
#@export var background = false
#@export var tile = false
#@export var tile_id = 0
#@export var tile_coords = Vector2i(0,0)
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#connect("gui_input", _item_clicked)
	#pass # Replace with function body.
#
#func _item_clicked(event):
	#if(event is InputEvent):
		#if(!tile):
			#if(event.is_action_pressed("mb_left")):
				#object_cursor.current_item = this_scene
				#cursor_sprite.texture = texture
				#Global.place_tile = false
		#else:
			#if(event.is_action_pressed("mb_left")):
				#Global.place_tile = true
				#Global.TileID = tile_id
				#Global.current_tile_coords = tile_coords
				#cursor_sprite.texture = texture
				#
	#pass
