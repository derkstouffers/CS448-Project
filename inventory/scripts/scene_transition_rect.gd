"""
	A basic scene transition: activates black screen fade animation and moves from one file to another 
"""

extends ColorRect

@export_file var next_scene_path: String
@onready var anim_player := $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play_backwards("fade")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# given file path to transition from current scene to the given file
func transition_to(next_scene := next_scene_path):
	anim_player.play("fade")
	await anim_player.animation_finished
	get_tree().change_scene_to_file(next_scene)

# activates animation
func transition():
	anim_player.play("fade")
	await anim_player.animation_finished
