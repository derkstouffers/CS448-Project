extends SubViewport

@onready var camera = $Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.make_current()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TextureRect.texture = get_tree().get_root().get_viewport().get_texture()
	
	pass
	
