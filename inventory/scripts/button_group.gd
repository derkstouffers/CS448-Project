extends CanvasLayer

@onready var top_menu = get_node("/root/button_group/Top_menu")
@onready var block_menu = get_node("/root/button_group/Block_menu")
@onready var edit = get_node("/root/button_group/Edit")
@onready var ground = get_node("/root/button_group/Ground")
@onready var walls = get_node("/root/button_group/Walls")
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
	Global.playing = !Global.playing
	top_menu.visible = false
	block_menu.visible = false
	edit.visible = true
	
	pass # Replace with function body.

###
### BLOCK MENU
###
func _on_ground_pressed() -> void:
	walls.visible = false
	ground.visible = true
	pass # Replace with function body.


func _on_walls_pressed() -> void:
	ground.visible = false
	walls.visible = true
	pass # Replace with function body.


###
### EDIT TOGGLE
###

func _on_edit_pressed() -> void:
	top_menu.visible = true
	block_menu.visible = true
	edit.visible = false
	pass # Replace with function body.
