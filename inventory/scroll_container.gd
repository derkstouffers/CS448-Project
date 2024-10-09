extends ScrollContainer

@onready var object_cursor = get_node("/root/main/editor_object")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", mouse_enter)
	connect("mouse_exited", mouse_exit)
	pass # Replace with function body.

#
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta: float) -> void:
	##pass


func mouse_enter():
	object_cursor.can_place = false
	object_cursor.hide()
	pass
	
func mouse_exit():
	object_cursor.can_place = true
	object_cursor.show()
	pass
