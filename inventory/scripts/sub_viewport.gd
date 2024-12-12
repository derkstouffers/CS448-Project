"""
	Used for making the MINIMAP visible
	
	makes the minimap camera the currently active camera and it recieves the texture from the current project tilemaps
"""

extends SubViewport

@onready var camera = $Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.make_current()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TextureRect.texture = get_tree().get_root().get_viewport().get_texture()
	

	
